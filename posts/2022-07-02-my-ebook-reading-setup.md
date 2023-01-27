---
title: "My ebook reading setup"
description: "Using Calibre-Web hosted on a Raspberry Pi, surfaced through Cloudflare Tunnel, to read ebooks across multiple devices from multiple sources like libraries and bundles and light novels."


tags: 
  - ebook
  - kindle
  - calibre
  - reading
  - multiple
  - light-novel
  - library





opengraph: 
  image: /assets/images/my-ebook-reading-setup/012.png

---


I used to have a simple life — I'd buy books off Amazon, and read them on a Kindle.  But over the past few years, my reading habits changed drastically.  I'm now reading a lot more things, from a lot more sources, on a lot more devices and have had to break out of the Amazon bubble.  

But I still wanted a relatively convenient setup for fetching and reading ebooks, and I've managed to achieve something that's working well enough for me.  I'm able to get books from the library, bundles, direct downloads, and I access them from my computer, phone as well as Kindle device.  Here I'm writing up my ebook getting, surfacing, and reading setup, along with the reasoning behind each of the decisions I've made. 

## Where I get books

![Sources](/assets/images/my-ebook-reading-setup/002.png)

### The library

Libraries are great because you can borrow books for free, which sounds obvious but is quite easy to forget when you're in any ecosystem.  I pay council tax, of which a portion goes towards my local council library.  My library is part of the UK's [Libraries Consortium](https://thelibrariesconsortium.org.uk/), and through Overdrive they provide ebooks to borrow, for free.  Joining was easy — I only had to walk in with proof of address, I got a library card, and that was my login details for the online library.  

The selection is actually better than I thought it would be, and I regularly find several items from my 'Want to Read' list.  Since there are limited copies of these ebooks (due to publisher restrictions), I don't always find the book available to borrow right away, but I can place a hold on them.  I get notified by email when it's available to borrow, at which point I go and download it, and add it to my Calibre library. 

![Library](/assets/images/my-ebook-reading-setup/005a.png)

### Online stores

Amazon is my main source for buying books, especially when I don't want to wait for a library copy, or if I want to show support for an author.  There are other stores too which I'll check out when there are sales, such as Kobo and Google Play.  Although books from all major online stores come with DRM (due to publisher restrictions), dealing with Adobe's Digital Editions (ADE) software is particularly loathsome and I try to avoid it.  

With Amazon, I can at least download purchased books through the web browser.  With stores that deliver through ADE, not only does it require a software installation, you can only activate up to 6 times, after which you have to contact their equally loathsome customer services team and explain that you wipe your devices regularly and are reinstalling their loathsome software to get some books.  

### Light novels and web novels

I have been reading more series from the world of Japanese, Korean, and Chinese Light Novels ([the name is misleading](https://anime.stackexchange.com/questions/13301/what-exactly-is-a-light-novel), many series go into thousands of pages).  More often than not, they are only available as fan translations and downloadable as epubs.  However this situation is slowly changing as more series are being officially translated and made available in stores.   

With Web Novels, authors will self publish their stories in blog posts for anyone to read, and similarly, the popular ones will get fan translations.  When I find an interesting series, I'll compile several chapters into epubs for some binge reading.  

### Free ebooks and direct downloads

Humble Bundle will sometimes offer book bundles on sale, and there are occasionally Tor.com promotions of free books.  Thankfully these are DRM free.  

For literary classics, I'll try out [Project Gutenberg](https://www.gutenberg.org/) which is quite well known, but can be hit-or-miss in terms of quality. For a more curated experience, [Standard Ebooks](https://standardebooks.org/) offers well formatted epubs too.  

{% gallery "Free books" %}
![](/assets/images/my-ebook-reading-setup/004a.png)
![](/assets/images/my-ebook-reading-setup/004b.png)
{% endgallery %}


## Organizing files in Calibre

At the center of my workflow is [Calibre](https://calibre-ebook.com/), an ebook management software.  

When adding a book to the Calibre library I'll ensure that both epub and mobi formats are generated, if either format is missing.  Epub because it's universal and widely accepted, and mobi for Kindle devices.  Calibre comes with convenience functions such as metadata download (series, high res covers, tags) which helps pretty up the presentation.  I've also added a custom column to track the read status, "Read", which is a simple boolean type.   

Calibre stores its metadata in a local database file, while the actual books are kept on disk, relative to the path of the database.  Both the Calibre database as well as the ebook files files are then synced up to Google Drive using [Insync](https://insynchq.com) which works well on Linux.  

![Calibre](/assets/images/my-ebook-reading-setup/003.png)



## How I make the library available

The next step is making the library available from anywhere, both at home and while outside, such as at work or while travelling.  This involves putting the library on the internet, which in turn means web access.  Because Calibre is a desktop application, it's not so simple to make it available from anywhere; it does come with a built in content server but it's meant for simple access and library management.  

![Calibre-Web on Raspberry Pi](/assets/images/my-ebook-reading-setup/007.png)

### Calibre-Web

The [Calibre-Web](https://github.com/janeczku/calibre-web) project is a fully featured web UI over the Calibre database.  It presents a web page as well as an [OPDS feed](https://en.wikipedia.org/wiki/Open_Publication_Distribution_System), the importance of which will become apparent later.  

Calibre-Web can run in a Docker container, which makes it a perfect candidate for running on a Raspberry Pi.  Having it run on a Raspberry Pi means I don't need to keep my computer running all the time, and I can benefit from its lower power consumption.  

To run, Calibre-Web requires the Calibre database file, as well as the books themselves.  I sync these down on a schedule using [Rclone](https://rclone.org/), a commandline application that can sync from Google Drive (among dozens of other sources).  Calibre-Web automatically picks up the latest changes, and is also able to show my Unread books based on the custom column I created in Calibre earlier.  Clicking on a book brings up its dialogue, I can then download the book to the device I'm accessing it from.  As an added bonus, it comes with OAuth authentication and I can use my Github login.  


![Calibre-Web](/assets/images/my-ebook-reading-setup/006.png)

### Cloudflare Tunnel

To expose Calibre-Web to the internet, I _could_ open a port on my home router and forward all traffic to the Raspberry Pi, but a much neater way of doing it is through [Cloudflare's tunnel](https://www.cloudflare.com/en-gb/products/tunnel/) which doesn't require opening any ports at all.  Since my DNS is hosted in Cloudflare, the tunnel works by mapping a DNS hostname, `mylibrary.example.com` directly through Cloudflare's network to the tunnel software running on the Raspberry Pi, which forwards traffic onto the Calibre-Web server.  

I've got the entire setup with instructions in a [Github repo](https://github.com/mendhak/docker-calibre-web-cloudflared).  Everything required is in [the docker-compose.yml](https://github.com/mendhak/docker-calibre-web-cloudflared/blob/master/docker-compose.yml), including running the tunnel.  


## How I read my books

Now that I've made the library available, I can access it from the applications and devices that I want to read from.  This is where the application choices become important.  They need to be good at rendering a book of course, but also need to be able to access an online catalog.  For this, there exists the Open Publication Distribution System format, or OPDS.  Most mature readers will be able to access an OPDS feed to present a library to the user and know how to authenticate against those and fetch the right format of books to present.  Calibre-Web presents its OPDS feed at `https://mylibrary.example.com/opds`.  

![Reading from devices](/assets/images/my-ebook-reading-setup/011.png)

### On Desktop, Foliate

I have tried numerous ebook reading applications on desktop, mobile, and tablets.  Of all of them, nothing comes close to the simplicity of [Foliate](https://johnfactotum.github.io/foliate/).  A really important factor in reading is immersion, and in terms of software that translates as ensuring that it gets out of your way.  Foliate is the reader I've found that does this best.  It can go full screen, with no controls visible, like a Zen mode.  The font colors and backgrounds can be customized and I like to play around with those; for instance I can set a dark background, with gray or yellowish text, and set Bookerly as the font.  It's pretty easy on the eyes.  

It may sound strange, reading on a computer, especially on a 27" 2560x1440 gaming monitor with 144Hz refresh rate.  After all, dedicated reader devices do exist, but it works for me; I will usually have Foliate open on my second monitor while I'm gaming, writing, or programming on the main monitor.  It's nice to glance away, read a little bit as a break, and then get back to the main task.  In fact, I'm doing it right now.  

![Calibre-Web](/assets/images/my-ebook-reading-setup/008.png)

Foliate Catalog feature can access libraries available over the OPDS format.  Since Calibre-Web makes my library available that way, I simply connect Foliate to `https://mylibrary.example.com/opds`, enter credentials, and connect.  The presentation is basic — it can list the categories, including unread, allows some searching, and can add the books to its library for reading.  

{% gallery "Foliate catalog view and customized reading view" %}
![](/assets/images/my-ebook-reading-setup/009a.png)
![](/assets/images/my-ebook-reading-setup/009b.png)
{% endgallery %}

### On Mobile, Moon+ Reader Pro

Interacting with content on a mobile device isn't the same as readers, tablets, or desktops.  Page turns don't really translate well, scrolling feels a lot more natural. So in addition to the immersion factor, and the ability to set background and text color, and fonts, and accessing OPDS feeds… another important feature for mobile reading applications is the ability to have continuous scrolling.  And yet it's surprisingly uncommon!  Moon+ Reader does have the ability, though it's not made very obvious.  I believe I had to set the Page Flip animation to "none" for it to go to continuous scrolling. 

As mentioned, Moon+ Reader can access OPDS feeds, under the Net Library menu. It's a very utilitarian presentation, not even the covers are visible, only the ability to pick a format to download.  It's good enough, and lets me get reading right away. A really neat feature in this app is also the ability to control brightness, so if I'm reading on the phone at night, or in bright sunlight, I can change the screen brightness by sliding my finger across the left edge.  

{% gallery "Moon+ Reader net library, and customized reading view" %}
![](/assets/images/my-ebook-reading-setup/010a.png)
![](/assets/images/my-ebook-reading-setup/010b.png)
{% endgallery %}



### The Kindle

Eink screen are my favorite type of reading surface.  No eye strain, crisp presentation, perfect for extended reading sessions.  I've mostly ever bought Kindles (though Sony PRS-505 was my first reader), simply because they are popular and good physical devices.  However after transforming my reading setup into something more diverse, a lot of the Kindle's shortcomings become more apparent.  Kindles can't (won't) render epubs, so I have to convert books to mobi or azw3 just for this one device.  

It can't read from OPDS feeds either.  Instead, I have to use its experimental browser, as it's called, and navigate to the Calibre-Web UI, login, download the book and then open it.  The browser has been experimental since the very first Kindle, you'd think they have had enough time by now to make it stable.  The adjective 'experimental' does not fill me with confidence either, as it implies that the browser could be taken away at any time.  And I won't be surprised if that happens, Amazon simply does not care about catering to books that originate from outside its ecosystem.  They've allowed Goodreads to stagnate after all.  

Without the Amazon ecosystem at the forefront, the Kindle device on its own merits, is just OK.  It's not mediocre, but it's not amazing either.  In the future I might consider different eink devices, both Kobo and Onyx seem to have compelling offerings.  

## What doesn't work: syncing

A glaring omission in all of this is something that the Kindle ecosystem did use to provide, and that's syncing position across books.  There is no solution available that can sync across disparate devices and applications seamlessly.  My workaround is to simply jump to the part of the book I was reading at, and find the exact place to resume.  It's not a dealbreak, but is a minor inconvenience. 

It would feel like the OPDS feed, or some 'endpoint' along those lines, could become a place to manage this kind of tracking.  The difficulty in coming up with such a protocol is that reading position is a piece of stateful information, and that information needs to be written somewhere.  The endpoint could store the position in its own database format, or even inside the Calibre DB, but either way, it requires all applications and devices to subscribe to said protocol.  

In any case, it does not look like such a thing will be created anytime soon, the last [discussion around this topic](https://github.com/opds-community/drafts/discussions/49) was in 2019.  

## Summary

There's a lot of text in this post, but the premise is simple.  Add books to Calibre.  Sync it to the Raspberry Pi and make it available using Calibre-Web through Cloudflare, [as shown in this docker-compose repo](https://github.com/mendhak/docker-calibre-web-cloudflared).  I then access Calibre-Web from my apps and devices.  

The flow, end-to-end, looks like this: 

![All together](/assets/images/my-ebook-reading-setup/012.png)

([Diagram](/assets/images/my-ebook-reading-setup/EbookReading.excalidraw) made in Excalidraw!)
