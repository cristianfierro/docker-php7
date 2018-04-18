FROM ubuntu:16.04

MAINTAINER Cristian Fierro <cristianfierro86@gmail.com>

RUN apt-get clean && apt-get update && apt-get install -y locales

RUN locale-gen en_US.UTF-8

ENV LANG en_us.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
    && apt-get install -y curl zip unzip git software-properties-common supervisor sqlite3 \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php7.0-fpm php7.0-cli php7.0-mcrypt php7.0-gd php7.0-mysql \
       php7.0-imap php-memcached php7.0-mbstring php7.0-xml php7.0-curl \
       php7.0-sqlite3 php7.0-zip php7.0-pdo-dblib \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php \
    && apt-get remove -y --purge software-properties-common \
    && apt-get -y autoremove \
    && apt-get install -y vim \
    && apt-get -yq install ruby \
    && apt-get build-dep -yq --force-yes ruby-compass \
    && gem install compass

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

RUN npm install -g bower gulp

COPY php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf

COPY www.conf /etc/php/7.0/fpm/pool.d/www.conf

EXPOSE 9000

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]