#!/bin/ash

if [ -f .env ]; then
	set -a
	source ../../.env
	set +a
fi 

if [ ! -d "${DB_PATH}" ]; then
# if [ ! -d "/var/lib/mysql/mysql" ]; then
 	chown -R mysql:mysql /var/lib/mysql /run/mysqld
	chmod 755 /var/lib/mysql /run/mysqld
fi
