---
title: "Updating another user's pull request to your Github repository"
tags:
  - git
  - pull request
  - update
---

When someone submits a pull request to your repository, it is actually possible to update their pull request by pushing commits to _their_ fork.  

{% button "View Gist", "https://gist.github.com/mendhak/d3cafcf2d1a6764f7c2395e37bc05a81" %}

In other words, you can push to a pull request branch, as long as the fork  owner has [allowed it](https://help.github.com/en/articles/allowing-changes-to-a-pull-request-branch-created-from-a-fork) while creating the pull request. 

![pull request](/assets/images/allow-maintainers-to-make-edits-sidebar-checkbox.png)


Suppose you receive a pull request against your repo, `yourname/yourrepo.git` and it is created by `otheruser`'s fork of `yourrepo.git`.  


Start by adding the other user's repo as a remote.


    git remote add otheruser git@github.com:otheruser/yourrepo.git


Fetch the commits from their repo to your local repo. 

    git fetch otheruser

Now create a local branch from their repository.  It's a good idea to name the branch after their repo name and branch name, as it helps identify the 'who' and 'what' later. In this example the `otheruser` simply worked on the `master` branch.


    git checkout -b otheruser-master otheruser/master 
    

At this point you should make the changes that you want.  Once you're done, you can push to their repo. Here you have to use the remote name `otheruser`, and prefix the branch name with `HEAD:`


    git push otheruser HEAD:master








