#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Variables
IS_STABLE=1

branch=stable
if [IS_STABLE -ne 1]; then
  branch=candidate
fi

sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing ${branch}" | sudo tee /etc/apt/sources.list.d/syncthing.list
sudo apt-get update
sudo apt-get install syncthing

if [ ! -d "~/.config/systemd" ];
then 
	mkdir ~/.config/systemd
fi

if [ ! -d "~/.config/systemd/user" ];
then 
	mkdir ~/.config/systemd/user
fi

curl "https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-systemd/user/syncthing.service" > ~/$USER/.config/systemd/user/syncthing.service

# Automaticly start on reboot
systemctl --user enable syncthing.service
systemctl --user start syncthing.service

echo "Run 'systemctl --user status syncthing.service' to check syncthing"