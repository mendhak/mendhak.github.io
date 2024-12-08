---
title: Compose keys are the nicest way of typing special characters
description: Compose keys in Linux are the nicest way of entering 
tags:
  - linux
  - compose
  - ubuntu

---

Compose keys are a Linux feature that allows you to type special characters. They're very useful for typing accents, umlauts, diacritics, and other special characters. All operating systems have a way of typing such characters, but they are, to put it mildly, a convoluted mess.

Compose keys work in a very intuitive way, as the name implies, by composing two or more keys together. As an example, to type the copyright symbol, I would type:

<kbd>Compose</kbd><kbd>(</kbd><kbd>c</kbd><kbd>)</kbd> which gives `ⓒ`

The (, c, ) sequence is a very natural combination for the copyright symbol.  

Umlauts and diacritics are similarly very simple. 

<kbd>Compose</kbd><kbd>u</kbd><kbd>"</kbd> gives **ü**

<kbd>Compose</kbd><kbd>O</kbd><kbd>/</kbd> gives **Ø**

<kbd>Compose</kbd><kbd>T</kbd><kbd>M</kbd> gives **™**

<kbd>Compose</kbd><kbd>5</kbd><kbd>6</kbd> gives **⅚**

The all important em dash: 

<kbd>Compose</kbd><kbd>-</kbd><kbd>-</kbd><kbd>-</kbd> gives **—**

Building target characters starts to become very discoverable. There's no need to remember specific numeric codes, or to have a numpad on a keyboard which Windows/Macos require. In fairness to Windows 11 though, the `Win+.` shortcut is quite useful, though it could do with a search across all character types. 

## But where is the <kbd>Compose</kbd> key>?

There isn't a dedicated key on a physical keyboard, instead you have to assign a key as the compose key. Often the default is the `Right Alt `or `Shift + Alt Gr`. 

You would normally [assign this through settings](https://help.ubuntu.com/community/ComposeKey), to a key that you don't usually use, or something out of the way. I strongly recommend the Caps Lock key, the [most useless key on the keyboard](/posts/2022-03-24-make-caps-lock-useful.md) as shown here. 

![Use caps lock as the compose key](/assets/images/compose-keys-user-friendly/001.png)

So in the examples above, I normally press Caps Lock, followed by the sequence. 

### List of Compose sequences

There are a few places I've been able to find a list of sequences, the [Ubuntu documentation](https://help.ubuntu.com/community/GtkComposeTable) and the [Dartmouth University site](https://math.dartmouth.edu/~sarunas/Linux_Compose_Key_Sequences.html).

## Unicode code points

_Somewhat_ related to Compose keys,  another user friendly shortcut is <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>U</kbd> - a way of typing out Unicode characters from their numeric code points. The code point for [sparkles is U+2728](https://www.compart.com/en/unicode/U+2728). Type it out using <kbd>Ctrl</kbd><kbd>Shift</kbd><kbd>U</kbd>, then 2728 ✨. 
