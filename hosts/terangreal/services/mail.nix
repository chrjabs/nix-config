{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.nixos-mailserver.nixosModules.mailserver ];

  # https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/issues/275
  services.dovecot2.sieve.extensions = [ "fileinto" ];

  mailserver = rec {
    stateVersion = 3;
    enable = true;
    fqdn = "mail.jabsserver.net";
    sendingFqdn = "terangreal.jabsserver.net";
    domains = [
      "christophjabs.info"
      "jabsserver.net"
      "cloud.jabsserver.net"
      "dash.jabsserver.net"
      "finances.jabsserver.net"
      "omv.jabsserver.net"
      "tracking.jabsserver.net"
    ];
    useFsLayout = true;
    certificateScheme = "acme-nginx";
    localDnsResolver = false;
    loginAccounts =
      let
        no-reply = subdom: {
          "no-reply@${subdom}.jabsserver.net" = {
            sendOnly = true;
            hashedPasswordFile = config.sops.secrets."${subdom}-mail-password-hashed".path;
          };
        };
      in
      {
        "contact@christophjabs.info" = {
          hashedPasswordFile = config.sops.secrets.christoph-mail-password-hashed.path;
          aliases = map (d: "@" + d) domains;
        };
        "admin@jabsserver.net" = {
          hashedPasswordFile = config.sops.secrets.jabsserver-admin-mail-password-hashed.path;
          aliases = [
            "postmaster@jabsserver.net"
            "abuse@jabsserver.net"
          ];
        };
      }
      // (no-reply "cloud")
      // (if config.services.grafana.enable then (no-reply "dash") else { })
      // (no-reply "finances")
      // (no-reply "omv")
      // (no-reply "tracking");
    mailboxes = {
      Archive = {
        auto = "subscribe";
        specialUse = "Archive";
      };
      Drafts = {
        auto = "subscribe";
        specialUse = "Drafts";
      };
      Sent = {
        auto = "subscribe";
        specialUse = "Sent";
      };
      Junk = {
        auto = "subscribe";
        specialUse = "Junk";
      };
      Trash = {
        auto = "subscribe";
        specialUse = "Trash";
      };
    };
    # When setting up check that /srv is persisted and directories exist!
    mailDirectory = "/srv/mail/vmail";
    sieveDirectory = "/srv/mail/sieve";
    dkimKeyDirectory = "/srv/mail/dkim";
  };

  # Prefer ipv4 and use main ipv6 to avoid reverse DNS issues
  # CHANGEME when switching hosts
  services.postfix.settings.main = {
    smtp_bind_address6 = "2a01:4f9:c012:eeb3::0";
    smtp_address_preference = "ipv4";
  };

  sops.secrets =
    let
      hashed-pw = id: { "${id}-mail-password-hashed".sopsFile = ../secrets.yaml; };
    in
    (hashed-pw "christoph")
    // (hashed-pw "jabsserver-admin")
    // (hashed-pw "dash")
    // (hashed-pw "omv")
    // (hashed-pw "finances")
    // (hashed-pw "cloud")
    // (hashed-pw "tracking");

  # Webmail
  services.roundcube = rec {
    enable = true;
    package = pkgs.roundcube.withPlugins (p: [ p.carddav ]);
    hostName = "mail.jabsserver.net";
    extraConfig = ''
      $config['smtp_host'] = "tls://${hostName}:587";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
      $config['plugins'] = [ "carddav" ];
    '';
  };

  # Autoconfig
  services.automx2 = {
    enable = true;
    domain = "jabsserver.net";
    settings = {
      provider = "Christoph Jabs";
      domains = [
        "jabsserver.net"
        "christophjabs.info"
      ];
      servers = [
        {
          type = "imap";
          name = "mail.jabsserver.net";
        }
        {
          type = "smtp";
          name = "mail.jabsserver.net";
        }
      ];
    };
  };
  services.nginx.virtualHosts =
    let
      redir = to: {
        enableACME = true;
        locations."/".return = "302 https://${to}$request_uri";
      };
    in
    {
      "autoconfig.christophjabs.info" = redir "autoconfig.jabsserver.net";
    };

  environment.persistence = {
    "/persist".directories = [
      "/srv/mail"
      "/var/lib/rspamd"
    ];
  };
}
