---
title: "Use KeePassXC to sign your git commits"
description: "How to use KeePassXC to sign your git commits using the git ssh feature"
tags:
  - keepassxc
  - git
  - ssh
  - commits
  
---

In Git 2.34, a [new feature](https://github.com/git/git/blob/master/Documentation/RelNotes/2.34.0.txt#L81-L84) was added that allows you to use an SSH key to sign your commits instead of just your PGP key. This in turn means that you can use KeePassXC to manage your SSH key not just for git pushes and fetches, but to sign commits as well. This is very convenient as it's all in one place, and easier to manage than a separate PGP key. You can also have a strong password on the key and won't have to type it in each time you push or sign the commit.  

This post assumes you're already using KeePassXC to manage your SSH keys. You can verify it's working by running `ssh-add -L` and seeing your key listed.

{% notice "info" %}
To set up KeePassXC as an SSH agent in WSL2, see [this post](/wsl2-keepassxc-ssh/)
{% endnotice %}

## Tell git to use SSH for signing

We'll first tell git that we want to sign every commit. 

```bash
git config --global commit.gpgsign true
```

Then we'll tell git to use ssh for signing, instead of gpg which it would normally use.

```bash
git config --global gpg.format ssh
```

Now have a look at the keys being served by KeePassXC using

```bash
ssh-add -L
```

If the first key being listed is the one you want to use, then:

```bash
git config --global --unset user.signingkey
git config --global gpg.ssh.defaultKeyCommand "ssh-add -L"
```

If however the key you want to use isn't the first, you have to copy the key as shown in your `ssh-add -L` output, and pass it to git as shown here:

```bash
git config --global --unset gpg.ssh.defaultKeyCommand
git config --global user.signingkey "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkrfhulAPWQMzPXF08BYdUgDi6NMD9FzdpiR5IhUmMr"
```
