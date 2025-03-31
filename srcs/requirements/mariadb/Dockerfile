# syntax=docker/dockerfile:1

# To fully secure your supply chain integrity, you can pin the image version to a specific digest.
# By pinning your images to a digest, you're guaranteed to always use the same image version, even if a publisher replaces the tag with a new image
FROM	alpine:3.20@sha256:de4fe7064d8f98419ea6b49190df1abbf43450c1702eeb864fe9ced453c1cc5f

# Install the application dependencies
RUN	apk add --no-cache mariadb mariadb-client \
	&& mkdir -p /run/mysqld /var/lib/mysql \
	&& chown -R mysql:mysql /run/mysqld /var/lib/mysql \
	&& sed -i "s|skip-networking|skip-networking=0|g" /etc/my.cnf.d/mariadb-server.cnf \
	&& sed -i "s|#bind-address=0.0.0.0|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

# Copy files from the host and put them into the container image
COPY	--chmod=755 ./conf/mariadb_conf.sh . 
COPY	--chmod=755 ./conf/mariadb_init.sh .

# Sets configuration on the image that indicates a port the image would like to expose
EXPOSE	3306

# Allows you to configure a container that will run as an executable
ENTRYPOINT ["./mariadb_init.sh"]

# Sets the default command a container using this image will run
CMD ["mysqld_safe", "--basedir=/usr", "--datadir=/var/lib/mysql", "--user=mysql"]

HEALTHCHECK	--interval=10s --timeout=1s --start-period=10s --retries=3  \
    CMD mysqladmin -u$DB_USER -p$DB_ROOT_PASSWORD ping 2>&1 | grep -qE "mysqld is alive"; \
    if [ $? -eq 0 ]; then exit 0; else exit 1; fi
