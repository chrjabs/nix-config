{
  pkgs,
  lib,
  config,
  ...
}: let
  mbsync = "${config.programs.mbsync.package}/bin/mbsync";
  pass = "${config.programs.password-store.package}/bin/pass";
  oauth2 = import ./oauth2.nix {
    inherit pkgs;
    inherit lib;
    inherit config;
  };

  common = rec {
    realName = "Christoph Jabs";
    gpg = {
      key = "1017 77DD 58F9 4B40 5E6E  585C 217C 6A43 9646 D51E";
      signByDefault = true;
    };
    signature = {
      showSignature = "append";
      text = ''
        ${realName}

        https://christophjabs.info
        PGP: ${gpg.key}
      '';
    };
  };
in {
  home.persistence."/persist/${config.home.homeDirectory}".directories = ["Mail"];

  home.packages = [
    oauth2.mutt_oauth2
    oauth2.work.authorize
    # oauth2.gmail.authorize
  ];

  accounts.email = {
    maildirBasePath = "Mail";
    accounts = {
      personal =
        rec {
          primary = true;
          address = "christoph@jabs-family.de";
          passwordCommand = "${pass} ${smtp.host}/${address}";

          imap.host = "mx2f80.netcup.net";
          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "both";
          };
          folders = {
            inbox = "Inbox";
            drafts = "Drafts";
            sent = "Sent";
            trash = "Trash";
          };
          neomutt = {
            enable = true;
            mailboxName = "Personal - Inbox";
            extraMailboxes = [
              {
                mailbox = "Archives";
                name = "Personal - Archive";
              }
              {
                mailbox = "Drafts";
                name = "Personal - Drafts";
              }
              {
                mailbox = "Spam";
                name = "Personal - Junk";
              }
              {
                mailbox = "Sent";
                name = "Personal - Sent";
              }
              {
                mailbox = "Trash";
                name = "Personal - Deleted";
              }
            ];
          };

          msmtp.enable = true;
          smtp.host = "mx2f80.netcup.net";
          userName = address;
        }
        // common;

      work =
        rec {
          address = "christoph.jabs@helsinki.fi";
          passwordCommand = oauth2.work.pwd_cmd;

          imap.host = "outlook.office365.com";
          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "both";
            extraConfig.account = {
              AuthMechs = "XOAUTH2";
            };
          };
          folders = {
            inbox = "Inbox";
            drafts = "Drafts";
            sent = "Sent Items";
            trash = "Deleted Items";
          };
          neomutt = {
            enable = true;
            mailboxName = "Work - Inbox";
            extraMailboxes = [
              {
                mailbox = "GitHub";
                name = "Work - GitHub";
              }
              {
                mailbox = "Archive";
                name = "Work - Archive";
              }
              {
                mailbox = "Drafts";
                name = "Work - Drafts";
              }
              {
                mailbox = "Junk Email";
                name = "Work - Junk";
              }
              {
                mailbox = "Deleted Items";
                name = "Work - Deleted";
              }
              "Publication News"
            ];
          };

          msmtp = {
            enable = true;
            extraConfig = {
              auth = "xoauth2";
            };
          };
          smtp.host = "smtp.office365.com";
          userName = "chrisjab@ad.helsinki.fi";
        }
        // common;

      # gmail =
      #   rec {
      #     address = "christoph.jabs@gmail.com";
      #     passwordCommand = oauth2.gmail.pwd_cmd;
      #
      #     imap.host = "imap.gmail.com";
      #     mbsync = {
      #       enable = true;
      #       create = "maildir";
      #       expunge = "both";
      #       extraConfig.account = {
      #         AuthMechs = "XOAUTH2";
      #       };
      #     };
      #     folders = {
      #       inbox = "Inbox";
      #       drafts = "Drafts";
      #       sent = "Sent";
      #       trash = "Deleted Messages";
      #     };
      #     neomutt = {
      #       enable = true;
      #       mailboxName = "GMail - Inbox";
      #       extraMailboxes = [
      #         {
      #           mailbox = "Drafts";
      #           name = "GMail - Drafts";
      #         }
      #         {
      #           mailbox = "Unwanted";
      #           name = "GMail - Junk";
      #         }
      #         {
      #           mailbox = "Deleted Messages";
      #           name = "Work - Deleted";
      #         }
      #       ];
      #     };
      #
      #     msmtp = {
      #       enable = true;
      #       extraConfig = {
      #         auth = "xoauth2";
      #       };
      #     };
      #     smtp.host = "smtp.gmail.com";
      #     userName = address;
      #   }
      #   // common;
    };
  };

  programs.mbsync = {
    enable = true;
    package = pkgs.isync.override {withCyrusSaslXoauth2 = true;};
  };
  programs.msmtp.enable = true;

  systemd.user.services.mbsync = {
    Unit = {
      Description = "mbsync synchronization";
    };
    Service = let
      gpgCmds = import ../cli/gpg-commands.nix {inherit pkgs;};
    in {
      Type = "oneshot";
      ExecCondition = ''
        /bin/sh -c "${gpgCmds.isUnlocked}"
      '';
      ExecStart = "${mbsync} -a";
    };
  };
  systemd.user.timers.mbsync = {
    Unit = {
      Description = "Automatic mbsync synchronization";
    };
    Timer = {
      OnBootSec = "30";
      OnUnitActiveSec = "5m";
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };

  # Run 'createMaildir' after 'linkGeneration'
  home.activation = let
    mbsyncAccounts = lib.filter (a: a.mbsync.enable) (lib.attrValues config.accounts.email.accounts);
  in
    lib.mkIf (mbsyncAccounts != []) {
      createMaildir = lib.mkForce (lib.hm.dag.entryAfter ["linkGeneration"] ''
        run mkdir -m700 -p $VERBOSE_ARG ${
          lib.concatMapStringsSep " " (a: a.maildir.absPath) mbsyncAccounts
        }
      '');
    };
}
