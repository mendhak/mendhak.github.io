---
title: "My OpenStreetMap workflow: mapping the village of Marmari, Evia"
description: "A general OpenStreetMap editing workflow, with the example of Mapping the village of Marmari, Evia in Greece (Μαρμάρι, Εύβοια). "
tags: 
  - openstreetmap
  - gps
  - greece
  - tutorial

opengraph:
  image: /assets/images/openstreetmap-workflow-marmari/monument3.jpg

---

Although I'm not a prolific or advanced editor, I do enjoy contributing to OpenStreetMap. I'll generally perform edits when I notice new changes in my area or while on holiday when I find certain features, trails or details are missing.  

I recently visited the village of Marmari, Evia (Μαρμάρι, Εύβοια) in Greece and noticed that OpenStreetMap had almost no info on this place; there were no street names, stores or ATMs, even though they did exist in real life.  The 'before' is pretty bleak.

![before](/assets/images/openstreetmap-workflow-marmari/marmari_empty.png)

I spent some time filling in missing information and bringing the [end result](https://www.openstreetmap.org/#map=18/38.04896/24.32156) into a decent state, though it isn't a complete picture of the village.  There were still a lot of steps and considerations involved in getting the data into OpenStreetMap, and I thought it would be helpful to write up the workflow I followed, loosely, along with additional details that I generally look for when doing OpenStreetMap work.  

{% figure "/assets/images/openstreetmap-workflow-marmari/final_marmari_osm.png", "End result" %}


## Recording traces and noteworthy things

The first thing I find important is to record my trail.  While out and about, I'll constantly be recording my location using [GPSLogger](https://gpslogger.app).  When passing by a certain point of interest or something I noticed isn't on OpenStreetMap, I'll make an annotation.  It doesn't have to be perfect, just enough to say that there's a thing in the vicinity of this point.  That's usually enough to reference it later. GPSLogger can upload to OpenStreetMap as a trace, so I'll upload my gpx file at the end of the day.  The GPX file is recorded as a `trk` (track), and the annotations are `wpt` (waypoint). 

Sometimes I need more precise pinpointing, for that I'll use OSMAnd's bookmark feature - I'll long press at the exact point and add to an OSM category. 

{% gallery "Making annotations and upload traces to OpenStreetMap" %}
![](/assets/images/openstreetmap-workflow-marmari/Screenshot_20190924-203610_GPSLogger.png)
![](/assets/images/openstreetmap-workflow-marmari/Screenshot_20190924-211004_GPSLoggerOSM.png)
![](/assets/images/openstreetmap-workflow-marmari/Screenshot_20190924-203817_OsmAnd.png)
{% endgallery %}



### What counts as noteworthy

From my perspective, if someone were to visit Marmari, it would be useful for them to know where the basic necessities are.  This would be the ATM and grocery store.  On Marmari, the grocery store was not open all day, making timings important for visitors. It would also be important to know the location of the ferry ticket office, for their return ticket to the mainland.  

What counts as noteworthy will be different for each person.  I usually like to know whether a shop I'm going to accepted credit cards, contactless, or was cash-only.  Whether there's a post office here.  Sometimes a hiking trail may be missing a gate or has been closed off.  A rest area may no longer exist, or a bridge now has a sidewalk for pedestrians. 

It's worth understanding that OpenStreetMap isn't just a map similar to Google Maps, it is better to think of it as a data store, and other map makers derive and present _their_ maps to you from this source.  For example, there are some map applications which help users with accessibility - noteworthy info for them would be details like wheelchair access, or whether a pedestrian crossing has tactile paving.  Adding this information in can be useful to a wider scope of people. 


## Using the traces

One of the best features of OpenStreetMap is that you can make edits right in your browser.   Once I've uploaded my trace for the day, I'll go to [my traces](https://www.openstreetmap.org/traces/mine), and click edit.  

![OSM Traces](/assets/images/openstreetmap-workflow-marmari/Selection_054.png)

This opens up the edit view and overlays the trace along with annotations.  

The annotations are simply indicators as to what was in the vicinity, not the actual objects themselves. Having the Bing aerial imagery provided helps find the actual points of interest relative to the nearby buildings and streets.  In the example below I've indicated some monuments and columns, and benches, so this area would be of interest to tourists to wander about, query some details about the monuments, and rest on the benches and enjoy the sea view.  

![OSM Edit View](/assets/images/openstreetmap-workflow-marmari/Selection_055.png)


## Adding features to the map

There were many different aspects involved here so I'll go over each type of feature.  Editing this village felt overwhelming at first, as the tendency to document _everything_ kicked in, however I tried to focus on a small amount of useful information.  


### Supermarkets

Here I'm adding the building Καλλιανιωτης Supermarket.  This store would close between 2PM and 5:30PM which caught me unaware, and these timings were not written anywhere making it very much local knowledge; that made it definitely worth recording for other visitors. The telephone number as well as wheelchair accessibility were useful to know.  Additionally, this shop did not accept credit cards; like many parts of Greece, it was cash only.  With that I added as many details as I could understand including address and phone number.

![Supermarkets](/assets/images/openstreetmap-workflow-marmari/Selection_056.png)

### ATMs and shops

There was one ATM I could find near the church.  I recorded its currency as well as whether it charged any fees.  

![ATMs and shops](/assets/images/openstreetmap-workflow-marmari/Selection_057.png)

There was also a bakery shop, a general store and a [taverna](https://en.wikipedia.org/wiki/Taverna).  Despite checking I was unable to find opening times on the doors, in the shops or on the menus, and I was too shy to verbally ask, so I left it to a future mapper.

### Ticket offices and shelters/waiting areas

While in Marmari, there were very strong winds and the ferries had shut down for a few days in between. Knowing the location of the ticket office became of great importance: it was the only place where the frequently modified schedules were available at short notice.  We were also given advice regarding tickets - for an early ferry ride, it was best to get the ticket the evening before.  

![Ferry times](/assets/images/openstreetmap-workflow-marmari/ferry_times.jpg)

![Ferry tickets](/assets/images/openstreetmap-workflow-marmari/Selection_058.png)

On other days, it was also oppressively hot and staying in the sun for too long was impairing my cognitive functions.  Shelters and waiting areas suddenly became another point of interest.  I recorded whether it had benches as well as lighting with a bit of description.  

![Waiting areas](/assets/images/openstreetmap-workflow-marmari/Selection_059.png)

Together, these features should help visitors know where to buy their tickets and spend some time waiting if necessary. 


### How to 'write' in another language

The signs, names and inscriptions were of course in Greek - and this needed to be reflected in the data entered into OpenStreetMap, that is, in the `name` tag.  Where the place had an equivalent English name, that was entered as a `name:en` tag.   But then, how would I go about writing in a non-English language?  I only had a phone and a laptop with a UK layout keyboard with me. 

I tried a few ways of 'copying' the text from photos of those signs.  Using a Greek soft-keyboard was proving too difficult and error prone.  Translation via image recognition software was not helping either, it was expecting perfect lettering, and even then it would produce incorrect results. 

The best way I eventually settled on was to use Google Translate's handwriting recognition feature. While writing the letters, it offers suggestions in upper and lower case and you can pick the closest match.  The recognition is actually very good.  Here I am writing `ΟΔΟΣ` which is the Greek word for 'street' and `ΕΘΝΙΚΉ` which means 'national'. 


{% gallery "Handwriting Greek" %}
![](/assets/images/openstreetmap-workflow-marmari/handwriting.png)
![](/assets/images/openstreetmap-workflow-marmari/handwriting2.png)
{% endgallery %}

Once the correct or closest text wa/assets/images/nextdns-nordvpn/007.pngs chosen, I would copy it, send it to myself on my laptop.  

But that still wasn't enough - [street names should be entered in mixed case](https://wiki.openstreetmap.org/wiki/Naming_conventions), even though the nameplates were all uppercase Greek.  

To conform to the convention, I ran the script through a simple Python one-liner to convert it to Title Case. Thankfully Python3 is comfortable working with Unicode to help me here. 

```bash
python3 -c "print('ΑΝΘΥΠΟΛΟΧΑΓΟΣ ΣΤΑΜ. Κ. ΡΕΓΓΟVKOV'.title())"
```
Which gives the output

>Ανθυπολοχαγος Σταμ. Κ. Ρεγγοvkov

Armed with this technique, I could now tackle monuments and street names. 


### Monuments and sculptures

I like the idea of recording memorials, monuments and sculptures.  Not the large, well known ones, but the smaller ones that we often walk by without noticing. There is a certain timelessness to them in the attempt made by people from years, decades or centuries ago to preserve a certain idea or event which may not register as significantly for us as it did for them.  

For this reason it's also useful not just to record the monument's position but to take a photo of the inscription on it as well. 


{% gallery %}
![War Memorial](/assets/images/openstreetmap-workflow-marmari/monument2.jpg)
![War Memorial](/assets/images/openstreetmap-workflow-marmari/monument3.jpg)
![Sculpture](/assets/images/openstreetmap-workflow-marmari/monument4.jpg)
![Inscription](/assets/images/openstreetmap-workflow-marmari/monument5.jpg)
{% endgallery %}



I followed the handwriting-to-text technique mentioned above and added those as inscriptions against the monuments.  

The column with a flame on top was a monument dedicated to [Greek Resistance](https://en.wikipedia.org/wiki/Greek_Resistance).  

![inscription](/assets/images/openstreetmap-workflow-marmari/Selection_061.png)

The statue of the sailor near the ferry ticket office was a monument to lost sailors.  I learned that most Greek ferry ports have a monument and came across [this interesting forum thread](https://translate.google.com/translate?sl=auto&tl=auto&u=https%3A%2F%2Fforum.nautilia.gr%2Fshowthread.php%3F24788) with some enthusiasts.  

![statue](/assets/images/openstreetmap-workflow-marmari/Selection_062.png)


#### Wikidata and National Websites

Some monuments have a Wikidata ID.  If the name is known I'll search for the ID of the monument on [Wikidata](https://www.wikidata.org/).  In the editor, adding the field `Wikidata` with a value such as `Q9202` will automatically fill in some details. This is more common with buildings and monuments in the UK/US.

Some countries also have national websites which document details of statues and monuments.  In the UK, this is [Historic England](https://historicengland.org.uk) and I'll usually add the monument's URL to an `inscription:url` field in the tags.  


### Street names

I believe Marmari actually may have had no street names until just a few years ago.  This isn't uncommon in smaller villages even today - either you'll know where you need to go, or the streets are just numbered for verbal reference.  As the place grows due to population and tourism,  the necessity of street names arises.  However finding information to corroborate this has been very difficult. In some villages, street names _do_ exist but it's rare for them to put up signs.  

I walked around the streets and took photographs of the street nameplates that had been put up. 


{% gallery %}
![](/assets/images/openstreetmap-workflow-marmari/street_name_1.jpg)
![](/assets/images/openstreetmap-workflow-marmari/street_name_2.jpg)
{% endgallery %}



Same as before, I hand-converted to text and applied Python3 to help convert to title case.  It's worth noting the names shortened with `.` in the street names.  It would be good to find the full names of the streets to add.  Further, it would also be good to verify that the text was correct.  

For the street, `Ι. ΒΟΓΑΤΖΑ`, I did a Google search of `ΒΟΓΑΤΖΑ` with `ΜΑΡΜΑΡΙ`, which would lead to pages containing addresses.  These addresses would be various businesses, law firms, electricians, etc.  Having the pages listed with these addresses helped confirm that the street name is `Ιωάννου Βογατζα`.  Continuing this method of searching also worked for most of the other streets nearby.

It didn't work for _all_ the streets though.  

> ΑΝΘΥΠΟΛΟΧΑΓΟΣ ΣΤΑΜ. Κ. ΡΕΓΓΟVKOV

There's a `ΣΤΑΜ.` - which may be short for `Σταμάτη` - however I was unable to confirm this. To avoid any errors or problems, I decided to keep this street names exactly as shown on the sign.  This would make it easier for others in the future to correct it if necessary.   


### Benches 

At least benches are pretty simple.  Add a point, and make it of type bench.  I'll usually add in the type of material and how many people it can seat. 

![benches](/assets/images/openstreetmap-workflow-marmari/Selection_060.png)


## Uploading changes

I try to keep the changesets similar to git commits, as small and 'related' as possible, with a brief description.  A bunch of benches in a single changeset, a set of nearby streets, a block of adjacent buildings.  

I also add the source as 'survey' if I verified the data myself.  In the case of drawing buildings, the source is 'aerial imagery'.  

![saving changes](/assets/images/openstreetmap-workflow-marmari/Selection_064.png)


## Viewing your changes

After performing so many edits, it's rewarding to see the results appear on OpenStreetMap!

[https://www.openstreetmap.org/#map=18/38.04896/24.32156](https://www.openstreetmap.org/#map=18/38.04896/24.32156)

However note that the new edits don't appear in OpenStreetMap right away. It can take a few minutes, up to half an hour sometimes, for the new features to appear. While it's tempting to keep refreshing, it's better to just wait. 

Other applications such as OSMAnd, Maps.Me and third party applications that use OpenStreetMap tiles won't get the changes right away, even if it appears in OpenStreetMap - quite often these applications will pull in tiles from OpenStreetMap on a scheduled basis, so the wait time for these apps can be a few hours up to a month.  


## Watching for changes

Making so many feature additions in an area creates a feeling of cartographic sentimentality towards it.  I generally want to know what additional changes other OpenStreetMap contributors will make and in this case I also want to know if I made any mistakes so that I could learn from them.  

There is a tool called [WhoDidIt](https://simon04.dev.openstreetmap.org/whodidit/) which can help.  First, I zoom in to the area of interest.  Then click 'Get RSS Link', and draw a large box around the area.  An 'RSS Link' is then available. 

![RSS](/assets/images/openstreetmap-workflow-marmari/Selection_065.png)

[The RSS feed for the Marmari area is here](https://simon04.dev.openstreetmap.org/whodidit/scripts/rss.php?bbox=24.306008,38.034519,24.340341,38.060609)

Adding this RSS link to Feedly then lets me see when other users make changes or when notes are added with corrections or questions. 

