---
title: "Running a Selenium Grid cheaply with Fargate Spot containers in AWS ECS"
description: "Terraform script for running a cheap Selenium Grid, using AWS ECS, with the containers managed by Fargate Spot instances."
categories: 
  - aws
  - ecs
  - fargate
  - spot
  - docker
  - terraform
---  

Here I will go over a Terraform script to help with running a cheap Selenium Grid, using AWS ECS, with the containers managed by Fargate Spot instances.  To put it in a simpler way, this is running a Selenium Grid (hub and nodes) in Docker containers, but the containers are run in ECS.  Within ECS, the containers are managed by Fargate, which immensely eases the running of containers from your perspective - you don't have to specify instance details, just tell it how much CPU/RAM you need.  And the backing types that Fargate uses, behind the scenes, are Spot instances.  Spot instances are unused EC2 capacity that AWS offers cheaply, with the caveat that there is a small chance of your instance being reclaimed with a 2 minute notice.  

For this reason, the combination of ECS with Fargate and Spot is good for fault tolerant workloads.  Selenium Grids are a great fit as you can just run it in this setup without having to think too much.  If a container is ever removed, Selenium Hub will simply continue farming out instructions to the remaining nodes.  If you ever need the full capacity back, simply destroy and recreate the cluster. This is much cheaper compared to running such a set up on a fleet of dedicated EC2 instances.  

And importantly, it makes your testers happy.

## Overview

There are quite a few AWS services that need to work together for this setup.  The Docker images for [Selenium Hub](https://hub.docker.com/r/selenium/hub/tags) as well as the browsers are [already provided by Selenium](https://hub.docker.com/r/selenium/node-firefox/tags).  This saves us the effort of having to build one. We just need to create task definitions for the hub and each browser, then run them as services in the ECS Cluster.

![overview]({{ site.baseurl }}/assets/images/ecs-selenium-grid/001.png)

Each browser container will need to know where the hub is and register itself.  To help them out, the hub will need to register itself with AWS Cloud Map, which is a service discovery tool.  You can think of it as a 'private' DNS within your VPC.

The hub node will also need to register itself with a Load Balancer.  This is because as the various containers in ECS are created and destroyed, they will have different private IP addresses.  Having a constantly changing hub address can be disruptive for testers, so placing a load balancer in front of the hub helps keep the test configuration static enough; you could even point a domain name at the load balancer and use ACM to give it a secure, easy to remember URL.

## What you'll need

Get these details out of your AWS account:

* The VPC ID where the containers are to be created
* The subnet ID of a private subnet in your VPC - this is where the containers will go
* The subnet IDs of public subnets in your VPC - this is where the load balancer will go

Modify the corresponding `variable` values at the top of the Terraform file and put those values in. 

After that it's a simple matter of running `terraform apply` and waiting for the `hub_address` output to appear, which will be the DNS of the ALB.  Wait a few minutes (the hub container needs to run, register with the ALB target group), then browse to the address and the Selenium Hub page should appear.  If you go to `/grid/console` then you can see the Selenium browser nodes appear as well. 

## The details

### The IAM policy 

Quite often, ECS needs to execute tasks on your behalf.  This would be things like pulling ECR images, creating CloudWatch Log Groups, reading secrets from KMS.  The `ecs_execution_policy` sets out what ECS is allowed to do, and is passed as an `execution_role_arn` when creating a task definition. 

### The Service Discovery and private DNS

In the service discovery section, we create a CloudMap Namespace with the TLD `.selenium`, and under that the service `hub`.   This is passed in the `service_registries` when creating an ECS Service;  the hub hub container registers here, creating the address `http://hub.selenium` so that the various browser containers can easily find the Selenium Hub container without knowing its IP address in advance.


```terraform

## This makes it `.selenium`

resource "aws_service_discovery_private_dns_namespace" "selenium" {
  name        = "selenium"
  description = "private DNS for selenium"
  vpc         = var.vpc_id
}

## This makes it `hub.selenium`

resource "aws_service_discovery_service" "hub" {
  name = "hub"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.selenium.id

    dns_records {
      ttl  = 60
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
```


### The ECS Cluster

An ECS Cluster is just a logical grouping for ECS tasks, it doesn't actually exist as a thing but is more of a designated area for the containers you want to run.  Here we create the selenium grid cluster. 
The most crucial money saving part here is specifying `FARGATE_SPOT` as the capacity provider. 

```terraform
resource "aws_ecs_cluster" "selenium_grid" {
  name = "selenium-grid"
  capacity_providers = ["FARGATE_SPOT"]
  default_capacity_provider_strategy {
      capacity_provider = "FARGATE_SPOT"
      weight = 1
  }

}
```

### The hub task definition

ECS expects containers to be created based on task definitions.  They are somewhat reminiscent of docker-compose files.  Task definitions don't actually run the containers, they just describe what you want when you do. 

The Selenium Hub listens on port 4444, and we've chosen the `selenium/hub:3.141.59` image, and requested 1024 CPU units (1 vCPU) and 2 GB RAM.

```terraform
resource "aws_ecs_task_definition" "seleniumhub" {
  family                = "seleniumhub"
  network_mode = "awsvpc"
  container_definitions = <<DEFINITION
[
   {
        "name": "hub", 
        "image": "selenium/hub:3.141.59", 
        "portMappings": [
            {
            "hostPort": 4444,
            "protocol": "tcp",
            "containerPort": 4444
            }
        ], 
        "essential": true, 
        "entryPoint": [], 
        "command": []
        
    }
]
DEFINITION

requires_compatibilities = ["FARGATE"]
cpu = 1024
memory = 2048

}
```

### The hub service

We can now run the ECS service by referencing the `task_definition`. The `capacity_provider_strategy` ensures it is placed on a Spot instance.  The `service_registries` ensures it grabs the `hub.selenium` address.  The `load_balancer` ensure that it registers with the target group. 

```terraform

resource "aws_ecs_service" "seleniumhub" {
  name          = "seleniumhub"
  cluster       = aws_ecs_cluster.selenium_grid.id
  desired_count = 1

  network_configuration {
      subnets = var.subnet_private_ids
      security_groups = [aws_security_group.sg_selenium_grid.id]
      assign_public_ip = false
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight = 1
  }

  platform_version = "LATEST"
  scheduling_strategy = "REPLICA"
  service_registries {
      registry_arn = aws_service_discovery_service.hub.arn
      container_name = "hub"
  }

  task_definition = aws_ecs_task_definition.seleniumhub.arn

  load_balancer {
    target_group_arn =   aws_lb_target_group.selenium-hub.arn
    container_name   = "hub"
    container_port   = 4444
  }

  depends_on = [aws_lb_target_group.selenium-hub]
}

```

