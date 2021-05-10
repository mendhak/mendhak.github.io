---
title: "How to use KeepassXC to serve SSH keys to WSL2 and Ubuntu"
description: "Using KeepassXC SSH, on Windows 10, to serve SSH keys to WSL 2 running Ubuntu"
categories: 
  - wsl2
  - ssh
  - ubuntu
  - windows
  - keepass

header: 
  teaser: /assets/images/wsl-ssh-keepassxc/004.png


gallery1:
  - url: /assets/images/wsl-ssh-keepassxc/002.png
    image_path: /assets/images/wsl-ssh-keepassxc/002.png
  - url: /assets/images/wsl-ssh-keepassxc/003.png
    image_path: /assets/images/wsl-ssh-keepassxc/003.png
  - url: /assets/images/wsl-ssh-keepassxc/004.png
    image_path: /assets/images/wsl-ssh-keepassxc/004.png
---


I have previously shown how to [serve keys to WSL1](/wsl-keepassxc-ssh/), here I'll be going over the method to do it for **WSL2**. 

KeepassXC can be used to serve SSH keys to WSL2, which is useful when remoting on to servers, or using Git over SSH. Some benefits of putting your SSH key into your KeepassXC are that you can have a strong password on the private key but don't need to type it out each time, and that you don't need to save your keys on disk - you can let KeePassXC manage the storage, unlocking and serving of the keys for you.  


## Set up KeePassXC

Open up KeePassXC's settings, and choose to `Enable SSH Agent` and also `Use OpenSSH for Windows instead of Pageant`.  
The second option requires the OpenSSH service in Windows to already be running, you will get an error message if it isn't. 

![keepassxc settings]({{ site.baseurl }}/assets/images/wsl-ssh-keepassxc/001.png)



### Store an SSH key


Create a new entry in your database, give it some name, and in the password field, put the passphrase for your SSH key. 

In the advanced section, attach your public and private key, then hit OK, then save the entry.  You need to save so that the SSH Agent can read your key in the next step. 

Now reopen the entry, then go to the SSH Agent section, under Private key, pick the file you attached earlier.  The rest of the section should get filled out with details about your key. Once again hit OK and save; KeePassXC is now serving those keys to the Windows SSH agent. 


{% include gallery id="gallery1" caption="KeePassXC settings" %}



## Get Npiperelay


[npiperelay](https://github.com/jstarks/npiperelay) allows named pipes to communicate between Linux in WSL and Windows.  Although it's a Windows based tool, it's still possible to run it from within WSL2, which makes for a convenient setup. 

In your WSL2, download and extract the npiperelay binary. 

```bash
cd ~
wget https://github.com/jstarks/npiperelay/releases/latest/download/npiperelay_windows_amd64.zip
unzip npiperelay_windows_amd64.zip -d npiperelay
rm npiperelay_windows_amd64.zip
```

This puts the npiperelay.exe at `/home/username/npiperelay`.  

You can also [download npiperelay](https://github.com/jstarks/npiperelay/releases) to the Windows side, and substitute the corresponding path below with slash notations, such as `/c/Temp/npiperelay.exe`
{: .notice--info}



## Install socat

In your WSL2, install socat, to allow communication with npiperelay.

```bash
sudo apt install socat
```



## Tell WSL to use it

You will need to tell WSL2 to talk to npiperelay via socat, so that it can talk to Windows SSH Agent, so that it can fetch your keys from KeePassXC.  

In your `~/.bashrc`, add the following lines.  This code checks to see if the agent socket is up, 

```bash
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
    rm -f $SSH_AUTH_SOCK
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$HOME/npiperelay/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi
```

If you've put npiperelay.exe in another location, replace the `$HOME/npiperelay/npiperelay.exe` above.
{: .notice--info}

Exit and reopen your shell, and this should call out to npiperelay.  There is no visual indication to know it's working, you can only find out by testing it. 

## Test it

Assuming you've already added your public key to Github, do a quick test. 

```
$ ssh -T git@github.com
Hi mendhak! You've successfully authenticated, but GitHub does not provide shell access.
```

## All together in one script

Save this to a bash script and execute it.  It should do all of the above steps including writing to `~/.bashrc`.  

```bash
cd ~

echo "Get npiperelay"
wget https://github.com/jstarks/npiperelay/releases/latest/download/npiperelay_windows_amd64.zip
unzip -o npiperelay_windows_amd64.zip -d npiperelay
rm npiperelay_windows_amd64.zip

echo "Install socat"
sudo apt -y install socat

echo "Add to .bashrc"
cat << 'EOF' >> ~/.bashrc
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
    rm -f $SSH_AUTH_SOCK
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$HOME/npiperelay/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi
EOF

echo "Reload ~/.bashrc"
exec bash

echo "Done"

```
