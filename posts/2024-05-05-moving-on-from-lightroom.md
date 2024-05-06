---
title: "Lessons learned in moving on from Lightroom"
description: "Leaving Lightroom behind and moving on to better photography workflow tools."
tags:
  - lightroom
  - photography
  - on1 photo raw
  - digikam

opengraph:
  image: /assets/images/moving-on-from-lightroom/008b.png

---


Returning to photography from a post-pandemic malaise has been an invaluable experience that forced me to re-evaluate my workflow and tools. The main reason for the break was the ease with which I slipped into staying at home, and the decreased prevalence of dedicated cameras and photography communities. There's a post that talks about the [rise, fall, and resurrection of Flickr](https://web.archive.org/web/20240130045340/https://ferdychristant.com/the-rise-fall-and-resurrection-of-flickr-ca1850410ee1?gi=c0f6fc9c995a) which resonates with me and puts things into perspective.  

Ten years ago, seeing people carry cameras was a common sight, but in the 'new' world it has been firmly relegated to enthusiasts. Although *photography* itself is far more prevalent due to smartphones, it has come at the cost of quality and appreciation. We've normalized a poorer experience of viewing highly compressed, low resolution images on ad-festooned social media platforms, where the focus is not the photography itself, but engagement and quickly moving on to the next photo. Appreciating a photo, zooming to see the details, and wondering about the post processing techniques seems to get lost in the noise, but I'd like to not give up on it just yet. 

Reacquainting myself with the camera didn't take too long. The muscle memory of adjusting the settings, framing the shot, and clicking came back... eventually. The real challenge was the post processing.

**Lesson learned**: Don't give up on hobbies due to external factors. The validation comes from you, not others. 

## The Lightroom situation

Lightroom 6 was a great tool for its time — it did asset management as well as processing, all in one place. Being standalone (the last one), you paid for the software and you could continue using it for however long you wanted. Adobe's focus is now on the subscription model, centered around mobile and cloud workflows. I believe this is a reflection of the majority of their target audience. 

Adobe has moved on, many of us are no longer its target audience, and we must accept it. Which would be fine, except that their strategy includes coercing those users into moving on to their newer offerings through a series of paper cuts and dark patterns which include removing older installers and requiring configuration gymnastics to keep the older software running. 

Their transformation has been the matter of much online debate, with enthusiasts and professionals arguing cross-purposes. Those in favour of a subscription model are unable to fathom that others may want to use the software infrequently, and it's not a given that we will always want to upgrade without good reason.

Lightroom comes in two variants: the default cloud version Lightroom CC, and Lightroom Classic. Lightroom CC comes with asset management and photo processing, and importantly it stores your files in its cloud storage space, and is available across multiple devices. It's very much aimed at companies and professionals who are willing to pay an ongoing cost, or who have no choice but to put up with the lock-in. 

