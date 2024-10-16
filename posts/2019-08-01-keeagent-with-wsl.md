---
title: "How to use KeeAgent with WSL and Ubuntu"
description: "Using KeePass and KeeAgent with WSL on Windows 10 with Ubuntu"
tags:
  - keepass
  - windows 10
  - wsl
---

How to serve SSH keys to `ssh` running in WSL (Ubuntu) from KeeAgent running in Windows 10. 


## Using KeeAgent with WSL

WSL (Windows Subsystem for Linux) has been gaining popularity in recent years, as it allows running an Ubuntu shell from within Windows.  Its architecture involves a degree of separation and so  there are additional steps to get ssh in WSL/Ubuntu talking to KeeAgent running in Windows. 


{% notice "info" %}
This is a follow up to the previous post, [Using KeePass to serve SSH keys](/posts/2019-07-28-keepass-and-keeagent-setup.md).  
This post also assumes you have [already installed WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) 
{% endnotice %}


### Get weasel-pageant

Although weasel-pageant is meant to allow usage of Pageant keys from WSL, it works just as well for our use case, since KeeAgent is also compatible with Putty. 

{% button "Download weasel-pageant", "https://github.com/vuori/weasel-pageant/releases" %}

Extract the zip in Windows, not in WSL.  You can place it anywhere.  If you're keeping with the portable theme, it can be placed in a synched directory near Keepass and your KDBX.   

![KeeAgent downloaded](/assets/images/keepass-ssh/keepass-ssh-key-11.png)

### Tell WSL to use it

You will then need to tell WSL to talk to the weasel-pageant.  In WSL, add the following lines to `~/.bashrc`, remember to modify `weaselpath` to match the directory where you extracted weasel-pageant. 


```bash
weaselpath="/mnt/c/Users/mendhak/Google Drive/Documents/keys/wsl-pageant-helper/"
echo -n "pageant loading, wait..."
"$weaselpath/weasel-pageant" -k> /dev/null 2> /dev/null
eval $("$weaselpath/weasel-pageant" -r -a "/tmp/.weasel-pageant-$USER")> /dev/null 2> /dev/null
sleep 1
sshkeysloaded=$(ssh-add -l | grep -c SHA)
if [[ $sshkeysloaded -gt 0 ]];  then
    echo -e "Loaded $sshkeysloaded keys."
else
    echo -e "Failed to load any keys."
fi
```

{% notice "info" %}
In WSL, Windows paths are prefixed with `/mnt/c/` for `C:`, and paths with spaces require double quotes around them.  
If you've changed your WSL mount point to `/c/`, be sure to reflect that in the path above.
{% endnotice %}

### Test it

Reload a WSL bash session and you should see `pageant loading, wait...` at the top.  Once your bash prompt appears, test a connection to Github as usual. 

```bash
ssh -T git@github.com
```


![Testing Keeagent](/assets/images/keepass-ssh/keepass-ssh-key-12.png)
