#!/bin/ash

NAME="elsa"
NICKNAME="eltouma"
DB_PW=""
DB_ROOT_PW=""
WP_USERPASS=""
ADM_WP_PASS=""

makefile="Makefile"
secrets="secrets"
credentials="credentials.txt"
db_password="db_password.txt"
db_root_password="db_root_password.txt"
srcs="srcs"
docker_compose="docker-compose.yml"
env=".env"
requirements="requirements"
mariadb="mariadb"
nginx="nginx"
tools="tools"
wordpress="wordpress"

echo "secrets" > .gitignore

inception=(
	"$secrets"
	"$srcs"
	)

secrets_d=(
	"$credentials"
	"$db_password"
	"$db_root_password"
	)

srcs_d=(
	"$docker_compose"
	"$env"
	)

req_d=(
	"$mariadb"
	"$nginx"
	"$tools"
	"$wordpress"
	)

if [ ! -f "$makefile" ]; then
	touch "$makefile"
	echo "$makefile created"
else
	echo "$makefile already exists"
fi

for dir in "${inception[@]}"; do
	if [ ! -d "$dir" ]; then
		mkdir -p "$dir"
		echo "Directory '$dir' created"
	else
		echo "Directory $dir already exists"
	fi
done

for s_file in "${secrets_d[@]}"; do
	file_path="$secrets/$s_file"
	if [ ! -f "$file_path" ]; then
		touch "$file_path"
		echo "File '$file_path' created"
	else
		echo "File $file_path already exists"
	fi
done

for srcs_file in "${srcs_d[@]}"; do
	file_path="$srcs/$srcs_file"
	if [ ! -f "$file_path" ]; then
		touch "$file_path"
		echo "File '$file_path' created"
	else
		echo "File $file_path already exists"
	fi
done

if [ ! -f "$requirements" ]; then
	dir_path="$srcs/$requirements"
	if [ ! -d "$dir_path" ]; then
		mkdir -p "$dir_path"
		echo "Directory $dir_path created"
	else
		echo "Directory $dir_path already exists"
	fi
fi

for req_dir in "${req_d[@]}"; do
	dir_path="$srcs/$requirements/$req_dir"
	if [ ! -d "$dir_path" ]; then
		mkdir -p "$dir_path"
		echo "Directory '$dir_path' created"
	else
		echo "Directory $dir_path already exists"
	fi
done
: <<'END_COMMENT'
END_COMMENT
