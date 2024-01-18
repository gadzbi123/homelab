#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "Starting printer script"
echo "Script based on https://www.bchemnet.com/suldr/index.html, https://wiki.ipfire.org/addons/cups, https://www.tomshardware.com/how-to/raspberry-pi-print-server"
echo "Installing external repo for Samsung Drivers"
sudo bash -c 'echo "deb https://www.bchemnet.com/suldr/ debian extra" >> /etc/apt/sources.list'
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv FB510D557CC3E840 
gpg --export --armor FB510D557CC3E840 | sudo apt-key add -
sudo apt update -y

echo "Installing driver for Samsung CLX-3180"
sudo apt install suld-driver2-1.00.39hp suld-driver2-common-1 -y

echo "Adding static IP"
sudo echo -e "interface wlan0 \nstatic ip_address=192.168.50.99/24 \nstatic routers=192.168.50.1 \nstatic domain_name_servers=192.168.50.1" > /etc/dhcpcd.conf

echo "Setting up CUPS"
sudo cupsctl --remote-any
sudo usermod -a -G lpadmin gadzbi
sudo systemctl restart cups

echo "launch browser with address http://raspberrypi:631/ and add a printer (REMEMBER to share it)"
echo "Add printers -> printer that isn't listed -> http://192.168.50.31:631/printers/Samsung_CLX-3180"
echo "Make sure to set correct driver: Samsung CLX-3180 Series!"
echo "Print document and enjoy!"