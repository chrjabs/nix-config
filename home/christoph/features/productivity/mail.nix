{
  pkgs,
  lib,
  config,
  workMode,
  ...
}:
let
  pass = lib.getExe config.programs.password-store.package;
  oama = lib.getExe config.programs.oama.package;

  common = rec {
    realName = "Christoph Jabs";
    gpg = {
      key = "47D6 1FEB CD86 F3EC D2E3  D68A 83D0 74F3 48B2 FD9D";
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
in
{
  options = {
    accounts.email.mainAccountPattern = lib.mkOption {
      type = lib.types.str;
      default = "*";
      description = "custom option for matching the main accounts in waybar module";
    };
  };

  config = {
    home.persistence."/persist/${config.home.homeDirectory}".directories = [ "Mail" ];

    accounts.email = {
      mainAccountPattern = if workMode then "{personal,work}" else "{personal,family}";
      maildirBasePath = "Mail";

      accounts = {
        personal = rec {
          primary = !workMode;
          address = "contact@christophjabs.info";
          passwordCommand = "${pass} ${smtp.host}/${address}";

          imap.host = "mail.jabsserver.net";
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
            enable = lib.mkDefault true;
            mailboxName = "==  Personal ==";
            extraMailboxes = [
              {
                mailbox = "Archive";
                name = "  Archive";
              }
              {
                mailbox = "Drafts";
                name = "  Drafts";
              }
              {
                mailbox = "Junk";
                name = "  Junk";
              }
              {
                mailbox = "Sent";
                name = "  Sent";
              }
              {
                mailbox = "Trash";
                name = "  Deleted";
              }
            ];
          };

          msmtp.enable = true;
          smtp.host = "mail.jabsserver.net";
          userName = address;
        }
        // common;

        family = rec {
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
            enable = !workMode;
            mailboxName = "==  Family ==";
            extraMailboxes = [
              {
                mailbox = "Archives";
                name = "  Archive";
              }
              {
                mailbox = "Drafts";
                name = "  Drafts";
              }
              {
                mailbox = "Spam";
                name = "  Junk";
              }
              {
                mailbox = "Sent";
                name = "  Sent";
              }
              {
                mailbox = "Trash";
                name = "  Deleted";
              }
            ];
          };

          msmtp.enable = true;
          smtp.host = "mx2f80.netcup.net";
          userName = address;
        }
        // common;

        work = rec {
          primary = workMode;
          address = "christoph.jabs@helsinki.fi";
          passwordCommand = "${oama} access ${address}";

          imap.host = "outlook.office365.com";
          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "both";
            extraConfig.account.AuthMechs = "XOAUTH2";
          };
          folders = {
            inbox = "Inbox";
            drafts = "Drafts";
            sent = "Sent Items";
            trash = "Deleted Items";
          };
          neomutt = {
            enable = workMode;
            mailboxName = "==  Work ==";
            extraMailboxes = [
              {
                mailbox = "GitHub";
                name = "  GitHub";
              }
              {
                mailbox = "Archive";
                name = "  Archive";
              }
              {
                mailbox = "Drafts";
                name = "  Drafts";
              }
              {
                mailbox = "Junk Email";
                name = "  Junk";
              }
              {
                mailbox = "Deleted Items";
                name = "  Deleted";
              }
              {
                mailbox = "Publication News";
                name = "  Publication News";
              }
            ];
          };

          msmtp = {
            enable = true;
            extraConfig.auth = "xoauth2";
          };
          smtp = {
            host = "smtp.office365.com";
            port = 587;
            tls.useStartTls = true;
          };
          userName = "chrisjab@ad.helsinki.fi";
        }
        // common;

        jabsserver = rec {
          address = "admin@jabsserver.net";
          passwordCommand = "${pass} ${smtp.host}/${address}";

          imap.host = "mail.jabsserver.net";
          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "both";
          };
          neomutt = {
            enable = !workMode;
            mailboxName = "==  Jabsserver ==";
            extraMailboxes = [
              {
                mailbox = "Trash";
                name = "  Trash";
              }
              {
                mailbox = "omv";
                name = "  OMV";
              }
            ];
          };

          msmtp.enable = true;
          smtp.host = "mail.jabsserver.net";
          userName = address;

          realName = "Jabsserver Admin";
        };
      };
    };

    programs.mbsync = {
      enable = true;
      package = pkgs.isync.override { withCyrusSaslXoauth2 = true; };
    };
    programs.msmtp.enable = true;

    services.mbsync = {
      enable = true;
      package = config.programs.mbsync.package;
      preExec = ''
        ${pkgs.coreutils}/bin/mkdir -m700 -p ${
          lib.concatStringsSep " " (
            lib.mapAttrsToList (_: v: v.maildir.absPath) config.accounts.email.accounts
          )
        }
      '';
    };

    # Only run if gpg is unlocked
    systemd.user.services.mbsync.Service.ExecCondition =
      let
        gpgCmds = import ../cli/gpg-commands.nix { inherit pkgs config lib; };
      in
      ''
        /bin/sh -c "${gpgCmds.isUnlocked}"
      '';
  };
}
