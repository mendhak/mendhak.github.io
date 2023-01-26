---
title: "A simple and effective Bash prompt for developers"
description: "Simple Bash prompt (PS1) that shows the current git branch and current time"


tags: 
  - git
  - bash
  - developers

---

In Bash I use a very basic prompt which is simple and effective.  
It consists only of the time, path, and git branch.  

It appears like this for normal directories:

<div class="language-bash highlighter-rouge">
<div class="highlight">
<pre class="highlight">
<code><span style="color:#d3d7cf;">19:04:17</span> <span style="color:#4e9a06;">~</span> $
</code></pre></div></div>

And like this for git repos: 

<div class="language-bash highlighter-rouge">
<div class="highlight">
<pre class="highlight">
<code><span style="color:#d3d7cf;">19:04:17</span> <span style="color:#4e9a06;">~/projects/myrepo</span> <span style="color:#c4a000">(master*)</span> <span style="color:#d3d7cf;">$</span>
</code></pre></div></div>

**To use it**, add this to your `~/.bashrc` and reload:  

```bash
function parse_git_dirty {
  [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}

export PS1="\n\t \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
```


## Why it's effective

A Bash prompt, like any tool, should be useful, and importantly, stay out of your way.  

The **time** (`\t`) tells you when the last command stopped running, and also serves as a clock that's right there.  

The current **directory** (`\w`) of course tells you where you are.  

The **branch** (`parse_git_branch`) name tells you which branch you're working in. It also indicates the dirty status, and can work with detached HEADs. 

These three pieces of information are usually sufficient data points in the context of working.

The above PS1 is also self contained, and should work with IDEs that embed terminals.  

## Alternative: Using git's built-in helper

Git itself provides a built-in command (`__git_ps1`) that can provide the same branch information, which results in an easy one-liner to add to `~/.bashrc`. 

```bash
export PS1="\n\t \[\033[32m\]\w\[\033[33m\]\$(GIT_PS1_SHOWUNTRACKEDFILES=1 GIT_PS1_SHOWDIRTYSTATE=1 __git_ps1)\[\033[00m\] $ "
```

But note that by default this doesn't work with some IDEs that embed terminals.  


## The problem with other prompts

I have spent a long time trying out many other prompts before arriving at the one above.  Here are my observations.  

### Defaults

The default Bash prompt usually shows a username and hostname along with the directory. 

    myuser@mymachine:~/projects $

This is not useful information, it is purely clutter, and is not something that needs to be seen on a regular basis.  

A developer will already know their username, and they are already at their machine.  
If through some strange happenstance they have forgotten, the commands `whoami` and `hostname` are available. 

### Oh My

The popular oh-my-bash/oh-my-zsh projects offer several 'themes' for the Bash/Zsh prompts, varying from basic to gaudy. 

Offerings like these suffer from the problem of overhead in terms of bloat of installation. 

Some themes come with additional bells and whistles, such as ASCII-ish graphics, arrows, lines, emojis, and colorful text backgrounds. While visually noticeable (perhaps meant for screenshots), they forego efficient information presentation in favor of 'aesthetics', often taking up additional space to present an artistic vision.  These properties go against what a good tool should be.  

I have also observed some themes that try to fetch and parse additional information in the prompt.  These are often poorly scripted, which serves to slow down Bash usage in general due to the excessive commands running to present a few bits of infrequently useful information. 






