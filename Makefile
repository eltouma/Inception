GREEN := \e[92m
GRAY := \e[90m
BLUE := \e[94m
RESET := \e[0m

NAME = inception
DATA_PATH = /home/eltouma
WP_DATA = $(DATA_PATH)/data/wordpress
MARIABD_DATA = $(DATA_PATH)/data/mariadb

all:
	@echo -e "$(GRAY)Copying ../.env into /srcs$(RESET)"
	@cp ../.env srcs/.env
	@echo -e "$(BLUE)../.env$(RESET) copied into /srcs: $(GREEN)Success$(RESET)\n"
	@echo -e "$(GRAY)Copying ../secrets into /srcs/requirements/nginx/secrets$(RESET)"
	@cp -r ../secrets ./srcs/requirements/nginx/secrets
	@echo -e "$(BLUE)../secrets$(RESET) copied into /srcs/requirements/nginx/secrets: $(GREEN)Success$(RESET)"
	@echo -e "\n$(GRAY)Creating repositories for persistent data$(RESET)"
	@mkdir -p $(WP_DATA) $(MARIABD_DATA)
	@echo -e "$(BLUE)Repositories for persistent data$(RESET) created: $(GREEN)Success$(RESET)\n"
	docker compose -f ./srcs/docker-compose.yml up --build

clean: 
	@docker images
	@echo ""
	@docker ps -a
	@echo ""
	@docker volume ls
	@echo ""
	@docker network ls
	@echo ""
	@docker stop $$(docker ps -qa)
	@docker rm $$(docker ps -qa)
	@docker rmi -f $$(docker images -qa)
	@docker volume rm srcs_mariadb srcs_wordpress
	@docker network rm inception
	@rm -rf ./srcs/.env ./srcs/requirements/nginx/secrets $(DATA_PATH)
	@echo -e "$(BLUE)srcs/.env$(RESET) removed: $(GREEN) Success$(RESET)"
	@echo -e "$(BLUE)srcs/requirements/nginx/secrets$(RESET) removed: $(GREEN) Success$(RESET)"
	@echo -e "$(BLUE)Repositories for persistent data$(RESET) removed: $(GREEN)Success$(RESET)\n"
	@docker images
	@echo ""
	@docker ps -a
	@echo ""
	@docker volume ls
	@echo ""
	@docker network ls

down:
	@docker compose -f ./srcs/docker-compose.yml stop
	@echo -e "Containers stopped $(GREEN)successfully$(RESET)"

up:
	@echo -e "$(BLUE)Restarting Containers$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml up
