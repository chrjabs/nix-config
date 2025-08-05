{ pkgs, ... }:
{
  services = {
    cgit."git.jabsserver.net" = {
      enable = true;
      package = pkgs.cgit-pink;
      repos = {
        nix-config = {
          desc = "My personal nix configuration, mirrored from github:chrjabs/nix-config";
          path = "/srv/git/nix-config";
        };
        rustsat = {
          desc = "The RustSAT repository, mirrored from github:chrjabs/rustsat";
          path = "/srv/git/rustsat";
        };
        scuttle = {
          desc = "The scuttle repository, mirrored from github:chrjabs/scuttle";
          path = "/srv/git/scuttle";
        };
      };
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
