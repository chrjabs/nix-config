{ lib, config, ... }:
{
  services = {
    uptime-kuma.enable = true;

    nginx.virtualHosts = {
      "uptime.jabsserver.net" = {
        enableACME = true;
        locations."/".proxyPass = "http://localhost:${config.services.uptime-kuma.settings.PORT}";
      };
    };
  };
}
