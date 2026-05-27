FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    zip \
    nginx \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project
COPY . .

# Fix git safe directory issue
RUN git config --global --add safe.directory /var/www/html

# Install dependencies
RUN composer install --no-interaction --prefer-dist

# Laravel permissions
RUN chmod -R 777 storage bootstrap/cache || true

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/default

RUN echo 'server { \
    listen 80; \
    index index.php index.html; \
    server_name localhost; \
    root /var/www/html/public; \
\
    location / { \
        try_files $uri $uri/ /index.php?$query_string; \
    } \
\
    location ~ \.php$ { \
        include snippets/fastcgi-php.conf; \
        fastcgi_pass 127.0.0.1:9000; \
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \
        include fastcgi_params; \
    } \
}' > /etc/nginx/sites-enabled/default

EXPOSE 80

CMD service nginx start && php-fpm
