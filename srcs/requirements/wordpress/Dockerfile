# syntax=docker/dockerfile:1

# To fully secure your supply chain integrity, you can pin the image version to a specific digest.
# By pinning your images to a digest, you're guaranteed to always use the same image version, even if a publisher replaces the tag with a new image
FROM	alpine:3.20@sha256:de4fe7064d8f98419ea6b49190df1abbf43450c1702eeb864fe9ced453c1cc5f

#ARG	PHP_VERSION=8.3 \
#	WP_ORG=wordpress.org \
#	WP_ZIP=wordpress-6.6.2.zip \
#	WP_CLI=wp-cli-2.10.0.phar
#

WORKDIR	/var/www/wordpress
	
# Install the application dependencies
RUN     apk add --no-cache php-fpm \
        php-mysqli \
        php-openssl \
        php-cli \
        php-phar \
	wget \
	fcgi
	# fcgi pour le healthcheck

# Copy files from the host and put them into the container image
COPY	--chmod=755 ./conf/wordpress_conf.sh . 
COPY	--chmod=755 ./conf/wordpress_init.sh .
COPY	--chmod=755 ./conf/www.conf /etc/php83/php-fpm.d/www.conf 

# Sets configuration on the image that indicates a port the image would like to expose
EXPOSE	9000

# Allows you to configure a container that will run as an executable
ENTRYPOINT ["./wordpress_init.sh"]

# Sets the default command a container using this image will run
CMD ["/bin/ash", "-c", "/usr/sbin/php-fpm83", "-F"]

HEALTHCHECK --interval=10s --timeout=1s --retries=3 --start-period=30s \
    CMD cgi-fcgi -bind -connect 127.0.0.1:9000 ping | grep -q pong; if [ $? -eq 0 ]; then exit 0; else exit 1; fi
