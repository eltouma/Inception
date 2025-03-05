#!/bin/bash

# Colors
green='\e[32m'
red='\e[31m'
blue='\e[34m'
reset='\e[0m'

# Exit when any command fails
# set -ex
set +x

# Keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG

# Echo an error message before exiting
if [ ! "$0" ]; then
#       echo -e "${red}Warning:${reset} ${last_command} command failed with exit code $?."
        trap 'echo -e "${red}Warning:${reset} ${last_command} command failed with exit code $?."' EXIT
else
        trap 'echo -e "${green}success${reset}"' EXIT
fi

: <<'END_COMMENT'
/********************************/
/*				*/
/*	     LINUX PART		*/
/*				*/
/********************************/
END_COMMENT


# Install sudo
# if dpkg -l | grep -q sudo; then
if ! sudo --version &>/dev/null; then
	echo -e "${blue}Installing sudo${reset}"
	apt update && apt upgrade -y 
	apt install sudo
	yes | sudo enable
	echo -e "${green}Success:${reset} sudo is installed"
else
	echo -e "Sudo is already installed"
fi

# Add user in sudo group
if ! groups elsa | grep -q '\bsudo\b'; then
	echo -e "\n${blue}Add user in sudo group${reset}"
	CURRENT_USER=$(logname)
	usermod -aG sudo $CURRENT_USER
	usermod -aG sudo elsa
	sudo visudo
	echo -e "${green}Success:${reset} user is in sudo group"
else
	echo -e "User is already in sudo group"
fi

# Check if user is in sudo group
getent group sudo

# Install git
#if ! dpkg -l | grep -q git; then
if ! git --version &>/dev/null; then
	echo -e "\n${blue}Installing git${reset}"
	sudo apt-get install git
	yes | git enable
	git --version
	echo -e "${green}Success:${reset} git is installed"
else
	echo -e "Git is already installed"
fi

# Install vim
if ! vim --version &>/dev/null; then
	echo -e "\n${blue}Installing vim${reset}"
	sudo apt-get install vim
	#yes | vim enable
	echo -e "${green}Success:${reset} vim is installed"
else
	echo -e "Vim is already installed"
fi

# Install wget
if ! which wget &>/dev/null; then
	echo -e "\n${blue}Installing wget${reset}"
	sudo apt-get install wget
	yes | wget enable
	echo -e "${green}Success:${reset} wget is installed"
else
	echo -e "Wget is already installed"
fi

# Install make
if ! which make &>/dev/null; then
	echo -e "\n${blue}Installing make${reset}"
	sudo apt-get install build-essential
#	yes | build-essential  enable
	echo -e "${green}Success:${reset} make is installed"
else
	echo -e "Make is already installed"
fi

# Install SSH
if ! which openssh-server &>/dev/null; then
	echo -e "\n${blue}Installing SSH${reset}"
	sudo apt-get install openssh-server
	echo -e "${green}Success:${reset} SSH is installed"
else
	echo -e "SSH is already installed"
fi

systemctl status ssh --no-pager

: <<'END_COMMENT'
# Install ufw
if ! which ufw &>/dev/null; then
	echo -e "\n${blue}Installing ufw${reset}"
	sudo apt-get install ufw
	yes | ufw enable
	echo -e "${green}Success:${reset} ufw is installed"
else
	echo -e "ufw is already installed"
fi

# List all available applications with ufw 
sudo ufw app list
END_COMMENT

: <<'END_COMMENT'
apt-get remove sudo
apt-get remove git
apt-get remove vim
apt-get remove wget
apt-get remove openssh-server
apt-get remove make
END_COMMENT

: <<'END_COMMENT'
/********************************/
/*				*/
/*	    DOCKER PART		*/
/*				*/
/********************************/
END_COMMENT

# Uninstall all conflicting packages
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Set up Docker's apt repository
	# Install ca-certificates
if ! which ca-certificates &>/dev/null; then
	echo -e "\n${blue}Installing ca-certificates${reset}"
	sudo apt-get update
	sudo apt-get install ca-certificates curl
	echo -e "${green}Success:${reset} ca-certificates is installed"
else
	echo -e "Docker's GPG key is already installed"
fi

	# Add Docker's official GPG key
if [ ! -f /etc/apt/keyrings/docker.asc ]; then
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
	echo -e "${green}Success:${reset} Docker's GPG key is installed"
else
	echo -e "Docker's GPG key is already installed"
fi

# Install docker
if ! which docker &>/dev/null; then
	echo -e "\n${blue}Installing Docker${reset}"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	echo -e "${green}Success:${reset} Docker is installed"
else
	echo -e "Docker is already installed"
fi

# Verify that the installation is successful
sudo docker run hello-world
