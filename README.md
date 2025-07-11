# NixOS Configuration

- Based on [Misterio77's standard starter config](https://github.com/Misterio77/nix-starter-configs)
- Heavily inspired by [Misterio77's nix confi](https://github.com/Misterio77/nix-config)

## Wallpapers

Many cool minimalist wallpapers that work quite well with the recolouring
process I'm using can be found [here](https://simpledesktops.com/).

## Bootstrapping

On another machine, do the following to set up an SSH host key for the new
system.

```bash
ssh-keygen -t ed25519 -f /tmp/ssh_host_ed25519_key
cp /tmp/ssh_host_ed25519_key.pub $NH_FLAKE/hosts/<hostname>/
cat /tmp/ssh_host_ed25519_key.pub | ssh-to-age > /tmp/age.pub
```

Put the contents of `/tmp/age.pub` into `.sops.yaml` and update the secrets
file(s).

```bash
sops updatekeys $NH_FLAKE/hosts/common/secrets.yaml
```

Commit and push the changes.
In some way or another, transfer the new key pair to the system you want to
bootstrap.

To bootstrap the system itself, from a live install system, run the following
commands:

```bash
# Set Luks Password, if not using other secret method
echo "mypwd" > /tmp/secret.key
# Format disk using disko
sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko' -- --mode disko --flake '/tmp/nix-config#<host>'
# Optionally enroll YubiKey as crypt device
sudo systemd-cryptenroll <dev> --fido2-device=auto --fido2-with-client-pin=yes
# Copy the SSH keypair to the persist volume
sudo mkdir -p /mnt/persist/etc/ssh/
sudo cp <keypair> /mnt/persist/etc/ssh/
# Unmount all subvolumes
sudo umount {/mnt/{persist,nix,.swapvol,boot},/mnt}
# Install with disko-install in mount mode
sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko#disko-install' -- --mode mount --disk <hostname> <devpath> --flake '/tmp/nix-config#<host>'
```

Reboot into the newly-installed system.
If the live ISO runs out of storage space while installing the system, either
mount a larger tmpfs at `/nix/.rw-store` or install a basic system on the
machine first and install from there.
