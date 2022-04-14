---
title: "Tool to find Steam trading card sets in common with another user"
description: "A useful tool based on Docker to help with 1:1 or 2:1 trading with other Steam users, it helps  with cross-set trading by finding common trading sets between two users"

categories: 
  - steam
tags: 
  - steam
  - trading

gallery1:
  - url: /assets/images/steam-find-common-trading-sets/001.png
    image_path: /assets/images/steam-find-common-trading-sets/001.png
  - url: /assets/images/steam-find-common-trading-sets/002.png
    image_path: /assets/images/steam-find-common-trading-sets/002.png

header: 
  teaser: /assets/images/steam-find-common-trading-sets/004.png

---

On Steam, I like to trade with other users to complete my card sets, and craft badges.  A common way to find users offering trades is on the [Steam Trading Cards Group](https://steamcommunity.com/groups/tradingcards/discussions).  Now, in this group, some people will accept cross-set trades.  

Usually, a cross-set trade is where you offer cards belonging to a set that they have, in exchange for 1 card from a set that you want to complete.  I find this to be a good way to offload sets that I'm not interested in.  

{% include gallery id="gallery1" layout="half" caption="People accepting cross set trades" %}

The problem: these users often have thousands of cards and it isn't a simple task to click through each page, and figure out which trading sets we have in common.  

I haven't been able to find any tool that can easily compare two users' inventories and show which trading sets they have in common, so I wrote [my own commandline tool](https://github.com/mendhak/steam-find-common-trading-sets) to do this.

## How to use it

The command is:


```bash
docker run --rm -t mendhak/steam-find-common-trading-sets <my_user_steam_id> <their_user_steam_id>
```

To get the Steam IDs, I use the [steamid.io website](https://steamid.io/).  Entering the Steam usernames there will reveal the SteamID64.  

[![SteamID]({{ site.baseurl }}/assets/images/steam-find-common-trading-sets/003.png)]({{ site.baseurl }}/assets/images/steam-find-common-trading-sets/003.png)

This gives: 

```bash
docker run --rm -t mendhak/steam-find-common-trading-sets 76561197984170060 76561198033232307
```

Running this command, the two inventories are fetched and compared, and the output is presented in a table.  

The gray text shows cards that both users have in common, the whiter text shows cards that one user has that the other doesn't.  

[![Results]({{ site.baseurl }}/assets/images/steam-find-common-trading-sets/004.png)]({{ site.baseurl }}/assets/images/steam-find-common-trading-sets/004.png)


## Notes

This tool is a basic NodeJS script which runs against the semi-documented Steam API.  It will fetch the inventory for each user, and for users with a lot of items, this can take a little time.  There are some Steam API quirks, so sometimes the API calls can simply start failing for unknown reasons.  Just rerun the tool again and it should start working again.  

After fetching inventory items, it then performs the comparison and renders the results in a table in the terminal for easy viewing.  There's also some filtering done to remove gems and avatars and emotes.  And finally the output text is colored to indicate which cards are common and which cards are exclusive to each user.  

