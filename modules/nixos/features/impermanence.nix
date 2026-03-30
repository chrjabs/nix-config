{ self, inputs, ... }:
{
  flake.nixosModules.impermanenceSetup =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.persistence;
    in
    {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      config =
        let
          hostname = config.networking.hostName;
          wipeScript = ''
            mkdir -p /tmp
            MNTPOINT=$(mktemp -d)
            (
              mount -t btrfs -o subvol=/ /dev/mapper/${hostname} "$MNTPOINT"
              trap 'umount "$MNTPOINT"' EXIT

              echo "Creating needed directories"
              mkdir -p "$MNTPOINT"/persist/var/{log,lib/{nixos,systemd}}
              if [ -e "$MNTPOINT/persist/dont-wipe" ]; then
                echo "Skipping wip"
              else
                echo "Cleaning root subvolume"
                btrfs subvolume list -o "$MNTPOINT/root" | cut -f9 -d ' ' |
                while read -r subvolume; do
                  btrfs subvolume delete "$MNTPOINT/$subvolume"
                done && btrfs subvolume delete "$MNTPOINT/root"

                echo "Restoring black subvolume"
                btrfs subvolume snapshot "$MNTPOINT/root-blank" "$MNTPOINT/root"
              fi
            )
          '';
          phase1Systemd = config.boot.initrd.systemd.enable;
        in
        lib.mkIf cfg.enable {
          boot = {
            tmp.cleanOnBoot = lib.mkDefault true;
            initrd = {
              supportedFilesystems = [ "btrfs" ];
              postDeviceCommands = lib.mkIf (cfg.nukeRoot && !phase1Systemd) (lib.mkBefore wipeScript);
              systemd.services.restore-root = lib.mkIf (cfg.nukeRoot && phase1Systemd) {
                description = "Rollback btrfs rootfs";
                wantedBy = [ "initrd.target" ];
                requires = [ "dev-disk-by\\x2dlabel-${hostname}.device" ];
                after = [
                  "dev-disk-by\\x2dlabel-${hostname}.device"
                  "systemd-cryptsetup@${hostname}.service"
                ];
                before = [ "sysroot.mount" ];
                unitConfig.DefaultDependencies = "no";
                serviceConfig.Type = "oneshot";
                script = wipeScript;
              };
            };
          };

          fileSystems."/persist".neededForBoot = true;

          programs.fuse.userAllowOther = true;

          environment.persistence = {
            "/persist" = {
              enable = true;

              directories = [
                "/var/lib/systemd"
                "/var/lib/nixos"
                "/var/log"
              ]
              ++ cfg.directories;

              files = [ "/etc/machine-id" ] ++ cfg.files;
            };
          };
        };
    };

  flake.nixosModules.impermanence = {
    imports = [
      self.nixosModules.impermanenceSetup
    ];

    persistence.enable = true;
  };
}
