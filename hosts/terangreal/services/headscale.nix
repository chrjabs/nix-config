{
  config,
  ...
}:
let
  derpPort = 3478;
in
{
  sops.secrets = {
    headscale-pocket-id-client-secret = {
      sopsFile = ../secrets.yaml;
      owner = config.services.headscale.user;
    };
  };

  services = {
    headscale = {
      enable = true;
      port = 8085;
      address = "127.0.0.1";
      settings = {
        dns = {
          override_local_dns = true;
          base_domain = "vpn.jabsserver.net";
          magic_dns = true;
          nameservers.global = [ "9.9.9.9" ];
          extra_records = [ ];
        };
        server_url = "https://tailscale.jabsserver.net";
        metrics_listen_addr = "127.0.0.1:8095";
        logtail.enabled = false;
        log.level = "info";
        ip_prefixes = [
          "100.77.0.0/24"
          "fd7a:115c:a1e0:77::/64"
        ];
        derp.server = {
          enable = true;
          region_id = 999;
          stun_listen_addr = "0.0.0.0:${toString derpPort}";
        };
        oidc = {
          issuer = "https://id.jabsserver.net";
          client_id = "7ae4fdf7-75a1-45d5-bead-74b24d1dd586";
          client_secret_path = config.sops.secrets.headscale-pocket-id-client-secret.path;
          scope = [
            "openid"
            "profile"
            "email"
            "groups"
          ];
          allowed_groups = [ "vpn" ];
          pkce = {
            enabled = true;
            method = "S256";
          };
        };
      };
    };

    nginx.virtualHosts = {
      "tailscale.jabsserver.net" = {
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString config.services.headscale.port}";
            proxyWebsockets = true;
          };
          "/metrics" = {
            proxyPass = "http://${config.services.headscale.settings.metrics_listen_addr}/metrics";
          };
        };
      };
    };
  };

  # Derp server
  networking.firewall.allowedUDPPorts = [ derpPort ];

  environment.systemPackages = [ config.services.headscale.package ];

  environment.persistence = {
    "/persist".directories = [ "/var/lib/headscale" ];
  };
}
