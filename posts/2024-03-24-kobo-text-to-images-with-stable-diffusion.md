---
title: "Enhancing Kobo with text-to-image generation and simple explanations"
# title: "Enhancing Kobo with Stable Diffusion text-to-image and OpenAI for ELI5"
# title: "Enhancing reading on the Kobo with GenAI to visualize passages and simplify text"
description: "How I modified my Kobo to generate images from higlighted text using Stable Diffusion, and ELI5 feature to simplify text using OpenAI."
tags:
  - kobo
  - stable-diffusion
  - generative-ai
  - text-to-image
  - openai
  - eli5
  - reading


opengraph:
  image: /assets/images/kobo-text-to-images-with-stable-diffusion/003.png

---

I've modified my Kobo device to generate images from passages of text that I highlight. I select a passage of text, choose the "Visualize" option from the menu, and that text is passed to Stable Diffusion. The output is then displayed on the Kobo's screen. 

Here it is in action. 

{% video "https://www.youtube.com/watch?v=9SvLe1d-Hbw" %}

I've also added an <abbr title="Explain Like I'm Five">ELI5</abbr> feature that simplifies the highlighted text using OpenAI's GPT-3.5. Here is a quick demo:  

{% video "https://www.youtube.com/watch?v=RNr6xvJJYxA" %}


## Motivation

