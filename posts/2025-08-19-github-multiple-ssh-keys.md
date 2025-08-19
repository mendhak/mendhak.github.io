---
title: Managing multiple SSH keys for multiple GitHub organisations in a simple way
description: A guide on how to manage multiple SSH keys for different GitHub organisations using hasconfig remote and includeif in .gitconfig, all native and no custom scripts.
tags:
  - github
  - ssh
  - keys
  - git

---

When working with multiple GitHub organisations, it is common to have to manage multiple SSH keys for git operations. 

The following solution is the one I have found to be the most convenient, with the least amount of overhead or behavioral changes, and as close to seamless as possible. 

Suppose you are in two orgs, `org_1` and `org_2`, and you have registered two SSH keys `id_ed25519_org_1` and `id_ed25519_org_2` for those orgs.

First, create a configuration file for each org. 

For `org_1`, create `~/.gitconfig_org_1` with an SSH command that uses the key for that org. Replace the path to the SSH key with yours.

```ini
[core]
    sshCommand = "ssh -i /home/ubuntu/.ssh/id_ed25519_org_1 -F /dev/null"
```

Similarly, for `org_2`, create `~/.gitconfig_org_2` with the key path for that org. 

```ini
[core]
    sshCommand = "ssh -i /home/ubuntu/.ssh/id_ed25519_org_2 -F /dev/null"
```

Now, edit your main `~/.gitconfig` file to include those org-specific files by adding the following lines. Replace `org_1` and `org_2` with the names of your Github organisations. 

```ini
[includeIf "hasconfig:remote.*.url:git@github.com:org_1/**"]
        path = ~/.gitconfig_org_1
[includeIf "hasconfig:remote.*.url:git@github.com:org_2/**"]
        path = ~/.gitconfig_org_2
```


That's it. You can now do a git clone against a repo, and the correct SSH key will be used. The output should look something like this:

```
$ git clone git@github.com:org_1/my_repo.git
Cloning into 'my_repo'...
Enter passphrase for key '/home/mendhak/.ssh/id_ed25519_org_1':
remote: Enumerating objects...
...
```

Similarly when cloning a repo in org_2, git will use the correct key.

### How it works

The [`includeIf` section](https://git-scm.com/docs/git-config#_includes) in .gitconfig allows conditionally including configuration from another file. There are different kinds of conditions, and the `hasconfig:remote` is what's being used here. The fragment will match on the remote URL of the repository. 

The reason it works is because for repos in org_1, the git clone URL will include the name of the org, org_1: `git@github.com:org_1/my_repo.git`. An org_2 repo will have a URL like `git@github.com:org_2/my_repo.git`.

By matching on these fragments, we include different configuration files. Those configuration files in turn set the `sshCommand` to make use of the correct SSH keys. 

## Solutions I don't like

In my research, these were the most common solutions as suggested on the internet and various mediocre LLM responses.

### Modifying the SSH config

This is the most common solution I see, which is to use multiple Host entries that all point at github.com, but with different keys. 

```
Host github_org1
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_org_1
    IdentitiesOnly yes
Host github_org2
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_org_2
    IdentitiesOnly yes
```

This isn't great, because you have to change the git clone URL whenever you're cloning: `git clone git@github_org1:my_repo.git`, where the `github.com` has been replaced with `github_org1`.

### Matching on directories

Another common solution is to match on the directory name. Here you clone repos into different directories for each org. It's somewhat similar to the main one above. 


```
[includeIf "gitdir:~/org_1/**"]
        path = ~/.gitconfig_org_1
[includeIf "gitdir:~/org_2/**"]
        path = ~/.gitconfig_org_2
```

Not terrible, but the downside is that you have to clone into a specific destination, and that isn't very intuitive or flexible. 


### Helper scripts to switch keys

No.




