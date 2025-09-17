#!/bin/sh

echo 'Start setup script for Ubuntu 24.04 on WSL2'

echo 'Update all packages'
sudo apt-get update -y
sudo apt-get upgrade -y

echo 'Install required packages'
sudo apt-get install -y \
  zsh \
  fzf \
  jq \
  curl \
  git \
  file \
  procps \
  gnupg \
  tmux \
  vim \
  openssh-client \
  acpi-support \
  acpi-support-base

echo 'change shell from bash to zsh'
sudo chsh -s /bin/zsh $USER
#curl -sL https://raw.githubusercontent.com/kyamada0dev/setup/main/dot.zshrc.simple >"$HOME/.zshrc"
#curl -sL https://raw.githubusercontent.com/kyamada0dev/setup/main/dot.tmux.conf >"$HOME/.tmux.conf"
#curl -sL https://raw.githubusercontent.com/kyamada0dev/setup/main/dot.vimrc.simple >"$HOME/.vimrc"

mkdir -p $HOME/bin

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

git clone git@bitbucket.org:melito/dotfiles.git $HOME/dotfiles
sh $HOME/dotfiles/setup.sh

echo 'Install mise'
curl https://mise.run | MISE_INSTALL_PATH=$HOME/bin/mise sh

echo 'Install build dependencies for rust and ruby'
sudo apt install -y build-essential rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev sqlite3 libsqlite3-dev

curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path

echo 'Install build dependencies for python'
sudo apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

echo 'Install Homebrew'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

########################################################################
echo 'Setup WSLg'
sudo env SYSTEMD_EDITOR=tee systemctl edit --full --force wslg-fix.service <<EOF
[Service]
Type=oneshot
ExecStart=-/usr/bin/umount /tmp/.X11-unix
ExecStart=/usr/bin/rm -rf /tmp/.X11-unix
ExecStart=/usr/bin/mkdir /tmp/.X11-unix
ExecStart=/usr/bin/chmod 1777 /tmp/.X11-unix
ExecStart=/usr/bin/ln -s /mnt/wslg/.X11-unix/X0 /tmp/.X11-unix/X0

[Install]
WantedBy=multi-user.target
EOF

########################################################################
echo 'Setup postman'
sudo apt install -y podman podman-docker docker-compose uidmap slirp4netns fuse-overlayfs buildah

sudo touch /etc/subuid /etc/subgid
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 kyamada

systemctl --user enable --now podman.socket
