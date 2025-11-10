{ lib, ... }:
let
  short = {
    enableACME = true;
    locations = lib.mapAttrs' (n: v: lib.nameValuePair "/${n}" { return = "302 ${v}"; }) {
      "quick-share" = "https://cloud.jabsserver.net/s/rNANyRWxrYxFzdd";
    };
  };
in
{
  services.nginx.virtualHosts = {
    "short.christophjabs.info" = short;
    "s.christophjabs.info" = short;
    "short.jabsserver.net" = short;
    "s.jabsserver.net" = short;
  };
}