As I have [aphantasia](https://en.wikipedia.org/wiki/Aphantasia), I am unable to visualize images in my mind. Scenes with excessive descriptions can be hard to follow, and maritime scenes with unfamiliar terminology are particularly difficult. That doesn't mean I don't enjoy reading, it's just that I don't read with the ongoing imagery that others might. Having an occasional illustration in a book is appreciated, but outside of the occasional light novel, I don't find illustrations to be very common in fiction books. 

I had been experimenting with Stable Diffusion, a generative AI model that can generate images from text prompts. I thought it would be interesting to see if I could integrate this into my Kobo e-reader to generate images from text passages that I highlight. I don't need an accurate rendering or consistency across image generations, just a rough idea of what the scene might look like, to nudge me along. 

{% gallery "The visualize menu and its output on my Kobo Libra 2" %}
![Choose the visualize menu](/assets/images/kobo-text-to-images-with-stable-diffusion/001.png)
![Output](/assets/images/kobo-text-to-images-with-stable-diffusion/002.png)

![Another example](/assets/images/kobo-text-to-images-with-stable-diffusion/003.png)
![Output](/assets/images/kobo-text-to-images-with-stable-diffusion/004.png)
{% endgallery %}

While I was doing this, the maritime terminology I kept encountering became a motivation to add the "ELI5" feature. I've noticed that when books get into their naval battles, the terminology starts flying thick and fast, and I can't keep up with the repeated dictionary lookups. Having those passages rephrased in simpler terms would be a great help.  

I'll first go over the Stable Diffusion integration for image generation, the ELI5 feature is just a minor addition after that.  


## How the image generation works

At a high level, when the text is highlighted on the Kobo, a custom Visualize menu item is presented. Pressing that fires off a curl command from the Kobo to the Stable Diffusion API running on my PC. Stable Diffusion does its work and returns an image. The image is then saved to the Kobo's storage and displayed in an HTML file in a popup browser window.  

The reason it works is because descriptive passages of text are often quite close to the prompts that you'd use for Stable Diffusion, as they're full of adjectives and scene descriptions. What's different is that books don't contain the _metadata_ of the scene, such as "a digital painting", the artist's style, "wide angle view", and so on. The output can be a bit hit and miss, but having a small bit of metadata hardcoded when making the request can help.  

### Stable Diffusion API

I've first set up Stable Diffusion WebUI to launch with the API enabled. 

```bash
    ./webui.sh --api --listen
```

This allows making requests to the API endpoint at `http://127.0.0.1:7860/sdapi/v1/txt2img`, pretty much the same as you would with the web UI. 

The request to generate an image isn't too complicated. In this example request, I've chosen 512x682 as it's close to my device's screen aspect ratio. 

```bash
curl -s -X POST -H "Content-Type: application/json" --data '{"prompt": "masterpiece, a cat", "negative_prompt": "disfigured, ugly, blurry, watermark", "seed": -1, "steps": 20, "width": 512, "height": 682, "cfg_scale": 7, "sampler_name": "DPM++ 2M Karras", "n_iter": 1, "batch_size": 1}' http://127.0.0.1:7860/sdapi/v1/txt2img
```

I believe this only uses the Stable Diffusion checkpoint already loaded in the web UI. Also worth noting that the generated image is returned as a base64 encoded string in the response.

### Kobo HTML file

I couldn't get the Kobo browser to display *standalone* images (it would prompt to download them), so I had to prepare a basic HTML file that would display the generated image.  

I placed this at `/mnt/onboard/sd.html` on the Kobo. It tries to display the image at full width. The image is pointing at a local path, which the image generation command will be writing to shortly.   

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title></title>
<style>
    html, body {
        height: 100%;
        margin: 0;
        padding: 0;
    }
    .container {
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        overflow: hidden; 
    }
    .container img {
        width: 100%;
        height: 100%;
        object-fit: cover;  
    }
</style>
</head>
<body>
    <div class="container">
        <img src="file:///mnt/onboard/sd.png">
    </div>
</body>
</html>
```

### Kobo custom menu and curl 

I've installed [NickelMenu](https://pgaskin.net/NickelMenu/) on the Kobo device. NickelMenu allows creating custom menu items in the main home area, the reading view, and importantly in the text selection menu.

Although it's a Linux based device, there is no curl installed. For that, I've installed [Niluje's misc packages](https://www.mobileread.com/forums/showthread.php?t=254214) which includes curl.  

Once both of those are in place, it's a matter of adding the custom menu item to the Kobo and the curl command that it will invoke.   

In `/mnt/onboard/.adds/nm/config` :


```
menu_item :selection :Visualize :cmd_output :9000:quiet:/usr/bin/curl -s -X POST -H "Content-Type: application/json" --data '{"prompt": "masterpiece, {1|aS|"$}", "negative_prompt": "disfigured, ugly, blurry, watermark", "seed": -1, "steps": 20, "width": 512, "height": 682, "cfg_scale": 7, "sampler_name": "DPM++ 2M Karras", "n_iter": 1, "batch_size": 1}' http://192.168.50.108:7860/sdapi/v1/txt2img | jq -r '.images[0]' | base64 -d > /mnt/onboard/sd.png 
      chain_success :nickel_browser :modal:file:///mnt/onboard/sd.html
```

There's quite a bit going on here which is worth breaking down.

The `Visualize` menu item is added to the text `:selection` menu. When selected, it fires off the curl command to the Stable Diffusion API and the output is saved to `/mnt/onboard/sd.png`. Of special note here is the `{1|aS|"$}` which is a placeholder for the highlighted text in lowercase. 

There's a bit of additional processing, with `jq` to get the base64 encoded image from the response, and then `base64 -d` to decode that base64 and write it to the PNG file. 

In NickelMenu, the `cmd_output` cannot be more than 10 seconds long, it's 9 in the above example, so it's vital to keep Stable Diffusion's processing as quick as possible, sacrificing quality for speed.

Finally, once the first command completes, the `chain_success` displays the prepared HTML file in a modal browser popup.



## Using OpenAI for simplifying text

Adding the ELI5 feature was a minor addition to the existing NickelMenu and packages setup, since the hard bits were taken care of.  

All it needs is an OpenAI API key and a little prompt to send to the API: 

```
menu_item :selection :ELI5 :cmd_output :9000 :/usr/bin/curl -s -X POST https://api.openai.com/v1/chat/completions      -H "Content-Type: application/json"      -H "Authorization: Bearer sk-xxxxxxxxxxxx" -d '{ "model": "gpt-3.5-turbo-0125", "messages":[{"role":"user","content": "Explain in simpler language the following passage from a book I am reading: \n {1|aS|"$} "}],"max_tokens": 80 }' | jq -r '.choices[0].message.content' | fold -w 50 -s
```

The `cmd_output` simply outputs whatever the curl command returns, which is the simplified text. The `fold` command is used to wrap the text at 50 characters, so it fits on the screen.

And once that's ready, I just highlight some text and pick the ELI5 option. This will be especially useful for maritime scenes and naval battles. 

{% gallery "ELI5 feature in action" %}
![Choose the ELI5 menu](/assets/images/kobo-text-to-images-with-stable-diffusion/005.png)
![Output](/assets/images/kobo-text-to-images-with-stable-diffusion/006.png)
{% endgallery %}



## Limitations and other notes

The Kobo will turn off **wifi** to conserve energy, which usually happens while immersed in reading. What this means is the Visualize command while Wifi is off will launch the wifi scanner to connect before issuing the command; the whole process doesn't always complete within the timeout, and a blank page is displayed. The act of opening the browser does turn on the wifi, so I just try again. 

A very obvious, glaring limitation is that the computer hosting Stable Diffusion needs to be **running**. It wouldn't be accessible while travelling or at work, but that's OK for me. 

Regarding the actual image **display**, I could go a bit more 'cinematic' and generate the images in landscape mode, and rotate them when displayed on the HTML page. That may be something I do in the future.  

Regarding **APIs**, I had considered using OpenAI's DALL-E for image generation — I'm already using GPT3.5 for the "ELI5" feature — but the pricing for their image generation is prohibitive. The cost can be up to $0.08 per image, which is not worth it. But if I find myself using this feature a lot, I might consider finding an online image generation API, if it's cheap. 

Overall I'm happy with the current setup, it's a fun project that adds a bit of extra enjoyment to my reading.
