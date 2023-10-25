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

echo "change or add lines below to /etc/samba/smb.conf and press Enter"
cat << EOF
[global]
spoolss: architecture = Windows x64

# CUPS printing.
[printers]
comment = All Printers
browseable = no
path = /var/spool/samba
printable = yes
guest ok = yes
read only = yes
create mask = 0700

# Windows clients look for this share name as a source of downloadable
# printer drivers
[print$]
comment = Printer Drivers
path = /var/lib/samba/printers
browseable = yes
read only = no
guest ok = no
EOF
read;
echo "launch browser with address http://raspberrypi:631/ and add a printer"
read;
echo "Add printer on Windows -> https://wiki.ipfire.org/addons/cups"
read;
echo "Print document and enjoy!"
