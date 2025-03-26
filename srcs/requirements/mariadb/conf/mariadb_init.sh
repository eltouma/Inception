#!/bin/ash

set	-ex

if [ -f .env ]; then
	set -a
	source ../../.env
	set +a
fi

./mariadb_conf.sh

if [ ! -d "${db_path}" ]; then
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

if [ ! -d "/var/lib/mysql/wordpress" ]; then
        cat << EOF > /tmp/mariadb_init.sql
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
	/usr/bin/mysqld --user=mysql --bootstrap < /tmp/mariadb_init.sql
fi

exec "$@"
