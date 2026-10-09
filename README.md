
# cloud-init for WSL with Ubuntu-26.04

## Preparation

wsl --update

mkdir $env:USERPROFILE\.cloud-init

## Steps

cp ubuntu-dev.user-data %USERPROFILE%/.cloud-init
scp nuc:work/setup-kyamada0dev/ubuntu-dev.user-data $env:USERPROFILE\.cloud-init
scp nuc:work/setup-kyamada0dev/setup-ubuntu-user.sh $env:USERPROFILE\.cloud-init

wsl.exe --install --distribution Ubuntu-26.04 --no-launch --name ubuntu-dev
wsl.exe -d ubuntu-dev -u root exec cloud-init status --wait --format json

wsl.exe -d ubuntu-dev

## bash "$(wslpath "$(wslvar USERPROFILE)")/.cloud-init/setup-ubuntu-user.sh"
zsh /mnt/c/Users/"$(id -un)"/.cloud-init/setup-ubuntu-user.sh
