FROM alpine:3.20

RUN	apk update \
	&& apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld /var/lib/mysql \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql 

RUN	{	echo '[mysqld]'; \
		echo 'skip-host-cache'; \
		echo 'skip-name-resolve'; \
		echo 'bind-address=0.0.0.0'; \
	} | tee /etc/my.cnf.d/docker.cnf; \
	sed -i "s|skip-networking|skip-networking=0|g" \
	/etc/my.cnf.d/mariadb-server.cnf

EXPOSE	3306

COPY	./conf/mariadb_conf.sh . 

RUN	chmod 755 mariadb_conf.sh

ENTRYPOINT ["./mariadb_conf.sh"]

CMD ["mysqld_safe", "--datadir=/var/lib/mysql", "--user=mysql"]

# HEALTHCHECK
