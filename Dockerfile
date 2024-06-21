FROM debian:jessie

# 古いDebianリポジトリを使用して、必要なパッケージをインストール
RUN echo "deb http://archive.debian.org/debian/ jessie main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates locales wget build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev --force-yes --allow-unauthenticated && \
    apt-get install -y --no-install-recommends apache2 apache2-utils --allow-unauthenticated && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# GPGキーの検証を無効にして再度パッケージリストを更新
RUN apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true && \
    apt-get install -y --no-install-recommends wget --force-yes && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ロケールの生成
RUN echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=ja_JP.UTF-8

# Ruby 1.8のソースコードをダウンロードしてインストール
RUN wget http://cache.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p374.tar.gz && \
    tar -xzf ruby-1.8.7-p374.tar.gz && \
    cd ruby-1.8.7-p374 && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    cd .. && \
    rm -rf ruby-1.8.7-p374 ruby-1.8.7-p374.tar.gz

# 環境変数を設定してデフォルトエンコーディングをEUC-JPに変更
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

WORKDIR /app

# Apacheを起動するためのCMD
CMD ["apachectl", "-D", "FOREGROUND"]
