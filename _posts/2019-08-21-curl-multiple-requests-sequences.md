---
title: "Issuing multiple requests with `curl`"
description: "Using curl's sequences feature to issue multiple requests"
categories: 
  - bash
tags: 
  - curl
  - bash
  - http
---


`curl` is normally used to issue a single request against a URL.  Sometimes you need to issue multiple requests against a URL, or quickly stress test a server or endpoint. You don't have to do this using bash's loops, instead you can use `curl`'s own sequences feature, `[]`  

Here's an example using httpbin:

```bash
curl -s  "https://httpbin.org/anything?a=[0-5]"
```

`curl` will issue 6 request, starting with `?a=0` to `?a=5`, one after the other.  You can see the querystring reflected in the response body.  

>{  
  ...  
  "method": "GET",   
  "url": "https://httpbin.org/anything?a=0"  
}  
{  
  ...  
  "method": "GET",   
  "url": "https://httpbin.org/anything?a=1"  
}  
...


The sequence can go anywhere in the URL and `curl` will increment it. The sequence can also be letters instead of numbers.  

```bash
curl -s  "https://httpbin.org/anything/file_[a-f].txt"
```

It's also possible to specify a step using `:`, regardless of letters or numbers. 

```bash
curl -s  "https://httpbin.org/anything/file_[a-f:3].txt"
```


If you want to use items from a specific list, use `{}` with your comma separated values inside. 

```bash
curl -s  "https://httpbin.org/anything/{lorem,ipsum,dolor}"
```

And finally you can mix and match sequences together. 

```bash
curl -s  "https://httpbin.org/anything/[0-6:3]_file_{lorem,ipsum,dolor}"
```
