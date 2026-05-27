FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    php-zip \
    php-curl \
    php-xml \
    php-mbstring \
    php-bcmath \
    php-cli \
    unzip \
    git \
    curl

# Enable Apache rewrite
RUN a2enmod rewrite

# Copy project files
COPY . /var/www/html

WORKDIR /var/www/html

# Laravel public directory setup
RUN sed -i 's!/var/www/html!/var/www/html/public!g' \
    /etc/apache2/sites-available/000-default.conf

# Enable .htaccess
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' \
    /etc/apache2/apache2.conf

# Permissions
RUN chmod -R 777 storage bootstrap/cache || true

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
