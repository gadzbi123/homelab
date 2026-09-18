#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if ! command -v ansible-playbook >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y ansible
fi

cd "$script_dir"
exec ansible-playbook site.yml --ask-become-pass "$@"

