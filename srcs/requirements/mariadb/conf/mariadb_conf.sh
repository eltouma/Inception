#!/bin/ash

green='\e[92m'
red='\e[91m'
yellow='\e[93m'
blue='\e[94m'
magenta='\e[95m'
reset='\e[0m'

echo -e "${green}Mariadb initialization${reset}"
./mariadb_install.sh

if [ ! -d "${DB_PATH}" ]; then
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	echo -e "${green}Mariadb installed${reset}"
fi

echo -e "${yellow}Launch temporary mariadb server${reset}"
mysqld --user=mysql --datadir=/var/lib/mysql  &
sleep 5

mariadb -u root <<-EOSQL
	DELETE FROM mysql.user WHERE User='';
	DROP DATABASE IF EXISTS test;
	CREATE DATABASE IF NOT EXISTS ${DB_NAME};
	CREATE USER IF NOT EXISTS ${ROOT_USER}@'%' IDENTIFIED BY '${ROOT_PASSWORD}';
	CREATE USER IF NOT EXISTS ${USER}@'%' IDENTIFIED BY '${USER_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO ${ROOT_USER}@'%'; 
	FLUSH PRIVILEGES;
EOSQL

echo -e "${blue}${DB_NAME} created${reset}"
echo -e "${blue}${ROOT_USER} created${reset}"
echo -e "${green}Mariadb is ready!${reset}"

mysqladmin shutdown -u root --password=${ROOT_PASSWORD}
mariadb -e "DELETE FROM mysql.user WHERE User='root';"
echo -e "${yellow}Shutdown temporary mariadb server${reset}"
echo -e "${magenta}Exec command mariadb container will run${reset}"
exec "$@"
