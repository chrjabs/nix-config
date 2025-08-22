{ config, ... }:
{
  sops.secrets = {
    grafana-christoph-password = {
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
        "auth.anonymous".enabled = true;
        smtp = rec {
          enabled = true;
          host = "mail.jabsserver.net:465";
          from_address = user;
          user = config.mailserver.loginAccounts."no-reply@dash.jabsserver.net".name;
          password = "$__file{${config.sops.secrets.grafana-mail-password.path}}";
        };
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
          forceSSL = true;
          enableACME = true;
          locations."/".proxyPass = "http://localhost:${toString port}";
        };
    };
  };
}
