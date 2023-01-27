---
title: "Colored and folded output for Gradle tests"
description: "Script to add colored and folded tests when Travis CI or Github Actions runs your gradle tests."
tags:
  - gradle
  - travis
opengraph:
  image: /assets/images/gradle-travis-colored-output/001.png
---

When running Gradle tests on Travis CI, the terminal is usually set to `dumb` mode, so you get very plain looking output.  However, Travis does [allow for colors](https://blog.travis-ci.com/2014-04-11-fun-with-logs/) in their logs.

{% githubrepocard "mendhak/Gradle-Travis-Colored-Output" %}

This Gradle script plugin formats the Gradle test output in a slightly colorful way (made for Travis CI but works in terminal).  It also adds a summary at the end.

{% button "ColoredOutput.gradle", "https://github.com/mendhak/Gradle-Travis-Colored-Output/blob/master/ColoredOutput.gradle" %}

## Usage

Add the ColoredOutput.gradle script to your project, for example at `buildtools/ColoredOutput.gradle`



At the top of your `build.gradle`, reference it.

```java
apply from: 'buildtools/ColoredOutput.gradle'
```

If you want Travis folding, you can enable it like so:

```java
apply from: 'buildtools/ColoredOutput.gradle'
project.ext.set("TRAVIS_FOLDING", true)
```

If you run your build on Travis you should now see colored output.  

[![travis](/assets/images/gradle-travis-colored-output/001.png)](/assets/images/gradle-travis-colored-output/001.png)





Additionally you will see colored output in the terminal. 

[![travis](/assets/images/gradle-travis-colored-output/002.png)](/assets/images/gradle-travis-colored-output/002.png)



## How it works

This script makes use of Gradle's [TestListener](https://docs.gradle.org/current/javadoc/org/gradle/api/tasks/testing/TestListener.html) class which provides methods that run before and after tests and test suites are run. 

The script uses the results passed in `afterTest` to render `✓` for success, `❌` for failure or `ಠ_ಠ` for skipped tests. 

At the end, the `afterSuite` method renders a summary using various ANSI colors which Travis recognizes and renders. 


