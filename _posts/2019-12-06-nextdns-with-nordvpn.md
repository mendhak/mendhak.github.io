---
title: "Getting NextDNS and NordVPN to work together on Android"
description: "Using NextDNS with NordVPN, including on Wifi networks with captive portals"
categories: 
  - android
  - nextdns
  - vpn
gallery1:
  - url: /assets/images/nextdns-nordvpn/002.png
    image_path: /assets/images/nextdns-nordvpn/002t.png
  - url: /assets/images/nextdns-nordvpn/003.png
    image_path: /assets/images/nextdns-nordvpn/003t.png
  - url: /assets/images/nextdns-nordvpn/004.png
    image_path: /assets/images/nextdns-nordvpn/004t.png

gallery2:
  - url: /assets/images/nextdns-nordvpn/001_dnstls.png
    image_path: /assets/images/nextdns-nordvpn/001_dnstls.png
  - url: /assets/images/nextdns-nordvpn/005.png
    image_path: /assets/images/nextdns-nordvpn/005t.png

gallery4:
  - url: /assets/images/nextdns-nordvpn/001_dns.png
    image_path: /assets/images/nextdns-nordvpn/001_dns.png
  - url: /assets/images/nextdns-nordvpn/006.png
    image_path: /assets/images/nextdns-nordvpn/006.png

gallery5:
  - url: /assets/images/nextdns-nordvpn/007.png
    image_path: /assets/images/nextdns-nordvpn/007.png

---

Documenting the steps I took to get NextDNS, NordVPN and restricted WiFi networks to work together.

