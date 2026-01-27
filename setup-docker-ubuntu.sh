#!/bin/sh

echo 'Setup docker'
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

curl -fsSL https://get.docker.com | sudo sh

sudo usermod -aG docker "$USER"
echo 'exec "newgrp docker"'
