---
title: "Setting up a WSL1 dev environment from the command line"
description: "Command line steps for setting up a WSL1 environment, including enabling WSL, setting the mount point, permissions, installing Docker and Docker compose and other tweaks."
categories:
  - wsl
  - ssh
  - ubuntu
  - windows
  - keepass
  - pgp
  - git

header: 
  teaser: /assets/images/my-wsl-dev-setup/001.png


---



Steps that I take to install WSL with Ubuntu, and set up a dev environment to work with Docker, correct permissions and a few other tweaks, on Windows 10.  I'll show the commands to run with explanations.

You can also [go straight to the automation scripts](#automating-the-whole-thing).

## Enable WSL

If Windows Subsystem for Linux isn't already set up, run this from a Powershell (admin) prompt.

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

You will need to reboot after this.


### Get the Ubuntu 18.04 image

You can install [Ubuntu 18.04 from the Microsoft Store](https://www.microsoft.com/en-gb/p/ubuntu-1804-lts/9n9tngvndl3q).
You can also just do it via Powershell (admin); download the `.appx` directly and install it. 

```powershell
New-Item -ItemType Directory -Force -Path C:\Temp
Invoke-WebRequest -Uri "https://aka.ms/wsl-ubuntu-1804" -OutFile "C:\Temp\UBU1804.appx" -UseBasicParsing
Add-AppxPackage -Path "C:\Temp\UBU1804.appx"
```


I'm choosing Ubuntu 18.04 as [20.04 currently has a critical bug](https://github.com/microsoft/WSL/issues/4898), and there are [more details here](https://discourse.ubuntu.com/t/ubuntu-20-04-and-wsl-1/15291)
{: .notice--warning}

## Configure Ubuntu

Run the first time install.  This creates a root user, needed in the next step, and not your own user yet.  

```powershell
ubuntu1804.exe install --root
```

Verify that the install worked:

```powershell
> wsl --list
Windows Subsystem for Linux Distributions:
Ubuntu-18.04 (Default)
```


### Set /c/ as the mount point

Set `/c/` as the mount point, instead of the default `/mnt/c/` - this is needed to work with Docker Desktop for volume mounting.
Also, set a permission mask so that WSL can invoke applications in Windows.

```powershell
ubuntu1804.exe run "echo '[automount]' > /etc/wsl.conf"
ubuntu1804.exe run "echo 'root = /' >> /etc/wsl.conf"
ubuntu1804.exe run "echo 'options = \""metadata,umask=22,fmask=11,uid=1000,gid=1000\""' >> /etc/wsl.conf"
```

### Create your user

Now create a user, in this example the username is `mendhak`, just set it to what you want.  
You will be prompted to set a password too.  
The user will also be configured to run sudo commands without a password prompt. 

```powershell
ubuntu1804.exe run adduser mendhak --gecos "First,Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
ubuntu1804.exe run usermod -aG sudo mendhak
ubuntu1804.exe run "echo 'mendhak ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
ubuntu1804.exe run passwd mendhak
ubuntu1804.exe config --default-user mendhak
```

Verify that the user has been created properly:

```powershell
> ubuntu1804.exe run whoami
mendhak
```


### Open MS Terminal

At this point if you open [Microsoft Terminal](https://www.microsoft.com/en-gb/p/windows-terminal/9n0dx20hk701?rtc=1), the Ubuntu 18.04 distro should be recognized and appear in the list of shells.  

Choose Ubuntu.  The user should already be set to `mendhak` and the path should already be set to `/c/Users/...`. 

![wsl]({{ site.baseurl }}/assets/images/my-wsl-dev-setup/001.png)

### Install some dependencies

Basic updates, and adding `~/.local/bin` to the path:

```bash
sudo apt-get -y update
sudo apt-get -y upgrade
mkdir -p ~/.local/bin
source ~/.profile
```

Packages that will be needed for development:

```bash
sudo apt-get install -y unzip git figlet jq screenfetch \
    apt-transport-https ca-certificates curl software-properties-common \
    python3 python3-pip build-essential libssl-dev libffi-dev python-dev  
```

### Install Docker Desktop for Windows

Over in Windows 10, install [Docker Desktop](https://www.docker.com/products/docker-desktop).  The installer should configure HyperV for you as well.  
After installation, be sure to go to Docker Desktop's settings, and choose to `Expose daemon on tcp://localhost:2375 without TLS`

![docker]({{ site.baseurl }}/assets/images/my-wsl-dev-setup/002.png)

It's also possible to automate the installation of Docker Desktop from Powershell:

```powershell
Start-BitsTransfer -Source "https://download.docker.com/win/stable/Docker%20Desktop%20Installer.exe" -Destination "C:\Temp\docker-desktop-installer.exe"
C:\Temp\docker-desktop-installer.exe install --quiet
```

You can even enable the option to expose the daemon by directly modifying Docker's settings file.  

```powershell
$dockerpath = "$env:APPDATA\Docker\settings.json"
$settings = Get-Content $dockerpath | ConvertFrom-Json
$settings.exposeDockerAPIOnTCP2375 = $true
$settings | ConvertTo-Json | Set-Content $dockerpath
```

Then restart Docker Desktop.

### Install docker and docker-compose

Continuing in WSL, install the Docker client first, and add your user to the docker group. Additionally, use an environment variable to point the Docker client at the Windows host. 

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -E apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get -y update
sudo apt-get install -y docker-ce 
sudo usermod -aG docker $USER

echo "export DOCKER_HOST=tcp://localhost:2375" >> ~/.bashrc && source ~/.bashrc
```

Verify that docker can talk to the Windows host

```bash
docker info
docker run hello-world
```

Now install docker-compose

```bash
pip3 install --user docker-compose
```

Verify that the install worked:

```bash
docker-compose version
```




### Configure GPG

GPG needs to be told what kind of terminal this is, to allow prompting for passphrase. 

```bash
echo 'export GPG_TTY=$(tty)' >> ~/.bashrc
```

### Create SSH directory

Create your SSH directory with the right permissions. 

```bash
mkdir -p ~/.ssh/
chmod 700 ~/.ssh
```

### Configure umask

Due to a [umask bug in WSL1](https://github.com/microsoft/WSL/issues/352), files can appear with incorrect permissions. To fix it:
 
```bash
echo '[[ "$(umask)" == '\''0000'\'' ]] && umask 0022' >> ~/.bashrc
```

To test this, 

```bash
umask
source ~/.bashrc
umask
```

The first output should be `0000`, and the second should be `0022`


## Starting over

In case you mess up, just delete the distribution. 

```powershell
wsl --terminate Ubuntu-18.04 
wsl --unregister Ubuntu-18.04 
```

And [configure Ubuntu again](#configure-ubuntu)



## Automating the whole thing

It's also possible to automate the entire process - from installing WSL to Ubuntu to configuring the bash environment, and even installing Docker Desktop for Windows.  

You will need two scripts, a `preparewsl.ps1` and a `preparewsl.sh`.  

[preparewsl.ps1](https://github.com/mendhak/automated-wsl-dev-setup/blob/master/preparewsl.ps1){: .btn .btn--info} [preparewsl.sh](https://github.com/mendhak/automated-wsl-dev-setup/blob/master/preparewsl.sh){: .btn .btn--info} 

Kick off the process by running the Powershell script, which in turn calls the bash script. 

```powershell
powershell -executionpolicy bypass -file .\preparewsl.ps1
```

About halfway, the script will prompt you for your desired WSL username and password.  
{: .notice--info}

