FROM php:8-apache

LABEL maintainer="orvice"

# Install Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y \
	bzip2 libzip-dev zip curl \
	libcurl4-openssl-dev \
	libfreetype6-dev \
	libicu-dev \
	libjpeg-dev \
	libldap2-dev \
	libmcrypt-dev \
	libmemcached-dev \
	libpng-dev \
	libpq-dev \
	libxml2-dev \
	zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/* && \
	docker-php-ext-configure gd --with-freetype --with-jpeg  &&  \
	docker-php-ext-install gd \
	&& docker-php-ext-install zip \
	&& docker-php-ext-install pdo pdo_mysql \
	&& docker-php-ext-install bcmath \
	&& pecl install mongodb \
	&& docker-php-ext-enable mongodb

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
	echo 'opcache.memory_consumption=128'; \
	echo 'opcache.interned_strings_buffer=8'; \
	echo 'opcache.max_accelerated_files=4000'; \
	echo 'opcache.revalidate_freq=60'; \
	echo 'opcache.fast_shutdown=1'; \
	echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Enable Rewrite
RUN a2enmod rewrite

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY 000-default.conf /etc/apache2/sites-enabled/

COPY install.sh .
RUN chmod +x install.sh && ./install.sh

WORKDIR /var/www/html

EXPOSE 80

#ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
