---
title: "Getting a Github Action to run randomly"
description: "Use a random value to cancel a Github Action from one of its own jobs"

categories: 
  - github
tags: 
  - github
  - action
  
---

If you have a Github Action set on a cron schedule, but don't necessarily want it to always run on that schedule - for example a daily cron that doesn't _always_ need to run daily - it's possible to introduce a random cancellation step. 

In the first step, set an environment variable.  Here we're using `$((RANDOM%2))` to give a 50% chance. This sets a 1 or 0 value against the `$PROCEED` environment variable.  

```yml
steps:
- id: Roll dice
  run: echo "PROCEED=$((RANDOM%2))" >> $GITHUB_ENV
  shell: bash
```

Next, call the [cancel action](https://github.com/andymckay/cancel-action) but only if `$PROCEED` was set to 0 in the previous step. 

```yml
- if: env.PROCEED == '0'
  name: Cancelling
  uses: andymckay/cancel-action@0.2
```

The cancellation call can take about 15-30 seconds, so it's worth adding in a sleep step so that the actual remaining build steps don't get called and killed halfway.  

```yml
- if: env.PROCEED == '0'
  name: Waiting for cancellation
  run: sleep 60
```      

## All together, a snippet of a sample workflow:

Here's an example workflow which runs daily at 5:30, but now should run just half the time.

```yml
name: My Action

# Controls when the action will run. Triggers the workflow on push or pull request
# events but only for the master branch
on:
  push:
    branches: [ master ]
  schedule:
    - cron:  '30 5 * * *'
    
    

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
    - id: Roll dice
      run: echo "PROCEED=$((RANDOM%2))" >> $GITHUB_ENV
      shell: bash
      
    - if: env.PROCEED == '0'
      name: Cancelling
      uses: andymckay/cancel-action@0.2
      
    - if: env.PROCEED == '0'
      name: Waiting for cancellation
      run: sleep 60
    
    # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
    - uses: actions/checkout@v2

    # rest of your steps...
```    
