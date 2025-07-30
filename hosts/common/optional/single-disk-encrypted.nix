{
  config,
  inputs,
  ...
}:
let
  hostname = config.networking.hostName;
in
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      "${hostname}" = {
        type = "disk";
        # Note: this needs to be set for each host
        # device = lib.mkDefault "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            crypt = {
              size = "100%";
              content = {
                type = "luks";
                name = hostname;
                passwordFile = "/tmp/secret.key"; # Interactive
                settings.allowDiscards = true;
                content =
                  let
                    this = config.disko.devices.disk.${hostname}.content.partitions.crypt.content.content;
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
      };
    };
  };
}
