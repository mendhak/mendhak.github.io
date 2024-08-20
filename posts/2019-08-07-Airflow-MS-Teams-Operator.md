---
title: "MS Teams Operator for Apache Airflow"
description: "Apache Airflow operator which sends messages to MS Teams channels"
categories:
  - airflow
tags:
  - airflow
  - python
  - teams

last_modified_at: 2024-08-20T19:15:00Z
---

This Apache Airflow operator can send messages to specific MS Teams Channels.  It can be especially useful if you use MS Teams for your chatops. There are various options to customize the appearance of the cards. 

{% githubrepocard "mendhak/Airflow-MS-Teams-Operator" %}


Common usages for this would be:

* A final step in a DAG to notify of success
* Notify a group of users when something needs attention
* Notify developers when a DAG has failed with option to view logs


## Screenshots

{% gallery %}
![Header, subtitle, and body](/assets/images/Airflow-MS-Teams-Operator/001.png)
![Header, subtitle, body, facts, and a button](/assets/images/Airflow-MS-Teams-Operator/004.png)
![Body with coloured text and coloured button](/assets/images/Airflow-MS-Teams-Operator/002.png)
![Body and empty green header](/assets/images/Airflow-MS-Teams-Operator/005.png)
![Coloured header, body, button, in dark mode](/assets/images/Airflow-MS-Teams-Operator/003.png)
![Body and coloured header, without logo](/assets/images/Airflow-MS-Teams-Operator/006.png)
{% endgallery %}



## Usage

The usage can be very basic from just a message, to several parameters including a full card with header, subtitle, body, facts, and a button. There are some style options too.

A very basic message:

```python
 op1 = MSTeamsPowerAutomateWebhookOperator(
        task_id="send_to_teams",
        http_conn_id="msteams_webhook_url",
        body_message="DAG **lorem_ipsum** has completed successfully in **localhost**",
    )
```

Add a button:
    
```python
op1 = MSTeamsPowerAutomateWebhookOperator(
        task_id="send_to_teams",
        http_conn_id="msteams_webhook_url",
        body_message="DAG **lorem_ipsum** has completed successfully in **localhost**",
        button_text="View Logs",
        button_url="https://example.com",
    )
```

Add a heading and subtitle:

```python
op1 = MSTeamsPowerAutomateWebhookOperator(
        task_id="send_to_teams",
        http_conn_id="msteams_webhook_url",
        heading_title="DAG **lorem_ipsum** has completed successfully",
        heading_subtitle="In **localhost**",
        body_message="DAG **lorem_ipsum** has completed successfully in **localhost**",
        button_text="View Logs",
        button_url="https://example.com",
    )
```

Add some colouring — header bar colour, subtle subtitle, body text colour, button colour:

```python
op1 = MSTeamsPowerAutomateWebhookOperator(
        task_id="send_to_teams",
        http_conn_id="msteams_webhook_url",
        header_bar_style="good",
        heading_title="DAG **lorem_ipsum** has completed successfully",
        heading_subtitle="In **localhost**",
        heading_subtitle_subtle=False,
        body_message="DAG **lorem_ipsum** has completed successfully in **localhost**",
        body_message_color_type="good",
        button_text="View Logs",
        button_url="https://example.com",
        button_style="positive",
    )
```

You can also look at [this sample_dag.py](https://github.com/mendhak/Airflow-MS-Teams-Operator/blob/master/sample_dag.py), for an example of how to use this operator in a DAG. 
A full list of parameters can be find in the [README](https://github.com/mendhak/Airflow-MS-Teams-Operator/#parameters). 


There is a bit of prep work required in Teams as well as Airflow to enable this functionality.  


## Prepare MS Teams

Create a webhook to post to Teams. The Webhook needs to be of the PowerAutomate type, not the deprecated Incoming Webhook type. Currently this is done either through the 'workflows' app in Teams, or via [PowerAutomate](https://powerautomate.com). 


{% notice "warning" %}
Webhooks don't usually have additional authentication; you should treat this URL as sensitive and keep it in a safe place. 
{% endnotice %}

## Prepare Airflow


Once that's ready, [create an HTTP Connection](https://airflow.apache.org/docs/apache-airflow/stable/howto/connection.html) in Airflow with the Webhook URL. 

* Conn Type: HTTP
* Host: The URL without the https://
* Schema: https

Copy the [ms_teams_power_automate_webhook_operator.py](https://github.com/mendhak/Airflow-MS-Teams-Operator/blob/master/ms_teams_powerautomate_webhook_operator.py) file into your Airflow dags folder and `import` it in your DAG code.



{% button "MS Teams Operator", "https://github.com/mendhak/Airflow-MS-Teams-Operator/blob/master/ms_teams_powerautomate_webhook_operator.py" %} 

```python
from ms_teams_powerautomate_webhook_operator import MSTeamsPowerAutomateWebhookOperator
```


## Notifying MS Teams on DAG failures

You can use Airflow's built in `on_failure_callback` to notify MS Teams when a DAG fails. This will create a card with a 'View Log' button that developers can click on and go directly to the log of the failing DAG operator.  Very convenient. 


Create a method that receives the failure context, which calls `MSTeamsPowerAutomateWebhookOperator`.  Set this method in the `on_failure_callback` of the DAG.  

```python

def get_formatted_date(**kwargs):
        iso8601date = kwargs["execution_date"].strftime("%Y-%m-%dT%H:%M:%SZ")
        # Teams date/time formatting: https://learn.microsoft.com/en-us/adaptive-cards/authoring-cards/text-features#datetime-example 
        formatted_date = (
            f"{{ '{{{{DATE({iso8601date}, SHORT)}}}} at {{{{TIME({iso8601date})}}}}' }}"
        )
        print(formatted_date)
        return formatted_date

def on_failure(context):

    dag_id = context['dag_run'].dag_id

    task_id = context['task_instance'].task_id
    context['task_instance'].xcom_push(key=dag_id, value=True)

    logs_url = "https://myairflow/admin/airflow/log?dag_id={}&task_id={}&execution_date={}".format(
         dag_id, task_id, context['ts'])

    teams_notification = MSTeamsPowerAutomateWebhookOperator(
        task_id="msteams_notify_failure", trigger_rule="all_done",
        header_bar_style="attention",
        heading_title="Airflow DAG Failure",
        heading_subtitle=get_formatted_date(**context),
        body_message="`{}` has failed on task: `{}`".format(dag_id, task_id),
        button_text="View log", button_url=logs_url,
        http_conn_id='msteams_webhook_url')
    teams_notification.execute(context)


default_args = {
    'owner' : 'airflow',
    'description' : 'a test dag',
    'start_date' : datetime(2019,8,8),
    'on_failure_callback': on_failure
}
```

Of course substitute the `logs_url` with the address of your own Airflow.  For convenience you can move the method out into a common Python module that every DAG imports from.  

