---
title: "Automatically turn XBox controller off with PC"
description: "Automatically turning off the XBox 360 controller off when the PC is shut down"
categories:
  - xbox
tags:
  - xbox
  - windows 10

extraWideMedia: false  
---

If you have a wireless XBox controller for PC, then you cannot turn the controller off without removing-and-reattaching the battery pack. Further, if you shut your computer off, the XBox controller will keep trying to find the wireless receiver until it drains the battery.

{% githubrepocard "mendhak/xbox-controller-off" %}



This project is a 'shutdown' script which you can use;

*  Set it as a shutdown script so that it always turns the XBox controller off when turning your PC off
*  Call it directly to turn the XBox controller off


 
{% button "Get Powershell script", "https://github.com/mendhak/xbox-controller-off/blob/master/TurnControllerOff.ps1" %} _or_ {% button "Get Executable", "https://github.com/mendhak/xbox-controller-off/releases" %}

## Setup

To set it in your shutdown, 

Click Start > Run...

```bash
gpedit.msc
```    

Go to startup/shutdown scripts:

![GPEdit settings]({{ site.baseurl }}/assets/images/xbox-controller-off/001.png)


Under the scripts tab, add the powershell script (adding to the PowerShell tab didn't work for me, I used this tab instead):

![Powershell]({{ site.baseurl }}/assets/images/xbox-controller-off/002.png)

Or add the EXE directly:

![Exe]({{ site.baseurl }}/assets/images/xbox-controller-off/003.png)

Apply and close.

Finally, Start > Run...

```bash
gpupdate /force
```


## How it works

This script makes use of an undocumented feature of `xinput1_3.dll`.  

These methods, along with their ordinals are:

```csharp
    # 100:
    DWORD XInputGetStateEx(DWORD dwUserIndex, XINPUT_STATE *pState);

    # 101:
    DWORD XInputWaitForGuideButton(DWORD dwUserIndex, DWORD dwFlag, unKnown *pUnKnown);

    # 102:
    DWORD XInputCancelGuideButtonWait(DWORD dwUserIndex);

    # 103:
    DWORD XInputPowerOffController(DWORD dwUserIndex);
```    

The script or executable simply invoke ordinal 103 with the index of the XBox controller. 

```csharp
    [DllImport("XInput1_3.dll", CharSet = CharSet.Auto, EntryPoint = "#103")]
    internal static extern int FnOff(int i);
```    

And then invoking `FnOff(0)`

To turn off multiple controllers you would simply invoke `FnOff(1)` and 2 and so on. 
