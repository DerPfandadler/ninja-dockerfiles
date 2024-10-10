# ARGs for versioning
ARG PHP_VERSION=8.2
ARG BAK_STORAGE_PATH=/var/www/app/docker-backup-storage/
ARG BAK_PUBLIC_PATH=/var/www/app/docker-backup-public/

# Use Home Assistant Add-on Base for the entire build
FROM homeassistant/aarch64-base:3.15 as base

# Node.js build stage based on Home Assistant base
FROM base as nodebuild

# Install Node.js and required tools
RUN apk add --no-cache nodejs npm curl unzip grep

# Download Invoice Ninja
ARG INVOICENINJA_VERSION
RUN set -eux; \
    DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/invoiceninja/invoiceninja/releases/latest" | grep -o '"browser_download_url": "[^"]*invoiceninja.tar"' | cut -d '"' -f 4) && \
    curl -LJO "$DOWNLOAD_URL" && \
    mv invoiceninja.tar /tmp/ninja.tar

# Extract Invoice Ninja
RUN mkdir -p /var/www/app \
    && tar -xvf /tmp/ninja.tar -C /var/www/app/ \
    && mkdir -p /var/www/app/public/logo /var/www/app/storage

# PHP build stage
FROM php:${PHP_VERSION}-fpm-alpine as phpbuild

LABEL maintainer="David Bomba <turbo124@gmail.com>"

# Add MariaDB connector and PHP extensions
RUN apk add --no-cache mariadb-connector-c

# PHP ini setup
RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# Install PHP extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN set -eux; \
    apk add --no-cache \
    font-isas-misc \
    supervisor \
    mysql-client \
    chromium \
    ttf-freefont \
    ttf-dejavu \
    && install-php-extensions \
    bcmath exif gd gmp mysqli opcache pdo_mysql zip intl @composer \
    && rm /usr/local/bin/install-php-extensions

# Copy HA-specific root files
COPY rootfs /

# Create user for Invoice Ninja
ARG UID=1500
ENV INVOICENINJA_USER invoiceninja
RUN addgroup --gid=$UID -S "$INVOICENINJA_USER" && \
    adduser --uid=$UID --disabled-password --gecos "" --home "/var/www/app" --ingroup "$INVOICENINJA_USER" "$INVOICENINJA_USER"

# Set up app
ARG INVOICENINJA_VERSION
ARG BAK_STORAGE_PATH
ARG BAK_PUBLIC_PATH
ENV INVOICENINJA_VERSION $INVOICENINJA_VERSION
ENV BAK_STORAGE_PATH $BAK_STORAGE_PATH
ENV BAK_PUBLIC_PATH $BAK_PUBLIC_PATH
COPY --from=nodebuild --chown=$INVOICENINJA_USER:$INVOICENINJA_USER /var/www/app /var/www/app

RUN rm -rf /var/www/app/ui

USER $UID
WORKDIR /var/www/app

# Dependency build stage for node packages
FROM base as dependencybuild

WORKDIR /var/www/app
COPY --from=phpbuild /var/www/app /var/www/app
COPY --from=nodebuild /var/www/app /var/www/app

# Move backup paths
RUN mv /var/www/app/storage $BAK_STORAGE_PATH && mv /var/www/app/public $BAK_PUBLIC_PATH

# Final production stage
FROM phpbuild as prod

COPY --from=dependencybuild --chown=$INVOICENINJA_USER:$INVOICENINJA_USER /var/www/app /var/www/app

# Set environment variables
ENV APP_ENV production
ENV LOG errorlog
ENV SNAPPDF_EXECUTABLE_PATH /usr/bin/chromium-browser

# Set s6-overlay entrypoint for Home Assistant
ENTRYPOINT ["/init"]
