---
title: "An https echo Docker container for web debugging"
description: "Docker image that echoes request data as JSON; listens on HTTP/S, useful for debugging."
categories:
  - docker
tags:
  - docker
  - http
---

I've often had to test various aspects of web requests such as whether the right headers, querystrings, body, methods, etc. were being passed correctly. 

{% githubrepocard "mendhak/docker-http-https-echo" %}

This Docker image echoes various HTTP request properties back to client, as well as in docker logs. An https connection is also available.  There are a lot of features available, see the [repo](https://github.com/mendhak/docker-http-https-echo) for more details.


## How to use it

You can get started quickly with just this command

```bash
docker run -p 8080:80 -p 8443:443 --rm -t mendhak/http-https-echo
```

This will bring up the image and start listening (quietly) on port `8080` for http and `8443` for https.  You can substitute with your own ports.  


Once the container is up, issue a request via your browser or curl -

```bash
curl -k -X PUT -H "Arbitrary:Header" -d aaa=bbb https://localhost:8443/hello-world
```

{% gallery "`curl` and browser output" %}
![curl output](/assets/images/docker-http-https-echo/001.png)
![browser response](/assets/images/docker-http-https-echo/002.png)
{% endgallery %}



You can also see the request appear in the docker logs  

[![`docker logs -f`]({{ site.baseurl }}/assets/images/docker-http-https-echo/003.png)]({{ site.baseurl }}/assets/images/docker-http-https-echo/003.png)

## Features


The image comes with extra parameters or headers that can be passed in for various functionality. 

* Choose your ports
* Use your own certificates
* Decode JWT headers
* Disable ExpressJS log lines
* Do not log specific path
* JSON payloads and JSON output
* No newlines
* Send an empty response
* Custom status code
* Set response Content-Type
* Add a delay before response
* Only return body in the response
* Include environment variables in the response
* Client certificate details (mTLS) in the response

Details on using these features are in the [README](https://github.com/mendhak/docker-http-https-echo).  


## More info

{% button "http-https-echo on Github", "https://github.com/mendhak/docker-http-https-echo" %} {% button "http-https-echo on Docker Hub", "https://hub.docker.com/r/mendhak/http-https-echo" %} 

