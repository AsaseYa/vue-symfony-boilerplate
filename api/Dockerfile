FROM php:8.2.5-apache AS symfony_php

# persistent / runtime deps
RUN apt-get update
RUN apt-get install -y acl \
		fcgiwrap \
		file \
		gettext \
		git \
		libc6-dev \
    	libzip-dev \
    	zip \
    	unzip \
    && docker-php-ext-install zip \
	;

RUN docker-php-ext-enable opcache;
RUN docker-php-ext-install mysqli pdo pdo_mysql;

# Install Composer
VOLUME /var/run/php

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"

WORKDIR /srv/api

# Allow to choose skeleton
ARG SKELETON="symfony/skeleton"
ENV SKELETON ${SKELETON}

# Allow to select skeleton version
ARG SYMFONY_VERSION="6.2.*"
ENV SYMFONY_VERSION ${SYMFONY_VERSION}

# Download the Symfony skeleton and leverage Docker cache layers
RUN composer create-project "${SKELETON}:${SYMFONY_VERSION}" . --prefer-dist --no-dev --no-progress --no-interaction; \
	composer clear-cache

RUN set -eux; \
	mkdir -p var/cache var/log; \
	composer install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction; \
	composer dump-autoload --classmap-authoritative --no-dev; \
	composer symfony:dump-env prod; \
	composer run-script --no-dev post-install-cmd; \
	chmod +x bin/console; sync;

RUN a2enmod headers
