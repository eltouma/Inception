FROM alpine:3.20

RUN	apk update \
	&& apk add --no-cache mariadb mariadb-client

RUN	mkdir /var/run/mysqld; \
	chmod 755 /var/run/mysqld; \
	{	echo '[mysqld]'; \
		echo 'skip-host-cache'; \
		echo 'skip-name-resolve'; \
		echo 'bind-address=0.0.0.0'; \
	} | tee /etc/my.cnf.d/docker.cnf; \
	sed -i "s|skip-networking|skip-networking=0|g" \
	/etc/my.cnf.d/mariadb-server.cnf

RUN	mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE	3306

COPY	./conf/mariadb_conf.sh . 

RUN	chmod 755 mariadb_conf.sh
RUN	sh ./mariadb_conf.sh # && rm mariadb_conf.sh
USER	mysql

# c'est mdb-conf.sh qui lance la cmd mysqld_safe
# ce script la lance la cmd mdb-conf.sh
# peut-etre le lancer avec exec() sans fork() // Garance, presque sur
# CMD ["mysqld_safe"]
#CMD ["/usr/bin/mysqld"]
CMD ["sleep", "infinity"]
