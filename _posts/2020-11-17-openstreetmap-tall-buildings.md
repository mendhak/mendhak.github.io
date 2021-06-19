---
title: "OpenStreetMap tip: tall buildings"
description: "Mapping tall buildings in OpenStreetMap"
categories: 
  - openstreetmap
tags: 
  - openstreetmap

---

When mapping tall buildings, it's important to ensure that the drawn area matches the building's footprint - where it intersects with the earth.  

It's a normal habit to just trace the roof of a building and move on to the next one.  However you need to be careful with tall buildings, just drawing the roof can be misleading, incorrect and could overlap other structures. Here's how to ensure that the buildings are mapped correctly.  


Take this example, there are two tall buildings here, and they're at an angle, not directly overhead.  

[![example]({{ site.baseurl }}/assets/images/openstreetmap-tall-buildings/001.png)]({{ site.baseurl }}/assets/images/openstreetmap-tall-buildings/001.png)

The correct way to map these would be to first trace the roof as you normally do. 

[![trace the roof]({{ site.baseurl }}/assets/images/openstreetmap-tall-buildings/002.png)]({{ site.baseurl }}/assets/images/openstreetmap-tall-buildings/002.png)

Now right click the area, and select Move (key `M`), and then move the area down until it touches the bottom of the building. 

[![move to earth]({{ site.baseurl }}/assets/images/openstreetmap-tall-buildings/003.png)]({{ site.baseurl }}/assets/images/openstreetmap-tall-buildings/003.png)

That's it, this now ensures that the OpenStreetMap map will show the correct position of the building, especially in relation to others around it.  

It does appear a little odd if you're not familiar with this technique, but once you know of it, it explains why some buildings in some areas appear 'off' their imagery, while some are right on their buildings - it's likely because someone else has done the same shifting.  

[![zoom out]({{ site.baseurl }}/assets/images/openstreetmap-tall-buildings/004.png)]({{ site.baseurl }}/assets/images/openstreetmap-tall-buildings/004.png)

I was given a very useful tip while working on some [OpenStreetMap tasks](https://www.hotosm.org/) and was able to understand it well, thanks to this helpful video which goes into a little more detail. 

{% include video id="JAPiGntG6fs" provider="youtube" %}