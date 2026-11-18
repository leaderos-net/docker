FROM php:8.5-fpm

# Required Libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    curl \
    wget \
    zip \
    mariadb-client \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libwebp-dev \
    libzip-dev \
    libmagickwand-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip exif \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && rm -rf /var/lib/apt/lists/*

# Ioncube Loader (PHP 8.5)
RUN ARCH="$(uname -m)" \
    && case "$ARCH" in \
        x86_64) IONCUBE_ARCH="x86-64" ;; \
        aarch64) IONCUBE_ARCH="aarch64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && wget -q "https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_${IONCUBE_ARCH}.tar.gz" \
    && tar -zxf "ioncube_loaders_lin_${IONCUBE_ARCH}.tar.gz" \
    && EXT_DIR="$(php -r 'echo ini_get("extension_dir");')" \
    && cp ioncube/ioncube_loader_lin_8.5.so "$EXT_DIR/" \
    && echo "zend_extension=$EXT_DIR/ioncube_loader_lin_8.5.so" > /usr/local/etc/php/conf.d/00-ioncube.ini \
    && rm -rf "ioncube_loaders_lin_${IONCUBE_ARCH}.tar.gz" ioncube

# PHP Configration
RUN echo "allow_url_fopen = On" >> /usr/local/etc/php/conf.d/99-leaderos.ini \
    && echo "short_open_tag = On" >> /usr/local/etc/php/conf.d/99-leaderos.ini \
    && echo "upload_max_filesize = 128M" >> /usr/local/etc/php/conf.d/99-leaderos.ini \
    && echo "post_max_size = 128M" >> /usr/local/etc/php/conf.d/99-leaderos.ini \
    && echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/99-leaderos.ini \
    && echo "max_execution_time = 600" >> /usr/local/etc/php/conf.d/99-leaderos.ini \
    && echo "max_input_time = 600" >> /usr/local/etc/php/conf.d/99-leaderos.ini \
    && echo "max_input_vars = 10000" >> /usr/local/etc/php/conf.d/99-leaderos.ini \
    && echo "display_errors = Off" >> /usr/local/etc/php/conf.d/99-leaderos.ini \
    && echo "log_errors = On" >> /usr/local/etc/php/conf.d/99-leaderos.ini \
    && echo "error_reporting = E_ALL & ~E_DEPRECATED" >> /usr/local/etc/php/conf.d/99-leaderos.ini

WORKDIR /var/www/html

CMD ["php-fpm"]
