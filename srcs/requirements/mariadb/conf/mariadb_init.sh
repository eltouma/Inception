#!/bin/ash

set	-ex

if [ -f .env ]; then
	set -a
	source ../../.env
	set +a
fi


./mariadb_conf.sh

#if [ ! -d "${DB_PATH}" ]; then
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	echo "oui"
fi

mysqld --user=mysql --datadir=/var/lib/mysql & 
sleep 5
	echo "oui1"
#until mariadb -u root -e "SELECT 1" > /dev/null 2>&1; do
#    sleep 1
#done
#for i in $(seq 1 30); do
#    mariadb -u root -e "SELECT 1" > /dev/null 2>&1 && break
#    echo "Attente de MariaDB pour qu'il soit prêt..."
#    sleep 1
#done

mariadb -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS coucou;
    CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;

    FLUSH PRIVILEGES;
EOSQL
#cat << EOF > /tmp/mariadb_init.sql
#CREATEDiU DATABASE IF NOT EXISTS TAMERE;
#FLUSH PRIVILEGES;
#EOF
#/usr/bin/mysqld --user=mysql --bootstrap < /tmp/mariadb_init.sql


mysqladmin shutdown -u root --password="secret"
exec "$@"

    #CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
    #CREATE USER IF NOT EXISTS \`${DB_USER}\`@'%' IDENTIFIED BY '${WP_PASSWORD}';
    #GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO \`${DB_USER}\`@'%' IDENTIFIED BY '${WP_PASSWORD}';
#mariadb -u root <<-EOSQL
#    CREATE DATABASE IF NOT EXISTS coucou;
#
#    FLUSH PRIVILEGES;
#EOSQL
