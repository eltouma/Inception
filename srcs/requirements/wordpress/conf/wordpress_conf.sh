#!/bin/sh

green='\e[92m'
grey='\e[90m'
magenta='\e[95m'
reset='\e[0m'

./wordpress_install.sh

if [ ! -f "/var/www/wp-config.php" ]; then
	echo -e "${grey}wp-cli.phar installation${reset}"
	php83 wp-cli.phar core download --version="6.6.2"
	echo -e "${green}wp-cli.phar installed${reset}"

	echo -e "${grey}config creation${reset}"
	php83 wp-cli.phar config create --dbname=$DB_NAME --dbuser=$ROOT_USER --dbpass=$ROOT_PASSWORD --dbhost=mariadb:3306 --path='/var/www/wordpress' --allow-root
	echo -e "${green}config created${reset}"

	echo -e "${grey}config installation${reset}"
	php83 wp-cli.phar core install --url=$DOMAIN_NAME --title=inception --admin_user=$ROOT_USER --admin_password=$ROOT_PASSWORD --admin_email=test@test.com --path='/var/www/wordpress' --allow-root
	echo -e "${green}config installed${reset}"

	php83 wp-cli.phar user create --role=author $USER $USER_MAIL --user_pass=$USER_PASSWORD
	chown -R nobody:nobody /var/www/wordpress
fi

sed -i -E "s/^listen = 127.0.0.1/listen = 0.0.0.0/" /etc/php83/php-fpm.d/www.conf
echo -e "${magenta}Exec command wordpress container will run${reset}"
exec "$@"
