FROM ruby:2.5.5

WORKDIR /srv/jekyll

COPY . /srv/jekyll

RUN apt-get -y update && apt-get install -y locales ruby-full build-essential zlib1g-dev
RUN dpkg-reconfigure locales && locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN gem install jekyll bundler
RUN bundle install

CMD ["bundle","exec","jekyll","serve","--config","_config.yml","--host","0.0.0.0","--drafts", "--incremental"]