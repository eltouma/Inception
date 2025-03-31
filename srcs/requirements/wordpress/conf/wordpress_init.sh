#!/bin/sh

green='\e[92m'
grey='\e[90m'
magenta='\e[95m'
reset='\e[0m'

if [ -f .env ]; then
	set -a
	source ../../.env
	set +a
fi


./wordpress_conf.sh

if [ ! -f "/var/www/wp-config.php" ]; then
	echo -e "${grey}wp-cli.phar installation${reset}"
	php83 wp-cli.phar core download --version="6.6.2"
	echo -e "${green}wp-cli.phar installed${reset}"

	echo -e "${grey}config creation${reset}"
	php83 wp-cli.phar config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_ROOT_PASSWORD --dbhost=mariadb:3306 --path='/var/www/wordpress' --allow-root
	echo -e "${green}config created${reset}"

	echo -e "${grey}config installation${reset}"
	php83 wp-cli.phar core install --url=$DOMAIN_NAME --title=inception --admin_user=$DB_USER --admin_password=$DB_ROOT_PASSWORD --admin_email=test@test.com --path='/var/www/wordpress' --allow-root
	echo -e "${green}config installed${reset}"

	php83 wp-cli.phar user create --role=author elsauser elsa@test.com --user_pass=$WP_PASSWORD
	chown -R nobody:nobody /var/www/wordpress
fi

sed -i -E "s/^listen = 127.0.0.1/listen = 0.0.0.0/" /etc/php83/php-fpm.d/www.conf
echo -e "${magenta}Exec command wordpress container will run${reset}"
exec "$@"
