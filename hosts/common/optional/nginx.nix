{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (config.networking) hostName;
in
{
  services = {
    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      clientMaxBodySize = "300m";
      statusPage = true;

      virtualHostDefaults = {
        forceSSL = true;
        blockAgents = {
          enable = true;
          method = "return 444";
          robotsTxt.enable = true;
        };
      };

      virtualHosts.localhost.forceSSL = lib.mkForce false;

      virtualHosts."${hostName}.jabsserver.net" = {
        default = true;
        enableACME = true;
        locations = {
          "/metrics".proxyPass =
            "http://localhost:${toString config.services.prometheus.exporters.nginx.port}";
          "/log-metrics".proxyPass =
            "http://localhost:${toString config.services.prometheus.exporters.nginxlog.port}";
        };
      };
    };

    prometheus.exporters.nginxlog = {
      enable = true;
      group = "nginx";
      metricsEndpoint = "/log-metrics";
      settings.namespaces = [
        {
          name = "filelogger";
          source.files = [ "/var/log/nginx/access.log" ];
          format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\"";
        }
      ];
    };

    prometheus.exporters.nginx = {
      enable = true;
      group = "nginx";
    };

    uwsgi = {
      enable = true;
      user = "nginx";
      group = "nginx";
      plugins = [ "cgi" ];
      instance = {
        type = "emperor";
        vassals = lib.mkBefore { };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
