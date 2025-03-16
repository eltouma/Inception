#!/bin/ash

# Colors 
green='\e[32m'                                      
red='\e[31m'                                        
blue='\e[34m'                                       
reset='\e[0m'  

if [ ! -d "/var/lib/mysql/mysql" ]; then
 	chown -R mysql:mysql /var/lib/mysql /run/mysqld
	chmod 755 /var/lib/mysql /run/mysqld
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	echo -e "${green}Database created${reset}" 
#	mariadb-admin shutdown
#	mysql -u root -e "SHUTDOWN;"
# 	rc-service mariadb stop
fi

exec "$@"
