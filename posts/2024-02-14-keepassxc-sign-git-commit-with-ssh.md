---
title: "Use KeePassXC to sign your git commits"
description: "How to use KeePassXC to sign your git commits using the git ssh feature"
tags:
  - keepassxc
  - git
  - ssh
  - commits
  
---

In Git 2.34, a [new feature](https://github.com/git/git/blob/master/Documentation/RelNotes/2.34.0.txt#L81-L84) was added that allows you to use an SSH key to sign your commits instead of just your PGP key. This in turn means that you can use KeePassXC to manage your SSH key not just for git pushes and fetches, but to sign commits as well. This is very convenient as it's all in one place, and easier to manage than a separate PGP key.

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

Then tell git to get the default key to use from the SSH agent, which for us is KeePassXC.

```bash
git config --global --unset user.signingkey
git config --global gpg.ssh.defaultKeyCommand "ssh-add -L"
```
