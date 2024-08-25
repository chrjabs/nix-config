# NixOS Configuration

- Based on [Misterio77's standard starter config](https://github.com/Misterio77/nix-starter-configs)
- Heavily inspired by [Misterio77's nix confi](https://github.com/Misterio77/nix-config)

## Bootstrapping

To bootstrap a new system from scratch, from a live install system, run the following commands:

```bash
# Set Luks Password, if not using other secret method
echo "mypwd" > /tmp/secret.key
# Format disk using disko
sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko' -- --mode disko --flake '<flake-url>#<host>'
# Unmount all subvolumes
sudo umount {/mnt/{persist,nix,.swapvol},/mnt}
# Mount root of file system
sudo mount -t btrfs -o subvol=/ /mnt
# Create read-only blank snapshot for root volume to roll back to
sudo btrfs snapshot -r /mnt/root /mnt/root-blank
# Unmount
sudo umount /mnt
# Install with disko install in mount mode
sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko#disko-install' -- --mode mount --flake '<flake-url>#<host>'
```
