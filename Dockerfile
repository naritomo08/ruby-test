FROM ruby:1.9

# 古いDebianリポジトリを使用して、必要なパッケージをインストール
RUN echo "deb http://archive.debian.org/debian/ jessie main" > /etc/apt/sources.list && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates --force-yes locales && \
    apt-get install -y --no-install-recommends apache2 apache2-utils --force-yes && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ロケールの生成
RUN sed -i '/^#.*ja_JP.EUC-JP/s/^#//' /etc/locale.gen && \
    locale-gen

# ApacheのCGIモジュールを有効化
RUN a2enmod cgi

# デフォルトのCGIスクリプトディレクトリを設定
RUN echo "ScriptAlias /cgi-bin/ /app/hiki/hiki-0.8.7/" > /etc/apache2/conf-available/cgi-bin.conf && \
    echo "<Directory \"/app/hiki/hiki-0.8.7/\">" >> /etc/apache2/conf-available/cgi-bin.conf && \
    echo "    AllowOverride None" >> /etc/apache2/conf-available/cgi-bin.conf && \
    echo "    Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch" >> /etc/apache2/conf-available/cgi-bin.conf && \
    echo "    Require all granted" >> /etc/apache2/conf-available/cgi-bin.conf && \
    echo "</Directory>" >> /etc/apache2/conf-available/cgi-bin.conf && \
    a2enconf cgi-bin

# サイトの設定を確認し、デフォルトの設定を有効にする
RUN echo "Include /etc/apache2/conf-available/cgi-bin.conf" >> /etc/apache2/apache2.conf

WORKDIR /app

# ロケールとタイムゾーンの設定
ENV LANG=ja_JP.EUC-JP
ENV LC_ALL=ja_JP.EUC-JP
ENV TZ=Asia/Tokyo

# Apacheを起動するためのCMD
CMD ["apachectl", "-D", "FOREGROUND"]
