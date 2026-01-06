# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# PATH for rust
export PATH="$HOME/.cargo/bin:$PATH"
# PATH for golang
export PATH="$(go env GOPATH)/bin:$PATH"
# Created by `pipx` 
export PATH="$PATH:/home/vla/.local/bin"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="tjkirch_mod"
ZSH_THEME=random
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
#old "robbyrussell" "agnoster"
ZSH_THEME_RANDOM_CANDIDATES=(  "ys" "michelebologna" "re5et" "Soliah" "xiong-chiamiov" "takashiyoshida" "geoffgarside" "kafeitu" "fletcherm" "fino" "kafeitu")

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions copypath emoji encode64 web-search history zsh-vi-mode )

# alias vim='vim'
alias vi='nvim'
#alias sudo vim='sudo nvim'
alias v='nvim'
alias ff='fzf'
alias cd='z'

#send with e2ecp
alias send='e2ecp send'
# Add this to your ~/.zshrc
gitc() {
  if [ -z "$1" ]; then
    echo "Provide argument of `commit message`"
    return 1
  fi
  git add .
  git commit -m "$1"
  git push
}




alias wifi_on='sudo rfkill unblock wifi'
alias wifi_off='sudo rfkill block wifi'

alias bt_on='sudo rfkill unblock bluetooth'
alias bt_off='sudo rfkill block bluetooth'

alias fopen='thunar'

alias cl='clear'
# alias f='google'
alias t='kitty'

alias act='source myenv/bin/activate'
alias pvenv='python3 -m venv myenv'
# alias lorem=lorem-ipsum-generator
alias shutdown='sudo shutdown'
alias reboot='sudo reboot'


alias hypr="nvim /home/vla/.config/hypr/"

# alias charge=`upower -i $(upower -e | grep 'BAT') | grep -E "state|to\ full|percentage"`
alias charge='upower -i $(upower -e | grep "BAT") | grep -E "state|to full|percentage"'
# alias clock =`tty-clock -c -s -b -f "%H:%M:%S" -C 3 -B "#6a2c8d" -t`
alias wifi='nmcli device wifi'
alias rtx='nvidia-smi'


alias nvrun='__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only'



# alias spotify='spicetify apply'
source $ZSH/oh-my-zsh.sh

# User configuration

export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi


bak() {
    if [ -z "$1" ]; then
        echo "Usage: bak <file_or_folder>"
        return 1
    fi

    target="$1"
    date_suffix=$(date +"%d_%m_%y")

    if [ -d "$target" ]; then
        # If it's a directory
        backup_name="${target%/}_bak_${date_suffix}"
        cp -r "$target" "$backup_name"
        echo "📁 Folder backed up as: $backup_name"
    elif [ -f "$target" ]; then
        # If it's a file
        backup_name="${target}.bak"
        cp "$target" "$backup_name"
        echo "📄 File backed up as: $backup_name"
    else
        echo "❌ Error: '$target' not found."
        return 1
    fi
}



gitundo() {
  if [[ -z "$1" ]]; then
    echo "Usage: gitundo <number_of_commits>"
    return 1
  fi

  local INT=$1
  git reset --hard HEAD~${INT}
  git push origin --force
}

# -----------------------------
# Disk formatting (Dangerous!)
# -----------------------------
format-disk() {
  if [[ -z "$1" ]]; then
    echo "Usage: format-disk /dev/sdX"
    return 1
  fi

  echo "⚠️  WARNING: This will COMPLETELY ERASE ALL DATA on $1 ⚠️"
  read "confirm?Type 'YES' (in uppercase) to continue: "

  if [[ "$confirm" != "YES" ]]; then
    echo "Aborted."
    return 1
  fi

  if command -v gparted &>/dev/null; then
    echo "Opening GParted GUI for $1..."
    sudo gparted "$1"
  else
    echo "Proceeding with CLI formatting..."
    sudo wipefs -a "$1" || return 1
    sudo parted -s "$1" mklabel gpt
    sudo parted -s "$1" mkpart primary ext4 0% 100%
    sudo mkfs.ext4 "${1}1"
    echo "✅ Disk $1 formatted as a single ext4 partition."
  fi
}

# -----------------------------
# Media conversion + auto-open with mpv
# -----------------------------

media2mp3() {
  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      echo "File $f not found, skipping."
      continue
    fi
    out="${f%.*}.mp3"
    ffmpeg -i "$f" -vn -ab 192k -ar 44100 -y "$out"
    echo "Converted $f -> $out"
    command -v mpv &>/dev/null && mpv  --force-window=immediate "$out"
  done
}

