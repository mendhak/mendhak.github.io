---
title: "Use KeePassXC to sign your git commits"
description: "How to use KeePassXC to sign your git commits using the git ssh signing feature"
tags:
  - keepassxc
  - git
  - ssh
  - commits
  - ssh-agent
  - wsl2
  - ubuntu
  
opengraph:
  image: /assets/images/keepassxc-sign-git-commit-with-ssh/003.png
---

Git 2.34 introduced a new feature: the ability to sign commits [using an SSH key](https://github.blog/2021-11-15-highlights-from-git-2-34/#tidbits) instead of just a PGP key. This means you can now manage your SSH key with KeePassXC for both git operations and commit signing. 

It's a convenient option, with everything being in one place; it's certainly easier to manage than separate PGP keys. And it still offers the security benefits of a password manager — you can have a strong password on the key and won't have to type it in each time you push or sign the commit.  



{% notice "info" %}
This post assumes you're already using KeePassXC to manage your SSH keys.   
To set up KeePassXC as an SSH agent in WSL2/Ubuntu, see [this post](/wsl2-keepassxc-ssh/)
{% endnotice %}

#### Get the latest git

It's best to have the latest version installed. On Ubuntu, you can get the latest git by adding their repository. 

```bash
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update 
sudo apt install -y git
git --version
```



## Tell git to use SSH for signing

First, tell git that we want to sign every commit. 

```bash
git config --global commit.gpgsign true
```

Then tell git to use ssh for signing, instead of gpg which it would normally use.

```bash
git config --global gpg.format ssh
```

Finally tell git to grab the first key from the ssh agent. 

```bash
git config --global --unset user.signingkey
git config --global gpg.ssh.defaultKeyCommand "ssh-add -L"
```

### If you have multiple keys

The above will work well if the *first* key being served by KeePassXC is the one you want to use. 

You can see for yourself by running:

```bash
ssh-add -L
```

If the key you want to use isn't the first in that list, you'll have to copy the public key, and pass it to git as shown here:

```bash
git config --global --unset gpg.ssh.defaultKeyCommand
git config --global user.signingkey "key::ssh-ed25519 AAAAC3NzaC1xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

The format is the `key::` prefix, followed by the key format (ssh-ed25519), and then the key itself. I've noticed that it works whether or not you include the label at the end of the key. 

## Sign a commit

Now try signing a commit; since we've told git to always sign commits, just do:

```bash
git commit --allow-empty --message="Testing SSH signing"
```

If you see no errors, then it worked. 


## Tell Github about your SSH key, again

If you use SSH for your git pushes and fetches, you've already [told Github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) about your SSH key.  You'll have to do this **once more**, but this time for signing. 

Go to the [Add new SSH key page](https://github.com/settings/ssh/new), and select "Signing Key" from the "Key Type" dropdown.  Then paste in your public key. 

![SSH key specifically for signing](/assets/images/keepassxc-sign-git-commit-with-ssh/004.png)

### Push a signed commit

Push your signed commit up to Github, and it should appear with the verified badge. 

![Verified badge](/assets/images/keepassxc-sign-git-commit-with-ssh/003.png)


## How to verify a signed commit locally

This is optional, though it's nice to be able to verify your own commits locally. 

If you do a `git log --show-signature`, you should see "No signature" listed against your SSH signed commits. This is normal for now. 

Add your email address followed by the public key to an allowed_signers file. 

```bash
echo "youremail@example.com $(ssh-add -L)" >> ~/.ssh/allowed_signers
```

As before, if you have multiple keys, specify the one you want to use directly. 

Tell git where to find that allowed_signers file. 

```bash
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

And that's it. If you now view the log, you should see "Good signature" listed against your SSH signed commits. 

```bash
git log --show-signature
```

![Good signature](/assets/images/keepassxc-sign-git-commit-with-ssh/005.png)


## Notes and references

Although this post is about KeePassXC, it should also work the same with other SSH agents like [KeeAgent](https://code.mendhak.com/keepass-and-keeagent-setup/), or the built in ssh-agent by just adding the key using `ssh-add ~/.ssh/id_ed25519`. 

#### My `~/.gitconfig`

For your reference, this is what my `~/.gitconfig` looks like after setting this up. 

This is a version where the first key from KeePassXC is used, nice and simple. 

```
[user]
        name = mendhak
        email = mendhak@users.noreply.github.com
[commit]
        gpgsign = true
[gpg]
        format = ssh
[gpg "ssh"]
        allowedSignersFile = /home/mendhak/.ssh/allowed_signers
        defaultKeyCommand = ssh-add -L
```

This is a version where I've specified the key directly.

```
[user]
        name = mendhak
        email = mendhak@users.noreply.github.com
        signingkey = key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkrfhulAPWQMzPXF08BYdUgDi6NMD9FzdpiR5IhUmMr
[commit]
        gpgsign = true
[gpg]
        format = ssh
[gpg "ssh"]
        allowedSignersFile = /home/mendhak/.ssh/allowed_signers
```

