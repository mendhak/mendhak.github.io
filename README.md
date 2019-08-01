## Environment setup

Set up [Ruby and bundler](https://jekyllrb.com/docs/installation/ubuntu/)

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

This repo uses the [Minimal Mistakes Jekyll theme](https://github.com/mmistakes/minimal-mistakes).


