FROM php:8.1-cli-alpine

ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions apcu \
    bcmath \
    bz2 \
    calendar \
    curl \
    csv \
    dom \
    exif \
    gd \
    gettext \
    grpc \
    http \
    imagick \
    imap \
    intl \
    ldap \
    mailparse \
    mcrypt \
    memcached \
    mongodb \
    oauth \
    openswoole \
    pcntl \
    pdo_mysql \
    pdo_odbc \
    pdo_pgsql \
    protobuf \
    rdkafka \
    redis \
    snappy \
    soap \
    sockets \
    ssh2 \
    uploadprogress \
    uuid \
    xdebug \
    xdiff \
    xlswriter \
    xmldiff \
    xmlrpc \
    yaml \
    zip \
    zstd

RUN apk add --no-cache bash supervisor

RUN mkdir -p /var/log/supervisor \
    && rm -rf /var/cache/apk/*  \
    && rm -f /usr/local/bin/install-php-extensions

COPY ./runtime/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY ./runtime/php.ini /etc/php/8.1/cli/conf.d/99-app.ini

COPY ./runtime/start-container /usr/local/bin/start-container

RUN chmod +x /usr/local/bin/start-container

WORKDIR /var/www

EXPOSE 80

ENTRYPOINT ["start-container"]
