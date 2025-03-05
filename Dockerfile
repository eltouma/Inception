FROM alpine:3.20

RUN	apk update && apk upgrade && apk add mariadb mariadb-openrc

#FROM	debian:bullseye
#RUN	apt update -y && apt upgrade -y && apt install mariadb-server -y

CMD ["mysqld_safe"]
