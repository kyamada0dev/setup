#!/bin/sh

echo 'Start setup script for Ubuntu 24.04 on WSL2'

echo 'Update all packages'
sudo apt-get update -y
sudo apt-get upgrade -y

echo 'Install required packages'
sudo apt-get install -y \
  zsh \
  fzf \
  tmux \
  openssh-client

echo 'change shell from bash to zsh'
sudo chsh -s /bin/zsh $USER
curl -sL https://raw.githubusercontent.com/kyamada0dev/setup/main/dot.zshrc.simple >"$HOME/.zshrc"
curl -sL https://raw.githubusercontent.com/kyamada0dev/setup/main/dot.tmux.conf >"$HOME/.tmux.conf"
curl -sL https://raw.githubusercontent.com/kyamada0dev/setup/main/dot.vimrc.simple >"$HOME/.vimrc"

echo 'config env'
sudo mv /etc/locale.gen /etc/locale.gen.orig
cat /etc/locale.gen.orig | sed -e 's/# en_US.UTF-8/en_US.UTF-8/' | sed -e 's/# ja_JP.UTF-8/ja_JP.UTF-8/' |sudo tee /etc/locale.gen >/dev/null
sudo locale-gen

echo 'Copy ssh keys'
WIN_HOME_TMP="$(cmd.exe /c "<nul set /p=%UserProfile%" 2>/dev/null)"
WIN_HOME=$(wslpath "${WIN_HOME_TMP}")

if [[ -d "${WIN_HOME}/.ssh" ]]; then
  if [[ ! -d "${HOME}/.ssh" ]]; then
    #mkdir -p "${HOME}/.ssh"
    #chmod 700 "${HOME}/.ssh"
    install -m 0700 -d "$HOME/.ssh"
  fi
  cp "${WIN_HOME}"/.ssh/* "${HOME}"/.ssh
  chmod 600 "$HOME"/.ssh/*
fi

echo 'Install mise'
curl https://mise.run | sh

echo 'Install build dependencies for rust and ruby'
sudo apt install -y build-essential rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev sqlite3 libsqlite3-dev

echo 'Setup docker'
# Add Docker's official GPG key:
# sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose

sudo usermod -aG docker "$USER"
echo 'exec "newgrp docker"'
