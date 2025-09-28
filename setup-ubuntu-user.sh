#!/bin/zsh

#  awk '/^packages:/{flag=1; next} flag && /^\-/{print; if ($0 !~ /^\-/) flag=0}' ubuntu-devuser.user-data | sed -e 's/^- //' >ubuntu-package.txt 
#

echo 'Start setup script for Ubuntu 24.04'

echo 'Update all packages'
sudo apt-get update -y
sudo apt-get upgrade -y

sudo /usr/bin/python3 -c "from softwareproperties.SoftwareProperties import SoftwareProperties; SoftwareProperties(deb822=True).enable_source_code_sources()" \
  && sudo apt-get update -y

if [ -e ubuntu-package.txt ]; then
  cat ubuntu-package.txt | xargs apt install -y
fi

curl -sL https://raw.githubusercontent.com/kyamada0dev/setup/main/dot.zshrc.simple >"$HOME/.zshrc"
curl -sL https://raw.githubusercontent.com/kyamada0dev/setup/main/dot.tmux.conf >"$HOME/.tmux.conf"
curl -sL https://raw.githubusercontent.com/kyamada0dev/setup/main/dot.vimrc.simple >"$HOME/.vimrc"

 update-alternatives --set editor "$(command -v vim.basic)"

# zsh wsl-copy-sshkeys.sh

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

# zsh setup-docker-ubuntu.sh

mkdir -p $HOME/bin
mkdir -p $HOME/tmp

#git clone git@bitbucket.org:melito/dotfiles.git $HOME/dotfiles
#sh $HOME/dotfiles/setup.sh

#ln -s ${WIN_HOME} $HOME/home

brew install neovim

cargo install sheldon cargo-update zoxide
#cargo install --git https://github.com/astral-sh/uv uv
curl -LsSf https://astral.sh/uv/install.sh | sh

echo GIT_SSH_COMMAND=\'ssh -o StrictHostKeyChecking=no\' git clone --branch personal-use git@github.com:melito00/kickstart.nvim.git $HOME/.config/kickstart.nvim

