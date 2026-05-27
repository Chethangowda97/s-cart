FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git unzip zip curl libzip-dev

RUN docker-php-ext-install pdo pdo_mysql zip

COPY . /var/www/html/

WORKDIR /var/www/html

EXPOSE 80
