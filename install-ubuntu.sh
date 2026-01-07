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
sudo apt --fix-broken install

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
    zsh \
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
export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes
echo -e "${YELLOW}Installing Oh-My-Zsh...${RESET}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

# -----------------------------
# Install .zshrc 
# -----------------------------
curl -fsSL https://raw.githubusercontent.com/Vladicki/installl/refs/heads/main/.zshrc -o "$HOME/.zshrc"

# -----------------------------
# Install NVIM Config 
# -----------------------------
mkdir -p "$HOME/.config"

if [ -d "$HOME/.config/nvim/.git" ]; then
  git -C "$HOME/.config/nvim" pull
elif [ -d "$HOME/.config/nvim" ]; then
  echo "⚠️ ~/.config/nvim exists but is not a git repo, skipping"
else
  git clone https://github.com/Vladicki/.nvim.git "$HOME/.config/nvim"
fi

# -----------------------------
# SSH Setup
# -----------------------------
read -p "Do you want to install and enable SSH? (y/n) " install_ssh < /dev/tty
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
read -p "Do you want to install Docker? (y/n) " install_docker < /dev/tty
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
read -p "Do you want to install the latest Go (Golang)? (y/n) " install_go < /dev/tty
if [[ "$install_go" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Installing latest Go...${RESET}"
    
    # Remove old Go if exists
    sudo rm -rf /usr/local/go
    
    # Get latest version dynamically
LATEST_GO=$(curl -s "https://go.dev/VERSION?m=text" | head -n1 | tr -d '\r\n')
    echo "Latest Go version: $LATEST_GO"
    
    # Download and extract
    curl -LO https://go.dev/dl/${LATEST_GO}.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf ${LATEST_GO}.linux-amd64.tar.gz
    rm ${LATEST_GO}.linux-amd64.tar.gz
    
    # Reload shell
    source ~/.zshrc
    echo -e "${GREEN}Go installed successfully:${RESET} $(go version)"

    # Append GOPATH and Go bin to .zshrc if not present
    if ! grep -q "GOPATH" "$HOME/.zshrc"; then
cat <<'EOF' >> "$HOME/.zshrc"
export GOPATH="$HOME/go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"
EOF
    fi
    
    # Reload shell
    source ~/.zshrc
fi

echo -e "${GREEN}Setup completed!${RESET}"
