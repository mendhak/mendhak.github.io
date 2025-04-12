---
title: A brief attempt to listening to radio on Ubuntu
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

Windows tutorial: https://austinsnerdythings.com/2021/09/11/getting-started-with-sdr-software-defined-radio-a-tutorial/

Ubuntu equivalent

First the driver. 

sudo apt install rtl-sdr


Copy the file https://github.com/rtlsdrblog/rtl-sdr-blog/blob/master/rtl-sdr.rules

to 

/etc/udev/rules.d/rtl-sdr.rules

That's not enough. Also need to blacklist a default driver that Linux loads. 

Check that this returns a result, which indicates a different driver is loaded:

lsmod | grep dvb_usb_rtl28xxu

If it returns a value, then blacklist the driver. Create a file /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf with the following contents:

blacklist dvb_usb_rtl28xxu



Reboot (so that the udev rules kick in, and the default DVB driver is ignored) then do a test: 

rtl_test


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


If you see the above, then the device is working. Press Ctrl+C to stop the test.

Now that rtl-sdr is installed and working, there are various applications that can make use of it. 

GQRX is for listening to radio stations.

RTL 433 is for decoding signals from weather stations, doorbells, etc.

Hamfax is for receiving weather fax signals.

# GQRX - listening to radio

sudo apt install gqrx-sdr


![alt text](/assets/images/listening-to-radio-on-ubuntu/image.png)

Click the number above the graph, set it to 101.0 for Classic FM. This didn't work for me. 
Set mode = WFM(stereo)
Press play button. THe screen appears with a yellow waterfall display, and static noise. 

![alt text](/assets/images/listening-to-radio-on-ubuntu/image-1.png)

Try 95.800 for Capital FM. I set the gain to 0.1 and it seemed to produce a 'decent' output, but there was still a bit of static. 

![alt text](/assets/images/listening-to-radio-on-ubuntu/image-2.png)

I tried 97.3 and it was a bit clearer:

![alt text](/assets/images/listening-to-radio-on-ubuntu/image-3.png)


I couldn't do AM radio, because the dongle I had - https://www.nooelec.com/store/sdr/sdr-receivers/nesdr-mini.html - only goes from 25 MHz to 1.7 GHz. AM radio is from 520 kHz to 1.6 MHz.

I couldn't do DAB radio with this software, it's not supported. 

# DAB Radio - listening to digital radio

I tried guglielmo, welle.io, and SDRangel, but none of them could work with DAB. I am wondering if the dongle I have is not suitable. It definitely is quite old. And when I search for similar dongles, I notice that they explicitly mention DAB, so it's quite possible that mine doesn't support it.


# RTL 433 - listening to devices

In Ubuntu the provided package is called rtl_433, but that didn't work for me. 

sudo apt install rtl_433

Instead I installed from the snap store:

sudo snap install rtl-433-bjornt
sudo snap connect rtl-433-bjornt:raw-usb

Then I could run it.

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

Unfortunately, no devices near me. So I got no output. 



# ADS-B

I found another software which worked quite well, called SDRAngel. 

I had to install it via the snap store and give it USB access. 

sudo snap install sdrangel
sudo snap connect sdrangel:raw-usb

Then I could run it. It was fascinating to watch!


![alt text](/assets/images/listening-to-radio-on-ubuntu/image-4.png)


TODO: 

DAB radio

RTL 433

hamfax: https://www.gqrx.dk/doc/practical-tricks-and-tips#more-229 