media2mp4() {
  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      echo "File $f not found, skipping."
      continue
    fi
    out="${f%.*}.mp4"
    ffmpeg -i "$f" -c:v libx264 -crf 23 -preset fast -c:a aac -b:a 192k -y "$out"
    echo "Converted $f -> $out"
    command -v mpv &>/dev/null && mpv  --force-window=immediate "$out"
  done
}

media2mkv() {
  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      echo "File $f not found, skipping."
      continue
    fi
    out="${f%.*}.mkv"
    ffmpeg -i "$f" -c:v libx264 -crf 23 -preset fast -c:a aac -b:a 192k -y "$out"
    echo "Converted $f -> $out"
    command -v mpv &>/dev/null && mpv  --force-window=immediate "$out"
  done
}

media2mov() {
  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      echo "File $f not found, skipping."
      continue
    fi
    out="${f%.*}.mov"
    ffmpeg -i "$f" -c:v prores_ks -profile:v 3 -c:a pcm_s16le -y "$out"
    echo "Converted $f -> $out"
    command -v mpv &>/dev/null && mpv --force-window=immediate "$out"
  done
}
# -----------------------------
# Image conversion + open with shotwell
# -----------------------------

# Convert any image to near-full quality JPG
img2jpg() {
  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      echo "File $f not found, skipping."
      continue
    fi
    out="${f%.*}.jpg"
    magick "$f" -quality 95 "$out"
    echo "Converted $f -> $out"
    command -v shotwell &>/dev/null && shotwell "$out" &
  done
}

# Convert any image to near-full quality 1080p-wide JPG
img2jpg-small() {
  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      echo "File $f not found, skipping."
      continue
    fi
    out="${f%.*}.jpg"
    magick "$f" -resize 1920x1080\> -quality 95 "$out"
    echo "Converted $f -> $out (1080p-wide)"
    command -v shotwell &>/dev/null && shotwell "$out" &
  done
}

# Convert any image to lossily-compressed PNG
img2png() {
  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      echo "File $f not found, skipping."
      continue
    fi
    out="${f%.*}.png"
    magick "$f" -quality 85 "$out"
    echo "Converted $f -> $out"
    command -v shotwell &>/dev/null && shotwell "$out" &
  done
}

# -----------------------------
# Disk formatting using GParted/parted
# -----------------------------
format-disk() {
  if [[ -z "$1" ]]; then
    echo "Usage: format-disk /dev/sdX"
    return 1
  fi

  echo "WARNING: This will destroy ALL DATA on $1"
  read "confirm?Type 'y' to continue: "

  if [[ "$confirm" != "y" ]]; then
    echo "Aborted."
    return 1
  fi

  # Option 1: open GParted GUI for manual formatting
  if command -v gparted &>/dev/null; then
    sudo gparted "$1"
  else
    # Option 2: CLI formatting (dangerous!)
    sudo wipefs -a "$1"
    sudo parted "$1" mklabel gpt
    sudo mkfs.ext4 "${1}1"
    echo "Disk $1 formatted as ext4 (CLI mode)."
  fi
}

# -----------------------------
# Optional: compress/decompress using tar
# -----------------------------
compress() {
  if [[ -z "$1" ]]; then
    echo "Usage: compress <file_or_folder>"
    return 1
  fi
  tar -czvf "$1.tar.gz" "$1"
}

decompress() {
  if [[ -z "$1" ]]; then
    echo "Usage: decompress <file.tar.gz>"
    return 1
  fi
  tar -xzvf "$1"
}

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
#
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# export PATH=$PATH:/home/vla/.spicetify
# eval "$(/bin/brew shellenv)"
eval "$(zoxide init zsh)"
export XDG_CONFIG_HOME=/home/vla/.config
source /home/vla/tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORMTHEME=qt6ct

zsh-help() {
  echo "
============================================================
            CUSTOM ZSH COMMANDS & ALIASES
============================================================

-- ALIASES --
" > /tmp/zsh_cmd_help.txt

  # Extract custom aliases (exclude oh-my-zsh internal ones)
  grep -E '^\s*alias ' ~/.zshrc \
    | grep -v "oh-my-zsh" \
    >> /tmp/zsh_cmd_help.txt

  echo "

-- FUNCTIONS --
" >> /tmp/zsh_cmd_help.txt

  # Extract function definitions
  grep -E '^[a-zA-Z0-9_-]+\s*\(\)' -n ~/.zshrc \
    >> /tmp/zsh_cmd_help.txt

  echo "

============================================================
Tip: Scroll with ↑↓ / j k | Search with / | Quit with q
============================================================
" >> /tmp/zsh_cmd_help.txt

  less /tmp/zsh_cmd_help.txt
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

