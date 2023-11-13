# from https://www.drupal.org/docs/system-requirements/php-requirements
FROM php:8.1-apache-buster

# install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
		libzip-dev \
        libxml2-dev \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg=/usr \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
        soap \
        intl \
	; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

COPY --from=composer:2.1 /usr/bin/composer /usr/local/bin/
COPY config/php.ini /usr/local/etc/php/php.ini



# Xdebug and Redis
RUN pecl install redis xdebug && docker-php-ext-enable redis xdebug
RUN apt-get update && apt-get install -y \
    libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
	&& docker-php-ext-enable imagick

# Install ssl-cert (snakeoil) package
RUN set -eux; \
    apt-get update && apt-get install -y ssl-cert; \
    : "Clean Apt system" ;\
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /tmp/* /var/tmp/* /var/log/lastlog /var/log/faillog; \
    rm -f /var/log/{apt/*,alternatives.log,dpkg.log}; \
    :;

RUN a2enmod rewrite
RUN a2enmod ssl

COPY config/certificates/cert.pem /etc/apache2/ssl/ssl.crt
COPY config/certificates/key.pem /etc/apache2/ssl/ssl.key

#Install drush launcher
RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*
RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar
RUN chmod +x drush.phar
RUN mv drush.phar /usr/local/bin/drush

RUN  apt-get update -y && \
     apt-get upgrade -y && \
     apt-get dist-upgrade -y && \
     apt-get -y autoremove && \
     apt-get clean
RUN apt-get install -y p7zip \
    p7zip-full \
    unace \
    zip \
    unzip \
    xz-utils \
    sharutils \
    uudeview \
    mpack \
    arj \
    cabextract \
    file-roller \
    git \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*;

#Install Node Js && NPM
RUN curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh && bash nodesource_setup.sh && apt-get -y install nodejs
# add `/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH
RUN npm install -g npm@latest

RUN npm install -g sass

WORKDIR /var/www
