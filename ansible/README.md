# Animated frame Ansible deployment

This playbook turns a Debian/Raspberry Pi OS machine into the unattended
animated framebuffer currently used by the Raspberry Pi. It installs all
runtime packages, checks out the artwork, configures access and user lingering,
installs the systemd units and CLI, enables unattended startup, and verifies the
service. It also installs/enables Tailscale, manages the existing T3 Code user
service, and installs a monitor detection/resize hook.

## Deploy locally

For a fresh Pi, run the interactive first-boot helper from this directory:

```sh
./prepare-pi.sh
```

It checks internet access and, when offline, lists nearby Wi-Fi networks and
asks NetworkManager for the credentials. The password is not written to this
repository or exposed on the command line. If NetworkManager is not available,
connect Ethernet temporarily or use `sudo raspi-config` and select **System
Options → Wireless LAN**.

When networking is already configured, run:

```sh
./bootstrap.sh
```

`bootstrap.sh` installs Ansible when needed, then runs the complete playbook.
Later updates use the same command or `pixel-frame update`.

## Deploy over SSH

Change `inventory.yml` to use the Pi's address and remove
`ansible_connection: local`, then run:

```sh
ansible-playbook site.yml --ask-become-pass
```

Settings such as frame rate, initial scene, Git revision, device, and console
are in `group_vars/all.yml`. Host-specific overrides can be placed in
`host_vars/pixel-frame.yml`.

Tailscale is installed and enabled automatically. To authenticate a new node,
store `tailscale_auth_key` in Ansible Vault and pass the vault file when running
the playbook. Leaving it empty preserves an existing Tailscale login. The
playbook never commits a key.

T3 Code must already be installed by its official installer; Ansible verifies
the configured binary and owns the boot service afterward. Override
`t3code_binary` when the installed version is different.

The monitor helper reports the live framebuffer dimensions with `fbset` and
optionally runs `monitor_resize_command`. The animated renderer itself reads
the framebuffer dimensions at runtime, so no fixed HDMI mode is required.

The playbook installs and enables NetworkManager and configures the TTY with a
large Terminus `16x32` font. Change `console_font_face` or `console_font_size`
in `group_vars/all.yml` if needed. No reboot is normally required because
`setupcon` applies it immediately.

GUI font scaling is desktop-specific and is intentionally not forced on this
headless framebuffer setup. On Raspberry Pi Desktop use **Preferences →
Appearance Settings → Defaults** and increase the font size or DPI. For the
terminal use **Edit → Preferences → Style**. Log out and back in if some GUI
applications retain the old size.

By default the playbook enables passwordless console autologin on `tty1`. This
lets the unprivileged display service own the active console immediately after
boot and reliably hide its cursor. Set `pixel_frame_console_autologin: false`
for a shared machine; the display will then need a local console login before
it can control the cursor.

Useful commands after deployment:

```sh
pixel-frame status
pixel-frame logs
pixel-frame restart
pixel-frame run sakura
```
