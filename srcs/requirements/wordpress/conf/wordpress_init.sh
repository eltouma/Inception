#!/bin/sh

green='\e[92m'
red='\e[91m'
yellow='\e[93m'
blue='\e[94m'
magenta='\e[95m'
cian='\e[96m'
reset='\e[0m'

#set	-ex

if [ -f .env ]; then
	set -a
	source ../../.env
	set +a
fi


echo "${red}Current directory: $(pwd)${reset}"
#echo -e "${magenta}wp-cli.phar installation${reset}"
#./wordpress_conf.sh
if [ ! -f wp-cli.phar ]; then
        wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod 777 wp-cli.phar
	echo -e "${cian}wp-cli.phar downloaded ici $(pwd)${reset}"
else
        echo -e "${cian}wp-cli.phar DEJA LA${reset}"
fi

echo -e "${magenta}Current directory: $(pwd)${reset}"
echo -e "\n\n"
ls -l wp-cli.phar
echo -e "\n\n"
echo -e "\n\n"
which php83
echo -e "\n\n"

#mkdir -p /var/www/wordpress
#cd /var/www/wordpress
#chmod -R 755  /var/www/wordpress
echo -e "Tentative de création de la configuration avec :"
echo -e "DB_NAME: $DB_NAME"
echo -e "DB_USER: $DB_USER"
echo -e "DB_HOST: $DB_HOST"

#if  ! php83 /var/www/wordpress/wp-cli.phar core is-installed ; then
if [ ! -f "/var/www/wp-config.php" ]; then
	echo -e "${red}wp-cli.phar installation${reset}"
	php83 wp-cli.phar core download --version="6.6.2"

	echo -e "${red}config creation${reset}"
php83 wp-cli.phar config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_ROOT_PASSWORD --dbhost=mariadb:3306 --path='/var/www/wordpress' --allow-root
#php83 wp-cli.phar config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_ROOT_PASSWORD --dbhost=mariadb:3306  --allow-root

	echo -e "${red}config created${reset}"
#php83 wp-cli.phar db create

	echo -e "${red}config installation${reset}"
php83 wp-cli.phar core install --url=$DOMAIN_NAME --title=inception --admin_user=$DB_USER --admin_password=$DB_ROOT_PASSWORD --admin_email=test@test.com --path='/var/www/wordpress' --allow-root

	echo -e "${red}config installed${reset}"
#php83 wp-cli.phar core config --dbhost=mariadb:3306 --dbname=mariadb --dbuser=elsa --dbpass=secret 
php83 wp-cli.phar user create --role=author elsauser elsa@test.com --user_pass=$WP_PASSWORD
chown -R nobody:nobody /var/www/wordpress
fi

sed -i -E "s/^listen = 127.0.0.1/listen = 0.0.0.0/" /etc/php83/php-fpm.d/www.conf
# sed -i -E "s/;ping.path/ping.path/" /etc/php83/php-fpm.d/www.conf
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
