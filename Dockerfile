FROM alpine:3.20

RUN	apk update \
	&& apk upgrade \
	&& apk add mariadb mariadb-openrc && rc-service mariadb status
# https://github.com/gliderlabs/docker-alpine/issues/183
# https://stackoverflow.com/questions/78269734/is-there-a-better-way-to-run-openrc-in-a-container-than-enabling-softlevel

#RUN	mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld \
	&& mysql_install_db --user=mysql --datadir=/var/lib/mysql
# RUN	apk update && apk upgrade && apk add mariadb mariadb-client && apk search mariadb

#FROM	debian:bullseye
#RUN	apt update -y && apt upgrade -y && apt install mariadb-server -y

CMD ["mysqld_safe"]
