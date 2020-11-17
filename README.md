Static site for code.mendhak.com.  This site uses the [Minimal Mistakes Jekyll theme](https://github.com/mmistakes/minimal-mistakes).


## To run from docker

    docker-compose up

This should build and run the image.  I was not able to use the `jekyll/builder` image, it kept prefixing URLs with `/pages/mendhak` and I could not figure out how to disable it.     


## To run without docker (don't do this)

For local development you will need to set up [Ruby and bundler](https://jekyllrb.com/docs/installation/ubuntu/)

    sudo apt update
    sudo apt-get install ruby-full build-essential zlib1g-dev
    echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
    echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
    echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
    gem install jekyll bundler
    bundle install


To run this repo, use

    bundle exec jekyll serve --config _config.yml --host 0.0.0.0




