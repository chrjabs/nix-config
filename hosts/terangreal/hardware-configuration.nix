{
  lib,
  inputs,
  config,
  modulesPath,
  ...
}:
let
  hostname = config.networking.hostName;
in
{
  imports = [
    inputs.disko.nixosModules.disko
    (modulesPath + "/profiles/qemu-guest.nix")

    ../common/optional/systemd-initrd.nix
    ../common/optional/ephemeral-btrfs.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "virtio_pci"
        "usbhid"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  nixpkgs.hostPlatform = "aarch64-linux";

  disko.devices.disk."${hostname}" = {
    device = lib.mkDefault "/dev/sda";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          name = "boot";
          size = "1M";
          type = "EF02";
        };
        esp = {
          name = "ESP";
          size = "500M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          name = hostname;
          size = "100%";
          content =
            let
              this = config.disko.devices.disk.${hostname}.content.partitions.root.content;
            in
            {
              type = "btrfs";
              extraArgs = [
                "-f"
                "-L${hostname}"
              ];
              postCreateHook = ''
                MNTPOINT=$(mktemp -d)
                mount -t btrfs "${this.device}" "$MNTPOINT"
                trap 'umount $MNTPOINT; rm -d $MNTPOINT' EXIT
                btrfs subvolume snapshot -r $MNTPOINT/root $MNTPOINT/root-blank
              '';
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/swap" = {
                  mountpoint = "/.swapvol";
                  swap.swapfile.size = "20M";
                };
              };
            };
        };
      };
    };
  };
}
