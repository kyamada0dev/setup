#!/bin/zsh

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
