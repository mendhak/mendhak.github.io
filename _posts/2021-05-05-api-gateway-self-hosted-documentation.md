---
title: "Host your API Gateway documentation in API Gateway"
description: "Host your OpenAPI documentation in a Lambda in API Gateway without any additional infrastructure"
categories: 
  - api-gateway
tags: 
  - lambda
  - api-gateway
  - openapi

---

It's possible to host your OpenAPI (Swagger) JSON as well the UI from within API Gateway itself, without needing an S3 bucket or any additional infrastructure.


The most common recommended ways of hosting API Gateway documentation often involve putting the OpenAPI JSON, along with a static website, on an S3 bucket and directing users to that. But this isn't simple and introduces deployment complexity.  It's easier though, to simply serve the JSON and UI from a Lambda. This is convenient as it allows your API code sit with, and be deployed with, the rest of your code. 

![Concept]({{ site.baseurl }}/assets/images/api-gateway-self-hosted/001.png)

This can be done by getting API Gateway to pass everything from the path `/docs` onwards to your Lambda which in turn just serves documentation.  


## Sample Code

I've prepared [a sample repo](https://github.com/mendhak/API-Gateway-Self-Hosted-Documentation) which creates an API Gateway with a /docs endpoint. 

To use it, clone the repo, create the Lambda's zip file, then run terraform. 

```bash
zip -j example.zip example/*
terraform apply
```

This will create the API Gateway, various integrations, Lambda and the IAM permissions required.  The output from `terraform apply` will print out a URL, like: 

```
go_to = "https://bolcx9v796.execute-api.eu-west-1.amazonaws.com/test/docs/"
```

Open that URL in a browser you should see a single page with the Petstore documentation, using Redoc's theme. 

![screenshot]({{ site.baseurl }}/assets/images/api-gateway-self-hosted/002.png)

Notice that the URL ends with `/docs/`.  

If you have a custom domain on your API Gateway, this could become something pleasing to the eye, such as `https://api.example.com/docs/`

Take a look at the network traffic, you'll see a request made to `/docs/swagger.json`.  Both of these requests are handled by the same API Gateway endpoint and same Lambda.  


[Sample repo](https://github.com/mendhak/API-Gateway-Self-Hosted-Documentation){: .btn .btn--info}


I'll point out some highlights from the code below. 

## Handling `/docs` and `/docs/`

In the [main Terraform code](https://github.com/mendhak/API-Gateway-Self-Hosted-Documentation/blob/master/main.tf), we need to create one resource for `/docs` and then one for `/docs/{proxy+}` as a child of the `/docs`.  


```terraform
 resource "aws_api_gateway_resource" "docs" {
    rest_api_id = aws_api_gateway_rest_api.example.id
    parent_id   = aws_api_gateway_rest_api.example.root_resource_id
    path_part   = "docs"
}

resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.example.id
   parent_id   = aws_api_gateway_resource.docs.id
   path_part   = "{proxy+}"
}

```

The first resource handles `/docs`, and the second one handles everything after that, `/docs/{proxy+}`.  Notice the the parent of the second resource is set to the first resource. 

The `{proxy+}` is known as a greedy path variable, think of it a wildcard in your API Gateway URLs. 


### Both go to the same Lambda

It's a similar thing with the Lambda integration.  Both resources point at the same Lambda. 

```terraform
resource "aws_api_gateway_integration" "lambda_docs_root" {
   ...
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.example.invoke_arn
}

resource "aws_api_gateway_integration" "lambda" {
   ...
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.example.invoke_arn
}

```

## Redoc in index.html

We are using [Redoc](https://github.com/Redocly/redoc) to generate the documentation, as the code involved is very simple. It's just a single HTML page with some JS, and a reference to the swagger.json.  

```html
<redoc spec-url='swagger.json'></redoc>
<script src="https://cdn.jsdelivr.net/npm/redoc@next/bundles/redoc.standalone.js"> </script>
```

When you go to the `/docs/` URL, the OpenAPI JSON is requested from `/docs/swagger.json`.  

### Ensure trailing slashes

Because the swagger.json is relative to index.html, if you go to `/docs` _without_ a trailing slash, the browser will request the JSON at `/swagger.json` instead.  Since that request doesn't hit the `/docs` endpoint, the page fails to load.  

This is remedied by adding a little script at the top of the page to ensure the page gets redirected if there's no trailing slash in the URL. 

```html
<script>
  if(!window.location.pathname.endsWith("/")){
    window.location.pathname += "/";
  }
</script>
```    


## The Lambda

The [Lambda handler](https://github.com/mendhak/API-Gateway-Self-Hosted-Documentation/blob/master/example/main.js) is passed all requests from `/docs` onwards. 

The trick then is to serve `index.html` by default for any incoming path, but for requests to `swagger.json`, serve the OpenAPI documentation. 

```javascript

 var response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html;'
    },
    body: fs.readFileSync("./index.html", "utf8")
  }

  if(event.requestContext.path.endsWith("swagger.json")){
    response = {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json;',
        "Access-Control-Allow-Origin" : "*"
      },
      body: JSON.stringify(swagger),
    }
  }

```

This is what allows keeping the documentation together with the code. 




