{
  pkgs,
  config,
  ...
}: let
  pass = "${config.programs.password-store.package}/bin/pass";
in {
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
        primaryCollection = "personal";
        local = {
          fileExt = ".ics";
          type = "filesystem";
        };
        remote = {
          type = "caldav";
          url = "https://cloud.jabsserver.net";
          userName = "christoph";
          passwordCommand = ["${pass}" "cloud.jabsserver.net/christoph-vdirsync"];
        };
        vdirsyncer = {
          enable = true;
          collections = ["from a" "from b"];
          metadata = ["color" "displayname"];
          conflictResolution = "remote wins";
        };
        khal = {
          enable = true;
          type = "discover";
        };
      };
    };
  };

  programs.khal = {
    enable = true;
    locale = {
      timeformat = "%H:%M";
      dateformat = "%d/%m/%Y";
      weeknumbers = "left";
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
          passwordCommand = ["${pass}" "cloud.jabsserver.net/christoph-vdirsync"];
        };
        vdirsyncer = {
          enable = true;
          collections = ["from a" "from b"];
          conflictResolution = "remote wins";
        };
      };
    };
  };

  # Need to manually configure khard because home manager does not support
  # specifying a subcollection for khard
  home.packages = with pkgs; [khard];
  xdg.configFile."khard/khard.conf".text =
    /*
    toml
    */
    ''
      [addressbooks]
      [[contacts]]
      path = ~/Contacts/nextcloud/contacts

      [general]
      default_action=list
    '';

  systemd.user.services.vdirsyncer = {
    Unit = {
      Description = "vdirsyncer synchronization";
    };
    Service = let
      gpgCmds = import ../cli/gpg-commands.nix {inherit pkgs;};
    in {
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
      WantedBy = ["timers.target"];
    };
  };
}
