#!/bin/zsh

echo 'Start setup script for Ubuntu 24.04 on WSL2 wich cloud-init'

echo 'Update all packages'
sudo apt-get update -y
sudo apt-get upgrade -y

sudo /usr/bin/python3 -c "from softwareproperties.SoftwareProperties import SoftwareProperties; SoftwareProperties(deb822=True).enable_source_code_sources()" \
  && sudo apt-get update -y

#curl -sL https://raw.githubusercontent.com/kyamada0dev/setup/main/dot.zshrc.simple >"$HOME/.zshrc"
#curl -sL https://raw.githubusercontent.com/kyamada0dev/setup/main/dot.tmux.conf >"$HOME/.tmux.conf"
#curl -sL https://raw.githubusercontent.com/kyamada0dev/setup/main/dot.vimrc.simple >"$HOME/.vimrc"

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
curl https://mise.run | MISE_INSTALL_PATH=$HOME/bin/mise sh

eval "$(/home/kyamada/bin/mise activate zsh)"
mise doctor
mise install node@22
mise install python@latest
mise install ruby@latest

mise use -g node@22
mise use -g python@latest
mise use -g ruby@latest

#echo 'Install build dependencies for rust and ruby'
#sudo apt install -y build-essential rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev sqlite3 libsqlite3-dev

curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path

export PATH=$HOME/.cargo/bin:$PATH

#echo 'Install build dependencies for python'
#sudo apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

echo 'Install Homebrew'
env NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo 'Setup docker'
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

mkdir -p $HOME/bin
mkdir -p $HOME/tmp

#git clone git@bitbucket.org:melito/dotfiles.git $HOME/dotfiles
#sh $HOME/dotfiles/setup.sh

ln -s ${WIN_HOME} $HOME/home

brew install neovim

cargo install sheldon cargo-update zoxide
#cargo install --git https://github.com/astral-sh/uv uv
curl -LsSf https://astral.sh/uv/install.sh | sh

GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=no' git clone --branch personal-use git@github.com:melito00/kickstart.nvim.git $HOME/.config/kickstart.nvim

