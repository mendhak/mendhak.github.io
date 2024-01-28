---
title: "The userscript that kept me fed"
description: "A userscript for Firefox that kept me fed by helping with groceries during lockdown in 2020"
tags:
  - javascript
  - amazon
  - firefox
  
---

When the lockdown was announced in March 2020, there was a surge of traffic to online grocery sites. Although I had been an early adopter and frequent user of several online supermarkets, I found myself unable to access many of my usual shops due to the way they decided to handle the traffic. 

Most sites decided that the best course of action was to emulate fainting goats and would fall over, and you had to wait until the early hours of the morning to be able to even browse the site. Sainsbury's proactively restricted my account from being able to access, citing the need to manage traffic better, and promised that they'd email me as soon as I was allowed to use their services again. They still haven't come back to this day, and I am not bitter about it *at all*. 

Amazon Prime Now was one of the few places that was able to manage the surge of traffic well, and wasn't blocking anyone from shopping. The catch was that you could only see available delivery slots at checkout. Annoyingly, the slots were usually unavailable, and seemed to be released throughout the day at irregular intervals. 

![Dramatic reenactment of the Prime Now checkout page. I didn't take any screenshots back then so I've recreated them just for illustration](/assets/images/the-userscript-that-kept-me-fed/001.png)

I was constantly refreshing checkout, to see if any slots had become available. I was struggling to focus on work while keeping an eye on the page; I'd frequently miss out on released slots. 

I needed automation to help me out, and I learned about [Greasemonkey](https://addons.mozilla.org/en-GB/firefox/addon/greasemonkey/), an extension that allowed users to run custom scripts on web pages. 

## The userscript

The work turned out to be simple, with a few minor issues that I had to work around. 

When no slots were available the text 'No delivery windows' was shown on the page, which disappeared if slots were available. The idea was to look for that text, and if it was absent, that represented success, that a slot was available.  

I added a banner to the top of the page which would be visible when the script was running and notify me of the status.


```javascript
var bigRedBanner = document.createElement('div');
bigRedBanner.setAttribute('style', 'width:100%; background-color: white;text-align:center;padding-top: 15px; padding-bottom:20px; font-size:24px; font-weight: bolder; ');
document.body.prepend(bigRedBanner);
```

Then of course, check for the text. 

```javascript
var slotUnavailable=true;
try {
  slotUnavailable=(/No delivery windows/i.test(document.getElementById('delivery-slot-form').innerText));
}
catch(err){
  slotUnavailable=false;
}
```

Instead of reloading the page to check again right away, I decided to randomize how long the script would wait. I didn't want to run afoul of any detection that might get triggered, and I didn't want to place unnecessary load on their servers. I chose a random value between 60 and 160 seconds, so that my checks were as 'organic' as possible. 

```javascript
var refreshAfter = Math.floor((Math.random() * 100) + 1)+60; 
```

If no slot was available, the banner would show the countdown until page reloaded.   

```javascript
if(slotUnavailable){
     setInterval(function() {

        console.log(i);
        i = i + 1;
        bigRedBanner.innerText = 'Nothing yet...😔 Reloading in (' + (refreshAfter-i) + ')';

        if (i == refreshAfter) {
            location.reload();
        }
    }, 1000);
}
```

![Userscript counting down](/assets/images/the-userscript-that-kept-me-fed/002.png)

And if a slot was available, of course, make the banner prominently tell me. 

```javascript
else {
  bigRedBanner.setAttribute('style', 'width:100%; background-color: red;text-align:center;padding-top: 15px; padding-bottom:20px; color: white; font-weight: bolder; font-size:33px;');
  bigRedBanner.innerText = '🎉SLOT FOUND!🎉';
}
```

![Delivery slot found](/assets/images/the-userscript-that-kept-me-fed/003.png)

## Adding some noise

There was still one problem though — I didn't always have the tab visible, so I'd still miss the banner sometimes. 

I needed a noisier notification, and I found the perfect clip to help me out. 


<audio controls preload="auto" src="/assets/images/the-userscript-that-kept-me-fed/whoop.mp3" autostart="false" ></audio>

This required a little more setup. I created the `audio` element, and set its source to the clip.

```javascript
var slotFoundSound = document.createElement('audio');
slotFoundSound.src = 'https://ia803000.us.archive.org/13/items/Zoidberg_Whoop/whoop.mp3';
slotFoundSound.preload = 'auto';
```

In Firefox's settings, I had to add an exception for the Prime Now site to allow autoplay. 

Finally, when a slot was found, I'd play the sound. 

```javascript
else {
    slotFoundSound.play();
    bigRedBanner.setAttribute('style', 'width:100%; background-color: red;text-align:center;padding-top: 15px; padding-bottom:20px; color: white; font-weight: bolder; font-size:33px;');
    bigRedBanner.innerText = '🎉SLOT FOUND!🎉';
}
```

### This is fine

Like all the best solutions, it was inelegant and worked just fine. I made regular use of the script for several months and it greatly helped my peace of mind. 

There were a few incidents where the sound played (very loudly) while I was in the middle of a meeting, but I'd pretend not to have heard it. In retrospect, I don't think I was fooling anyone.  

The script is in [this Github repo](https://github.com/mendhak/Prime-Now-Checker/blob/master/primenowchecker.user.js).