I have been experimenting with [NextDNS](https://nextdns.io) recently, a cloud based private DNS with privacy controls.  Feature-wise, it's pretty similar to [Pi-hole](https://pi-hole.net/).  The main difference is that the Pi-hole runs at home, while NextDNS is available everywhere.  This makes it pretty appealing as it allows me to carry my site blocking configuration everywhere. 

It comes with preset lists, blacklists, whitelists, analytics (graphs) and logs.  The [Linux client is open source](https://github.com/nextdns/nextdns), and the [privacy policy](https://nextdns.io/privacy) looks pretty good. Where it shines is its connectivity options.  You can use DNS over TLS, DNS over HTTPS, and regular DNS.  They give clear instructions, and there are many options across OSes and browsers.

The sign-up process is fast and you are given a unique configuration ID immediately, and you can start playing with the settings right away.

{% include gallery id="gallery1"  caption="NextDNS screens" %}

The configuration ID is unique to your account, only share it with people you trust.  The examples shown on this page are purely for demonstration purposes.
{: .notice--warning}

## NordVPN and NextDNS together

Although NordVPN comes with its own [CyberSec](https://nordvpn.com/features/cybersec/) feature, there is very little in the way of explanation or control regarding how it works.  I wanted to make use of NordVPN for the actual traffic, but still use NextDNS to retain control over what's being blocked and keep an eye on requests being made.  



## Private DNS in Android 9+

The [Private DNS](https://android-developers.googleblog.com/2018/04/dns-over-tls-support-in-android-p.html) feature introduced in Android 9 allows you to set a system wide DNS, not just specific to a WiFi.  Android will perform DNS over TLS requests against this address, and in most cases this DNS setting is applied whether you're connected to WiFi, mobile data, or VPN.  Where available, this is the most convenient way to set yourself up with NextDNS, and should play nicely with NordVPN and other VPNs too.

From the main settings page on your NextDNS configuration, find the DNS-over-TLS address.  

{% include gallery id="gallery2"  caption="DNS over TLS on Android" %}

For most scenarios and use cases, this works well enough and is a good enough default setting to stick with.

### There's a catch - captive portals and corporate WiFi

Many workplaces, hotels and airports offer a guest WiFi network to connect personal devices to, and often these come with captive portals.  The trouble here is that such 'corporate' networks often block most outgoing ports, 853 included, which is what DNS-over-TLS makes use of.  When using the Private DNS feature in such a network, Android will mark the corporate WiFi with 'no internet connection'; your web browsing will fail, and you will be unable to connect to VPN.  

<i class="fas fa-check-circle"></i> Works with WiFi  
<i class="fas fa-check-circle"></i> Works with mobile networks  
<i class="fas fa-check-circle"></i> Works with NordVPN  
<i class="fas fa-times-circle"></i> Doesn't work with corporate WiFi/captive portals    
<i class="fas fa-times-circle"></i> Not an option on older Android devices    


If connecting to a restricted WiFi isn't necessary for you, this is the best place to stop.  You're in a good position, and you can enjoy both NextDNS and NordVPN.

If however, you _do_ need to work with a restricted WiFi, there are a few options to get these working together. 


## The NextDNS app

The [NextDNS app](https://play.google.com/store/apps/details?id=io.nextdns.NextDNS&hl=en_GB) on the Play Store makes DNS requests using DNS-over-HTTPS.  The advantage of DNS-over-HTTPS is that the DNS requests themselves are made over the 'common' port 443, with TLS certificates encrypting your traffic; to a network this just appears as normal traffic and will not often be blocked.  

Using their app will allow you to use NextDNS while on WiFi or mobile network, but won't allow you to use an actual VPN - this is because the app itself sets up a local device VPN for all traffic, and it then makes requests using DNS-over-HTTPS.  Since it's a local device VPN, the battery consumption is very low.  The main setting in the app is the configuration ID of your NextDNS settings.   You can also get it to send your device model so that you can easily identify it in the logs.  


<i class="fas fa-check-circle"></i> Works with WiFi  
<i class="fas fa-check-circle"></i> Works on mobile networks  
<i class="fas fa-check-circle"></i> Works with corporate WiFi/captive portals  
<i class="fas fa-check-circle"></i> Works on Android 4+  
<i class="fas fa-times-circle"></i> Cannot use with actual VPNs

If using an actual VPN isn't necessary for you, this is the best place to stop.  It only gets more complicated from here.

If however, you do need an actual VPN as well as DNS, then read on.


## NordVPN's custom DNS

Now we're complicated. The NordVPN app allows setting an IP address for a DNS server that it will use when making requests.  Get this from the settings screen on NextDNS, and add it to the NordVPN setting, `Custom DNS`.  Since you're connecting to a restricted WiFi, be sure to also select `Use TCP` - this makes NordVPN connect over port 443 to its servers.   

{% include gallery id="gallery4"  caption="DNS in the NordVPN app" %}

 However, observe that the NextDNS IP address is actually common to many of its users.  NextDNS needs some way of identifying your requests to that IP, among the thousands of other people using the same IP.  Connect to the VPN, then browse to the NextDNS configuratino page and press the `Link IP` button.  It will then detect the IP you're connecting from (the NordVPN server)  and from then on any requests from your device will make use of your NextDNS configurations.

 But pressing the "Link IP" button is not a maintainable solution and is easy to forget; in the screenshot above, NextDNS provides a convenience URL that you can call - it will detect the IP you called from, and set the linked IP address on your behalf. In the example above, this is `https://link-ip.nextdns.io/924d45/0d927fe242bee36c`

 We need a way of invoking that URL on a regular basis.  Specifically, we need a way of invoking that URL whenever we connect to a VPN.  

### Use Tasker to update the Linked IP on NextDNS

[Tasker](https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm&hl=en_GB) is an automation app for Android which lets you perform actions based on various conditions, events, variables.  You can create a profile that invokes an HTTP request when connecting to a VPN. 

In Tasker, create a new profile, "VPN On".    
Pick `State`, and in the dialog, search for `VPN Connected`  
Leave the State as is, and press the back arrow <i class="fas fa-arrow-left"></i>  
When prompted, create a new Task, "Update NextDNS Linked IP"  
Press <i class="fas fa-plus"></i> to add an Action, and search for `HTTP Request`   
Paste the URL from the NextDNS setting screen in the URL field    



```
Profile: Vpn On (2)
    	State: VPN Connected [ Active:Any ]
    Enter: Update dynamic ip (3)
    	A1: HTTP Request [  Method:GET URL:https://link-ip.nextdns.io/924d45/0d927fe242bee36c Headers: Query Parameters: Body: File To Send: File To Save With Output: Timeout (Seconds):30 Trust Any Certificate:Off ]

```

This setup works reliably, but is only applicable to the NordVPN connection.  When you disconnect from the VPN, you are no longer using NextDNS, and you'll need to launch the NextDNS app and connect there.  

<i class="fas fa-check-circle"></i> Works with NordVPN  
<i class="fas fa-check-circle"></i> Works with corporate WiFi/captive portals  
<i class="fas fa-check-circle"></i> Use the NextDNS app when not on VPN - covers wifi and mobile networks  
<i class="fas fa-times-circle"></i> Complicated setup  


If you can stick to using NordVPN across all your wifi and mobile connections, then this is a good place to stop.  It's going to get _even more complicated_ after this.  Just stop. 

If however, you are looking to automate the switch to NextDNS when NordVPN disconnects, then read on.  


### Launch NextDNS when VPN disconnects

Tasker profiles have the concept of Exit Tasks; we can get Tasker to launch NextDNS when disconnecting from NordVPN.  

In Tasker, long press the right side of the "NextDNS VPN On" profile. 
Press `Add Exit Task` and Create a New Task <i class="fas fa-plus"></i>, "Launch NextDNS"  
Press <i class="fas fa-plus"></i> to add an Action, and search for `Launch App`   
Find NextDNS in the list and select it, then press the back arrow <i class="fas fa-arrow-left"></i>  


{% include gallery id="gallery5" layout="half" caption="Tasker Exit Task" %}

When disconnecting from NordVPN, the NextDNS app should launch and serve as a gentle reminder to connect to it.  

This Tasker profile will only work on Android 9 and below.  From Android 10+, Tasker can no longer [launch activities from the background](https://developer.android.com/guide/components/activities/background-starts). 
{: .notice--warning}



