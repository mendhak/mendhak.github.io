---
title: "Raspberry Pi: Simple Waveshare e-paper dashboard with weather and calendar"
description: "Raspberry Pi dashboard with an e-paper display from waveshare, shows weather info, severe weather, and calendar entries"
last_modified_at: 2023-01-25

tags: 
  - raspberrypi
  - epaper
  - dashboard
  - weather
  - alerts
  - warnings
  - calendar

opengraph:
  image: /assets/images/raspberrypi-epaper-dashboard/001.jpg

  
---

I have created a simple, DIY e-paper dashboard setup that displays the weather and calendar information.  It's minimal, and doesn't require a lot of power, so it can run on a Raspberry Pi Zero.  I have been running it for several years now and it is very reliable. 

Here I will share instructions on setting up a Raspberry Pi Zero WH with a Waveshare ePaper 7.5 Inch HAT. 
The screen will display: 

* Date and time
* Weather icon and short description, with high and low temperature (OpenWeatherMap, Met office, AccuWeather, Met.no, Climacell, VisualCrossing)
* A severe weather warning (provided by Met Office or Weather.gov)
* Google Calendar, Outlook Calendar, ICS or CalDav calendar entries

Here it is in action

{% gallery "epaper dashboard" %}
![In a picture frame](/assets/images/raspberrypi-epaper-dashboard/001.jpg)
![Generated image](/assets/images/raspberrypi-epaper-dashboard/002.png)
{% endgallery %}



## Shopping list

### E-Paper Display

