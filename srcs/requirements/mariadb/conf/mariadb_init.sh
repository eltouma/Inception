#!/bin/ash

green='\e[92m'
red='\e[91m'
yellow='\e[93m'
blue='\e[94m'
reset='\e[0m'

set	-ex

if [ -f .env ]; then
	set -a
	source ../../.env
	set +a
fi

./mariadb_conf.sh
echo -e "${green}Mariadb initialized${reset}"

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
exec "$@"
