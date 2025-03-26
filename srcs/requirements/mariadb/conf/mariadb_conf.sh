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
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	echo -e "${green}Database installed${reset}" 
fi

if [ ! -d "/var/lib/mysql/wordpress" ]; then
        cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM     mysql.user WHERE User='';
DELETE FROM     mysql.user WHERE User='wordpress_user';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
CREATE DATABASE \`${db_name}\` CHARACTER SET utf8 COLLATE utf8_general_ci;
FLUSH PRIVILEGES;
EOF
        /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
fi

#mariadb -e "GRANT ALL PRIVILEGES ON DEPARTEMENT.* TO 'eltouma.42.fr@localhost' IDENTIFIED BY 'secret';"
exec "$@"
