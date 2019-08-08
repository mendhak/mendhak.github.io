---
title: "MS Teams Operator for Apache Airflow"
description: "Apache Airflow operator which sends messages to MS Teams channels"
categories:
  - airflow
tags:
  - airflow
  - python
  - teams
---

This Apache Airflow operator can send messages to specific MS Teams Channels.  It can be especially useful if you use MS Teams for your chatops.  

{% include repo_card.html reponame="Airflow-MS-Teams-Operator" %}


Apache Airflow is a programmatic platform for workflows, crons, ETLs, adhoc scripts. One of its greatest strengths is the concept of operators which are basically wrapped up tasks that take arguments.  This operator is a simple Python script which creates an MS Teams card in a given channel. 

## Usage

From your DAG, call the operator.  

```python
op1 = MSTeamsWebhookOperator(task_id='msteamtest',
    http_conn_id='msteams_webhook_url',
    message = "Hello from Airflow!",
    subtitle = "This is the **subtitle**",
    theme_color = "00FF00",
    button_text = "My button",
    button_url = "https://example.com",
    #proxy = "https://yourproxy.domain:3128/",
    dag=dag)
```

`http_conn_id` : Hook pointing at MS Teams Webhook  
`message` : (Templated) the card's headline.   
`subtitle` : (Templated) the card's subtitle  
`button_text` : Text for action button at the bottom of the card  
`button_url` : What URL the button sends the user to  
`theme_color` : Color for the card's top line, without the `#`  

This results in a card like this:

![MS Teams]({{ site.baseurl }}/assets/images/Airflow-MS-Teams-Operator/001.png)


## Prepare MS Teams

Pick the channel you want messages sent to, click the `…` > `Connectors` and search for Incoming Webhook. 

Click Configure, give it a name and you will be given a webhook URL. 

![Webhook]({{ site.baseurl }}/assets/images/Airflow-MS-Teams-Operator/002.png)

Webhooks don't usually have additional authentication; you should treat this URL as sensitive and keep it in a safe place. 
{: .notice--warning}

## Prepare Airflow

In Airflow, create a new Connection under Admin > Connections

![http]({{ site.baseurl }}/assets/images/Airflow-MS-Teams-Operator/003.png)

Note the `Host` field starts directly with `outlook.office.com` and the `Schema` is where you specify `https`.  

## Copy hook and operator

Copy the MS Teams operator and Hook into your own Airflow project. 

[MS Teams Hook](https://github.com/mendhak/Airflow-MS-Teams-Operator/blob/master/ms_teams_webhook_hook.py){: .btn .btn--info} [MS Teams Operator](https://github.com/mendhak/Airflow-MS-Teams-Operator/blob/master/ms_teams_webhook_operator.py){: .btn .btn--info} 

Import it into your DAG

```python
from ms_teams_webhook_operator import MSTeamsWebhookOperator
```

You can now use the operator as shown above. 


## Notifying MS Teams on DAG failures

You can also use the operator to notify MS Teams whenever a DAG fails.  This will create a card with a 'View Log' button that developers can click on and go directly to the log of the failing DAG operator.  Very convenient. 


![http]({{ site.baseurl }}/assets/images/Airflow-MS-Teams-Operator/004.png)

To do this, create a method that receives the failure context, which calls `MSTeamsWebhookOperator`.  Set this method in the `on_failure_callback` of the DAG.  

```python
def on_failure(context):

    dag_id = context['dag_run'].dag_id

    task_id = context['task_instance'].task_id
    context['task_instance'].xcom_push(key=dag_id, value=True)

    logs_url = "https://myairflow/admin/airflow/log?dag_id={}&task_id={}&execution_date={}".format(
         dag_id, task_id, context['ts'])

    teams_notification = MSTeamsWebhookOperator(
        task_id="msteams_notify_failure", trigger_rule="all_done",
        message="`{}` has failed on task: `{}`".format(dag_id, task_id),
        button_text="View log", button_url=logs_url,
        theme_color="FF0000", http_conn_id='msteams_webhook_url')
    teams_notification.execute(context)


default_args = {
    'owner' : 'airflow',
    'description' : 'a test dag',
    'start_date' : datetime(2019,8,8),
    'on_failure_callback': on_failure
}
```

Of course substitute the `logs_url` with the address of your own Airflow.  For convenience you can move the method out into a common Python module that every DAG imports from.  

## Proxies

Some corporate environments make use of outbound proxies.  If you are behind an outbound proxy for Internet access, there are two ways that you can specify your server. 

The easiest way is to put the details in the `Extra` field when creating the HTTP Connection. 

```
{"proxy":"http://my-proxy:3128"}
```

You can also pass the `proxy` argument to the `MSTeamsWebhookOperator` operator.  

```python
proxy = "https://my-proxy:3128/",
```



# How it works

MS Teams allows creating [actionable message cards](https://docs.microsoft.com/en-gb/outlook/actionable-messages/send-via-connectors) which allow you to send formatted JSON with various things like column layout, text blocks, action buttons, headlines, subtitles and so on.  There are plenty of examples on the [Message Card Playground](https://messagecardplayground.azurewebsites.net/).  

The [incoming webhook](https://docs.microsoft.com/en-us/microsoftteams/platform/concepts/connectors/connectors-using) connector is already bundled with MS Teams, and it allows actionable messages to be created.  

The main work happens in the hook which inherits from Airflow's own `HttpHook`; in turn this is simply a Python script which takes the arguments and [builds up](https://github.com/mendhak/Airflow-MS-Teams-Operator/blob/master/ms_teams_webhook_hook.py#L94-L115) the `MessageCard` before performing an HTTP POST.
