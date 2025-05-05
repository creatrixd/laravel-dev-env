#!/bin/sh

install_make() {
    echo "Trying to install make..."
    if command -v make > /dev/null; then
        echo "make is already installed"
        return
    fi
    if command -v apt-get > /dev/null; then
        echo "Installing make with apt-get..."
        sudo apt-get update
        sudo apt-get install -y make
    elif command -v yum > /dev/null; then
        echo "Installing make with yum..."
        sudo yum install -y make
    elif command -v dnf > /dev/null; then
        echo "Installing make with dnf..."
        sudo dnf install -y make
    elif command -v pacman > /dev/null; then
        echo "Installing make with pacman..."
        sudo pacman -S --noconfirm make
    else
        echo "No supported package managers found"
        echo "Install make manually"
        exit 1
    fi
}

add_user_to_docker() {
    CURRENT_USER=$(id -un)
    echo -n "Add user $CURRENT_USER to docker group (if you want to work with docker without using sudo and typing your password)? (y/*): "
    read suggest

    if [ "$suggest" = "y" ]; then
        if getent group docker >/dev/null 2>&1; then
	        echo "Docker group has already been created"
        else
            echo "Creating docker group"
            sudo groupadd docker
            if [ $? -ne 0 ]; then
                echo "Error while creating docker group"
            fi
        fi
        echo "Adding $CURRENT_USER to docker group"
        sudo usermod -aG docker "$CURRENT_USER"
        if [ $? -eq 0 ]; then
            echo "User $CURRENT_USER was successfully added to docker group"
            echo "WARNING: to use docker without sudo you need to do logout and login again"
        else
            echo "Error while adding $CURRENT_USER to docker group"
        fi
    fi
}

install_docker() {
    echo "Checking and updating repositories..."

    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
       sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    echo "Installing docker..."

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Finishing docker installation..."

    add_user_to_docker
}

start_docker_installation() {
    if command -v docker >/dev/null 2>&1; then
        echo -n "Docker is already installed, reinstall it? (y/*): "
        read suggest

        if [ "$suggest" = "y" ]; then
            install_docker
        else
            echo "Skipping docker reinstallation"
        fi
    else
	    install_docker
    fi
}

prepare_env_root() {
    mkdir project/
    echo "Created project root folder..."
}

entrypoint() {
    echo -n "Start installation? (y/*): "
    read suggest

    if [ "$suggest" = "y" ]; then
	prepare_env_root
    install_make
	start_docker_installation
        echo "Installation finished"
        echo "Check ./README.md for info"
    else
        echo "Installation canceled. Bye."
    fi
}

entrypoint
