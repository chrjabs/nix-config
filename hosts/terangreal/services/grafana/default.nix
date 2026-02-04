{ config, ... }:
{
  sops.secrets = {
    grafana-christoph-password = {
      sopsFile = ../../secrets.yaml;
      owner = "grafana";
    };
    grafana-pocket-id-client-secret = {
      sopsFile = ../../secrets.yaml;
      owner = "grafana";
    };
    grafana-mail-password = {
      sopsFile = ../../secrets.yaml;
      owner = "grafana";
    };
  };

  services = {
    grafana = {
      enable = true;
      settings = {
        users.default_theme = "system";
        dashboards.default_home_dashboard_path = "${./dashboards}/hosts.json";
        security = {
          admin_user = "christoph";
          admin_email = "contact@christophjabs.info";
          admin_password = "$__file{${config.sops.secrets.grafana-christoph-password.path}}";
          cookie_secure = true;
        };
        auth.oauth_allow_insecure_email_lookup = true;
        "auth.basic".eanbled = false;
        "auth.generic_oauth" = {
          enabled = true;
          name = "Pocket ID";
          client_id = "d9aae002-3f5c-4d41-8f29-fd5f04743e07";
          client_secret = "$__file{${config.sops.secrets.grafana-pocket-id-client-secret.path}}";
          auth_url = "https://id.jabsserver.net/authorize";
          token_url = "https://id.jabsserver.net/api/oidc/token";
          api_url = "https://id.jabsserver.net/api/oidc/userinfo";
          allow_sign_up = false;
          auth_style = "AutoDetect";
          scopes = "openid,email,profile";
          email_attribute_name = "email:primary";
          skip_org_role_sync = true;
          use_pkce = true;
        };
        smtp = rec {
          enabled = true;
          host = "mail.jabsserver.net:465";
          from_address = user;
          user = config.mailserver.loginAccounts."no-reply@dash.jabsserver.net".name;
          password = "$__file{${config.sops.secrets.grafana-mail-password.path}}";
        };
        server.root_url = "https://dash.jabsserver.net";
      };
      provision = {
        enable = true;
        dashboards.settings.providers = [
          {
            options.path = ./dashboards;
          }
        ];
        datasources.settings = {
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "https://metrics.jabsserver.net";
              isDefault = true;
            }
          ];
        };
      };
    };
    nginx.virtualHosts = {
      "dash.jabsserver.net" =
        let
          port = config.services.grafana.settings.server.http_port;
        in
        {
          enableACME = true;
          locations."/".proxyPass = "http://localhost:${toString port}";
        };
    };
  };
}
