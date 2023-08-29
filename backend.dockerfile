# Backend Dockerfile
FROM php:7.2-fpm

# Install system dependencies and Nginx
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git unzip nginx

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install gd pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Install PHPUnit
RUN curl -sS https://phar.phpunit.de/phpunit.phar -o /usr/local/bin/phpunit && chmod +x /usr/local/bin/phpunit
# Install Composer dependencies
RUN composer install

# Set up Nginx
COPY ./nginx.conf /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Set working directory
WORKDIR /var/www

# Copy existing application directory
COPY . .

# Install Composer dependencies
RUN composer install

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx and PHP-FPM
CMD service nginx start && php-fpm
