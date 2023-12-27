---
title: GraphQL's poor developer experience
description: Exposing a GraphQL API to third party developers results in a poor experience, but not for the API owners.
tags:
  - ux
  - user-experience
  - dx
  - devex
  - developer-experience
  - graphql
  - rest


---

GraphQL's touted advantages are numerous, including data retrieval efficiency, and flexibility that it can enable. [This page](https://www.apollographql.com/docs/intro/benefits/) even calls its developer experience its greatest benefit, but this is only true from the API owner's perspective, not the API consumer's. That might explain why it sells so well to API development teams in organisations; their local experience gives them the assumption that their own experience will mirror the consumer's.

Of course this is not true, GraphQL APIs are a poor user experience, especially the first time user experience. The documentation is often dense and hard to follow, and this is best illustrated through some real life examples such as the [Github GraphQL API](https://docs.github.com/en/graphql) and the [Gitlab GraphQL API](https://docs.gitlab.com/ee/api/graphql/). Both have to introduce help documentation on how to understand GraphQL itself, and the user is immediately hit with jargon and terminology that they must adopt, as well as recommended tooling and libraries that the user should look at right away as the way of getting familiar with their API. 

But that isn't enough, working through the reference documentation is another chore, and the user is given a list of unintuitively named objects to sift through to figure out how to accomplish their goal. Have a look at the object names in these screenshots.

{% gallery %}
![Gitlab](/assets/images/graphql-poor-developer-experience/001.png)
![Github](/assets/images/graphql-poor-developer-experience/002.png)
{% endgallery %}

These are completely unhelpful to a new user, and appear to be more like leaky abstractions of internal implementation details. Few of the actual objects come with a decent explanation and many just refer to other parts of the equally sparse documentation. This isn't specific to these two examples, it's a common pattern across many GraphQL APIs.

Contrast this with their REST APIs, from the same organisations, in these screenshots. 

{% gallery %}
![Gitlab](/assets/images/graphql-poor-developer-experience/003.png)
![Github](/assets/images/graphql-poor-developer-experience/004.png)
{% endgallery %}

Notice the endpoints named in a human readable way, the documented requests and responses with examples, and simple curl commands to try out the endpoint with. The biggest advantage here is the ability to get started with the API right away, without having to install any libraries or tools or get familiar with academic terminology. This is low friction onboarding and invaluable to the first time user experience. 

It does make sense to offer GraphQL APIs to in-house teams, as any lack of documentation quality is offset by ready communication channels and oral tradition. But offering it to third party developers shifts a great deal of cognitive burden onto them, and indeed this has been my unpleasant experience working with various GraphQL APIs. There's more reading to do, more terrible GraphQL explorers to learn to use, and more client side libraries that become necessary to adopt to achieve any semblance of integration. The GraphQL landscape exemplifies the opposite of [Don't Make Me Think](https://en.wikipedia.org/wiki/Don%27t_Make_Me_Think).


## What is the motivation?

Still, I wanted to try and understand the motivation these companies had behind the shift to GraphQL as an offering to third party developers; many are large companies with a lot of talented people, and they must have some good reasons. Sadly I could not find much except for a few blog posts that parroted each other with the same talking points. Most testimonials about GraphQL are from producers which greatly skews perceptions.  

I did however find a good attempt at an explanation from Github's own launch blog post, introducing [The GitHub GraphQL API](https://github.blog/2016-09-14-the-github-graphql-api/). They're trying to solve two problems. The first is addressing scalability, to address unwieldy APIs with bloat. The second one is more telling:

>  We wanted to be smarter about how our resources were paginated. We wanted assurances of type-safety for user-supplied parameters. We wanted to generate documentation from our code. We wanted to generate clients instead of manually supplying patches to our Octokit suite.  
> ...  
> And then we learned about GraphQL.

What miraculous serendipity that these just happen to be the precise areas that GraphQL aims to tackle. Someone more cynical, like myself, might say they had already decided to use GraphQL and were looking for ways to justify it. 

At the time of 'selling' GraphQL to the rest of the organisation, it's the points around scalability and efficiency in the *creation process* that would have made it compelling to the decision makers — user experience would have been a secondary concern. If it was a topic at all, it would have been handwaved away at best with the parroted "great developer experience" with nods around the room. 

That would explain the state of the documentation. It's generated from their code, but as is clear, [self documenting code is a myth](https://www.ericholscher.com/blog/2017/jan/27/code-is-self-documenting/) perpetuated by people who don't want to write documentation. 


Looking at the blog post I could not find how this improved things for end users. The only sentence fragment that actually addresses developer experience is here:

> we heard from integrators that our REST API also wasn’t very flexible

All of them, or was this a selected set of voices? Do they hear feedback about GraphQL not being simple, or does that get ignored?

## Other notes

I did find one good example of a GraphQL API offering, and that was Shopify's. The object names, though still somewhat leaky, are better named and organized, and they [come with examples](https://shopify.dev/docs/api/admin-graphql/2023-10/queries/app) as well as curl commands. If I had to guess, what Shopify have probably done which others haven't, is think about the functionality they're trying to enable, and design around that. 

I had mistakenly thought that [Microsoft's Graph API](https://learn.microsoft.com/en-us/graph/overview) was great exception to my observations, as an example of what a good GraphQL offering could look like. But it turns out they've gone for a hybrid approach - it's a REST offering, with graph like querying capabilities. This is a good compromise, and potentially the best of both worlds.

Overall GraphQL has left a sour taste for me as an end-user. What promised to be a great new developer experience, with good reasons, has turned out to be a poor one through our industry's continuing lack of empathy and care for the end user. 

Although the GraphQL intentions seem to be in the right place, it suffers from a shade of overhype endemic to our industry. I think there ought to be some effort from the forces driving GraphQL promotion to address user experience, especially documentation. Acknowledging that the onus of user experience is on the API producer would go a long way towards promoting and improving upon their [best practices](https://graphql.org/learn/best-practices/). 

Until then it feels that the GraphQL community is so busy patting itself on the back for solving specific problems of API producers, that it has forgotten about the end user.
