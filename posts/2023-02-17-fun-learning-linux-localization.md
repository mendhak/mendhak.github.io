---
title: Fun and learnings with localization on Linux
description: Things I learned about date and time localization and fonts in Python and Shell
tags:
  - linux
  - localization
  - python
  - bash
  - epaper
  - locale
  - font

opengraph:
  image: /assets/images/fun-learning-linux-localization/007.png
---

I have a simple [epaper dashboard project](https://github.com/mendhak/waveshare-epaper-display), which displays the time, date, weather and calendar entries. Of course the format is entirely specific to English, and I had naïvely assumed that everyone would understand "Friday Feb 17, 2023" and "5:20 PM". When I received a feature request to display the preferred time format based on the system's locale, I decided to apply it to the days and dates too, which sent me down a rabbit hole of locales, formats, and figuring out how to display them with font matching.  


{% gallery "The end result, localized epaper dashboard examples" %}
![Thai `th_TH`](/assets/images/fun-learning-linux-localization/004.png)
![Chinese Traditional `zh_TW`](/assets/images/fun-learning-linux-localization/005.png)
![Swedish `sv_SE`](/assets/images/fun-learning-linux-localization/006.png)
![Korean `ko_KR`](/assets/images/fun-learning-linux-localization/007.png)
![Vietnamese `vi_VN`](/assets/images/fun-learning-linux-localization/008.png)
![Greek `el_GR`](/assets/images/fun-learning-linux-localization/009.png)
{% endgallery %}


### Python Babel library

The simplest way to play around and experiment with locales was using the Python [Babel library](https://babel.pocoo.org/). It provides some simple utility functions that do the thinking and formatting. Babel itself gets its information from the Unicode Common Locale Data Repository (CLDR) project, a massive collection of locale metadata, formatting and parsing for dates, times, numbers, units, names, even down to words like 'yesterday'. As an example, here's the CLDR data for [date formats in Icelandic](https://unicode-org.github.io/cldr-staging/charts/latest/verify/dates/is.html). What's in this database isn't _always_ going to match reality, but it's the closest thing to a standardized formatting there is. Making use of the Babel library was then as simple as:

```python
>>> format_date(datetime.now(), format='full', locale='th_TH')
'วันศุกร์ที่ 17 กุมภาพันธ์ ค.ศ. 2023'
```

Playing around with this library was a fun way of getting a glimpse into other locales that I don't normally interact with.  


### Things I observed about time


#### 24-hour format vs AM/PM

The clearly superior 24-hour format is preferred not just in the UK, but most European locales

en_GB:  `19:45:00`  

The US prefers AM/PM

en_US: `7:45:00 PM`

And Australia uses lowercase

en_AU: `7:45:00 pm`

#### The AM/PM can be at the beginning

For Korean (ko_KR), the AM/PM indicator come before the time. 

`PM 7:45:00`


#### It's not always "AM" and "PM"

Even if the locale uses English letters, it's not always the suffixes "AM" and "PM" that's used.  Malaysian (ms_MY) uses PG and PTG: 

`9:15:00 PG`  
`7:45:00 PTG`

Greek (el_GR) uses 'pro mesimvrías' and 'metá mesimvrían'

`9:15:00 π.μ.`  
`7:45:00 μ.μ.`

And Arabic (Egypt, ar_EG) uses the suffixes `ص` and `م`

`9:15:00 ص`  
`7:45:00 م`

#### It's not always an AM and PM analogue

The Chinese Traditional locale (zh_TW) didn't have a one to one mapping with AM and PM. Instead, it's the day period name that gets used as the prefix. 

`清晨5:15:00` (early morning)  
`上午9:15:00` (morning)  
`下午1:15:00` (afternoon)  
`晚上7:15:00` (night)  
`午夜12:00:00` (midnight)  

#### The colon isn't always the time separator

In Sinhala Sri Lanka (si_LK), the time separator is a dot, and numbers are padded too. 

`09.15.00`  
`19.45.00`


### Things I observed about days and dates

This was relatively simpler, having experienced a variety of time formats. Most of the differences were simply translations of day names, and usage of commas and dots.  

#### Days and months can be lowercase

In Swedish (sv_SE), as well as many other languages, the names of days and months usually start with a lowercase letter.  

`fredag 17 februari 2023`

#### Vietnamese is pretty efficient

In Vietnamese (vi_VN) there's a slightly different date format that can be used, when a short form is desired:

`T6 Thg 2 17`

The 'T6' is day 6 (Friday), 'Thg 2' is month 2 (February), and 17 is the date.  


#### Some put the year first

Several eastern locale date formats had the year first.  

ko_KR: `2023년 2월 17일`

ja_JP: `2023年2月17日`

zh_TW: `2023年2月17日`


### Fonts working with locales

Now that I had the times and dates being produced by the code, displaying it on screen was a different matter. This is an epaper application being rendered by an SVG-to-PNG converter. It's not being displayed in a browser, which meant that I didn't have the luxury of font bundling or web fonts and other magic to hide away problems from the user. The only fonts available were what the OS said was available. 

The simplest thing to do in the SVG was to set the font to be a web safe font, `font-family:sans-serif`.   

During processing, the renderer would then ask the OS for the correct font to use. This is where fontconfig helps. It's a program that helps match requested fonts with what's available on the system. It comes with many rules about matching fonts, and substituting fonts if they're not available.  

On a Raspberry pi, the default font is DejaVu Sans. This can be seen using a fontconfig utility known as `fc-match` which does its best to match a font for a request.  

```bash
$ fc-match sans-serif
DejaVuSans.ttf: "DejaVu Sans" "Book"
```

DejaVu Sans was fine for most European languages, but would render squares, indicating missing characters, for many others.  

{% gallery "Eastern languages didn't render properly with the default font" %}
![](/assets/images/fun-learning-linux-localization/001.png)
![](/assets/images/fun-learning-linux-localization/002.png)

{% endgallery %}


By setting the locale using `LC_ALL`, fontconfig would know how to match on the correct font. 

```bash
$ LC_ALL=th_TH.UTF-8 fc-match sans-serif
FreeSerif.ttf: "FreeSerif" "ปกติ"

LC_ALL=ja_JP.UTF-8 fc-match sans-serif
NotoSansCJK-Regular.ttc: "Noto Sans CJK JP" "Regular"
```

With that, everything started working, and rendering properly!

### About LC_ALL and language packs

`LC_ALL`, and its related environment variables, controls aspects of localization such as date time format, symbols, decimals. The current locale of a system can be seen by running the `locale` command. 

```
 $ locale
LANG=en_GB.UTF-8
LANGUAGE=
LC_CTYPE="en_GB.UTF-8"
LC_NUMERIC="en_GB.UTF-8"
LC_TIME="en_GB.UTF-8"
LC_COLLATE="en_GB.UTF-8"
LC_MONETARY="en_GB.UTF-8"
LC_MESSAGES="en_GB.UTF-8"
LC_PAPER="en_GB.UTF-8"
LC_NAME="en_GB.UTF-8"
LC_ADDRESS="en_GB.UTF-8"
LC_TELEPHONE="en_GB.UTF-8"
LC_MEASUREMENT="en_GB.UTF-8"
LC_IDENTIFICATION="en_GB.UTF-8"
LC_ALL=
```

Linux applications base their own localization output on the values in these variables, and it allows a user to choose different localizations for different aspects.   

It's possible to see a list of all installed locales on a system, using `locale -a`. And to add more locales, run `sudo dpkg-reconfigure locales` which launches a text interface to select locales from.  Importantly it also allows setting default locale, which is then picked up by `LC_ALL` and applications that use it.  


### Fontconfig

Fontconfig is quite powerful, and even lets users specify their own substitution rules. Instead of DejaVu Sans, I could force the use of Noto Sans by creating a file at `~/.config/fontconfig/conf.d/00-fonts.conf`:

```xml
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
  <alias>
    <family>sans-serif</family>
    <prefer>
        <family>Noto Sans</family>
    </prefer>
  </alias>
</fontconfig>
```

It's possible [to be more sophisticated](https://wiki.archlinux.org/title/Font_configuration) by filtering it down to specific languages and other metadata too.  It's even possible to specify a fallback font in case the original font doesn't have all the characters to be displayed on screen. Sadly the SVG converter I was using didn't support fallback fonts. Still, good to know it's there.  


### Closing notes

Between being able to control the locales and fontconfig, I was able to test a variety of configurations when developing the rendering for the epaper dashboard. Understanding fontconfig also gave me an appreciation of how font matching works at a system level, behind the scenes.  Along with understanding how to manage locales, I gained a much better appreciation for the beauty and simplicity of Linux.  