For the rest of us, the kind-of equivalent to Lightroom 6 in the new world is Lightroom Classic, where the files are local. It's still subscription based though: if you stop paying, you can't develop photos anymore, only stare at them like a clown. Short term purchasing for adhoc usage isn't possible either as the 'monthly' pricing is a false promise. Cancelling is a nightmare in its own right. Without going into more detail, there's a good reason that Adobe makes a frequent appearance on [/r/assholedesign](https://www.reddit.com/r/assholedesign/). 

If that isn't troubling enough, Lightroom Classic is likely to be killed off at some point in favour of CC only. No software product with a future would ever have the word "classic" in its name. 

It's pretty safe to say that for infrequent users like me, Lightroom makes no sense at best. 

**Lessons learned**: 
* Don't tie yourself to a specific software, be ready to move on.  
* Subscriptions incentivize profits over products.  


## The new world

In my search for a replacement, I've seen that the photo software landscape has changed a lot, and overall I'd say it's for the better. The search goes in two parts, asset management, and photo processing. 

Digital Asset Management (DAM) is basically the process of organising photos, tagging them, managing metadata, culling them, and searching. 

Most photo processing software actually did come with _some_ asset management features, but they are often minimal. The best strategy then was to look for software dedicated to DAM, and separately software for processing.  

### Digikam for DAM, easy

[Digikam](https://www.digikam.org/) has emerged here as one of the best photo management offerings that I could find, and it is absolutely *packed* with features. It's <abbr title="Free and Open Source Software">FOSS</abbr>, which lends to peace of mind right away. It's a very mature project, which began in 2006. The interface does take some getting used to, though isn't a problem to learn. 

It can do RAW imports, flagging and rejecting, rating, colours, sharing and publishing. It also does GPS correlation, which is pretty important to me. I record my GPX tracks and let the [geotagging tool](https://userbase.kde.org/Digikam/Geotagging) correlate the photos; it can even do reverse geocoding and put the location name in the metadata. 

![Digikam GPS correlation for my recent Peak District holiday](/assets/images/moving-on-from-lightroom/006.png)

Digikam's similarity search is a great way of finding duplicates and helping clean up years of accumulated sprawl. It actually helped me recover from a major mistake I had made, which was exporting directly from Lightroom to Flickr. The changes were stuck in the Lightroom Catalog (lrcat) file. 

Thankfully, I was able to do a Flickr data export, then use [the flickr-export-organizer script](https://github.com/tagspaces/flickr-export-organizer) to rearrange the files into a folder structure. Digikam's similarity search then helped me identify similar photos and I'd then drag them into the right folders. It was a bit of a manual process, and the final files don't sit exactly next to its original files, but I'm satisfied with this salvage operation. 

![Digikam similarity search example](/assets/images/moving-on-from-lightroom/005.png)

There was another mistake I had made, which I wasn't exactly able to recover from, which is sidecar files. Lightroom does have the ability to write metadata to XMP files, but it isn't something I had uniformly applied everywhere, and so a lot of metadata was stuck in the catalog file. XMPs are generally a good idea and understood by many asset management applications, but I had not been consistent with them. 

**Lessons learned**: 
* Always export the final image locally, then publish manually. 
* A manual step in a workflow is not a terrible thing, not every workflow needs to be optimal. 
* If there's a proprietary format, minimize time with it. Do your work and get out. 
* Enable sidecar files (XMPs), it's a boatload of new files that appear, but it's worth it.

### Photo processing software

Having the DAM sorted and out of the way was helpful, it meant that I could focus on just the processing part instead of looking for an all-in-one replacement. 

There are several good offerings here with a perpetual option, and that made me glad — the field is still alive, vibrant, and healthy. 

The main criteria I had was a perpetual license, obviously, HDR and panorama stitching and helper workflow tools.  

Modern photo processing workflows place an emphasis on editing using layers and masks. In practical terms, that means you'd pick an area of a photo like the ground or the sky, and apply adjustments just to that bit. What's new is that some of these applications can help you identify these areas using machine learning models, and some can even automatically identify areas and make those adjustments as a starting point, so it makes the overall process faster. Of course, because it's 2024, the marketing pages are calling it AI because absolutely everything with a bit of smarts needs to be called AI. Only time will tell how cringey that description will be, I just hope it doesn't affect the actual functionality, because it has been pretty useful. 

The FOSS offerings include DarkTable and RawTherapee. RawTherapee is especially comprehensive in what it can do, with a steep and rewarding learning curve, but it feels very much for power users. I think I would investigate it as a fallback option if I ever needed to.

In the paid sphere, I had a look at Capture One Pro, DXO PhotoLab, ON1 Photo Raw, Affinity Photo, and Skylum. All of them came with trials, which was very helpful. 

Of these, Skylum was a bit _too_ basic for my needs, and Affinity Photo felt more like a Photoshop replacement than a Lightroom one (perhaps a future consideration). 



### Capture One Pro

I found C1 to be really good, and it seems aimed at experienced people. Its editing is top notch, and its object selection is very intelligent. Sadly, Capture One has gone through a marketing overhaul and has chosen to adopt Adobe's nickel-and-dime route. Their perpetual license option is the most expensive among the offerings, and yet does not include even minor updates. They offer miniscule upgrade discounts, so there's no reward for loyalty. They're now [prominently pushing their subscription model](https://www.reddit.com/r/captureone/comments/13o7f5l/im_sorry_but_the_new_pricing_is_just_bonkers/), which is a shame because the software is quite good. 

### DXO Photolab

I wanted to give it a good try, but was more confused by its home page than anything else, which you could clearly tell was designed by a marketing team. I couldn't tell which of the software I actually needed, what was included in the main PhotoLab package, what was even a product and what wasn't. I was also left wondering why the Nik collection wasn't included as part of Photolab. 

By the time I had gotten it installed, I was expecting a lot more than they offered, especially presets and smart object selection tools which I had gotten used to. I'm sure this is a great tool for those that know it already, but I was already pretty put off by the experience.


### ON1 Photo Raw

ON1 Photo RAW is what I chose in the end. It has a Lightroom vibe to it while staying its own thing. Much of the interface and terms used are quite similar, including the shortcuts and ability to snapshot from history. 

Just like Capture One, it has an intelligent object selection tool, so it can pick out sky, mountain, ground, to help along with the workflow, and it also has an option where it figures out the main parts of the image and applies suggestions to it automatically. 

I thought it struck a good balance between enthusiast and professional wofkflows; many of its tools come with an explanation of what they are, and some even link to tutorials. The HDR and panorama stitching worked well, which I use quite a bit. The cost felt the most reasonable of the lot, you get a perpetual license and updates for that major version, which is very similar to what Jetbrains does with their IDEs.  

What sold me on this software was the ability to take it easy or go deep on the editing. There are several presets it comes with, which act as a good starting point because they just perform actions in the develop module, which you can carry on from. Or you can choose to start fresh and make your own adjustments to different parts of the image. 

![ON1 Photo Raw. Presets on the left, and layer masks on the right](/assets/images/moving-on-from-lightroom/007.png)

It's not perfect; there's a thankfully smaller proprietary lock-in which is limited to the image level rather than a more egregious catalog level. Each image you process gets a corresponding `.on1` file which stores the changes you've made to it, a somewhat decent compromise that gets out of my way. For HDRs and panoramas, the combined image is in an `.onphoto` file, but can be converted to TIFF. Even regular images can be converted to TIFF, which is a good way to not be locked in.  



### My workflow

The workflow I've settled on is to use Digikam for asset management, and ON1 Photo Raw for processing. 

Because Digikam works on Linux, I'll have it with me on holidays on my light Ubuntu laptop, and load my RAW files into it regularly. I'll do the usual managing: pick the photos to keep, remove the unnecessary ones, mark out the ones that I think have potential for processing, or HDRs, or panoramas. Since I'm recording my GPX tracks, I'll also geotag the photos and reverse geocode them.  

When I'm back home with a large screen and a GPU, I'll load the photos into Photo Raw, and start editing. In some cases I'll use a preset to get an idea and go from there. In other cases I start from scratch and try various local adjustments or effects to see what works.  

Finally when I have something I'm happy with, I'll export the final image to disk, and use Digikam to publish it to [my Flickr account](https://www.flickr.com/photos/mendhak/). The latest images there are from a recent holiday to Peak District, processed in Photo Raw. I'm mostly happy with the results, though still getting used to processing again.   

**Lessons learned**:
* Keep the asset management and photo processing separate.
* Don't be afraid to try out new software, and don't be afraid to move on.
* Don't be afraid to pay for software, but make sure it respects your time.

![Work in progress](/assets/images/moving-on-from-lightroom/008.png)

----

#### Side note - cleaning up

With the numerous sidecar files floating about, between Digikam and ON1, you can sometimes end up with orphaned `.xmp` files for missing images. This isn't a regular occurrence, it is normally prevented by configuring Digikam to treat `on1` as additional sidecar files, but it could happen if you delete files externally or through other applications that don't get the association. It's a minor annoyance, I have a script to help with that, which basically looks for `.xmp` files that don't have a corresponding image file, and deletes them. 


```bash
#!/bin/bash

# Check if directory is provided as argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 directory_path"
    exit 1
fi

directory="$1"

# Check if the provided directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist."
    exit 1
fi

# Change to the specified directory
cd "$directory" || exit 1

shopt -s nullglob extglob nocaseglob;

# Get all sidecar files
for file in *.{xmp,pts,pp3,dop}
do
  # Generate all permutations of filenames that it may belong to,  
  # and let globbing delete the ones that don't exist  
  candidates=("${file%.*}"@() "${file%%.*}".{jpg,jpeg,arw,on1,onphoto,raw,nef,raf,orf}@());  # add possible extension types that may be present here
  # If none exist, the file can be deleted  
  [[ {% raw %}${#candidates[@] }{% endraw %} -eq 0 ]] && echo "Found orphan $file" # && rm -f $file # uncomment this to actually delete the file
done

```




