# syntax=docker/dockerfile:1

# To fully secure your supply chain integrity, you can pin the image version to a specific digest.
# By pinning your images to a digest, you're guaranteed to always use the same image version, even if a publisher replaces the tag with a new image
FROM	alpine:3.20@sha256:de4fe7064d8f98419ea6b49190df1abbf43450c1702eeb864fe9ced453c1cc5f

ARG	PHP_VERSION=php83 

WORKDIR	/var/www/wordpress
	
# Install the application dependencies
RUN     apk add --no-cache ${PHP_VERSION}-fpm \
        ${PHP_VERSION}-mysqli \
        ${PHP_VERSION}-cli \
        ${PHP_VERSION}-phar \
        ${PHP_VERSION}-iconv \
	wget \
	mariadb-client \
	fcgi

# Copy files from the host and put them into the container image
COPY	--chmod=755 ./conf/wordpress_install.sh .
COPY	--chmod=755 ./conf/wordpress_conf.sh /

# Sets configuration on the image that indicates a port the image would like to expose
EXPOSE	9000

# Allows you to configure a container that will run as an executable
ENTRYPOINT ["/wordpress_conf.sh"]

# Sets the default command a container using this image will run
CMD ["php-fpm83", "-F"]

HEALTHCHECK --interval=10s --timeout=1s --start-period=10s --retries=3 \
    CMD cgi-fcgi -bind -connect 127.0.0.1:9000; if [ $? -eq 0 ]; then exit 0; else exit 1; fi
