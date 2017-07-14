FROM ruby:2.3.4-slim

RUN apt-get update -qq && \
    apt-get install -y \
      build-essential git --no-install-recommends && \
    apt-get clean

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV APP /app
ENV BUNDLE_PATH /bundle

RUN gem install bundler --no-rdoc --no-ri

# App
RUN mkdir $APP
WORKDIR $APP
ADD . $APP

ENTRYPOINT bin/docker-entrypoint.sh $0 $@
