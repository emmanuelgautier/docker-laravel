FROM composer/composer:latest

MAINTAINER Emmanuel Gautier <manu.gautier1394@gmail.com>

# Install NodeJs
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y nodejs git && \
    npm install gulp-cli bower -g

ARG PUID=1000
ARG PGID=1000
RUN groupadd -g $PGID laravel && \
    useradd -u $PUID -g laravel -m laravel

RUN mkdir -p /var/www/laravel

WORKDIR /var/www/laravel
COPY . /var/www/laravel

RUN chown -R laravel:laravel /var/www/laravel
USER laravel

RUN chmod 755 /var/www/laravel/storage -R
RUN chmod 755 /var/www/laravel/bootstrap/cache -R

# Compile Application
RUN npm install --production --unsafe-perm=true && \
    bower install && \
    gulp --production

RUN rm ./node_modules/ -r
RUN rm ./bower_components/ -r

RUN composer install --no-ansi --no-dev --no-interaction --no-progress --no-scripts --optimize-autoloader

VOLUME /var/www/laravel
