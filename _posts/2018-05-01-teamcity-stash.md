---
title: "TeamCity to Bitbucket Status Reporter"
categories:
  - git
tags:
  - git
  - pull request
---

This build feature sends build status updates from TeamCity to Bitbucket.  You can then see build statuses against commits.

{% include repo_card.html reponame="teamcity-stash" %}


## Why use this

Reporting build statuses to Bitbucket is a useful way of working with pull requests.  Bitbucket allows you to restrict pull request approvals to a passing builds in addition to the usual approvers, so this can be used to gain some confidence with regards to the quality of a pull request. 


![Bitbucket screenshot]({{ site.baseurl }}/assets/images/teamcity-stash/001.png)
 


**TeamCity 10:** Recent releases of TeamCity now include a [commit status publisher](https://www.jetbrains.com/help/teamcity/commit-status-publisher.html) which works with Bitbucket, Github, Gitlab and Gerrit.
{: .notice--info}






Install
==========

Download the [.zip file](https://github.com/mendhak/teamcity-stash/blob/master/teamcity.stash.zip?raw=true) and place it in the `<TeamCity data directory>/plugins` folder, then restart TeamCity.


Set-up
==========

Under your build steps, click on `Add Build Feature`. It will appear in the dropdown list.

![Build Feature]({{ site.baseurl }}/assets/images/teamcity-stash/002.png)


Simply enter your Bitbucket server details and credentials to connect with. The plugin will now send build status updates to your Bitbucket server.

![Configuration]({{ site.baseurl }}/assets/images/teamcity-stash/003.png)


How it works
======

This is a TeamCity Build Feature built using the [TeamCity Open API](http://confluence.jetbrains.com/display/TCD7/Developing+TeamCity+Plugins).

It listens for build statuses and posts them to the [Atlassian Bitbucket Build API](https://developer.atlassian.com/static/rest/stash/latest/stash-build-integration-rest.html).



License
=======
GPL v2


______________


Code setup
=====
You will need [IntelliJ IDEA](http://www.jetbrains.com/idea/download/) as this project uses IDEA features to build artifacts.

You will also need to download and extract [TeamCity](http://www.jetbrains.com/teamcity/download/) which provides the required jars.

Open the project in Intellij IDEA, you should see a lot of unresolved references, this is normal.

Go to `File | Settings | Path Variables` and set the `TeamCityDistribution` variable, pointing it to your TeamCity location.

To **build** the project, click `Build | Build Artifacts...` and choose `plugin-zip`.  The .zip is generated in `/out/artifacts/plugin_zip`.


Troubleshooting
====
If the plugin doesn't seem to be working, you can find plugin messages in the `teamcity-server.log` file under your TeamCity installation. (Example: `/TeamCity/logs/teamcity-server.log`)
This usually gives you a good idea of why a call may have failed.

You can also look at Bitbucket's `atlassian-bitbucket.log` under `BITBUCKET_HOME`'s log folder (Example: `/Bitbucket-Home/log/atlassian-bitbucket.log`) file to see what it did with the HTTP request sent by the plugin.  In the log file, search for `POST /rest/build-status` as a starting point.
