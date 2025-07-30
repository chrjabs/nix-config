# This file defines the "non-hardware dependent" part of opt-in persistence
# It imports impermanence, defines the basic persisted dirs, and ensures each
# users' home persist dir exists and has the right permissions
{
  lib,
  config,
  ...
}:
{
  environment.persistence = {
    "/persist" = {
      enable = true;
      directories =
        [
          "/var/lib/systemd"
          "/var/lib/nixos"
          "/var/log"
        ]
        ++ lib.optionals config.hardware.bluetooth.enable [ "/var/lib/bluetooth" ]
        ++ lib.optionals config.programs.regreet.enable [ "/var/lib/regreet" ];
    };
  };

  programs.fuse.userAllowOther = true;

  system.activationScripts.persistent-dirs.text =
    let
      mkHomePersist =
        user:
        lib.optionalString user.createHome ''
          mkdir -p /persist/${user.home}
          chown ${user.name}:${user.group} /persist/${user.home}
          chmod ${user.homeMode} /persist/${user.home}
        '';
      users = lib.attrValues config.users.users;
    in
    lib.concatLines (map mkHomePersist users);
}
