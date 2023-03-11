---
title:      Syncing your Github status with your currently playing Steam game 
description: "Read the currently playing game on Steam and set it as a Github Status, with busy icon and expiry time"

tags:
 - tech
 - gaming
 - steam
 - github

opengraph:
  image: /assets/images/steam-github-profile-status/001.png

---

I have written a script that will attempt to update your Github user profile status with the game currently being played on Steam.  I haven't been using the Github Profile Status feature for any purpose, so might as well use it for something interesting to me.  

![Example](/assets/images/steam-github-profile-status/001.png)

The script can mark the status as 'busy', and also expires the status after a certain number of hours. 

{% githubrepocard "mendhak/steam-github-profile-status" %}

## Setup

The script is available as a Github Action, a Docker image, and a standalone script.  That should provide enough flexibility to run it as part of Github CI, or a Raspberry Pi, or something else.  

Regardless of how you run it, there is a little setup required first.  

Your Steam Profile will need to be set to public, since the library used simply scrapes the Steam profile page.  You'll also need to know what your Steam ID is, which you can get from [SteamID.io](https://steamid.io/).  

On Github, you will need to generate a [Github Access Token](https://github.com/settings/tokens), with the `user` scope. 

### Run it as a Github Action

You can consider running it [on a Github Action schedule](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule).  


      - name: Set My Github Status From Steam
        uses: mendhak/steam-github-profile-status@v1.1
        env:
          STEAM_USER_ID: "YOUR_STEAM_USER_ID"
          GITHUB_ACCESS_TOKEN: "${{ secrets.MY_GITHUB_ACCESS_TOKEN }}"

Where `MY_GITHUB_ACCESS_TOKEN` is an Actions Secret in your repository, and it contains the Github Access Token value generated earlier. 

### Run it in a Docker container

To run it in a Docker container:

    docker run --rm -e GITHUB_ACCESS_TOKEN=xxxxxxxxxxxxxxxxx -e STEAM_USER_ID=76561197984170060 mendhak/steam-github-profile-status:latest

### Run it standalone

To run it as a standalone NodeJS script:

    export STEAM_USER_ID=76561197984170060
    export GITHUB_ACCESS_TOKEN=xxxxxxxxxxxxxxxxx
    node index.js


## Additional configuration

You can choose whether you are shown as busy or not by passing a `GITHUB_STATUS_SHOW_BUSY=True` environment variable.

You can set the status expiry time in hours by passing a `GITHUB_STATUS_EXPIRES_AFTER=3` environment variable. 

## Limitations

So far I haven't found a way to get this to work with non-Steam games.  The library I'm using doesn't expose this information and [I've raised an issue on their Github repo](https://github.com/DoctorMcKay/node-steamcommunity/issues/290)



