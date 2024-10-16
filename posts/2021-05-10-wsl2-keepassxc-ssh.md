---
title: "How to use KeepassXC to serve SSH keys to WSL2 and Ubuntu"
description: "Using KeepassXC SSH, on Windows 10, to serve SSH keys to WSL 2 running Ubuntu"
tags: 
  - wsl2
  - ssh
  - ubuntu
  - windows
  - keepass

opengraph: 
  image: /assets/images/wsl-ssh-keepassxc/004.png

last_modified_at: 2023-08-22

---


I have previously shown how to [serve keys to WSL1](/posts/2020-05-03-wsl-keepassxc-ssh.md), here I'll be going over the method to do it for **WSL2**. 

KeepassXC can be used to serve SSH keys to WSL2, which is useful when remoting on to servers, or using Git over SSH. Some benefits of putting your SSH key into your KeepassXC are that you can have a strong password on the private key but don't need to type it out each time, and that you don't need to save your keys on disk - you can let KeePassXC manage the storage, unlocking and serving of the keys for you.  


{% notice "info" %}
You can also skip the steps and go straight to [the setup script](#all-together-in-one-script)
{% endnotice %}


## Set up KeePassXC

Open up KeePassXC's settings, and choose to `Enable SSH Agent` and also `Use OpenSSH for Windows instead of Pageant`.  
The second option requires the OpenSSH service in Windows to already be running, you will get an error message if it isn't. 

![keepassxc settings](/assets/images/wsl-ssh-keepassxc/001.png)



### Store an SSH key


Create a new entry in your database, give it some name, and in the password field, put the passphrase for your SSH key. 

In the advanced section, attach your public and private key, then hit OK, then save the entry.  You need to save so that the SSH Agent can read your key in the next step. 

Now reopen the entry, then go to the SSH Agent section, under Private key, pick the file you attached earlier.  The rest of the section should get filled out with details about your key. Once again hit OK and save; KeePassXC is now serving those keys to the Windows SSH agent. 


{% gallery "KeePassXC settings" %}
![](/assets/images/wsl-ssh-keepassxc/002.png)
![](/assets/images/wsl-ssh-keepassxc/003.png)
![](/assets/images/wsl-ssh-keepassxc/004.png)
{% endgallery %}

## Get Npiperelay


[npiperelay](https://github.com/jstarks/npiperelay) allows named pipes to communicate between Linux in WSL and Windows. It is a Windows based tool and needs to be run from the Windows side. 

You can do this from WSL2, download and extract the npiperelay binary to a Windows directory of your choice.  

```bash
npiperelaypath=$(wslpath "C:/npiperelay")
cd ~
wget https://github.com/jstarks/npiperelay/releases/latest/download/npiperelay_windows_amd64.zip
unzip npiperelay_windows_amd64.zip -d $npiperelaypath
rm npiperelay_windows_amd64.zip
```

This puts the npiperelay.exe at `C:\npiperelay\`, so adjust the path to your liking.  

{% notice "info" %}
You can also [download npiperelay](https://github.com/jstarks/npiperelay/releases) to the Windows side, and substitute the corresponding path below with slash notations, such as `/c/Temp/npiperelay.exe`
{% endnotice %}



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
    npiperelaypath=$(wslpath "C:/npiperelay")
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$npiperelaypath/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi
```

{% notice "info" %}
If you've put npiperelay.exe in another location, replace the `$HOME/npiperelay/npiperelay.exe` above.
{% endnotice %}

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
unzip npiperelay_windows_amd64.zip -d $npiperelaypath
rm npiperelay_windows_amd64.zip

echo "Install socat"
sudo apt -y install socat

echo "Add to .bashrc"
cat << 'EOF' >> ~/.bashrc
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
    rm -f $SSH_AUTH_SOCK
    npiperelaypath=$(wslpath "C:/npiperelay")
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$npiperelaypath/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi
EOF

echo "Reload ~/.bashrc"
exec bash

echo "Done"

```

## Troubleshooting Notes

### Make sure the versions match

On Windows 11, you may also need to ensure that the OpenSSH versions match or are close enough. First, check the Ubuntu SSH version. 

```bash
$ ssh -v localhost
OpenSSH_8.9p1 Ubuntu-3ubuntu0.1, OpenSSL 3.0.2 15 Mar 2022
```

On Windows 11 I've found the version of OpenSSH is a bit older so I've had to install a later, matching version using winget. In Powershell:

```powershell
> winget install Microsoft.OpenSSH.Beta --version 8.9.1.0
```

Once these versions were close enough, the SSH Agent started working. 