The most important component is the Waveshare display, which is a [7.5 inch e-paper HAT](https://www.waveshare.com/wiki/7.5inch_e-Paper_HAT) with `SKU: 13504` and `UPC: 614961951068`.  A quick search will also show similar displays available, with a single additional color. As tempting as they may be, the problem with those displays is the refresh rate, in part due to the way the third color is 'pushed' to the surface when displaying a color.  While the black and white display isn't very fast, the colored ones are much, much slower and are only suitable for frequently-refreshing dashboards.  

{% button "E-Paper Display", "https://smile.amazon.co.uk/gp/product/B075R4QY3L/" %}

### Raspberry Pi

Although any Raspberry Pi can be used, the best one to get here is the Raspberry Pi Zero W - it's thinner and more portable.  Since it's a HAT (Hardware Attached on Top), you can save some time by buying it with the GPIO presoldered.  Of course you'll also need a microSD card.  

{% button "Raspberry Pi Zero WH", "https://smile.amazon.co.uk/gp/product/B07BHMRTTY/" %}
{% button "microSDHC card", "https://smile.amazon.co.uk/gp/product/B073K14CVB" %}

### Picture frame

You'll need a 18x13 cm (7"x5") picture frame to hold everything together.  This is the best size just larger than the e-paper display.  The back needs to be made of cheap material so that it can be cut out for the e-paper display's connection mechanism.  

{% button "Picture frame", "https://www.tescophoto.com/harriet-photo-frame" %}



{% githubrepocard "mendhak/waveshare-epaper-display" %}


## Setup the PI

### Prepare the Pi

I've got a separate post for this, [prepare the Raspberry Pi with WiFi and SSH](https://code.mendhak.com/prepare-raspberry-pi/).  Once the Pi is set up, and you can access it, come back here. 


### Connect the display

Turn the Pi off, then put the HAT on top of the Pi's GPIO pins.  

Connect the ribbon from the epaper display to the extension.  To do this you will need to lift the black latch at the back of the connector, insert the ribbon slowly, then push the latch down.  Now turn the Pi back on. 

Wait a few minutes, and let the Pi connect over WiFi.  You should be able to SSH onto the Pi now. 

### Configure the application

[The Github Repo](https://github.com/mendhak/waveshare-epaper-display#readme) covers all configuration instructions. This includes:

* Installing the code and dependencies 
* Choosing a weather provider (OpenWeatherMap, Met Office, AccuWeather, Met.no, Weather.gov, Climacell)
* Choosing a severe weather alert provider (Met Office and Weather.gov)
* Choosing a calendar provider (Google Calendar and Outlook)
* Choosing a layout

{% button "Instructions on Github", "https://github.com/mendhak/waveshare-epaper-display#readme" %}

## Run it

Run `./run.sh` which should query your chosen weather provider, as well as Google/Outlook calendar.  It will then create a png, then display the png on screen. 
After a few runs, if everything is working well, you should then make this a cron job. 

```bash
* * * * * cd /home/pi/waveshare-epaper-display && bash run.sh > run.log 2>&1
```

## Putting it in a picture frame

The picture frame I got had a cheap backing.  Using a box cutter (Stanley knife) I was able to remove a square portion from the bottom.  This allowed me to put the e-paper display inside the picture frame while its connector hung outside.  

The ribbon from the connector loops upwards and over to the picture frame's stand.  The Raspberry Pi Zero WH is light enough that it could be taped right to the stand.  

The only bit of wire in the whole setup is the USB to power the Raspberry Pi.  


{% gallery "Picture frame details" %}
![Cutout for e-paper connector](/assets/images/raspberrypi-epaper-dashboard/003.png)
![Topdown view or Raspberry Pi attached to picture frame stand](/assets/images/raspberrypi-epaper-dashboard/004.png)
{% endgallery %}



## How it works

Everything starts with the `screen-template.svg` which holds the labels and layout for the final image to be produced. SVGs are simply XML files which are understood by renderers.  Being text files makes them easy to work with from dynamic scripts.  



### API Calls

The first part of `run.sh` calls on the `screen-weather.get.py` script which queries Climacell API, gets the weather info and substitutes icons and temperatures in the SVG.  It also sets the date and time.  The SVG is then written out to `screen-output-weather.svg`.  The API response is stored in 


The last API call is to Google Calendar, the upcoming 2 calendar entries are written to the same SVG.  

{% notice "info" %}
Due to API rate limits, you will see various `.pickle` files which store the Google/Outlook Calendar and weather API responses for a few hours.  This means that any new entries in your target calendar won't show up immediately.  Similarly weather info will be up to a few hours delayed.  
{% endnotice %}

### Image conversion and display

The image is converted from the intermediate SVG to PNG, and then the `display.py` renders it to screen using the e-Paper libraries.  This used to take 30 seconds, but [recent improvements](https://github.com/waveshare/e-Paper/pull/104) have brought it down to less than 10 seconds. Which is decent, considering the Raspberry Pi Zero hardware.  

It's possible to use the C libraries to make this process even faster, but it requires writing and compiling the display binary yourself.  It could further be sped up by converting the PNG to a 1-bit BMP so that there's less data to send over the wire.  The C way would take about 6-8 seconds.  

The reason for sticking with the Python way is that I've got a v1 Waveshare display, while most users have a v2 Waveshare display, and it's easier to cater to both this way.  Curse of the early adopter!

### Refreshing the screen at 2 AM

The display by default does a 'partial' refresh every minute when displaying the new image.  However, the [Waveshare documentation](https://www.waveshare.com/w/upload/7/74/7.5inch-e-paper-hat-user-manual-en.pdf) recommends refreshing the screen fully once every 24 hours.  


> We suggest you update e-Paper once every 24 hours or at least 10 days to update again. Otherwise, ghost of the last content may cannot [sic] be cleared

To this effect, the screen goes fully blank at 2 AM for a minute, with the assumption that very few people will be awake to see it.  


## Troubleshooting

If the scripts don't work at all, try going through the Waveshare sample code linked below - if you can get those working, this script should work for you too. 

You may want to further troubleshoot if you're seeing or not seeing something expected.  
If you've set up the cron job as shown above, a `run.log` file will appear which contains some info and errors.  
If there isn't enough information in there, you can set `export LOG_LEVEL=DEBUG` in the `env.sh` and the `run.log` will contain even more information.  

The scripts cache the calendar and weather information, to avoid hitting weather API rate limits.   
If you want to force a weather update, you can delete the `cache_weather.json`.   
If you want to force a calendar update, you can delete the `cache_calendar.pickle` or `cache_outlookcalendar.pickle`.   
If you want to force a re-login to Google or Outlook, delete the `token.pickle` or `outlooktoken.bin`.  

## Learn more: Waveshare documentation and sample code


Waveshare have a [user manual](https://www.waveshare.com/w/upload/7/74/7.5inch-e-paper-hat-user-manual-en.pdf) which you can get to from [their Wiki](https://www.waveshare.com/wiki/7.5inch_e-Paper_HAT)


The [Waveshare demo repo is here](https://github.com/waveshare/e-Paper).  Assuming all dependencies are installed, these demos should work.  

    git clone https://github.com/waveshare/e-Paper
    cd e-Paper

This is the best place to start for troubleshooting - try to make sure the examples given in their repo works for you. 

[Readme for the C demo](https://github.com/waveshare/e-Paper/blob/master/RaspberryPi_JetsonNano/c/readme_EN.txt)

[Readme for the Python demo](https://github.com/waveshare/e-Paper/blob/master/RaspberryPi_JetsonNano/python/readme_jetson_EN.txt)

