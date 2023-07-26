FROM composer:latest as backend-builder

WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install --no-scripts --no-autoloader

COPY . .

RUN composer install

FROM node:14 as frontend-builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

RUN npm run build

FROM php:fpm

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

COPY --from=backend-builder /app /var/www/html

COPY --from=frontend-builder /app/dist /var/www/html/public

RUN chown -R www-data:www-data /var/www/html/storage

EXPOSE 9000

ENV DB_HOST=mysql
ENV DB_PORT=3306
ENV DB_DATABASE=homestead
ENV DB_USERNAME=homestead
ENV DB_PASSWORD=123456


CMD ["php-fpm"]
