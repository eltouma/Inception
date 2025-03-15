FROM alpine:3.20

RUN	apk update \
	&& apk upgrade \
	&& apk add mariadb \
	&& apk add openrc --no-cache \
	&& apk add mariadb-client

# Ici : https://medium.com/@afatir.ahmedfatir/unveiling-42-the-network-inception-a-dive-into-docker-and-docker-compose-cfda98d9f4ac#:~:text=subject.pdf.-,2%2DMariaDB%20Container,-This%20is%20the
# RUN apt-get install -y mariadb-server netcat
# netcat =>  ping the MariaDB container to make sure it's running before the WordPress container.

COPY	./mdb-conf.sh /mdb-conf.sh

RUN	chmod 755 /mdb-conf.sh

EXPOSE	3306
#FROM	debian:bullseye
#RUN	apt update -y && apt upgrade -y && apt install mariadb-server -y

# c'est mdb-conf.sh qui lance la cmd mysqld_safe
# ce script la lance la cmd mdb-conf.sh
# peut-etre le lancer avec exec() sans fork() // Garance, presque sur
# CMD ["mysqld_safe"]
CMD ["sh", "./mdb-conf.sh"]
