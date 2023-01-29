---
title: Escaping Jekyll, and moving to Eleventy
date: 2023-01-28
---


A rite of passage exists, that after a certain amount of time spent writing on a platform, a blogger feels a need to revamp or migrate to something else.  I used to come across such posts on various other blogs and I'd be dismissive of them. Just be happy with what you have, right?  As it turns out, **no**, there are always good reasons to move, and it took me a while to understand that. I can say I am glad to be free of the torturous hell that is Jekyll and Ruby. 

### Jekyll and Minimal Mistakes

I had originally picked Jekyll purely for convenience — Github Pages automatically builds and deploys it.  I'm always in favor of managed services, so this fit the bill perfectly.  Just write in Markdown, push to Github, and the post appears on the site momentarily.  

There was also an excellent theme to get started with, called [minimal mistakes](https://mmistakes.github.io/minimal-mistakes/). It's a very popular theme for Jekyll with several features and many configuration options, not limited to  images, galleries, notices, buttons, and color themes too. 

### Running it locally

Over time though, as the writing became more involved, I needed to preview what I wrote, which meant running Ruby locally.  This is where the problems started.  And persisted, while I tolerated.    

In my experience across many language ecosystems, I have never encountered any as fragile as that of Ruby and Jekyll; one that breaks so easily and so frequently, in strange and inexplicable ways.  As with many experiences, it's always a case of <abbr title="Your Mileage May Vary">YMMV</abbr>, and I'm sure that most people in this ecosystem won't experience the same, but I did, and it was a significant factor.  

Each time I'd run it after a few weeks away, another part of the setup would have broken and had to be solved in strange ways that made no sense to me. It felt like Gemfiles were worthless, making a spectacle of themselves, locks were too open, rakes were broken, and Dockerfiles were more like Jokerfiles.  The distractions were enough that I wasn't writing, I was first overcoming the trepidation of fixing something, and then writing if I still had the energy.  

A lot of the problems encountered felt symptomatic of the Ruby philosophy of hiding things away to appear like 'magic', which was once praised widely during its peak popularity phase. Little rotting nuggets of said philosophy were now worming its way to the surface and cheerily waving hello at me.  

### Choosing another platform

Although the next obvious choice was Hugo, I had been hearing quite a bit about [Eleventy](https://www.11ty.dev/).  I started experimenting with both and ended up using Eleventy for a few other minor things, such as [the GPSLogger page](https://gpslogger.app/) and my [noodles website](https://noodles.mendhak.com/). 

What I like about it is its low touch approach — it isn't tied to any framework, just plain old Javascript. It has a data-first design, which fits nicely with the content-first approach I am looking for.  At the same time, it allows for extensive customisability through its many features. 

I did find a few different blog themes, but what I was missing was a feature-set like that of minimal-mistakes. 

### Modifications

I decided to use an Eleventy starter base, and start adding some of those features in, or a close approximation.  Since I've got no web design skills, [SimpleCSS](https://simplecss.org/) was a good place to start. It has a sensible set of defaults and comes with automatic dark and light themes. I was able to modify it to achieve a simplified version of [the Hylia theme](https://hylia.website).  

Some of the modifications I'm happy about. 

Being able to link to another post [by its `.md` file name](https://code.mendhak.com/eleventy-satisfactory/posting-links/).  

A shortcode that can [minify multiple files together](https://github.com/mendhak/eleventy-satisfactory/blob/main/_includes/layouts/base.njk#L24-L31).  

A shortcode that generates [Github repo cards](https://code.mendhak.com/eleventy-satisfactory/github-repo-card/). 

Being able to [render Github Gists right on a page](https://code.mendhak.com/eleventy-satisfactory/post-with-github-gists/) instead of that awkward looking embed.    

Converting normal markdown images to use lightbox, and [super wide images!](https://code.mendhak.com/eleventy-satisfactory/post-with-an-image/#unconstrained-full-width-image) (And [videos too](https://code.mendhak.com/eleventy-satisfactory/post-with-iframes-videos-third-party/))


[Notice panels like info, warning, danger](https://code.mendhak.com/eleventy-satisfactory/post-notice/). 

Developing with Eleventy was a joy, and I spent a pretty intense 3 weeks working on the 'Eleventy Satisfactory' theme.  Working on one idea would lead to others in a cascade, and getting to grips with the various data wrangling features like computed data and nunjucks made for efficient snippets that weren't too unwieldy.  Overall a very satisfying experience.  

![Github activity lit up](/assets/images/escaping-jekyll-to-eleventy/001.png)


### Other thoughts

I have a lot more confidence in the continuity of Eleventy as compared to Jekyll.  However, one disadvantage now is that I've developed a theme, which is its own maintenance overhead, and the opposite of using something managed.  

My hope is that the modifications I've done are simple enough that I needn't spend a lot more time working on it.  Only time will tell and whether it results in a second migration, which is often another rite of passage. Or I should say, write of passage.   

