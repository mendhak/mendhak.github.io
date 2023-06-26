---
title: .NET's underrated configuration feature
description: The hierarchical configuration combined with double underscore notation makes for a powerful and simple featureset
tags:
  - dotnet
  - configuration
  - json
  - secrets
  - environment-variables
  - fargate
  - aws

opengraph:
  image: /assets/images/dotnet-simple-powerful-configuration/001.png

---

My favorite kind of features are usually ones that let you start simple and still let you build powerfully on top without being overwhelming. .NET's [ConfigurationBuilder](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.configuration.configurationbuilder) being one, is one of my favorite framework features. It's used regularly in codebases, without much thought given to it, but I wanted to take a moment to appreciate it. 

The setup starts with a simple block, 

```csharp
var currentEnvironment = Environment.GetEnvironmentVariable("ENVIRONMENT_NAME"); 

var config = new ConfigurationBuilder()
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
    .AddJsonFile($"appsettings.{currentEnvironment}.json", optional: true)
    .AddEnvironmentVariables().Build();
```

which does a few things: 

* Look for an `appsettings.json` file, and read values from it
* Look for an `appsettings.{currentEnvironment}.json` file where the `currentEnvironment` name can in turn be loaded from an environment variable
* Read further values in from environment variables
* Have values loaded later override values loaded previously

It also fails gracefully by allowing all of the above to be optional, which means you don't have to do anything at all. And you're not limited to JSON files, you can also provide in memory lists, or even your own configuration.  

### Appsettings in action

Suppose there's just an `appsetting.json` file with a Subject and a Name section. 

```json
{
    "Subject": {
        "Name": "From Default"
    }
}
```

This could be available to the application code via a colon `:` separator for each hierarchy. 

```csharp
Console.WriteLine($"Hello, {config["Subject:Name"]}");
```

Running the program would then produce a very expected output. 

```bash
$ dotnet run
Hello, From Default
```

If you now add an `appsettings.production.json` with some different value, and set the current environment to production, the values from this new file override what the default provided. 

```bash
$ ENVIRONMENT_NAME=production dotnet run
Hello, From Production!
```

### Provide values at runtime using double underscore

Now the best bit: it's further possible to override whatever's in the appsettings JSON files, at runtime. The convention is simple, supply it via environment variables using the double underscore notation `__` in place of colons `:`. 

For the `Subject:Name` example, the environment variable, this would be `SUBJECT__NAME`, which would take precedence, regardless of environment. 


```bash
$ ENVIRONMENT_NAME=production SUBJECT__NAME=Dennis dotnet run
Hello, Dennis

# Works in Docker too
$ docker run -e ENVIRONMENT_NAME=production -e SUBJECT__NAME=Harry --rm dotnetconfigdemo:latest
Hello, Harry

```

### Useful for secrets

This is an especially useful feature because it means that specific configuration values can be provided from external sources including secret managers. 

When deploying a .NET application to containers, you can use a provider of your choice to set those secrets. 

For serverless deployments such as Fargate, this pairs really nicely by having the environment variable [fetched securely from Secrets Manager](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/secrets-envvar-secrets-manager.html#secrets-envvar-secrets-manager-update-container-definition), without writing any extra code. It's simply part of the ECS Task Definition

```json
{
  "containerDefinitions": [{
    "secrets": [{
      "name": "SUBJECT__NAME",
      "valueFrom": "arn:aws:secretsmanager:region:aws_account_id:secret:secret_subject_name"
    }]
  }]
}
```

I'm always a fan of making security easy, and this is a great example.  

### Notes

The actual double underscore notation `__` doesn't seem well promoted, or it isn't readily surfaced via search results and samples. The first place I've encountered it was [here](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/configuration/?view=aspnetcore-7.0#non-prefixed-environment-variables) under the title 'Non-prefixed environment variables'. 

I've created a [sample repo here](https://github.com/mendhak/Dotnet-Configuration-Inheritance-Demo/) demonstrating the environment and appsettings capabilities.  

