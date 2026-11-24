# syntax=docker/dockerfile:1

# ---------------------------------------------------------------------------
# 1. Bangun aset Vue / Tailwind. Pakai bookworm (glibc) karena binary opsional
#    Tailwind 4 / Rollup yang dipakai proyek ini adalah varian linux-x64-gnu.
# ---------------------------------------------------------------------------
FROM node:22-bookworm-slim AS assets
WORKDIR /app
COPY package.json package-lock.json .npmrc vite.config.ts tsconfig.json ./
COPY resources ./resources
COPY public ./public
RUN npm ci && npm run build

# ---------------------------------------------------------------------------
# 2. Base PHP 8.4 + FPM + ekstensi yang dibutuhkan Laravel 13 dan Postgres.
# ---------------------------------------------------------------------------
FROM php:8.4-fpm-alpine AS php-base
RUN apk add --no-cache \
        ca-certificates \
        postgresql-libs \
        libzip \
        libpng \
        libjpeg-turbo \
        freetype \
        oniguruma \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        postgresql-dev \
        libzip-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        oniguruma-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" \
        pdo_pgsql pgsql mbstring bcmath gd zip exif opcache \
    && apk del .build-deps
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ---------------------------------------------------------------------------
# 3. Vendor produksi saja (tanpa PHPUnit, Pest, PHPStan, dll.).
# ---------------------------------------------------------------------------
FROM php-base AS vendor
WORKDIR /var/www/html
COPY composer.json composer.lock ./
RUN composer install \
        --no-dev \
        --prefer-dist \
        --optimize-autoloader \
        --no-interaction \
        --no-scripts \
        --no-progress

# ---------------------------------------------------------------------------
# 4. Image final: Nginx + PHP-FPM + kode aplikasi.
# ---------------------------------------------------------------------------
FROM php-base AS runtime
RUN apk add --no-cache nginx gettext \
    && mkdir -p /run/nginx /etc/nginx/conf.d /var/www/html

COPY docker/php.ini /usr/local/etc/php/conf.d/zz-kolab.ini
COPY docker/nginx.conf.template /etc/nginx/kolab.conf.template
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html
COPY . .
COPY --from=vendor /var/www/html/vendor ./vendor
COPY --from=assets /app/public/build ./public/build

RUN mkdir -p \
        storage/framework/cache/data \
        storage/framework/sessions \
        storage/framework/views \
        storage/app/public \
        bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 10000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
