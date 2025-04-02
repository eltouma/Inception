#!/bin/ash

if [ ! -d "${DB_PATH}" ]; then
 	chown -R mysql:mysql /var/lib/mysql /run/mysqld
	chmod 755 /var/lib/mysql /run/mysqld
fi
