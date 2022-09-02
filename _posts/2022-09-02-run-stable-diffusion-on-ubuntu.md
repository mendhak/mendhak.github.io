---
title:      The simplest way to get started with Stable Diffusion on Ubuntu 
description: "Simple set of instructions to run the Dream Script Stable Diffusion on Ubuntu 22.04"
categories:
 - tech
 - ubuntu
 - machine-learning
 - images
tags:
 - tech
 - ubuntu
 - machine-learning
 - images

header: 
  teaser: /assets/images/run-stable-diffusion-on-ubuntu/003.png

---

Stable Diffusion is a machine learning model that can generate images from natural language descriptions.  Because it's open source, it's also easy to run it locally, which makes it very convenient to experiment with in your own time. The simplest and best way of running Stable Diffusion is through the [Dream Script Stable Diffusion](https://github.com/lstein/stable-diffusion) fork, which comes with some convenience functions.  

## Setup

### Install Anaconda

Download the Anaconda installer script from [their website](https://www.anaconda.com/products/distribution#linux) and install it.  The download URL may change over time, so replace it.: 

```bash
wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh
chmod +x Anaconda3-2022.05-Linux-x86_64.sh
# Install Anaconda without prompts
./Anaconda3-2022.05-Linux-x86_64.sh -b
```

Once installation is finished, initialise conda, but tell it not to activate each time the shell starts. 

```bash
~/anaconda3/bin/conda config --set auto_activate_base false
~/anaconda3/bin/conda init
```

### Get the model file

The model file needed by Stable Diffusion is hosted on [Hugging Face](https://huggingface.co/CompVis/).  You will need to register with any email address.  Once registered, head to the latest model repository, which at the time of writing is [stable-diffusion-v-1-4-original](https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/tree/main).  Under the 'files and versions' tab, download the checkpoint file, `sd-v1-4.ckpt`.  


### Get the Dream Script Stable Diffusion repository

The Dream Script Stable Diffusion repo is a fork of Stable Diffusion, it comes with some convenience functions to accept a text prompt, as well as a web interface.  

```bash
git clone https://github.com/lstein/stable-diffusion.git
cd stable-diffusion
```

Next, move the model file downloaded previously, into this repo, renaming it to `model.ckpt`

```bash
mkdir -p models/ldm/stable-diffusion-v1/
mv ~/Downloads/sd-v1-4.ckpt models/ldm/stable-diffusion-v1/model.ckpt
```

### Create the conda environment

While still in the Stable Diffusion repo, create the conda environment in which the scripts will run.  

```bash
conda env create -f environment.yaml
```

The first time this step runs, it will take a long time, due to the numerous dependencies involved. 


## Run Stable Diffusion

Once the setup is done, these are the steps to run Stable Diffusion.  Activate the conda environment, preload models, and run the dream script. 

```bash
conda activate ldm
python scripts/preload_models.py
python scripts/dream.py
```

A prompt will appear where you can enter some natural language text. 

```bash
* Initialization done! Awaiting your command (-h for help, 'q' to quit)
dream>
```

As an example, try *photograph of highly detailed closeup of victoria sponge cake*.  Wait a few seconds, and an image gets generated in the `outputs/img-sample` folder.  

[![Example]({{ site.baseurl }}/assets/images/run-stable-diffusion-on-ubuntu/001.png)]({{ site.baseurl }}/assets/images/run-stable-diffusion-on-ubuntu/001.png)

Conveniently, a `dream_log.txt` file shows you all the prompts you've run in case you want to refer back to something. 


### Extras

Type `--help` at the `dream>` prompt to see a list of options.  You can use flags like `-n5` to generate multiple images, `-s` for number of steps, and `-g` to generate a grid.  

More details, including how to use an image as a starting prompt, can be found in [the README](https://github.com/lstein/stable-diffusion#interactive-command-line-interface-similar-to-the-discord-bot).  