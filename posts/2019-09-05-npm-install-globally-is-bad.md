---
title: "Don't install npm packages globally"
description: "npm install -g is bad and should be avoided, there are many ways to do this"
tags: 
  - node
  - npm
  - javascript
gallery:
  - url: /assets/images/npm-install-globally-is-bad/002.png
    image_path: /assets/images/npm-install-globally-is-bad/002.png
  - url: /assets/images/npm-install-globally-is-bad/003.png
    image_path: /assets/images/npm-install-globally-is-bad/003.png
  - url: /assets/images/npm-install-globally-is-bad/004.png
    image_path: /assets/images/npm-install-globally-is-bad/004.png    
---


Many node packages and tools will encourage you to install their tools globally.  This is a bad practice and should be avoided.  

![](/assets/images/npm-install-globally-is-bad/001.png)

Some examples of this are Angular, Grunt, Gulp, Karma, Verdaccio, Snyk, React Native.  


{% gallery "Examples of well known packages encouraging global install" %}
![](/assets/images/npm-install-globally-is-bad/002.png)
![](/assets/images/npm-install-globally-is-bad/003.png)
![](/assets/images/npm-install-globally-is-bad/004.png)
{% endgallery %}

## Why it should be avoided

When a tool asks you to install their tool globally, there are several issues they are ignoring. 


### Teams work on several projects

A team, even single developer, using Node tools will often have multiple projects.  By placing the tool in the `$PATH`, that's the version that all projects are dependent on. 

### Breaking changes happen

Minor changes can still contain breaking changes, despite semver's intended promises. There will come a time when a project uses a feature or behavior in a certain version of the tool which breaks compatibility with the other projects.  This can and will make project upgrades painful, in addition to the fact that it is increasing workload for no beneficial reason. 

### It does not save time

When you npm install a package, a copy is kept in a cache directory on the host.  This allows for subsequent npm installs to be faster than the first install. 
Even for a build server where there is no guaranteed cache, it is still possible to set up a local npm registry to help with speeding up npm install steps. 
 
### It is dangerous

Due to permissions required to write to the global directories, you may need to `sudo install -g toolname`.  
Combine this with the fact that npm install will run the package's arbitrary scripts, any misconfiguration or malicious code can seriously compromise your server.  



## What to do instead



### Run it with `npx`

Since npm v5, a tool called `npx` has been bundled alongside.  This tool will download a package locally, invoke it, and clean up after itself. 

```bash
npx hashcat --help
```


### Run it with `$(npm bin)`

In any node project, `npm bin` will evaluate to the path of the bin directory inside `node_modules`.  You can use this to use the tool locally.

```bash
npm install hashcat
$(npm bin)/hashcat --help
```



### Run it with package.json scripts

You can create custom scripts in your package.json.  The path to the bin directory inside `node_modules` is already included.  

Add your script,

```json
"scripts": {
    "helpme": "hashcat --help"
  },
```
Then run it

```bash
npm install hashcat
npm run helpme
```

