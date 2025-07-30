{
  pkgs,
  lib,
  config,
  ...
}:
let
  pass = lib.getExe config.programs.password-store.package;
in
{
  home.persistence."/persist/${config.home.homeDirectory}".directories = [
    "Calendars"
    "Contacts"
    ".local/share/vdirsyncer"
  ];

  programs.vdirsyncer.enable = true;

  accounts.calendar = {
    basePath = "Calendars";
    accounts = {
      nextcloud = {
        primary = true;
        primaryCollection = "Christoph";
        local = {
          fileExt = ".ics";
          type = "filesystem";
        };
        remote = {
          type = "caldav";
          url = "https://cloud.jabsserver.net";
          userName = "christoph";
          passwordCommand = [
            "${pass}"
            "cloud.jabsserver.net/christoph-vdirsync"
          ];
        };
        vdirsyncer = {
          enable = true;
          collections = [
            "from a"
            "from b"
          ];
          metadata = [
            "color"
            "displayname"
          ];
          conflictResolution = "remote wins";
        };
        khal = {
          enable = true;
          type = "discover";
        };
      };
    };
  };

  accounts.contact = {
    basePath = "Contacts";
    accounts = {
      nextcloud = {
        local = {
          fileExt = ".vcf";
          type = "filesystem";
        };
        remote = {
          type = "carddav";
          url = "https://cloud.jabsserver.net";
          userName = "christoph";
          passwordCommand = [
            "${pass}"
            "cloud.jabsserver.net/christoph-vdirsync"
          ];
        };
        vdirsyncer = {
          enable = true;
          collections = [
            "from a"
            "from b"
          ];
          conflictResolution = "remote wins";
        };
      };
    };
  };

  systemd.user.services.vdirsyncer = {
    Unit = {
      Description = "vdirsyncer synchronization";
    };
    Service =
      let
        gpgCmds = import ../cli/gpg-commands.nix {
          inherit pkgs;
          inherit lib;
        };
      in
      {
        Type = "oneshot";
        ExecCondition = ''
          /bin/sh -c "${gpgCmds.isUnlocked}"
        '';
        ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
      };
  };
  systemd.user.timers.vdirsyncer = {
    Unit = {
      Description = "Automatic vdirsyncer synchronization";
    };
    Timer = {
      OnBootSec = "30";
      OnUnitActiveSec = "5m";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
