---
title: Hands on LLM programming tutorial for developers
description: Help make sense of programming with LLMs for people without a machine learning background
tags:
  - genai
  - llm
  - langchain
  - openai

---

In this post I will go over an approach to getting developers familiar with LLMs, and how to write code against them. It is not meant to be in depth in any way, nor will it cover the inner workings of LLMs or how to make your own. The aim is to simply get developers comfortable interacting with LLMs. There are nuances in the concepts involved, and those will be skipped as well.   

For this tutorial you will need access to a commercial off-the-shelf LLM service, such as OpenAI Platform, Azure OpenAI, or Amazon Bedrock; in my examples I will be referencing OpenAI's playground but the others will have similar functionality to follow along. You'll also need a Python notebook, which can be a service like [Google Colab](https://colab.research.google.com), [Paperspace Gradient](https://www.paperspace.com/), or [locally in VSCode](https://code.visualstudio.com/docs/datascience/jupyter-notebooks). 


## Clarify some terms

It's boring but important to get familiar with some of the words that are used in this area. Some are pure marketing, and some have specific meanings. 

**AI** is supposed to be the branch of computer science trying to get machines to do intelligent things. It has now been coopted by mainstream media and is now a marketing buzzword, used to describe any sufficiently advanced technology that wows people. As an example, text to speech conversion (dictation) was referred to as AI when it first came out decades ago, but is now a pedestrian aspect of many application interfaces.  

**Machine Learning** is a subset of AI (the field) that focuses on the development of algorithms and models to enable the performance of specific tasks, like predicting the weather, or identifying a dog breed from a photograph. 

**Large Language Models**, or LLMs, are a specific type of model that have been trained on a large amount of text data, to understand and generate human like language as an output. LLMs have been gaining a lot of media and business attention in the past few years. Well known LLMs are GPT by OpenAI, Claude by Anthropic, and LLaMa by Meta. 

**Image generation models**, are also gaining attention, and these can generate an image based on a text description, in various styles and degrees of realism. The most well known systems here are Dall-E, MidJourney and Stable Diffusion. 

Similarly there are also models for music generation, video generation, code generation, and speech. The collective term for these content creation models is **Generative AI**, or shortened to GenAI to appear in-the-know in circles of acquaintances who don't know the difference and don't care anyway. 

Of the many types, LLMs get a lot of attention from businesses, research, and hobbyists, because they are very easy to work with, it's just text input and output; and there are a lot of techniques emerging to optimize working with them. 


## Text completion and patterns

In your LLM playground, switch to the completions tab. Completions is very close to the raw interface of an LLM, you just provide it with some text and a few additional parameters. 

Give it any sentence fragment to begin with, like

    Once upon a time, 

and let it generate text. It might appear a little nonsensical, but the LLM simply produces what it thinks should come next after your fragment. 

Try a few more fragments, which can be quite revealing. 

    The following is a C# function to reverse a string:

See how it produces the function, but carries on predicting until it reaches the maximum length.  

Next, try adjusting the temperature slider, and see how it affects the output.  For example, try the following input at temperature = 0 and then at temperature = 1. 

    The sky is blue, and 
 
**Temperature** influences the randomness of the model's output; at higher temperatures the generated text is more creative, and at lower temperatures it's more focused. When programming against LLMs, using low temperatures is better if you need a more deterministic, repeatable output.  

{% gallery %}
![Completing text](/assets/images/hands-on-llm-tutorial/005.png)
![Temperature = 1, more creativity](/assets/images/hands-on-llm-tutorial/006a.png)
![Temperature = 0, tighter description](/assets/images/hands-on-llm-tutorial/006b.png)
{% endgallery %}


### Tokens and context

**Tokens** are mentioned frequently in LLM interfaces, conversations, as well as pricing, so they're a pretty important concept. 

Tokens are the units of text that the models understand. They are sometimes full words, and sometimes parts of words or punctuation. The best way to see for yourself is to try the [OpenAI Tokenizer](https://platform.openai.com/tokenizer) and see the example. 

![Token example](/assets/images/hands-on-llm-tutorial/008.png)

Notice that some words get split up, some characters that often appear together are grouped up, and some punctuation marks get their own token. There is no exact conversion between tokens and words but the most common idea is to consider on average 4 to 5 characters as be a token.  

LLMs come with a **token context** or context window. It includes your input prompt, the output from the model, and any other previous tokens you may have included. LLMs come with a limited token context which is the maximum number of tokens the LLM can handle while still (sort of) being effective at its predictions. 

Some well known examples: 

* GPT 3.5: 16k tokens
* GPT 4: 32k tokens
* GPT 4 Turbo: 128k tokens
* Claude v2: 100k tokens
* LLaMa2: 4k tokens

It might appear that the 100k+ LLMs are 'the best' for being able to handle so many, but it's not a numbers game. In practice, LLMs start to lose attention when it has to deal with too much input, and start producing nonsense output anyway. And it's more expensive. 



