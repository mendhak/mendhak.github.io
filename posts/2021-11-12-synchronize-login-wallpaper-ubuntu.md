---
title: "Syncing the login wallpaper with the desktop wallpaper on Ubuntu"
description: "Getting the login wallpaper to sync with the desktop wallpaper, when using standalone or Variety wallpaper changer"
  
opengraph: 
  image: /assets/images/synchronize-login-wallpaper-ubuntu/003.png

last_modified_at: 2024-09-15

extraWideMedia: false

---

On Ubuntu 22.04 and 24.04, the background image that you set for your desktop doesn't appear on the login screen. I will go over two ways of synchronizing the login screen wallpaper to match the one chosen for the desktop.  

{% notice %}
To skip straight to the scripts, see [this Github repository](https://github.com/mendhak/change-login-background).
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


### Create the script

Create a project folder that will hold your script, for this post let's say it's at `/home/myusername/Projects/change-login-background`. 

```bash
mkdir -p ~/Projects/change-login-background
```

Create a file in there called change.sh, and give it these contents

```bash
# Copy it to /usr/share/backgrounds 
sudo mkdir -p /usr/share/backgrounds/gdm
sudo cp $1 /usr/share/backgrounds/gdm/gdm-wallpaper
# Tell GDM to use it as a wallpaper
sudo machinectl shell gdm@ /bin/bash -c "gsettings set com.ubuntu.login-screen background-picture-uri 'file:///usr/share/backgrounds/gdm/gdm-wallpaper'; gsettings set com.ubuntu.login-screen background-size 'cover'"
# Display it back, just for troubleshooting
sudo machinectl shell gdm@ /bin/bash -c "gsettings get com.ubuntu.login-screen background-picture-uri; gsettings get com.ubuntu.login-screen background-size"
```

After saving, remember to make the file executable using `chmod +x change.sh`. 

Now, as a test, try setting the login screen wallpaper.

```bash
sudo ./change.sh ~/Pictures/testwallpaper.jpg 
```

You'll be prompted for your password, and then some output as the commands run. 

Now logout and have a look at the login screen, the wallpaper should have changed. 

![login screen wallpaper](/assets/images/synchronize-login-wallpaper-ubuntu/003.png)

{% notice "info" %}
Your original theme isn't lost, you can go back to it using `sudo machinectl shell gdm@ /bin/bash -c "gsettings set com.ubuntu.login-screen background-picture-uri ''"`
{% endnotice %}

### Allow the script to run without prompting for password

Because the script requires `sudo` to run, it will by default prompt for your password.  This is not useful for automation, so you'll need to allow this specific script to run without prompting.  

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


## Synchronizing with a cron job

The most versatile way to synchronize the desktop and login screen wallpapers is to use a cron job.  It will work with whichever wallpaper manager software you use, and even if you manage it manually.

Create a bash script that will hold your cron job

```bash
nano sync_desktop_wallpaper_to_login.sh
```
Add these lines in it.  Replace the path to the change script with yours.   

```bash
current_wallpaper_uri=$(gsettings get org.gnome.desktop.background picture-uri | sed "s/'//g")
current_wallpaper_path=$(python3 -c "import sys;from urllib.parse import unquote, urlparse; print(unquote(urlparse(sys.argv[1]).path))" "$current_wallpaper_uri")
sudo change.sh "$current_wallpaper_path"
```

After saving, remember to make the file executable using `chmod +x sync_desktop_wallpaper_to_login.sh`. Try running it once to see if it does as it says, and that you're not prompted for a password. 


```bash
./sync_desktop_wallpaper_to_login.sh
```

This script is using `gsettings` to get the currently set wallpaper, then a bit of Python to convert the `file:///` path to a local path, and then passing that along to the main change script.  


Finally set up a cron job that runs that script, say, every 5 minutes.  Run `crontab -e`

```bash
crontab -e
```

Add this line, replacing the path to the script. 

```
*/5 * * * * cd /home/myusername/Projects/change-login-background && bash sync_desktop_wallpaper_to_login.sh
```

Try testing it by changing the wallpaper and waiting a few minutes, then rebooting.  

## Synchronizing with Variety

Instead of a cron jobs, if you use [Variety wallpaper changer](https://peterlevi.com/variety/), you can have the login screen wallpaper change together with the desktop wallpaper by [adding a custom command](https://github.com/varietywalls/variety/blob/a8abe2bd36e293300bc1d3066726b660a3db9078/data/config/variety.conf#L16-L25).  

To do this, edit the Variety config file:

```
nano ~/.config/variety/variety.conf
```

Look for the setting, `set_wallpaper_script` (add it if it doesn't exist), which tells Variety to execute a specific bash script when the wallpaper should change:  

```
set_wallpaper_script = /home/myusername/Projects/change-login-background/set_both_wallpapers.sh
```

Create the `set_both_wallpapers.sh` script in the project folder. 

```
nano /home/myusername/Projects/change-login-background/set_both_wallpapers.sh
```

Add these lines in:

```bash
#!/bin/bash 

echo "Processing $1" | tee $(dirname $0)/run.log

# Set the lock screen wallpaper
sudo $(dirname $0)/change.sh "$1" 2>&1 | tee $(dirname $0)/run.log

# Now let Variety set the desktop wallpaper as usual.
~/.config/variety/scripts/set_wallpaper $@
```

After saving, remember to make the file executable using `chmod +x set_both_wallpapers.sh`. 

This script takes the wallpaper path passed by Variety, sets the login screen wallpaper using the change script, then calls the regular Variety script to set the desktop wallpaper. 

Exit and restart Variety so that it picks up the config changes. Now try changing the wallpaper via Variety, and then reboot. The login screen should match the desktop.  A run.log file should also be present in the project folder. 

## Blurring the background

An additional step, if it appeals, is to make the login screen background a blurred version of the current desktop background. This can be done with `imagemagick` installed, and tweaking the above scripts to created a blurred version just before settings it as the login background. 

The `sync_desktop_wallpaper_to_login.sh` script becomes: (modify the paths below to reflect yours)

```bash
current_wallpaper_uri=$(gsettings get org.gnome.desktop.background picture-uri | sed "s/'//g")
current_wallpaper_path=$(python3 -c "import sys;from urllib.parse import unquote, urlparse; print(unquote(urlparse(sys.argv[1]).path))" "$current_wallpaper_uri")
blurredpath=/tmp/blurred.jpg
convert $current_wallpaper_path -channel RGBA -blur 0x26 $blurredpath
sudo ./change.sh "$blurredpath"
```

Similarly the `set_both_wallpapers.sh` script becomes: (modify the paths below to reflect yours)

```bash
#!/bin/bash 
echo "Processing $1" | tee $(dirname $0)/run.log

blurredpath=/tmp/blurred.jpg
convert $1 -channel RGBA -blur 0x26 $blurredpath

# Set the lock screen wallpaper
$(dirname $0)/change.sh "$blurredpath" 2>&1 | tee -a $(dirname $0)/run.log

# Now let Variety set the desktop wallpaper as usual.
~/.config/variety/scripts/set_wallpaper $@
```




## Special note for multi-monitor setups

With multiple monitors, the wallpaper appears zoomed in and lower quality on the login screens.  This is due to [the way GDM3 treats multiple monitors](https://github.com/thiggy01/change-gdm-background/issues/15) as a single one and simply stretches the image across it. 

The workaround for this is to get your login screen to only work on one monitor.  

To do this, first in your own desktop (login using an X11 session, not Wayland), change the display mode to be Single Display and apply the changes.  

![display settings](/assets/images/synchronize-login-wallpaper-ubuntu/004.png)


This will have modified your `~/.config/monitors.xml` file that you need to pass to GDM3.  To do that, 

```bash
sudo cp ~/.config/monitors.xml `grep gdm /etc/passwd | awk -F ":" '{print $6}'`/.config/
```

Then go back to your display settings and restore your original multi-monitor setup.  

On your next reboot, the login screen will only appear on one monitor, with the wallpaper no longer zoomed in.  
