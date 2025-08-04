{
  config,
  outputs,
  lib,
  ...
}:
let
  hosts = lib.attrNames outputs.nixosConfigurations;
in
{
  services = {
    prometheus = {
      enable = true;
      globalConfig.scrape_interval = "30s";
      scrapeConfigs = [
        {
          job_name = "prometheus";
          scheme = "https";
          static_configs = [ { targets = [ "metrics.jabsserver.net" ]; } ];
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
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://localhost:${toString config.services.prometheus.port}";
      };
    };
  };

  environment.persistence = {
    "/persist".directories = [ "/var/lib/prometheus2" ];
  };
}
