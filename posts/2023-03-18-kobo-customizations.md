---
title: My Kobo Customizations
description: Calibre Web syncing, new fonts, immersive reading, book covers, Pocket login, dark mode everywhere, Nickel Menu features
tags:
  - kobo
  - calibre
  - calibre-web
  - customizations
  - tweaks
  - nickelmenu

opengraph:
  image: /assets/images/kobo-customizations/000.jpg
---

I recently switched from a Kindle device to a Kobo Libra 2, and have been playing around with its customization and tweaks. These are the ones I've found useful so far. They include dark mode, immersive reading, less fidgeting, Pocket and Overdrive. Most important is integration with Calibre Web, and some unlocked features with NickelMenu. 

{% figure "/assets/images/kobo-customizations/000.jpg", "Kobo Libra 2", "half" %}

## Better reading

### Reduce distractions

I prefer an immersive experience when reading, without any distractions such as page number and progress. 

`More` > `Settings` > `Reading settings`  
`Header`: `Off`  
`Footer`: `Off`  
`Show book progress bar`: `Uncheck`    

![Hide distractions](/assets/images/kobo-customizations/001.png)

### Dark mode, easier on the eyes

To help with reading at night, it's also useful to have dark mode, which is very easy on the eyes in combination with the warm front light. 

`More` > `Settings` > `Reading settings` (Page Appearance)  
`Dark Mode`: `On`  

![Kobo dark mode](/assets/images/kobo-customizations/003.png)

### Reading without fidgeting

The Kobo Libra 2 has physical page turn buttons. I find it easy to hold the device with my thumb over the top button. Since it's more common to go forward while reading a book, it made sense to have the top button be the page forward button. 

`More` > `Settings` > `Reading settings`  
`Button Controls`: `Inverted`  

![Top button is for next page](/assets/images/kobo-customizations/002.png)

Also, when reading on my side, the device keeps automatically rotating to landscape. I've locked the rotation to portrait. 

`More` > `Settings` > `Reading settings` (Page Appearance)  
`Reading orientation`: `Portrait`  

![Lock to portrait](/assets/images/kobo-customizations/004.png)

Old muscle memory still remains, and I'll accidentally touch the screen while reading, which causes a jump to next page. While I can't disable the touch screen entirely for navigation, I can disable tapping to go forward. 

`More` > `Settings` > `Reading settings` (Page Appearance)  
`Page forward and back by`: `Swiping only`  

![Swipe to change page](/assets/images/kobo-customizations/005.png)

## Some nice to have extras

### Full screen covers

I like the book cover that appears when a device is turned off. I've enabled the feature that makes the cover go full screen.

`More` > `Settings` > `Energy saving and privacy`  
`Show book covers full screen`: `On`  

The info panel option is worth playing around with if you want some stats, or just uncheck it. 

![Book cover full screen](/assets/images/kobo-customizations/006.png)

### Custom image screensavers

Instead of the book cover appearing as the 'screensaver' when the Kobo is turned off, it's possible to have Kobo display a custom image. 

Connect the Kobo to a computer, and create a folder called screensaver under .kobo, that's `.kobo/screensaver`. 

Add a bunch of images inside that folder, ideally at a resolution matching the Kobo's screen. For the Libra 2 this is 1264x1680, and here are some of my images:

{% gallery "Screensaver images for Kobo Libra 2" %}
![](/assets/images/kobo-customizations/kobo1.jpg)
![](/assets/images/kobo-customizations/kobo2.jpg)
![](/assets/images/kobo-customizations/kobo3.jpg)

![](/assets/images/kobo-customizations/kobo4.jpg)
![](/assets/images/kobo-customizations/kobo5.jpg)
![](/assets/images/kobo-customizations/kobo6.jpg)
{% endgallery %}

Then, same as the book covers, enable it in settings. 

`More` > `Settings` > `Energy saving and privacy`  
`Show book covers full screen`: `On`  

An image should appear the next time the Kobo is put to sleep. 


### Sending articles to Kobo

Kobo comes with Pocket integration, which happens to be integrated with my main browser, Firefox. This allows me to save a web page to Pocket, and it appears in the Pocket collection in Kobo. 

Pocket's normal login is via Firefox SSO, but no such option appears on the Kobo Pocket app. The Kobo Pocket app expects a regular Pocket username and password. I had to go through the [Forgot Password](https://getpocket.com/forgot?ep=1) workflow on Pocket to set a password, and I was then able to log into the Kobo. 


### Borrowing books from Overdrive library

The Kobo also has an Overdrive app, and as luck would have it, my local library is on Overdrive. It's been a major source of my books over the past few years. Logging in and borrowing books is very simple, and the epub files are saved to the device without any need of the user-hostile Adobe Digital Editions. 

### Adding new fonts

Adding new fonts to the Kobo is really easy. Connect the Kobo to a computer, and create a new folder at the root level called `fonts`. Then just copy the font files (ttf) into that folder. 

