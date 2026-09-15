FROM composer:2.8 AS build

WORKDIR /tmp/
COPY ./src/quoteservice/composer.json ./src/quoteservice/composer.lock ./

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --no-dev \
    --prefer-dist

FROM php:8.4-apache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions \
  && install-php-extensions \
    opcache \
    protobuf \
    opentelemetry-1.1.3

# The compose memory limit for this service is 30M; cap opcache and the prefork
# pool so a burst of concurrent requests cannot grow past it.
RUN printf 'opcache.memory_consumption=16\nopcache.interned_strings_buffer=4\nopcache.max_accelerated_files=4000\n' \
      > /usr/local/etc/php/conf.d/zz-opcache.ini \
  && printf '<IfModule mpm_prefork_module>\n  StartServers 2\n  MinSpareServers 1\n  MaxSpareServers 3\n  MaxRequestWorkers 6\n  MaxConnectionsPerChild 500\n</IfModule>\n' \
      > /etc/apache2/conf-available/zz-prefork.conf \
  && a2enconf zz-prefork

WORKDIR /var/www
COPY --from=build /tmp/vendor/ ./vendor/
COPY ./src/quoteservice/ /var/www

ENV APACHE_DOCUMENT_ROOT /var/www/public
RUN sed -ri -e 's|/var/www/html|${APACHE_DOCUMENT_ROOT}|g' /etc/apache2/sites-available/*.conf \
    && a2enmod rewrite \
    && echo "ServerName quoteservice" >> /etc/apache2/apache2.conf \
    && sed -i "s/80/\$\{QUOTE_SERVICE_PORT\}/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

USER www-data
EXPOSE ${QUOTE_SERVICE_PORT}
