---
title: "An `https` echo Docker container for web debugging"
description: "Docker image that echoes request data as JSON; listens on HTTP/S, useful for debugging."
categories:
  - docker
tags:
  - docker
  - http
---

I've often had to test various aspects of web requests such as whether the right headers, querystrings, body, methods, etc. were being passed correctly. 

{% include repo_card.html reponame="docker-http-https-echo" %}

This Docker image echoes various HTTP request properties back to client, as well as in docker logs. An https connection is also available.


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


<figure class="half">
    <a href="{{ site.baseurl }}/assets/images/docker-http-https-echo/001.png"><img src="{{ site.baseurl }}/assets/images/docker-http-https-echo/001.png"></a>
    <a href="{{ site.baseurl }}/assets/images/docker-http-https-echo/002.png"><img src="{{ site.baseurl }}/assets/images/docker-http-https-echo/002.png"></a>
    <figcaption>curl and browser output</figcaption>
</figure>


You can also see the request appear in the docker logs  

[![dockerlogs]({{ site.baseurl }}/assets/images/docker-http-https-echo/003.png)]({{ site.baseurl }}/assets/images/docker-http-https-echo/003.png)



## Docker Compose

You don't have to use the certificate that comes with the container, you can replace the certificate and private key with your own. This is easily done with `docker-compose` volume mapping, and this example uses the snakeoil cert from Ubuntu.

Create your `docker-compose.yml` file:


```docker
my-http-listener:
    image: mendhak/http-https-echo
    ports:
        - "8080:80"
        - "8443:443"
    volumes:
        - /etc/ssl/certs/ssl-cert-snakeoil.pem:/app/fullchain.pem
        - /etc/ssl/private/ssl-cert-snakeoil.key:/app/privkey.pem

```

Then run it and watch the logs. 

```bash
docker-compose up -d
docker-compose logs -f
```

Then just issue your requests via `curl` or your browser again. 


## Docker Hub

[mendhak/http-https-echo](https://hub.docker.com/r/mendhak/http-https-echo){: .btn .btn--info} 

