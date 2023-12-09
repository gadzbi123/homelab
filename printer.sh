#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "Starting printer script"
echo "Script based on https://www.tomshardware.com/how-to/raspberry-pi-print-server"

# maybe needed for samsung printers
# sudo apt install printer-driver-splix

# driver for samsung-clx-3185 printer
sudo apt install printer-driver-foo2zjs

# set up CUPS https://www.tomshardware.com/how-to/raspberry-pi-print-server
sudo echo -e "interface wlan0 \nstatic ip_address=192.168.50.99/24 \nstatic routers=192.168.50.1 \nstatic domain_name_servers=192.168.50.1" > /etc/dhcpcd.conf
sudo cupsctl --remote-any
sudo systemctl restart cups

# set up samba for Windows users
sudo apt install samba
sudo systemctl start samba

echo "Changing /etc/samba/smb.conf"
sudo cp /etc/samba/smb.conf /etc/samba/smb.bak
sudo sed -ie 's@\[global\]@\[global\]\nspoolss: architecture = Windows x64@g;s@/var/tmp@/var/spool/samba@g;s@^   guest ok = no@   guest ok = yes@' /etc/samba/smb.conf
echo "Adding ssh to PI"
sudo systemctl enable ssh
sudo systemctl start ssh
echo "launch browser with address http://raspberrypi:631/ and add a printer"
read;
echo "Add printer on Windows -> https://wiki.ipfire.org/addons/cups"
read;
echo "Print document and enjoy!"
