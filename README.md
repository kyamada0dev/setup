
# cloud-init for WSL with Ubuntu-24.04

## Preparation

mkdir %USERPROFILE%/.cloud-init

## Steps

cp ubuntu-devuser.user-data %USERPROFILE%/.cloud-init
scp nuc:work/setup-kyamada0dev/ubuntu-devuser.user-data %USERPROFILE%/.cloud-init
scp nuc:work/setup-kyamada0dev/wsl-ubuntu-devuser.sh %USERPROFILE%/.cloud-init

wsl --install Ubuntu-24.04 --name ubuntu-devuser

bash "$(wslpath "$(wslvar USERPROFILE)")/.cloud-init/wsl-ubuntu-devuser.sh"
