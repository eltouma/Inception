# syntax=docker/dockerfile:1

# To fully secure your supply chain integrity, you can pin the image version to a specific digest.
# By pinning your images to a digest, you're guaranteed to always use the same image version, even if a publisher replaces the tag with a new image
FROM	alpine:3.20@sha256:de4fe7064d8f98419ea6b49190df1abbf43450c1702eeb864fe9ced453c1cc5f

# Install the application dependencies
RUN	apk add --no-cache nginx

# Copy files from the host and put them into the container image
COPY	--chmod=644 ./conf/nginx.conf /etc/nginx/nginx.conf
COPY	--chmod=644 ./conf/index.html /var/lib/nginx/html

# Sets configuration on the image that indicates a port the image would like to expose
EXPOSE	443


# Sets the default command a container using this image will run
CMD ["nginx", "-g", "daemon off;"]

