#!/bin/ash

# Colors 
green='\e[32m'                                      
red='\e[31m'                                        
blue='\e[34m'                                       
reset='\e[0m'  

if [ ! -d "/var/lib/mysql/mysql" ]; then
	# Change owner: define mysql as owner and group
 	chown -R mysql:mysql /var/lib/mysql /run/mysqld

	# Change permissions
	chmod 755 /var/lib/mysql /run/mysqld

	# Init database
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	# Check if db is safe
	tfile=`mktemp`
	 if [ ! -f "$tfile" ]; then
		return 1
	fi
	echo -e "${green}Database created${reset}" 
#	mariadb-admin shutdown
#	mysql -u root -e "SHUTDOWN;"
# 	rc-service mariadb stop
fi

exec "$@"
