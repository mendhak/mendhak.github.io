---
title: The unpleasant hackiness of CSS dark mode toggles
description: The browser native mechanism to set user color scheme preference is at odds with user preference toggles.
tags:
  - css
  - dark-mode
  - toggle
  - prefers-color-scheme

opengraph:
  image: /assets/images/css-dark-mode-toggle-sucks/000.png

---

There are two ways that websites can offer users a choice between light and dark mode. The first makes use of pure CSS and is managed natively by the browser. The other involves a combination of CSS and Javascript and is usually accompanied by a sun/moon toggle that the user can click on. 

## The pure CSS way

The native way is actually quite simple. Design CSS for one color scheme, then override values for the other using the [`prefers-color-scheme`](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme) media feature. 



<iframe width="100%" height="300" src="//jsfiddle.net/35e0a97a/9rmvu68e/2/embedded/result,css,html/dark/" allowfullscreen="allowfullscreen" allowpaymentrequest frameborder="0"></iframe>


The user's preference value is read from the operating system or the browser's own setting. Life is simple, but there's one glaring omission — letting the user set this preference at a more granular website or page level. For instance, a user might set a preference for dark mode in their browser, but would want to switch to light mode [for a text-heavy page](https://graphicdesign.stackexchange.com/questions/15142/which-is-easier-on-the-eyes-dark-on-light-or-light-on-dark).  


## The hacky Javascript way, using custom classes

The most common technique for offering a toggle is to use Javascript to apply a custom class at the body level. The `prefers-color-scheme` feature is still used to start with, and clicking the button then applies the alternate class based on the current detected theme. 

<iframe width="100%" height="300" src="//jsfiddle.net/35e0a97a/6g5dreyj/26/embedded/result,css,js,html/dark/" allowfullscreen="allowfullscreen" allowpaymentrequest frameborder="0"></iframe>

The CSS is messier, and grows unwieldy as the site's style expands. As a convenience, it's also common to save the user's toggled theme to local storage so that it is automatically loaded on their next visit. 

## Still hacky Javascript, using CSS media features

I've [managed](https://stackoverflow.com/a/75124760/974369) to work out a way of using Javascript to toggle the light and dark themes, while still making use of the `prefers-color-scheme` feature, and without any custom classes. It requires looping through every stylesheet's [rules](https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet/cssRules), inspecting the media of each one, and swapping the light and dark color themes out. The code also includes storing the user's preference in localStorage, so it remembers on page refresh. 

<iframe width="100%" height="300" src="//jsfiddle.net/35e0a97a/xmt1k659/61/embedded/result,js,html,css/dark/" allowfullscreen="allowfullscreen" allowpaymentrequest frameborder="0"></iframe>

The code involved is somewhat complicated and unoptimized and will probably be slow for heavy stylesheets. The CSSStyleSheet and CSSRule APIs aren't widely used nor are they well documented. However, it works, so it could be considered the best of both worlds: it respects the user's choice at a granular site level, while still allowing the use of native CSS features. 

A further enhancement is to listen to any operating system or browser level preference changes and adjust the applied theme accordingly. This can be done by adding a listener, `window.matchMedia('(prefers-color-scheme: dark)').addListener(...)` and reapplying the themes. 

## Fixing the white flash

Sadly, the hackiness (or its lesser alternative) still isn't enough. In certain scenarios, when there is a lot of content on the page and the user has saved a dark theme preference for the site, there will briefly appear a blinding white flash before the dark theme activates. 

What's happening is that the browser is painting the page for a few cycles before the Javascript runs, the local storage is checked, and then the theme gets applied. This is especially common on content heavy pages where certain elements are blocking but take a while to load (embedded YouTube videos). 

A [workaround](https://zwbetz.com/fix-the-white-flash-on-page-load-when-using-a-dark-theme-on-a-static-site/) is to hide the body, use Javascript to apply the theme, and then make the body visible. Another is to [block and assign](https://stackoverflow.com/questions/63033412/dark-mode-flickers-a-white-background-for-a-millisecond-on-reload) the dark mode as early as possible during page load. 

## On the fence

I am still not convinced that offering an option to toggle dark mode is worth the complexity that it entails: possibly some custom CSS, a JavaScript kludge either way, and some additional CSS and further JavaScript band-aid patches to deal with edge cases. 

Looking at this from a high level, I feel that the work and modifications involved in providing a user toggle takes me a step too far from focusing on the content-first nature of a web page. I'd prefer a more 'native' way of achieving the same thing; I did try searching for whether there were any standards, discussions or proposals in place, but couldn't find any. 

For my own purposes I am using [this extension](https://addons.mozilla.org/en-US/firefox/addon/toggle-dark-mode/), it toggles the browser's own light and dark mode preference. 
