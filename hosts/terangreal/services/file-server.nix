let
  files = {
    enableACME = true;
    locations."/".root = "/srv/files/christophjabs";
  };
in
{
  services.nginx.virtualHosts = {
    "media.christophjabs.info" = files;
    "m.christophjabs.info" = files;
    "files.christophjabs.info" = files;
    "f.christophjabs.info" = files;
  };

  environment.persistence = {
    "/persist".directories = [ "/srv/files" ];
  };
}
