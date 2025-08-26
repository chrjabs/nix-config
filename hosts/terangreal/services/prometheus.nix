{
  config,
  outputs,
  lib,
  ...
}:
let
  hosts =
    lib.attrNames outputs.nixosConfigurations
    ++
    # extra non-nixos hostss
    [
      "jabsserver"
      "backupserver"
    ];
in
{
  services = {
    prometheus = {
      enable = true;
      globalConfig.scrape_interval = "30s";
      scrapeConfigs = [
        {
          job_name = "headscale";
          scheme = "https";
          static_configs = [ { targets = [ "tailscale.jabsserver.net" ]; } ];
        }
        {
          job_name = "prometheus";
          scheme = "https";
          static_configs = [ { targets = [ "metrics.jabsserver.net" ]; } ];
        }
        {
          job_name = "nginx";
          scheme = "https";
          static_configs = [
            {
              targets = [
                "terangreal.jabsserver.net"
              ];
            }
          ];
        }
        {
          job_name = "nginxlog";
          scheme = "https";
          metrics_path = "/log-metrics";
          static_configs = [
            {
              targets = [
                "terangreal.jabsserver.net"
              ];
            }
          ];
        }
        {
          job_name = "hosts";
          scheme = "http";
          static_configs = map (hostname: {
            targets = [ "${hostname}:${toString config.services.prometheus.exporters.node.port}" ];
            labels.instance = hostname;
          }) hosts;
        }
      ];
      extraFlags =
        let
          prometheus = config.services.prometheus.package;
        in
        [
          # Custom consoles
          "--web.console.templates=${prometheus}/etc/prometheus/consoles"
          "--web.console.libraries=${prometheus}/etc/prometheus/console_libraries"
        ];
    };

    nginx.virtualHosts = {
      "metrics.jabsserver.net" = {
        enableACME = true;
        locations."/".proxyPass = "http://localhost:${toString config.services.prometheus.port}";
      };
    };
  };

  environment.persistence = {
    "/persist".directories = [ "/var/lib/prometheus2" ];
  };
}
