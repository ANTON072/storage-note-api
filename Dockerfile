FROM ruby:3.2.0

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

WORKDIR /storage_note

# apt-get利用リポジトリを日本サーバーに変更（インストール時間を短くする）
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

# 依存のインストール
RUN set -ex && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends sudo vim wget zip unzip postgresql-client libvips graphviz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    : "Install rails7.X latest version" && \
    gem install rails --version="~>7.0.5"

COPY Gemfile Gemfile.lock /storage_note/
RUN bundle install

COPY . /storage_note
