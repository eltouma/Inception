#!/bin/ash

echo "coucou"

cd /var/www/
echo "coucou1"
chmod -R 755 wordpress
ls -lR /var/www/wordpress
chown -R www-data:www-data wordpress

<<  END_COMMENT
wp core download --allow-root

wp config create --allow-root

wp core install --url=elsa.42.fr --title=inception --admin_user=elsa_admin --admin_password=secret --admin_email=test@test.com --allow-root

wp core config --dbhost=mariadb:3306 --dbname=mariadb --dbuser=elsa --dbpass=secret --allow-root
wp user create elsauser elsa@test.com secretelsa useruser --allow-root

END_COMMENT
sed -i 's|listen = 127.0.0.1:9000|listen = 9000|' /etc/php8/php-fpm.d/www.conf \

sed -i '36 s@/run/php/php8.3-fpm.sock@9000@' /etc/php/8.3/fpm/pool.d/www.conf
# create a directory for php-fpm
mkdir -p /run/php
# start php-fpm service in the foreground to keep the container running
/usr/sbin/php-fpm8.3 -F

exec "$@"
