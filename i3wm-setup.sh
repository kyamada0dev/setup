#!/bin/sh

echo 'Start setup script for i3wm'

sudo apt install -y \
  dbus-x11 \
  fonts-noto-mono \
  tigervnc-standalone-server \
  lxterminal \
  i3-wm \
  i3status \
  rofi \
  polybar \
  picom

#feh --no-fehbg --bg-fill '/usr/share/backgrounds/archlinux/small.png'
#lxterminal --title 'Terminal' --command='zsh -c "sleep 1 && /usr/bin/picom-trans -c 80 && zsh -i"'

