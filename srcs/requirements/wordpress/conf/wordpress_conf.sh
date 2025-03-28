#!/bin/ash

#green='\e[92m'
#red='\e[91m'
#yellow='\e[93m'
#blue='\e[94m'
#cian='\e[96m'
#magenta='\e[95m'
#reset='\e[0m'

set	-ex

if [ -f .env ]; then
	set -a
	source ../../.env
	set +a
fi

#mkdir -p /var/www/wordpress
#cd /var/www/wordpress
#chmod -R 755  /var/www/wordpress

if [ ! -f wp-cli.phar ]; then
	#wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp 
	#chmod +x /usr/local/bin/wp
	# wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /var/www/wordpress
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	# chmod 777 wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
	chmod +x /usr/local/bin/wp
#	echo -e "${cian}wp-cli.phar downloaded${reset}"
#else
#	echo -e "${cian}wp-cli.phar DEJA LA${reset}"
fi
