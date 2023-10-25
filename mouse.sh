#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# from ckb-next wiki -> https://github.com/ckb-next/ckb-next/wiki/Linux-Installation
sudo apt-get install build-essential cmake libudev-dev qtbase5-dev zlib1g-dev libpulse-dev libquazip5-dev libqt5x11extras5-dev libxcb-screensaver0-dev libxcb-ewmh-dev libxcb1-dev qttools5-dev git libdbusmenu-qt5-dev git
git clone https://github.com/ckb-next/ckb-next
cd ckb-next
./quickinstall
