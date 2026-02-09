let
  christophjabs = {
    enableACME = true;
    locations."/".root = "/srv/files/christophjabs";
  };
  jabsserver = {
    enableACME = true;
    locations."/".root = "/srv/files/jabsserver";
  };
in
{
  services.nginx.virtualHosts = {
    "media.christophjabs.info" = christophjabs;
    "m.christophjabs.info" = christophjabs;
    "files.christophjabs.info" = christophjabs;
    "f.christophjabs.info" = christophjabs;
    "files.jabsserver.net" = jabsserver;
    "f.jabsserver.net" = jabsserver;
    "www.jabsserver.net" = jabsserver;
  };

  environment.persistence = {
    "/persist".directories = [ "/srv/files" ];
  };
}
