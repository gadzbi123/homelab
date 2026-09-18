#!/bin/sh
# Interactive first-boot helper. Wi-Fi credentials are passed directly to
# NetworkManager and are never stored in this repository.
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if ! ping -c 1 -W 3 1.1.1.1 >/dev/null 2>&1; then
    if ! command -v nmcli >/dev/null 2>&1; then
        echo "No internet connection and nmcli is unavailable." >&2
        echo "Connect Ethernet, or run: sudo raspi-config" >&2
        exit 1
    fi

    sudo nmcli radio wifi on
    sudo nmcli device wifi rescan || true
    sudo nmcli --fields SSID,SIGNAL,SECURITY device wifi list
    printf 'Wi-Fi SSID: '
    IFS= read -r wifi_ssid
    [ -n "$wifi_ssid" ] || { echo "SSID cannot be empty" >&2; exit 1; }
    # --ask lets NetworkManager request the password without exposing it in
    # shell history or the process list.
    sudo nmcli --ask device wifi connect "$wifi_ssid"
fi

ping -c 3 1.1.1.1
ping -c 3 debian.org
exec "$script_dir/bootstrap.sh" "$@"

