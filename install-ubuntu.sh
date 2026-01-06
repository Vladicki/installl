#!/bin/bash

# =============================
# install-deb.sh
# =============================

set -e  # Exit on any error

GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

echo -e "${GREEN}Starting Debian/Ubuntu setup...${RESET}"

# -----------------------------
# Update & Upgrade
# -----------------------------
echo -e "${YELLOW}Updating package lists...${RESET}"
sudo apt update -y

echo -e "${YELLOW}Upgrading packages...${RESET}"
sudo apt upgrade -y

# -----------------------------
# Install base packages
# -----------------------------
echo -e "${YELLOW}Installing essential packages...${RESET}"
sudo apt install -y \
    curl \
    wget \
    git \
    vim \
    htop \
    unzip \
    tar \
    build-essential \
    net-tools \
    ufw \
    neovim \
    tmux \
    zsh
    fzf \
    python3 \
    python3-venv \
    g++ \
    gparted \
    util-linux \
    parted \
    e2fsprogs \
    ffmpeg \
    mpv \
    imagemagick \
    upower \
    rfkill \
    network-manager \
    thunar \
    zoxide
# -----------------------------
# Install Oh-My-Zsh
# -----------------------------
echo -e "${YELLOW}Installing Oh-My-Zsh...${RESET}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

# -----------------------------
# Install .zshrc 
# -----------------------------
curl -fsSL https://raw.githubusercontent.com/Vladicki/installl/refs/heads/main/.zshrc -o "$HOME/.zshrc"

# -----------------------------
# SSH Setup
# -----------------------------
read -p "Do you want to install and enable SSH? (y/n) " install_ssh
if [[ "$install_ssh" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Installing OpenSSH server...${RESET}"
    sudo apt install -y openssh-server
    sudo ufw allow ssh
    sudo systemctl enable ssh
    sudo systemctl start ssh
    echo -e "${GREEN}SSH installed and enabled.${RESET}"
fi

# -----------------------------
# Docker Setup
# -----------------------------
read -p "Do you want to install Docker? (y/n) " install_docker
if [[ "$install_docker" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Installing Docker prerequisites...${RESET}"
    sudo apt install -y ca-certificates curl gnupg lsb-release

    echo -e "${YELLOW}Adding Docker GPG key and repo...${RESET}"
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo -e "${YELLOW}Installing Docker...${RESET}"
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker
    sudo systemctl start docker
    echo -e "${GREEN}Docker installed and started.${RESET}"
fi

# -----------------------------
# GoLang Setup
# -----------------------------
read -p "Do you want to install the latest Go (Golang)? (y/n) " install_go
if [[ "$install_go" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Installing latest Go...${RESET}"
    
    # Remove old Go if exists
    sudo rm -rf /usr/local/go
    
    # Get latest version dynamically
    LATEST_GO=$(curl -s https://go.dev/VERSION?m=text)
    echo "Latest Go version: $LATEST_GO"
    
    # Download and extract
    curl -LO https://go.dev/dl/${LATEST_GO}.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf ${LATEST_GO}.linux-amd64.tar.gz
    rm ${LATEST_GO}.linux-amd64.tar.gz
    
    # Add to PATH if not already present
    if ! grep -q "/usr/local/go/bin" <<< "$PATH"; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
        echo 'export GOPATH=$HOME/go' >> ~/.zshrc
        echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.zshrc
    fi
    
    # Reload shell
    source ~/.zshrc
    echo -e "${GREEN}Go installed successfully:${RESET} $(go version)"
fi


echo -e "${GREEN}Setup completed!${RESET}"

