#!/bin/ash

green='\e[92m'
grey='\e[90m'
reset='\e[0m'

if [ ! -f wp-cli.phar ]; then
        echo -e "${grey}wp-cli.phar download${reset}"
        wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod 777 wp-cli.phar
        echo -e "${green}wp-cli.phar downloaded${reset}"
fi

