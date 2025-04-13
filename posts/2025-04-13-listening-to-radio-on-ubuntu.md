---
title: My brief attempt at learning about Software Defined Radio on Ubuntu
description: Using rtl-sdr, gqrx, rtl_433, sdrangel to listen and decode radio on Ubuntu
tags:
  - ubuntu
  - radio
  - sdr
  - rtl-sdr
  - gqrx
  - rtl_433
  - sdrangel
  - ham
  - amateur

---

When my previous office building shut down, I 'inherited' a [Pi-aware](https://uk.flightaware.com/adsb/piaware/build/) which had been set up many years ago. I was vaguely aware that it made use of something called RTL-SDR, but I didn't actually understand what that meant. I thought it was just for tracking aircraft, but it turns out the receiver is a general purpose radio receiver and can be used for other things. The SDR simply stands for Software Defined Radio, of which there are many implementations. The RTL in RTL-SDR (a specific implementation) and is probably related to the Realtek chipset that is used in the dongle.

I found this [excellent tutorial](https://austinsnerdythings.com/2021/09/11/getting-started-with-sdr-software-defined-radio-a-tutorial/), but I wanted to try out its equivalents on Ubuntu. 


## Getting started - installing the drivers

This is the specific model I have: it's a [Nooelec NESDR Mini SDR & DVB-T USB Stick (RTL2832 + R820T) with Antenna](https://www.nooelec.com/store/sdr/sdr-receivers/nesdr-mini.html). The antenna was easy to understand, the dongle, I believe its purpose is to convert the radio signals into a digital format that can be read by a computer. I didn't take a photo of it because the setup had become grimey and sticky after years of sitting neglected in the office. 

I plugged the antenna to the dongle, and the dongle to the USB port on my Ubuntu PC. 

The first thing I had to do was install the drivers for the dongle. That was a simple matter of installing the rtl-sdr package:


```bash
sudo apt install rtl-sdr
```

To then make it available to non-root users, that is, to be able to let applications use that driver without being root, I had to add a provided udev rules file.  

```bash
sudo wget -O /etc/udev/rules.d/rtl-sdr.rules https://raw.githubusercontent.com/rtlsdrblog/rtl-sdr-blog/refs/heads/master/rtl-sdr.rules
```

I also had to blacklist a default driver that Linux loads. The reasons for this were unclear to me, but the [rtl-sdr instructions](https://www.rtl-sdr.com/rtl-sdr-quick-start-guide/) indicated it was necessary. 

I first checked that this 'default' driver, called `dvb_usb_rtl28xxu`, was actually being loaded when I had plugged the dongle in. 

```bash
lsmod | grep dvb_usb_rtl28xxu
```

That did return a value, so indeed this default driver was being loaded. To blacklist it, I created a blacklist rule:

```bash
echo "blacklist dvb_usb_rtl28xxu" | sudo tee /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf
```

I rebooted, so that the udev rules and the blacklist rules would kick in (and ignore that default DVB driver). 

I then ran a test:

```bash
$ rtl_test
    Found 1 device(s):
    0:  Realtek, RTL2838UHIDIR, SN: 00000001

    Using device 0: Generic RTL2832U OEM
    Found Rafael Micro R820T tuner
    Supported gain values (29): 0.0 0.9 1.4 2.7 3.7 7.7 8.7 12.5 14.4 15.7 16.6 19.7 20.7 22.9 25.4 28.0 29.7 32.8 33.8 36.4 37.2 38.6 40.2 42.1 43.4 43.9 44.5 48.0 49.6 
    [R82XX] PLL not locked!
    Sampling at 2048000 S/s.

    Info: This tool will continuously read from the device, and report if
    samples get lost. If you observe no further output, everything is fine.

    Reading samples in async mode...
    Allocating 15 zero-copy buffers

    (Ctrl + C to stop)
```

It found the device, pretty good! 


## Software to use the device

With the hardware installed, it was time to actually make use of it. It turns out there's several different methods and applications that have different purposes and approaches. There is no all-in-one.

**GQRX** is a GUI that can be used to listen to radio stations. This would be simplest to try out.

**guglielmo**, and **welle.io** are applications that can be used to listen to DAB radio 

**SDRangel** is a multi purpose application, it can be used to listen to radio, track aircraft, and probably more.  

**rtl_433** is a CLI tool that can be used to decode signals from devices that operate on 433MHz such as weather stations, doorbells, blinds, thermometers, etc. 

Hamfax can be used to receive weather fax signals including _weather maps_! Very intriguing.


## GQRX - listening to radio

Getting started with GQRX was the simplest:

```bash
sudo apt install gqrx-sdr
```

After launching it, I had to select the right device. In my case it was this Realtek one. 


![GQRX configure i/o devices](/assets/images/listening-to-radio-on-ubuntu/image.png)

After the main application started, I tried tuning in to a few London radio stations. This was done by scrolling or typing the numbers above the graph. 

There was a kHz option over to the right, which I left at 0.  I set the mode to WFM (stereo) for FM radio.  Unfortunately I didn't really understand the other settings including AGC, Gain, and Squelch.

Here I tried 95.800 for Capital FM. I set the gain to 0.1 and it seemed to produce a 'decent' output, but there was still a bit of static. But I was listening to radio! 

![Capital FM](/assets/images/listening-to-radio-on-ubuntu/image-2.png)

I tried 97.3 and it was a bit clearer:

![97.3 FM](/assets/images/listening-to-radio-on-ubuntu/image-3.png)

Sadly, when I tried ClassicFM, I could 'see' there was something in that river of yellow, but it just wouldn't tune in, there was a lot of static.  

![Classic FM](/assets/images/listening-to-radio-on-ubuntu/image-1.png)

After some searching, I found that ClassicFM was available on DAB, which GQRX didn't support. 

I couldn't do AM radio stations either, because the dongle I had only went from 25 MHz to 1.7 GHz. AM radio is from 520 kHz to 1.6 MHz.

However, FM worked, so a decent conclusion to this exercise. 

## DAB Radio

For DAB, I found a few other applications that could be used: [guglielmo](https://github.com/marcogrecopriolo/guglielmo), [welle.io](https://www.welle.io/), and [SDRangel](https://www.sdrangel.org/).

Although all of these applications were able to see my device, none of them could actually tune in to a DAB station. 

This is where my understanding became unclear, I had thought the RTL-SDR would be able to work with anything, but I'd likely need a more specific dongle that can work with and support DAB. I concluded this because I was able to find other RTL SDR dongles that specifically mentioned DAB support.

A disappointing conclusion to this exercise. 

## RTL 433 - listening to smart devices

rtl_433 describes itself:

> rtl_433 (despite the name) is a generic data receiver, mainly for the 433.92 MHz, 868 MHz (SRD), 315 MHz, 345 MHz, and 915 MHz ISM bands.

There's a package for it in Ubuntu called rtl_433, but that didn't work for me. Instead, I installed a snap equivalent, and gave it USB access. 

```bash
sudo snap install rtl-433-bjornt
sudo snap connect rtl-433-bjornt:raw-usb
```


I then ran it and let it listen for devices. 

```bash

    $ rtl-433-bjornt.rtl-433 -g 40
    rtl_433 version 22.11-27-ge6b1a648 branch master at 202212201952 inputs file rtl_tcp RTL-SDR
    Use -h for usage help and see https://triq.org/ for documentation.
    Trying conf file at "rtl_433.conf"...
    Trying conf file at "/home/mendhak/snap/rtl-433-bjornt/6/.config/rtl_433/rtl_433.conf"...
    Trying conf file at "/usr/local/etc/rtl_433/rtl_433.conf"...
    Trying conf file at "/etc/rtl_433/rtl_433.conf"...
    Protocols: Registered 191 out of 223 device decoding protocols [ 1-4 8 11-12 15-17 19-23 25-26 29-36 38-60 63 67-71 73-100 102-105 108-116 119 121 124-128 130-149 151-161 163-168 170-175 177-197 199 201-215 217-223 ]
    SDR: Found 1 device(s)
    SDR: trying device  0:  Realtek, RTL2838UHIDIR, SN: 00000001
    Found Rafael Micro R820T tuner
    SDR: Using device 0: Generic RTL2832U OEM
    Exact sample rate is: 250000.000414 Hz
    [R82XX] PLL not locked!
    SDR: Sample rate set to 250000 S/s.
    SDR: Tuner gain set to 40.200000 dB.
    SDR: Tuned to 433.920MHz.
    Allocating 15 zero-copy buffers
    Baseband: low pass filter for 250000 Hz at cutoff 25000 Hz, 40.0 us

```
I left it for an hour, and unfortunately, there were no devices near me. Nor do I have any of my own. There was no interesting output.  

Mixed conclusions to this exercise - it theoretically worked, but I live in a quiet, low-tech neighbourhood.


## ADS-B - tracking aircraft

Instead of using FlightAware's PiAware, I found SDRAngel. SDRAngel had several functions when I opened it (including DAB) and they included AIS (ships) and ADS-B (aircraft) tracking. 

I installed it via the snap store and gave it USB access. 

```bash
sudo snap install sdrangel
sudo snap connect sdrangel:raw-usb
```

Then I could run it. It was fascinating to watch!


![ADS-B with SDRAngel](/assets/images/listening-to-radio-on-ubuntu/image-4.png)


## Hamfax

Considering how limited this dongle's range was, I figured out quickly that I wouldn't be able to receive weather fax signals. A [tutorial page](https://www.gqrx.dk/doc/practical-tricks-and-tips#apps) shows that the frequencies for weather faxes from Northwood UK were 2618.5 kHz and 11086.5 kHz, which was out of the dongle's range. 

But still, the instructions looked pretty fascinating - it involved recording the signal, waiting for 11 minutes, then using hamfax to visualize it. 

I'm glad I stopped there, any attempt on my part would have been hamfisted. 


## Final thoughts

This was an interesting exercise, despite the blockers, because it was completely outside my normal 'domain'. I was able to listen to radio, track aircraft, and theoretically decode signals from smart devices. I wasn't able to listen to DAB radio, or receive weather fax signals, but I could probably try that another time. Or I could set up something with a Raspberry Pi and take it with me on holidays.  

If I want to go further, properly, I think I'll have to do a few things: buy a better receiver (that supports DAB) and actually learn more about radio, potentially even interacting with it [using Python](https://pysdr.org/).
