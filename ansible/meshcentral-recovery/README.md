# MeshCentral recovery

This directory contains the playbook and an Ansible Vault–encrypted snapshot
of `/var/lib/meshcentral/data/config.json` from the rock device.

The repository snapshot is encrypted because the MeshCentral configuration can
contain credentials and private keys. The vault password is stored locally on
the rock device and is not committed to Git.

## Check the live configuration

From this directory:

```sh
ansible-playbook -i inventory.yml meshcentral-recovery.yml \
  --vault-password-file /home/gadzbi/.config/ansible/homelab-vault-password
```

## Restore the repository snapshot

The playbook first saves the current live configuration under
`/home/gadzbi/meshcentral-recovery/`, then restores the encrypted snapshot:

```sh
ansible-playbook -i inventory.yml meshcentral-recovery.yml \
  --vault-password-file /home/gadzbi/.config/ansible/homelab-vault-password \
  -e meshcentral_restore=true
```

To restart MeshCentral after restoring, also add:

```sh
-e meshcentral_restart_service=true
```

The playbook does not restart the service by default because the installation's
service name may differ.
