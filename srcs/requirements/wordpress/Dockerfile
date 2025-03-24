# syntax=docker/dockerfile:1

# To fully secure your supply chain integrity, you can pin the image version to a specific digest.
# By pinning your images to a digest, you're guaranteed to always use the same image version, even if a publisher replaces the tag with a new image
FROM	alpine:3.20@sha256:de4fe7064d8f98419ea6b49190df1abbf43450c1702eeb864fe9ced453c1cc5f

ARG	PHP_VERSION=8.3 \
	WP_ORG=wordpress.org \
	WP_ZIP=wordpress-6.6.2.zip \
	WP_CLI=wp-cli-2.10.0.phar

WORKDIR	/var/www
	
# Install the application dependencies
RUN	apk add --no-cache php php-fpm \
 	php-mysqli \
    	php-json \
#	php-curl \
	php-dom \
	php-mbstring \
	php-openssl \
	php-xml \
	php-zip \
	php-xdebug \
#	php-exif \
#	php-fileinfo \
# 	php-redis \
	php-cli \
	php-phar \
	php-tokenizer \
	wget \
	unzip \
#	&& sed -i 's|listen = 127.0.0.1:9000|listen = 9000|' /etc/php8/php-fpm.d/www.conf \
	&& rm -f /var/cache/apk/* \
	&& wget https://${WP_ORG}/${WP_ZIP} \
	&& unzip ${WP_ZIP} \
	&& cp -rf wordpress/* . \
	&& rm -rf ${WP_ZIP} \
	&& wget https://github.com/wp-cli/wp-cli/releases/download/v2.10.0/${WP_CLI} \
	&& chmod 755 ${WP_CLI} \
	&& mv ${WP_CLI} /usr/local/bin/wp

# Copy files from the host and put them into the container image
COPY	--chmod=755 ./conf/wordpress_conf.sh . 

# Sets configuration on the image that indicates a port the image would like to expose
EXPOSE	9000

# Allows you to configure a container that will run as an executable
ENTRYPOINT ["./wordpress_conf.sh"]

# Sets the default command a container using this image will run
#CMD ["mysqld_safe", "--basedir=/usr", "--datadir=/var/lib/mysql", "--user=mysql"]
CMD ["/bin/ash", "-c", "/usr/sbin/php-fpm8 -F"]