Some fonts I chose to try were [Noto Serif](https://fonts.google.com/noto/specimen/Noto+Serif), [Linux Libertine](https://www.dafont.com/linux-libertine.font) and [Bookerly](https://the-digital-reader.com/how-to-install-bookerly-ember-roboto-and-other-fonts-kobo-ereaders/).  


![Fonts selection](/assets/images/kobo-customizations/008.png)


## Syncing Kobo with Calibre Web

My [ebook setup](https://code.mendhak.com/my-ebook-reading-setup/) is centered around Calibre as the main source of books, so that I can read on multiple devices. Calibre Web comes with a [Kobo Sync feature](https://github.com/janeczku/calibre-web/wiki/Kobo-Integration) which allows setting a specific shelf as the source of books for the Kobo. 

In Calibre Web > `Admin` > `Edit Basic Configuration` > `Feature Configuration`, check `Enable Kobo Sync` and `Proxy unknown requests to Kobo Store`.

Under the user profile ('admin' for me), check `Sync only books in selected shelves with Kobo`. 

Click `Create/View` under `Kobo Sync Token`, and a popup with a value in the format `api_endpoint=https://example.com/kobo/xxxxxxxxxxxxxxxx` appears. Make a note of this value as it's needed later. 

Create a new shelf, eg 'Kobo Shelf' and check `Sync this shelf with Kobo device `. 

{% gallery "Setting up Calibre Web with Kobo Sync" %}
![](/assets/images/kobo-customizations/010.png)
![](/assets/images/kobo-customizations/011.png)
![](/assets/images/kobo-customizations/012.png)
![](/assets/images/kobo-customizations/014.png)

{% endgallery %}

That's the Calibre Web setup, and next is getting the Kobo device to make use of it. 

Connect the Kobo to a computer, and when the device is mounted, edit the file `.kobo/Kobo/Kobo eReader.conf`. Look for the line: 

    api_endpoint=https://storeapi.kobo.com

And change it to the value that Calibre Web gave earlier. 

    api_endpoint=https://example.com/kobo/xxxxxxxxxxxxxxxx

Unmount the Kobo, then sync the device from the top right icon on the home screen. The Kobo now attempts to sync with Calibre Web, which responds with the list of books from the created shelf. 

![Sync Kobo](/assets/images/kobo-customizations/015.png)




## Advanced features with NickelMenu

NickelMenu is third party software that can run on the Kobo and it comes with various quality of life improvements and unlocks hidden features on the Kobo. 

[NickelMenu](https://pgaskin.net/NickelMenu/) creates an additional menu at the bottom right of the Kobo home screen, and can also add additional menu _items_ in the reader view menu, and the word selection menu. 

Here are some of the ones I've made use of:

**Invert & Reboot** — Kobo's default Dark Mode only sets it in the reader view, but not in the menus, home screen, and library view. NickelMenu can make available an _Invert_ option which inverts the colors everywhere, including the menus and screens. 

**Sleep** — it's easier to sleep the device right from the menu rather than the harder to reach power button on the Kobo Libra 2. Less fidgeting while reading. 

**Screenshots** — toggling this menu option turns the power button into a screenshot button. Remember to un-toggle it, or it becomes difficult to recover the device from sleep.

**Overdrive** and **Pocket**  — easy to get to these two apps from the menu

**Sketch Pad, Solitaire, Sudoku, Word Scramble, Unblock It** — various simple games. Sketch Pad is a quick way of just drawing with your finger, and it saves as SVG.  

**Toggle screensaver** — allows switching between the [book cover](#full-screen-covers) or the [custom images](#custom-image-screensavers) as the screensaver.

![My NickelMenu options](/assets/images/kobo-customizations/020.png)


I followed the instructions to install NickelMenu, created a custom menu file, and these are its contents:

```
#--------------------------------------------------------------------------------------------
menu_item :main    :Dark Mode          :nickel_setting     :toggle :dark_mode
menu_item :main :Invert & Reboot :nickel_setting :toggle: invert
    chain_success :power :reboot
menu_item :main    :Screenshots        :nickel_setting     :toggle :screenshots
menu_item :main    :Overdrive          :nickel_open: store:overdrive
menu_item :main    :Pocket             :nickel_open:       library:pocket
menu_item :main    :Sketch Pad         :nickel_extras      :sketch_pad
menu_item :main    :Solitaire          :nickel_extras      :solitaire
menu_item :main    :Sudoku             :nickel_extras      :sudoku
menu_item :main    :Word Scramble      :nickel_extras      :word_scramble
menu_item :main    :Unblock It         :nickel_extras      :unblock_it
menu_item : main : Toggle screensaver : cmd_output : 500 : quiet : test -e /mnt/onboard/.kobo/screensaver_old
      chain_failure : skip : 3
      chain_success : cmd_spawn : quiet: mv /mnt/onboard/.kobo/screensaver_old /mnt/onboard/.kobo/screensaver
      chain_success : dbg_toast : Screensaver on
      chain_always : skip : -1
      chain_failure : cmd_spawn : quiet: mv /mnt/onboard/.kobo/screensaver /mnt/onboard/.kobo/screensaver_old
      chain_success : dbg_toast : Screensaver off
menu_item :main    :Kernel Version     :cmd_output         :500:uname -a
menu_item :main    :IP Address         :cmd_output         :500:/sbin/ifconfig | /usr/bin/awk '/inet addr/{print substr($2,6)}'
menu_item :main    :Sleep              :power              :sleep
#--------------------------------------------------------------------------------------------
menu_item :reader  :Invert Screen      :nickel_setting     :toggle :invert
menu_item :reader  :Sleep              :power              :sleep
#--------------------------------------------------------------------------------------------
menu_item :library :Import books       :nickel_misc        :rescan_books_full
#--------------------------------------------------------------------------------------------
menu_item :browser :Invert Screen      :nickel_setting     :toggle :invert
menu_item :browser :Open Pop-Up        :nickel_browser     :modal
#--------------------------------------------------------------------------------------------
```
