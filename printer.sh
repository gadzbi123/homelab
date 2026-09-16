#!/usr/bin/env bash

# Share the USB-connected Samsung CLX-3180/3185 on the local network.
set -euo pipefail

# Include administrative commands when launched from cron or another service.
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_SUSPEND=1

if (( EUID != 0 )); then
    echo "Run as root: sudo ./printer.sh" >&2
    exit 1
fi

apt-get update
apt-get install -y --no-install-recommends \
    avahi-daemon cups cups-client printer-driver-foo2zjs

systemctl enable --now cups avahi-daemon

# Permit the account that invoked sudo to administer CUPS in a browser.
[[ -z ${SUDO_USER:-} || $SUDO_USER == root ]] || usermod -aG lpadmin "$SUDO_USER"

printer_name=Samsung_CLX-3180
device_uri=$(lpinfo -v | awk '
    $1 == "direct" && tolower($2) ~ /^usb:\/\/samsung\/clx-3180/ {
        print $2
        exit
    }
')
driver=$(lpinfo -m | awk '
    tolower($0) ~ /samsung clx-3185/ && tolower($0) ~ /foo2qpdl/ {
        print $1
        exit
    }
')

[[ -n $device_uri ]] || { echo "Samsung CLX-3180 not found on USB" >&2; exit 1; }
[[ -n $driver ]] || { echo "Samsung CLX-3185 driver not found" >&2; exit 1; }

lpadmin -p "$printer_name" -E -v "$device_uri" -m "$driver" \
    -D "Samsung CLX-3185" -L "Home" -o PageSize=A4 \
    -o ColorMode=Color -o print-color-mode=color \
    -o printer-is-shared=true

# CUPS advertises the printer with Avahi and permits administration only on local LANs.
cupsctl --share-printers --remote-admin --no-remote-any \
    BrowseLocalProtocols=dnssd DefaultShared=Yes
systemctl restart cups avahi-daemon

echo "Printer ready at ipp://$(hostname -s).local:631/printers/$printer_name"
