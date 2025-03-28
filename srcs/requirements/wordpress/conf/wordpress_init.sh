#!/bin/sh

: <<'END_COMMENT'
if [ ! -f wp-cli.phar ];
then
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
fi

if ! php83 wp-cli.phar core is-installed;
then
    php83 wp-cli.phar core download --version=8.3
    php83 wp-cli.phar config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=mariadb:3306
    php83 wp-cli.phar core install --url="localhost" --title="title" --admin_user="admin"--admin_password="test" --admin_email="elsa.touma@test.fr";

#    php83 wp-cli.phar user create --role=author $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWD
    chown -R nobody:nobody /srv/www/wordpress
fi

#sed -i -E "s/^listen = 127.0.0.1/listen = 0.0.0.0/" /etc/php83/php-fpm.d/www.conf
#sed -i -E "s/;ping.path/ping.path/" /etc/php83/php-fpm.d/www.conf
#sed -i -E "s/;ping.response/ping.response/" /etc/php83/php-fpm.d/www.conf

exec "$@"
END_COMMENT

green='\e[92m'
red='\e[91m'
yellow='\e[93m'
blue='\e[94m'
magenta='\e[95m'
reset='\e[0m'

set	-ex

if [ -f .env ]; then
	set -a
	source ../../.env
	set +a
fi

#echo -e "${magenta}wp-cli.phar installation${reset}"
#./wordpress_conf.sh
if [ ! -f wp-cli.phar ]; then
        wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod 777 wp-cli.phar
        echo -e "${cian}wp-cli.phar downloaded${reset}"
else
        echo -e "${cian}wp-cli.phar DEJA LA${reset}"
fi

echo "Current directory: $(pwd)"
echo "\n\n"
ls -l wp-cli.phar
echo "\n\n"
echo "\n\n"
which php83
echo "\n\n"

#mkdir -p /var/www/wordpress
#cd /var/www/wordpress
#chmod -R 755  /var/www/wordpress
echo "Tentative de création de la configuration avec :"
echo "DB_NAME: $DB_NAME"
echo "DB_USER: $DB_USER"
echo "DB_HOST: $DB_HOST"

#if  ! php83 /var/www/wordpress/wp-cli.phar core is-installed ; then
if [ ! -f "/var/www/wp-config.php" ]; then
	echo -e "${red}wp-cli.phar installation${reset}"
	php83 wp-cli.phar core download --version="6.6.2"

php83 wp-cli.phar config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=mariadb:3306 --allow-root

php83 wp-cli.phar core install --url=localhost --title=inception --admin_user=elsa_admin --admin_password=secret4 --admin_email=test@test.com 

#php83 wp-cli.phar core config --dbhost=mariadb:3306 --dbname=mariadb --dbuser=elsa --dbpass=secret 
#php83 wp-cli.phar user create --role=autor elsauser elsa@test.com secretelsa useruser 
chown -R nobody:nobody /var/www/wordpress
fi

#sed -i -E "s/^listen = 127.0.0.1/listen = 0.0.0.0/" /etc/php83/php-fpm.d/www.conf
#sed -i -E "s/;ping.path/ping.path/" /etc/php83/php-fpm.d/www.conf
#sed -i -E "s/;ping.response/ping.response/" /etc/php83/php-fpm.d/www.conf

: <<'END_COMMENT'
echo -e "${green}Mariadb initialization${reset}"
./mariadb_conf.sh

if [ ! -d "${DB_PATH}" ]; then
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	echo -e "${green}Mariadb installed${reset}"
fi

echo -e "${yellow}Launch temporary mariadb server${reset}"
mysqld --user=mysql --datadir=/var/lib/mysql & 
sleep 5

mariadb -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
    CREATE USER IF NOT EXISTS \`${DB_USER}\`@'%' IDENTIFIED BY '${WP_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO \`${DB_USER}\`@'%' IDENTIFIED BY '${WP_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

echo -e "${blue}${DB_NAME} created${reset}"
echo -e "${blue}${DB_USER} created${reset}"
echo -e "${green}Mariadb is ready!${reset}"

mysqladmin shutdown -u root --password="secret"
echo -e "${yellow}Shutdown temporary mariadb server${reset}"
echo -e "${magenta}Exec command mariadb container will run${reset}"
exec "$@"

#######################################
cd /var/www/
chmod -R 755 wordpress
ls -lR /var/www/wordpress
chown -R www-data:www-data wordpress

wp core download --allow-root

wp config create --allow-root

wp core install --url=elsa.42.fr --title=inception --admin_user=elsa_admin --admin_password=secret --admin_email=test@test.com --allow-root

wp core config --dbhost=mariadb:3306 --dbname=mariadb --dbuser=elsa --dbpass=secret --allow-root
wp user create elsauser elsa@test.com secretelsa useruser --allow-root

sed -i 's|listen = 127.0.0.1:9000|listen = 0.0.0.0|' /etc/php83/php-fpm.d/www.conf \

#sed -i '36 s@/run/php/php8-fpm.sock@9000@' /etc/php/8/fpm/pool.d/www.conf
# create a directory for php-fpm
mkdir -p /run/php
# start php-fpm service in the foreground to keep the container running
/usr/sbin/php-fpm83 -F

exec "$@"

END_COMMENT
exec "$@"
