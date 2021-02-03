FROM ruby:2.6.0
RUN apt-get update -qq && apt-get install -y mysql-client build-essential nodejs apt-transport-https
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn
RUN apt-get update && apt-get install -y curl apt-transport-https wget
# Node.jsをインストール
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
apt-get install nodejs
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
