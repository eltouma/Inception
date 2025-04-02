NAME = inception
WP_DATA = /home/${LOGIN}/data/wordpress

all:
	@docker-compose -f ./srcs/docker-compose.yml up --build
#all: up
