FROM php:8.4.11-fpm
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
ADD index.php /var/www/html/index.php
