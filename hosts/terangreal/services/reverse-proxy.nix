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
  services.nginx.virtualHosts = {
    "house.jabsserver.net" = basicReverseProxy "http://jabsserver:8123" ''
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
    '';
    "home.jabsserver.net" = basicReverseProxy "http://rumah:8123" ''
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
    '';
    "paper.jabsserver.net" = basicReverseProxy "http://paperless:8000" "";
    "photos.jabsserver.net" = basicReverseProxy "http://immich:2283" "";
    "finances.jabsserver.net" = basicReverseProxy "http://firefly:8080" "";
    "keziaolive.jabsserver.net" = basicReverseProxy "http://keziaolive" "";
    "files.keziaolive.com" = basicReverseProxy "http://keziaolive" "";
  };
}
