#!/bin/ash

green='\e[32m'
reset='\e[0m'

if [ -f .env ]; then
	set -a
	source ../../.env
	set +a
fi 

if [ ! -d "${db_path}" ]; then
 	chown -R mysql:mysql /var/lib/mysql /run/mysqld
	chmod 755 /var/lib/mysql /run/mysqld
	echo -e "${green}Database installed${reset}" 
fi
