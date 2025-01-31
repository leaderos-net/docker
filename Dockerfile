FROM php:7.4-fpm

# Required Libs
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    wget \
    mariadb-client \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip

# Ioncube Loader
RUN wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
    tar -zxvf ioncube_loaders_lin_x86-64.tar.gz && \
    cp ioncube/ioncube_loader_lin_7.4.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/ && \
    echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20190902/ioncube_loader_lin_7.4.so" > /usr/local/etc/php/conf.d/00-ioncube.ini && \
    rm -rf ioncube_loaders_lin_x86-64.tar.gz ioncube

# PHP Configration
RUN echo "upload_max_filesize = 128M" >> /usr/local/etc/php/php.ini \
    && echo "post_max_size = 128M" >> /usr/local/etc/php/php.ini \
    && echo "memory_limit = 512M" >> /usr/local/etc/php/php.ini \
    && echo "max_execution_time = 600" >> /usr/local/etc/php/php.ini \
    && echo "max_input_vars = 10000" >> /usr/local/etc/php/php.ini

WORKDIR /var/www/html

CMD ["php-fpm"]
