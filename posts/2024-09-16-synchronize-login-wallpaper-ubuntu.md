---
title: "Syncing the login wallpaper with the desktop wallpaper on Ubuntu"
description: "Getting the login wallpaper to sync with the desktop wallpaper, when using standalone or Variety wallpaper changer. For Ubuntu 22.04 and 24.04"
  
opengraph: 
  image: /assets/images/synchronize-login-wallpaper-ubuntu/003.png

last_modified_at: 2024-09-16

extraWideMedia: false

---

On Ubuntu 22.04 and 24.04, the background image that you set for your desktop doesn't appear on the login screen. I will go over two ways of synchronizing the login screen wallpaper to match the one chosen for the desktop.  

{% notice "info" %}
To skip straight to the scripts, see [this Github repository](https://github.com/mendhak/ubuntu-change-login-background).
{% endnotice %}


{% gallery "Desktop wallpaper, but dull login screen" %}
![](/assets/images/synchronize-login-wallpaper-ubuntu/001.png)
![](/assets/images/synchronize-login-wallpaper-ubuntu/002.png)
{% endgallery %}

## Setup

Ensure that systemd-container is installed.

```bash
sudo apt install systemd-container
```

This is required to run some steps on behalf of gdm. 


### Download an image to test with

If you do not have a test wallpaper already, you can use [this one](https://www.flickr.com/photos/mendhak/30454355997/). 

```bash
wget https://live.staticflickr.com/1932/30454355997_f460fcdb22_o_d.jpg -O ~/Pictures/testwallpaper.jpg
```


### Download the repo

Clone the scripts repo down, for this post we'll assume it gets cloned to `~/Projects/`. 

```bash
git clone https://github.com/mendhak/ubuntu-change-login-background.git
```

The main file to look here is [the change.sh script](https://github.com/mendhak/ubuntu-change-login-background/blob/master/change.sh), which copies the file passed to `/usr/share/backgrounds/gdm`, the reason being that the gdm3 session cannot read from the user's home directory. It then uses machinectl to tell gdm3 to set that image as its own background.  

As a test, try setting the login screen wallpaper to the test image downloaded earlier. 

```bash
sudo ./change.sh ~/Pictures/testwallpaper.jpg 
```

You'll be prompted for your password, and then some output as the commands run. 

Now logout and have a look at the login screen, the wallpaper should have changed. 

![login screen wallpaper](/assets/images/synchronize-login-wallpaper-ubuntu/003.png)

{% notice "info" %}
Your original theme isn't lost, you can reset it using `sudo machinectl shell gdm@ /bin/bash -c "gsettings set com.ubuntu.login-screen background-picture-uri ''"`
{% endnotice %}

### Allow the script to run without prompting for password

Because the script requires `sudo` to run, it will by default prompt for your password. This is not useful for automation, so you'll need to allow this specific script to run without prompting.  

Create a custom sudoers file with the right permissions, like so: 

```
sudo touch /etc/sudoers.d/change-login-background
sudo chmod 0440 /etc/sudoers.d/change-login-background
sudo nano /etc/sudoers.d/change-login-background
```

Add this one line in there.  Replace the `myusername` and path to the change script with your own.  

```
myusername ALL=(ALL:ALL) NOPASSWD:/home/myusername/Projects/change-login-background/change.sh
```

You can try running the script again and this time you shouldn't be prompted for a password. 


## Method 1 - Synchronizing on a schedule

The most versatile way to synchronize the desktop and login screen wallpapers is to use a cron job. It will work with whichever wallpaper manager software you use, and even if you manage it manually.

The [sync_desktop_wallpaper_to_login.sh script](https://github.com/mendhak/ubuntu-change-login-background/blob/master/sync_desktop_wallpaper_to_login.sh) will get the currently set desktop wallpaper using `gsettings`, then pass it to the above change script. 

Try running it once manually:


```bash
./sync_desktop_wallpaper_to_login.sh
```

Then again have a look at the login screen. 

You can now set up a cron job that runs that script, say, every 5 minutes.  Run `crontab -e`

```bash
crontab -e
```

Add this line, replacing the path to the script. 

```
*/5 * * * * cd /home/myusername/Projects/change-login-background && bash sync_desktop_wallpaper_to_login.sh
```

Change the wallpaper and wait a few minutes, then reboot and observe the results.  

## Method 2 - Synchronizing with Variety

If you use [Variety wallpaper changer](https://peterlevi.com/variety/), you can have the login screen wallpaper change together with the desktop wallpaper by adding a custom command.  

The [set_both_wallpapers.sh script](https://github.com/mendhak/ubuntu-change-login-background/blob/master/set_both_wallpapers.sh) has been made to work with Variety; it can be called from Variety, it accepts a path to an image, passes it to the original change script, then calls back to Variety's own setter script. 

To do this, edit the Variety config file:

```
nano ~/.config/variety/variety.conf
```

Look for the setting, `set_wallpaper_script` (add it if it doesn't exist), which tells Variety to execute a specific bash script when the wallpaper should change:  

```
set_wallpaper_script = /home/myusername/Projects/change-login-background/set_both_wallpapers.sh
```

Exit and restart Variety so that it picks up the config changes. Now try changing the wallpaper via Variety, and then reboot. The login screen should match the desktop.  A run.log file should also be present in the project folder. 

## Optional - Blurring the background

It is somewhat appealing to give the login screen background a blurred version of the current desktop background. This can be done with `imagemagick` installed, and making a call to the `convert` command just before passing it to the change script. 

The 'blurred' versions of the [cron script is here](https://github.com/mendhak/ubuntu-change-login-background/blob/master/sync_desktop_wallpaper_to_login.blurred.sh), and the [Variety script is here](https://github.com/mendhak/ubuntu-change-login-background/blob/master/set_both_wallpapers.blurred.sh).




## Special note for multi-monitor setups

With multiple monitors, the wallpaper appears zoomed in and lower quality on the login screens, which may or may not look great. This is due to [the way GDM3 treats multiple monitors](https://github.com/thiggy01/change-gdm-background/issues/15) as a single one and simply stretches the image across it. 

The workaround for this is to get your login screen to only work on one monitor.  

To do this, first in your own desktop (login using an X11 session, not Wayland), change the display mode to be Single Display and apply the changes.  

![display settings](/assets/images/synchronize-login-wallpaper-ubuntu/004.png)


This will have modified your `~/.config/monitors.xml` file that you need to pass to GDM3.  To do that, 

```bash
sudo cp ~/.config/monitors.xml `grep gdm /etc/passwd | awk -F ":" '{print $6}'`/.config/
```

Then go back to your display settings and restore your original multi-monitor setup.  

On your next reboot, the login screen will only appear on one monitor, with the wallpaper no longer zoomed in.  
