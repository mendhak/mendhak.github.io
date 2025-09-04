---
title: Getting Firefox's chatbot sidebar talking to a local LLM
description: How to get the Firefox AI chatbot sidebar to talk to a local open-webui talking to ollama
tags:
  - firefox
  - local
  - ollama
  - open-webui

---

Firefox has a chatbot sidebar that can be used to interact with the popular LLM chatbot providers, such as Claude, Gemini, and Claude. It is possible to allow it to also talk to a local LLM, although it's not a readily visible option. 

![Firefox running open-webui with ollama](/assets/images/firefox-local-chatbot-ollama/001.png)

The steps, roughly, involved installing ollama, open-webui, and configuring Firefox. 


## Ollama

Installing ollama was simple enough, there's [a convenience script](https://github.com/ollama/ollama/blob/main/docs/linux.md) which also sets it up as a systemd service. 

The only change I made was to the `/etc/systemd/system/ollama.service` file, to make it listen on all interfaces. I added this line to the [Service] section:

```ini
...
[Service]
Environment="OLLAMA_HOST=0.0.0.0"
...
```

Of course I also pulled a few models locally:

```bash
ollama pull llama3.2:1b
ollama pull qwen2.5:1.5b
```

## open-webui

Now ollama just provides an API, but no web interface. The Firefox chatbot sidebar needs to load a web interface, that's where [open-webui](https://github.com/open-webui/open-webui) comes in. 

I decided to run it in Docker. 

```bash
docker run -d -p 8080:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
```

![open-webui running in Docker](/assets/images/firefox-local-chatbot-ollama/002.png)

Then quickly tested it by browsing to http://localhost:8080. 

Since ollama is listening on all interfaces, the open-webui container can reach it easily. It also conveniently lists all the models that ollama has downloaded.


## Firefox config

The final bit is to tell Firefox to use the local open-webui. This was done by setting a preference. 

Under `about:config`, I searched for `browser.ml.chat.hideLocalhost` and set it to `false`. By default, Firefox will now look for an interface running on http://localhost:8080, which open-webui just happens to run on. 

That's it, the chatbot sidebar started showing "localhost" as an option in the top dropdown. 



