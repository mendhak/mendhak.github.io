---
title: Developing personal Python apps for Android's Linux environment
description: Exploring the new Android Linux Terminal, how to set up Python and see if personal app development is feasible
tags:
  - android
  - linux
  - terminal
  - ssh
  - tailscale

opengraph:
  image: /assets/images/python-apps-android-linux/010.png

---

Since the Linux Terminal app was introduced for Android, I've been curious about the possibilities it could open up for personal app development. 

Considering that a smartphone is a portable computer, it makes sense that a user ought to have the ability to run their own apps on their own devices. The notion of running bespoke scripts or utilities for personal workflows feels logical and privacy friendly (and is long overdue). 

### Exploring and installing tools

The Android Linux Terminal app is [technically a webview](https://www.androidauthority.com/android-linux-terminal-app-3489887/) which connects to a local Debian Bookworm VM, and works well. All the usual suspects worked straight away. 

It is a tradition that the first thing to do is run `neofetch`:

{% figure "/assets/images/python-apps-android-linux/001.png", "Neofetch, as is tradition", "half" %}


The Gemini CLI installed, and the authentication step was straightforward. Of course I have also configured it to be [a simple adhoc helper](/posts/2025-06-30-gemini-cli-adhoc-helper.md), so I can just type `? "How do I..."` and get an answer. 



{% figure "/assets/images/python-apps-android-linux/002.png", "Gemini CLI", "half" %}


The new [`edit` text editor](/posts/2025-06-02-microsoft-edit-cli-text-editor.md) had no issues. It even recognizes menu clicks with the finger, which is a nice touch (ha...).

{% figure "/assets/images/python-apps-android-linux/003.png", "Microsoft Edit", "half" %}



More developer focused tools like `docker` and `uv` installed using their normal Linux instructions, and didn't feel slow at all. 

{% gallery "`uv` and `docker`" %}
![uv commands are still fast](/assets/images/python-apps-android-linux/004.png)
![A docker container running the http-https-echo listener](/assets/images/python-apps-android-linux/005.png)
![Hitting it from a browser](/assets/images/python-apps-android-linux/006.png)
{% endgallery %}

### Reaching Android Linux ports from the outside

One limitation though, is that the ports are only accessible locally from the device itself. That is, `http://localhost:8080` from the Android device worked, but `http://<my-phone-ip>:8080` from another device on the network did not. 

But this was overcome thanks to Tailscale, a 'mesh network' utility that allows connecting devices together securely, even if they are on different networks. I installed Tailscale using [its convenience script](https://tailscale.com/kb/1031/install-linux). With this in place I was able to access the container port from my desktop using the Tailscale DNS address. 

{% figure "/assets/images/python-apps-android-linux/007.png", "Connecting to a listening port on Android Linux Terminal via Tailscale" %}


### Developing remotely on Android Linux

With the tooling in place and network connectivity established, the next logical step was to try and develop remotely on the device. This wasn't necessary of course, a very simple way to work could be to develop on the desktop, push it up to Github, and pull down in Android Linux Terminal. But that's a lot of extra steps and for personal app development, a fast feedback loop is important.  

To that end, there is a [VSCode extension for Tailscale](https://tailscale.com/kb/1265/vscode-extension). With Tailscale running on the desktop, the extension can connect to the Android Linux instance, and open a VSCode Remote Session. Here I have VSCode connecting remotely, editing, and running files directly on Android's Linux environment.

{% figure "/assets/images/python-apps-android-linux/008.png", "VSCode Remote Session to Android Linux Terminal, notice the bottom left status bar, and the terminal" %}

This is where the power of personal development comes in. I can now write Python scripts in a familiar environment, and run them on the Android device. I don't need permission from anyone, I don't need to publish it anywhere, I can just write a script and run it.

### My book rating prediction example

In the screenshot above, I'm actually training [a simple machine learning model](https://github.com/mendhak/goodreads_book_rating_prediction/blob/master/generate_content_model.ipynb) right on the device. This model uses my existing Goodreads data to then predict whether I would like a new book, given some metadata about it. 

{% figure "/assets/images/python-apps-android-linux/009.png", "Model prediction output", "half" %}

### Developing TUIs with Textual

TUIs (Terminal User Interfaces) are interactive user interface applications for the terminal. A popular library for this is [Textual](https://textual.textualize.io/). It's made for Python, and is pretty simple to use. 

Continuing on from my book rating prediction example above, I wrote [a simple Textual app](https://github.com/mendhak/goodreads_book_rating_prediction/blob/master/textual_goodreads_predictor.py) that would allow me to enter a Goodreads URL. The app would then grab the book metadata from the page, pass it to the model, and output the prediction. 

{% figure "/assets/images/python-apps-android-linux/010.png", "Textual app calling the model", "half" %}

Here it is in action:

<p align="center">
  <video src="/assets/images/python-apps-android-linux/screen-20250809-140910.mp4" controls="controls" width="50%"></video>
</p>



## My thoughts

The experience isn't as difficult as I was expecting, it was simple and intuitive. It does feel viable that anyone could develop their own little personal standalone scripts or apps for the Android Linux Terminal, and deploy it directly. 

It feels quite refreshing to work this way and not having to live under the constraints and chokehold that the present duopoly of app stores have been imposing on us for years, or running the risk of running afoul of opaque rules that allow no recourse. I can just write something and run it. It can be sloppy, experimental, crude, it can break frequently, and that's okay. 

Because it's a sandboxed environment, it does have limitations — there are no USB devices visible, it's a local only network, there is no Android OS/API access — but those limitations are probably what make this viable in the first place. I am not sure how much of this will be opened up, looking at [this video demonstrating a full Debian desktop environment](https://www.youtube.com/watch?v=H2C7GOmbDxw), and [unpublished enhancements that allow running Doom](https://www.androidauthority.com/android-16-linux-terminal-doom-3521804/), it seems like they might want to allow us to develop Android apps in a desktop environment just by plugging in to a dock. This could be interesting in terms of testing and deployment and Android API access. It also reflects a modern demographic trend of people who use phones as their primary device, many who don't bother with desktops or laptops at all. 

There's still some work that could happen to make personal app development easier, such as being able to launch a script from the home screen, but I can probably live without it for now. 

I'm already thinking of other things I could do, involving more helper scripts, [a spongebob mocking generator](https://gist.github.com/mendhak/b4302d1a546053ae528b3151423dde0d), or even exploring if running a local LLM is feasible... I might need to wait for hardware acceleration to be available to do that though. 
