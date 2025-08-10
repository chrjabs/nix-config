{
  lib,
  pkgs,
  config,
  ...
}:
{
  services = {
    cgit."git.jabsserver.net" = {
      enable = true;
      package = pkgs.cgit-pink;
      repos = lib.attrsets.mapAttrs (name: remote: {
        desc = "${name} mirror from ${remote}";
        path = "/srv/git/${name}";
      }) config.services.gitMirror.repos;
      settings = {
        root-title = "Git (Jabsserver)";
        root-desc = "This is a cgit mirror for some of my projects. You might want to check them out on github (github.com/chrjabs) instead.";
        enable-http-clone = true;
      };
    };

    nginx.virtualHosts = {
      "git.jabsserver.net" = {
        forceSSL = true;
        enableACME = true;
      };
    };
  };
}
