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

echo -n "Start installation? (y/*): "
read suggest

if [ "$suggest" = "y" ]; then

    echo "Cleaning old docker installations..."

    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

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

    mkdir project/
    echo "Created project root folder..."

    install_make

    echo "Installation finished"
    echo "Check ./README.md for info"
else
   echo "Installation canceled. Bye."
fi