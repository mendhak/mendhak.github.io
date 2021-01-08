---
title: "A hello world example using a Docker image in AWS Lambda"
description: "Simple guide to using AWS Lambda with the new Docker image format"
categories: 
  - lambda
  - docker
  - aws
tags: 
  - lambda
  - docker
  - aws

---

AWS [recently announced](https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/) the ability to use Docker images in your Lambda functions.  Here I'll go over a basic set of steps to get a simple example working. 

## Setup

You will need the latest version of the [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install). 

Make sure you've [configured AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) with an IAM user that can perform actions against your account.  

You will need a role for Lambdas in your AWS account.  If you haven't created one already, run this and make note of the Role ARN that comes back.  

```bash
aws iam create-role --role-name lambda-ex --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{ "Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, 
    "Action": "sts:AssumeRole"}]
  }'
```

You will need to have Docker installed, obviously.

You can also follow along using the git repo with [sample code](https://github.com/mendhak/lambda-docker-hello-world). 
{: .notice--info}


## Write your basic Node function

Create a new directory and initialise a Node project

```bash
mkdir -p lambda-docker-hello-world
cd lambda-docker-hello-world
npm init -f 
```

Create an `index.js` file, with the usual Lambda style handler, and have the function return Hello World. 

```javascript
exports.handler = async (event, context) => {
    console.log(event);
    console.log(context);
    return "Hello World.";
}
```


## Build the Docker image

To make use of Docker in Lambda, AWS provides a [specific Docker image for NodeJS](https://hub.docker.com/r/amazon/aws-lambda-nodejs) to base your image from. 


Create a Dockerfile with these contents.

```
FROM amazon/aws-lambda-nodejs:12
COPY index.js package.json ./
RUN npm install
CMD [ "index.handler" ]
```

Note that the command uses the Lambda filename.functionname 'syntax' to point at your `index.js`'s `handler` funciton. 

Build the image:

```bash
docker build -t lambda-docker-hello-world .
```


There are also base images for [.NET Core](https://hub.docker.com/r/amazon/aws-lambda-dotnet), [Go](https://hub.docker.com/r/amazon/aws-lambda-go), and [Python](https://hub.docker.com/r/amazon/aws-lambda-python) among others. 
{: .notice--info}


## Test it locally

Before you push the image up, you can run the Lambda locally first, in the container

```bash
docker run --rm -p 8080:8080 lambda-docker-hello-world
```

Once it's running, in another window use the AWS CLI to invoke the local container. 

```bash
aws lambda invoke \
--region eu-west-1 \
--endpoint http://localhost:8080 \
--no-sign-request \
--function-name function \
--cli-binary-format raw-in-base64-out \
--payload '{"a":"b"}' output.txt
```

Have a look at the output.txt file using `cat output.txt` and it should contain the Hello World message.  You can stop the container now.  

## Push your Docker image to ECR

At the time of writing, you can only push images to a _private_ ECR repository.  You can't use Docker Hub, nor can you use the new [ECR Public Gallery](https://gallery.ecr.aws/).


Login to your ECR Repository.  Substitute the value below for your own ECR's registry URI.

```
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin xxxxxxxxx.dkr.ecr.eu-west-1.amazonaws.com
```

Retag the image we built above to match ECR's format. Then push the image up.

```
docker tag lambda-docker-hello-world:latest xxxxxxxxx.dkr.ecr.eu-west-1.amazonaws.com/lambda-docker-hello-world:latest 
docker push xxxxxxxxx.dkr.ecr.eu-west-1.amazonaws.com/lambda-docker-hello-world:latest
```

## Create the Lambda function

Now that the image is in place, you can create the Lambda function in your AWS account. 

Substitute the `role` below for your Lambda's IAM role. The `ImageUri` needs to point at the image that you pushed to ECR.    

```
aws lambda create-function \ 
--package-type Image \ 
--function-name lambda-docker-hello-world \ 
--role arn:aws:iam::xxxxxxxxx:role/lambda-ex \ 
--code ImageUri=xxxxxxxxx.dkr.ecr.eu-west-1.amazonaws.com/lambda-docker-hello-world:latest
```


## Invoke the Lambda function

Finally, you can call the function. 

```bash
aws lambda \
--region eu-west-1 invoke \
--function-name lambda-docker-hello-world \
--cli-binary-format raw-in-base64-out \
--payload '{"a":"b"}' \
output.txt
```

Again, have a look at the output.txt file using `cat output.txt` and it should contain the Hello World message. 


## Notes

The [introductory announcement from AWS](https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/) about Lambda with container image support contained too much information, and a lot of it was tangential.  I found it very confusing, so I felt it useful to write a basic introduction.  Even then the normal AWS CLI documentation to create a function with a Docker image was very poor and lacking. 

The workflow involved with developing locally and then pushing up, is very similar to that of [LambCI's Lambda image](https://github.com/lambci/docker-lambda).  A big advantage of LambCI's offering is that the images are very friendly towards local development.  For example their Node image can reload if you change any files, you don't need to rebuild the image.  

