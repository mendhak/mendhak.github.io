---
title: "Mentally calculate the day of the week, given a date in the current year"
description: "Use the Doomsday algorithm to mentally calculate the day of the week that a given date of the year falls on"
last_modified_at: 2021-02-27T09:00:00Z
categories: 
  - calendar
tags: 
  - date
  - doomsday
  - day
  
---

The Doomsday algorithm is a memory trick that lets you figure out the day of the week that a given date falls on. I'll go over the simplest variation of this which is a good starting point, and requires refreshing just once a year.  

### The last day in February

For this year of writing (2021) the last day in February is the 28<sup>th</sup> and it falls on a Sunday.  This is the *anchor* day, and is the only variation you need to memorize for a given year.  

The rest of the mnemonic stays the same every year.  There will be a day in each month which also falls on that anchor day (Sunday).  Once you know where you are in a month, you can work forwards or backwards to figure out the day.

### The Even Months

For the remaining even months in the year, just match the month number with itself.  

* The 4<sup>th</sup> of the 4<sup>th</sup> month (April 4)
* The 6<sup>th</sup> of the 6<sup>th</sup> month (June 6)
* The 8<sup>th</sup> of the 8<sup>th</sup> month (August 8)
* The 10<sup>th</sup> of the 10<sup>th</sup> month (October 10)
* The 12<sup>th</sup> of the 12<sup>th</sup> month (December 12)

All fall on the anchor day (Sunday).  


### The Odd Months

For the odd months, remember this:  "9 to 5 at 7-11". 

* The 9<sup>th</sup> of the 5<sup>th</sup> month (May 9)
* The 5<sup>th</sup> of the 9<sup>th</sup> month (September 5)
* The 7<sup>th</sup> of the 11<sup>th</sup> month (November 7)
* The 11<sup>th</sup> of the 7<sup>th</sup> month (July 11)

All fall on the anchor day (Sunday). 


### January

For January, remember this: "3 out of 4".  

The anchor day is on the 3<sup>rd</sup> every 3 out of 4 years.  It's on the 4<sup>th</sup> on leap years.  

That means for 2021, January 3<sup>rd</sup> falls on the anchor day (Sunday).


### March

If you look at a calendar, you'll notice that all the dates in February and March fall on the same day.

That means just like February, March 28<sup>th</sup> falls on the anchor day (Sunday).  Even easier, any multiple of 7 in March will also match the anchor day.


## Practice

You can now practice - pick a random date in the year.  Figure out that month's anchor day, then work towards the date.  

Example: December 25<sup>th</sup> 2021.  

1. The 12<sup>th</sup> of the 12<sup>th</sup> month.  
1. December 12<sup>th<sup> is a Sunday.  
1. 12 + 14 days = 26<sup>th</sup> is a Sunday
1. 25<sup>th</sup> is a Saturday

Example: September 15<sup>th</sup> 2021. 

1.  5<sup>th</sup> of the 9<sup>th</sup> month
1.  September 5<sup>th</sup> is a Sunday
1.  5 + 7 = 12<sup>th</sup> is a Sunday. 
1.  Plus a few more days, September 15<sup>th</sup> is a Wednesday



## Advanced Doomsday - figure out the anchor day for a given year

It's actually possible to figure out which day will be the anchor day, just by looking at the year itself.   This is because the calendars repeat themselves every 400 years, and roughly you need to figure out the anchor day for the century, then the anchor day for the year, and then the anchor day for each month.   

The algorithm for that is [described here](https://www.timeanddate.com/date/doomsday-weekday.html) and is also on [Wikipedia](https://en.wikipedia.org/wiki/Doomsday_rule).

It's too much effort for me so I just memorize the anchor day for the year at the beginning of each year.  