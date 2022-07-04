---
title: "My ebook reading setup"
description: "Various software and tools I use to read ebooks across multiple devices from multiple sources"

categories: 
  - ebook
  - kindle
  - calibre
  - reading
  - multiple
  - light-novel
  - library

tags: 
  - ebook
  - kindle
  - calibre
  - reading
  - multiple
  - light-novel
  - library

gallery1:
  - url: /assets/images/my-ebook-reading-setup/004a.png
    image_path: /assets/images/my-ebook-reading-setup/004a.png
  - url: /assets/images/my-ebook-reading-setup/004b.png
    image_path: /assets/images/my-ebook-reading-setup/004b.png

---


I used to have a simple life — I'd buy books off Amazon, and read them on a Kindle.  But over the past few years, my reading habits changed drastically.  I'm now reading a lot more things, from a lot more sources, on a lot more devices.  Amazon and the Kindle were inadequate for my needs, but I still wanted a relatively convenient setup for fetching and reading ebooks.  Here I'm writing up my ebook getting and reading setup, and the reasoning behind each of the decisions I've made. 

## Where I get books

[![sources]({{ site.baseurl }}/assets/images/my-ebook-reading-setup/002.png)]({{ site.baseurl }}/assets/images/my-ebook-reading-setup/002.png)

### The library

Libraries are great because you can borrow books for free, which sounds obvious but is quite easy to forget when you're in any ecosystem.  I pay council tax, of which a portion goes towards my local council library.  My library is part of the UK's [Libraries Consortium](https://thelibrariesconsortium.org.uk/), and through Overdrive they provide ebooks to borrow, for free.  Joining was easy — I only had to walk in with proof of address, I got a library card, and that was my login details for the online library.  

The selection is actually better than I thought it would be, and I regularly find several items from my 'Want to Read' list.  Since there are limited copies of these ebooks (due to publisher restrictions), I don't always find the book available to borrow right away, but I can place a hold on them.  I get notified by email when it's available to borrow, at which point I go and download it, and add it to my Calibre library. 

[![library]({{ site.baseurl }}/assets/images/my-ebook-reading-setup/005a.png)]({{ site.baseurl }}/assets/images/my-ebook-reading-setup/005a.png)

### Online stores

Amazon is my main source for buying books, especially when I don't want to wait for a library copy, or if I want to show support for an author.  There are other stores too which I'll check out when there are sales, such as Kobo and Google Play.  Although books from all major online stores come with DRM (due to publisher restrictions), dealing with Adobe's Digital Editions (ADE) software is particularly loathsome and I try to avoid it.  With Amazon, I can at least download purchased books through the web browser.  With stores that deliver through ADE, not only does it require a software installation, you can only activate up to 6 times, after which you have to contact their equally loathsome customer services team and explain that you wipe your devices regularly and are reinstalling their loathsome software to get some books.  

### Light novels and web novels

I have been reading more series from the world of Japanese, Korean, and Chinese Light Novels (the name is deceptive, many series go into thousands of pages).  More often than not, they are only available as fan translations and downloadable as epubs.  However this situation is slowly changing as more series are being officially translated and made available in stores.   

With Web Novels authors will self publish their stories in blog posts for anyone to read, and similarly, the popular ones will get fan translations.  When I find a popular series, I'll compile several chapters into epubs for some binge reading.  

### Free ebooks and direct downloads

Humble Bundle will sometimes offer book bundles on sale, and there are occasionally Tor.com promotions of free books.  Thankfully these are DRM free.  

For the classics, I'll try out [Project Gutenberg](https://www.gutenberg.org/) which is quite well known, but can be hit-or-miss in terms of quality. For a more curated experience, [Standard Ebooks](https://standardebooks.org/) offers well formatted epubs too.  

{% include gallery id="gallery1" layout="half" caption="Free books" %}

## Organizing files in Calibre

At the center of everything is [Calibre](https://calibre-ebook.com/), an ebook management software.  

When adding a book to the Calibre library I'll ensure that both epub and mobi formats are generated, if either format is missing.  Epub because it's universal and widely accepted, and mobi for Kindle devices.  Calibre comes with convenience functions such as metadata download (series, high res covers, tags) which helps pretty up the presentation.  I've also added a custom column to track the read status, "Read", which is a simple boolean type.   

Calibre stores its metadata in a local database file, while the actual books are kept on disk, relative to the path of the database.  Both the Calibre database as well as the ebook files files are then synced up to Google Drive using [Insync](https://insynchq.com) which works well on Linux.  

[![calibre]({{ site.baseurl }}/assets/images/my-ebook-reading-setup/003.png)]({{ site.baseurl }}/assets/images/my-ebook-reading-setup/003.png)


## Calibre Web on the Raspberry Pi

Calibre is a desktop application, so it's not easily accessible from anywhere.  For that, there's [Calibre-Web](https://github.com/janeczku/calibre-web) which is a web UI over Calibre.  



