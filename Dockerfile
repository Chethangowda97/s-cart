FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git unzip zip curl libzip-dev libpng-dev \
    libonig-dev libxml2-dev

RUN docker-php-ext-install pdo pdo_mysql zip

RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . /var/www/html

# Install Laravel dependencies
RUN composer install --no-interaction --prefer-dist

# Permissions
RUN chown -R www-data:www-data /var/www/html

# Apache public folder setup
RUN sed -i 's!/var/www/html!/var/www/html/public!g' \
    /etc/apache2/sites-available/000-default.conf

RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' \
    /etc/apache2/apache2.conf

EXPOSE 80
