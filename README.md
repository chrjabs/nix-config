# NixOS Configuration

- Based on [Misterio77's standard starter config](https://github.com/Misterio77/nix-starter-configs)
- Heavily inspired by [Misterio77's nix confi](https://github.com/Misterio77/nix-config)

## Bootstrapping

On another machine, do the following to set up an SSH host key for the new
system.

```bash
ssh-keygen -t ed25519 -f /tmp/ssh_host_ed25519_key
cp /tmp/ssh_host_ed25519_key.pub $FLAKE/hosts/<hostname>/
cat /tmp/ssh_host_ed25519_key.pub | ssh-to-age > /tmp/age.pub
```

Put the contents of `/tmp/age.pub` into `.sops.yaml` and update the secrets
file(s).

```bash
sops updatekeys $FLAKE/hosts/common/secrets.yaml
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
# Copy the SSH keypair to the persist volume
sudo mkdir -p /mnt/persist/etc/ssh/
sudo cp <keypair> /mnt/persist/etc/ssh/
# Unmount all subvolumes
sudo umount {/mnt/{persist,nix,.swapvol,boot},/mnt}
# Mount root of file system
sudo mount -t btrfs -o subvol=/ /dev/mapper/<hostname> /mnt
# Create read-only blank snapshot for root volume to roll back to
sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
# Unmount
sudo umount /mnt
# Install with disko-install in mount mode
sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko#disko-install' -- --mode mount --disk <hostname> <devpath> --flake '/tmp/nix-config#<host>'
```

Reboot into the newly-installed system.
If the live ISO runs out of storage space while installing the system, either
mount a larger tmpfs at `/nix/.rw-store` or install a basic system on the
machine first and install from there.
