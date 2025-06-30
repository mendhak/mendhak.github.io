---
title: Using Gemini CLI as an adhoc commandline question answerer
description: Using Gemini CLI to quickly ask a question and get an answer, without interacting with it. 
tags:
  - gemini
  - cli
  - llm
  - helper
  - linux

openGraph:
  image: /assets/images/gemini-cli-adhoc-helper/002.png
  
---

Google's [Gemini CLI](https://github.com/google-gemini/gemini-cli/) is command line, context aware assistant: it looks at your current directory, tools, and tries to make helpful suggestions. Here I go over how I was able to _somewhat_ trim it down to a simple adhoc helper. I just type `? "How do I..."` and get an answer. 

### What `gemini` does

By default, `gemini` runs in an interactive mode. It starts up a text interface with a little text-input-box, where you can ask questions, it provides answers, and you carry on the chat there. 

![Gemini CLI in action](/assets/images/gemini-cli-adhoc-helper/001.png)

### What I want

I'm not so interested in this mode, I would prefer that this tool answer my question and get out of my way. And I'm really keen on using `?` as the invoker because it's so short and easy to type. 

```
$ ? "How do I list all files in a directory?"

You can use the `ls` command to list files in a directory!
```



### The `--prompt` flag

To that end, it does have a `--prompt` flag which works in a non-interactive mode, and this is what I'm interested in. 

Unfortunately, out of the box, I found its defaults to be somewhat unsafe; it has access to some tools already, and those tools execute even when using the `--prompt` flag, without asking. A decision probably made to make it more convenient. 

### How I configured it

Gemini can work off a settings file, located at `~/.gemini/settings.json`, in which I disabled its core tools: 

```json
$ cat ~/.gemini/settings.json

{
  "theme": "Dracula",
  "selectedAuthType": "oauth-personal",
  "coreTools": [],
  "autoAccept": false
}

```

Further, it can take a `~/.gemini/GEMINI.md` file which gives it the context for the questions. I told it to be simple:

```bash
$ cat ~/.gemini/GEMINI.md

Act only as an adhoc commandline assistant. 
When asked a question, answer the question briefly. 
Important: NEVER offer to run any tools.
```

And finally, to be able to use the `?` command, I added this to my `.bashrc`:

```bash
? () {
    gemini --prompt "$*"
}
```

That's it, the results were just what I wanted:

![The adhoc helper in action](/assets/images/gemini-cli-adhoc-helper/002.png)

