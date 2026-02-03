{ config, ... }:
{
  sops.secrets = {
    pocket-id-encryption-key = {
      sopsFile = ../secrets.yaml;
      owner = config.services.pocket-id.user;
    };
    pocket-id-mail-password = {
      sopsFile = ../secrets.yaml;
      owner = config.services.pocket-id.user;
    };
    pocket-id-maxmind-license-key = {
      sopsFile = ../secrets.yaml;
      owner = config.services.pocket-id.user;
    };
  };

  services = {
    pocket-id = {
      enable = true;
      dataDir = "/srv/pocket-id";
      settings =
        let
          email = "no-reply@id.jabsserver.net";
        in
        {
          TRUST_PROXY = true;
          APP_URL = "https://id.jabsserver.net";
          UI_CONFIG_DISABLED = true;
          ALLOW_USER_SIGNUPS = "disabled";
          SMTP_HOST = "mail.jabsserver.net";
          SMTP_PORT = "465";
          SMTP_TLS = "tls";
          SMTP_FROM = email;
          SMTP_USER = email;
          EMAIL_VERIFICATION_ENABLED = true;
          EMAIL_LOGIN_NOTIFICATION_ENABLED = true;
        };
      credentials = {
        ENCRYPTION_KEY = config.sops.secrets.pocket-id-encryption-key.path;
        MAXMIND_LICENSE_KEY = config.sops.secrets.pocket-id-maxmind-license-key.path;
        SMTP_PASSWORD = config.sops.secrets.pocket-id-mail-password.path;
      };
    };

    nginx.virtualHosts = {
      "id.jabsserver.net" = {
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:1411";
            proxyWebsockets = true;
          };
        };
      };
    };
  };

  environment.persistence = {
    "/persist".directories = [
      "/srv/pocket-id"
    ];
  };
}
