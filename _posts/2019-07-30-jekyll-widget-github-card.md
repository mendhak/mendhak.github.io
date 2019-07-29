---
title: "A Jekyll widget for Github Repo Cards"
description: "Using Jekyll includes with a parameter to render a Github repository card "
categories:
  - jekyll
tags:
  - jekyll
  - widget
---

This Jekyll widget can render a Github repo card on a Jekyll page.

## Usage

Place this `include` on a post or page, passing in the name of a public repo you own in the `reponame` parameter. 


```liquid
{% raw %}{% include repo_card.html reponame="gpslogger" %}{% endraw %}
```

The above will render this:

{% include repo_card.html reponame="gpslogger" %}

## Adding to your own Jekyll site

You will need to copy the include template, and the sass styling as well.  

[View include](https://github.com/mendhak/mendhak.github.io/blob/master/_includes/repo_card.html){: .btn .btn--info }  [View scss](https://github.com/mendhak/mendhak.github.io/blob/master/_sass/github-repo-card.scss){: .btn .btn--info }


I am using the minimal-mistakes theme, which includes Font Awesome for the icons. You may have to tweak the CSS as well for your own themes. 

## Background


While learning how to work with Jekyll, and the minimal mistakes theme, I came across a page on Github describing the [repository metadata available](https://help.github.com/en/articles/repository-metadata-on-github-pages).

A list of your own repositories are available in `site.github.public_repositories` along with things like description, stars and forks.  

The trick is to filter out to only grab the repo matching the name passed in.  

```liquid
{% raw %}{% assign repository = site.github.public_repositories 
| where: "name", include.reponame 
| first %}%{% endraw %}
```

Then it's a simple matter of rendering in HTML and CSS. 

