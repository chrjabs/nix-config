{ lib, ... }:
let
  basicReverseProxy = proxyPass: extraConfig: {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      inherit proxyPass;
      extraConfig = ''
        proxy_ssl_server_name on;
        proxy_pass_header Authorization;
      ''
      + extraConfig;
    };
  };
in
{
  # Use tailnet IPs rather than hostnames to not prevent startup if not connected
  services.nginx.virtualHosts = {
    "house.jabsserver.net" = basicReverseProxy "http://100.64.0.3:8123" ''
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
    '';
    "home.jabsserver.net" = basicReverseProxy "http://100.64.0.10:8123" ''
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
    '';
    "paper.jabsserver.net" = basicReverseProxy "http://100.64.0.5:8000" "";
    "photos.jabsserver.net" = basicReverseProxy "http://100.64.0.11:2283" "";
    "finances.jabsserver.net" = basicReverseProxy "http://100.64.0.2:8080" "";
    "keziaolive.jabsserver.net" = basicReverseProxy "http://100.64.0.8" "";
    "files.keziaolive.com" = basicReverseProxy "http://100.64.0.8" "";
    "cloud.jabsserver.net" = basicReverseProxy "http://100.64.0.12" ''
      client_max_body_size 10G;
      proxy_request_buffering off;
      proxy_connect_timeout 600;
      proxy_send_timeout 600;
      proxy_read_timeout 600;
    '';
  };
}
