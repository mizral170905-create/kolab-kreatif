#!/bin/sh
set -e

# Render mengirim nomor port lewat environment variable PORT (default 10000).
: "${PORT:=10000}"
export PORT

# Render "generateValue" menghasilkan base64 tanpa prefix; Laravel butuh "base64:".
case "$APP_KEY" in
    base64:*) ;;
    *) [ -n "$APP_KEY" ] && export APP_KEY="base64:$APP_KEY" ;;
esac

envsubst '${PORT}' < /etc/nginx/kolab.conf.template > /etc/nginx/conf.d/default.conf

cd /var/www/html

# Symlink storage bisa hilang saat container restart; pastikan selalu ada.
[ -L public/storage ] || php artisan storage:link --force

php artisan package:discover --ansi
php artisan optimize
php artisan migrate --force
php artisan kolab:seed-if-empty

chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

php-fpm -D
exec nginx -g 'daemon off;'
