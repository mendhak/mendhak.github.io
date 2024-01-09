---
title: Automatically hyperlinking the selected text when pasting a URL
description: Implementing a quality of life feature, automatically converting some selected text into a hyperlink when pasting a URL over it.  

tags:
  - javascript
  - ux
  - user-experience
  - hyperlink

---

A really nice quality of life feature I've noticed in some applications is the ability to automatically hyperlink some selected text when pasting a URL over it. To be clear this isn't about automatically converting URLs in text into hyperlinks, rather when you have some text selected and you paste a URL over it, the text becomes a hyperlink to the URL just pasted.

Here it is in action. Try selecting some text, then copy a URL, and paste it over the selected text. (This might require desktop browsers, not sure if it works on mobile)

<p class="codepen" data-height="300" data-default-tab="result" data-slug-hash="VwRjVQd" data-user="mendhak" style="height: 300px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/mendhak/pen/VwRjVQd">
  Create hyperlink when pasted over selected text</a> by mendhak (<a href="https://codepen.io/mendhak">@mendhak</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

This is a feature that I've seen in only a few applications: Slack, Notion, Confluence, Github, and the WordPress editor. It's a small thing, it feels so natural, and it's a nice touch that saves on clicks and keystrokes. It's not present in VSCode natively, but is possible through the [Markdown All In One extension](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one).

Aside from those places, it's sadly not a common feature; I find myself trying it out in various other applications and missing it. Having to highlight text and click an additional button or press a shortcut is now a small but noticeable friction. 

The implementation is actually quite simple. In the paste event, inspect the clipboard data. Check if it's a URL, and then  surround the selected text with an anchor tag. 

```javascript
document.querySelector('div').addEventListener("paste", (event) => {
  event.preventDefault();
  
  if(window.getSelection().toString()){
    let paste = (event.clipboardData || window.clipboardData).getData("text");
    if(isValidHttpUrl(paste)){
      var a = document.createElement('a');
      a.href = paste;
      a.title = paste;
      window.getSelection().getRangeAt(0).surroundContents(a);
    }
    
  }
});
```

The [`isValidHttpUrl` function](https://stackoverflow.com/questions/5717093/check-if-a-javascript-string-is-a-url) can be as simple or as crude as you'd like. 

It would be great if this became the norm, and I hope this post helps someone implement it!
