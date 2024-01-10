#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "Starting printer script"
echo "Script based on https://www.tomshardware.com/how-to/raspberry-pi-print-server"

echo "Installing driver for Samsung CLX-3180 and samba"
sudo apt install printer-driver-foo2zjs samba -y
# sudo apt install printer-driver-splix

echo "Adding static IP"
sudo echo -e "interface wlan0 \nstatic ip_address=192.168.50.99/24 \nstatic routers=192.168.50.1 \nstatic domain_name_servers=192.168.50.1" > /etc/dhcpcd.conf

echo "Setting up CUPS"
sudo cupsctl --remote-any
sudo usermod -a -G lpadmin gadzbi
sudo systemctl restart cups

echo "Setting up Samba for Windows x64"
sudo systemctl start samba

echo "Changing /etc/samba/smb.conf"
sudo cp /etc/samba/smb.conf /etc/samba/smb.bak
sudo sed -ie 's@\[global\]@\[global\]\nspoolss: architecture = Windows x64@g;s@/var/tmp@/var/spool/samba@g;s@^   guest ok = no@   guest ok = yes@' /etc/samba/smb.conf
echo "Adding ssh to PI"
sudo systemctl enable ssh
sudo systemctl start ssh
echo "launch browser with address http://raspberrypi:631/ and add a printer (REMEMBER to share it)"
read;
echo "Based on https://wiki.ipfire.org/addons/cups"
echo "Add printers -> printer that isn't listed -> http://192.168.50.31:631/printers/Samsung_CLX-3180"
echo "Print document and enjoy!"
