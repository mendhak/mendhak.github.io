---
title: edit is a terminal text editor that doesn't make me think
description: The best parts about the new Microsoft edit tool is its sane shortcuts and mouse friendliness, it's like having gedit or notepad right in the terminal.
tags:
  - edit
  - cli
  - vim
  - nano
  - linux
  
opengraph:
  image: /assets/images/microsoft-edit-cli-text-editor/001.png
---

My terminal-based text editing almost always occurs in short sessions. I'll usually want to modify something and get out. To me, it makes no sense to have to step on a learning curve for a text editor. A good tool gets out of your way, which is why I don't tend to favour `vim`, and only tolerate `nano`. 

Recently, [edit](https://devblogs.microsoft.com/commandline/edit-is-now-open-source/) was open-sourced, and by chance I spotted that it had a [Linux build](https://github.com/microsoft/edit/releases), so I decided to try it out. 
 
It comes in a zstd file, which was new to me, but installing it wasn't too difficult: 

```bash
wget https://github.com/microsoft/edit/releases/download/v1.1.0/edit-1.1.0-x86_64-linux-gnu.tar.zst
tar --zstd -xvf edit-1.1.0-x86_64-linux-gnu.tar.zst
cp edit ~/.local/bin/
exec bash
```

After that, just `edit` a file:  

```bash
edit myfile.txt
```

![Writing this blog post](/assets/images/microsoft-edit-cli-text-editor/001.png)

Within just a few minutes, I had a pretty good grasp of it, mostly because there wasn't anything to 'learn'. It's like the original gedit or notepad right in the terminal, out of the box. 

Another thought that occurred: it's like someone reimplemented a terminal text editor, while cognizant of the slew of modern rich TUI tools that have emerged such as [rich](https://github.com/Textualize/rich), [click](https://github.com/pallets/click/), and [textual](https://github.com/Textualize/textual). 

Using `edit` immediately felt intuitive and natural (minus some `vim`/`nano` shortcuts I had to Ctrl+Z from muscle memory).

The shortcuts are intuitive, because they're what most GUI text editors and IDEs use. `Ctrl+S` to save (how did it take this long?), and `Ctrl+Q` to quit, and `Alt+Z` to word wrap. I can even `Ctrl+Z` to undo. 

![The `edit` edit menu](/assets/images/microsoft-edit-cli-text-editor/002.png)

The find supports regex! 

![Regex](/assets/images/microsoft-edit-cli-text-editor/003.png)

Clicking somewhere in a document moves the mouse cursor to that position — again, it's that natural visual way of editing. I _believe_ `nano` and `vim` can do this with some configuration settings, but it isn't a default.  

It's possible to use the mouse as well as usual keyboard shortcuts to highlight text, and copy, paste, cut, delete just as I would elsewhere. Sure, it's simple, but it's the simple things. 

Overall, they've done a pretty decent job of porting the fast click-and-shortcut experience over from UI land. 

![There's even column select](/assets/images/microsoft-edit-cli-text-editor/004.png)

The menus at the top are clickable, and there's a file picker too. 

![File picker](/assets/images/microsoft-edit-cli-text-editor/005.png)

Opening multiple files is possible, and I just use the bottom right menu to switch between them. 

![Switching between files](/assets/images/microsoft-edit-cli-text-editor/006.png)

While writing this post using `edit`, it did exactly what I wanted: it got out of my way. I'm now convinced enough to add it to my `$PATH` and give it a proper shot. 