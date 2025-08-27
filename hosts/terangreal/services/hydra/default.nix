{
  pkgs,
  config,
  ...
}:
let
  hydraUser = config.users.users.hydra.name;
  hydraGroup = config.users.users.hydra.group;
in
{
  imports = [ ./machines.nix ];

  services = {
    hydra = {
      enable = true;
      package = pkgs.hydra;
      hydraURL = "https://hydra.jabsserver.net";
      notificationSender = "no-reply@hydra.jabsserver.net";
      listenHost = "localhost";
      smtpHost = "localhost";
      useSubstitutes = true;
      extraEnv.HYDRA_DISALLOW_UNFREE = "0";
    };
    nginx.virtualHosts = {
      "hydra.jabsserver.net" = {
        enableACME = true;
        locations = {
          "~* ^/shield/([^\\s]*)".return =
            "302 https://img.shields.io/endpoint?url=https://hydra.jabsserver.net/$1/shield";
          "/".proxyPass = "http://localhost:${toString config.services.hydra.port}";
        };
      };
    };
  };
  users.users = {
    hydra-queue-runner.extraGroups = [ hydraGroup ];
    hydra-www.extraGroups = [ hydraGroup ];
  };
  sops.secrets = {
    nix-ssh-key = {
      sopsFile = ../../secrets.yaml;
      owner = hydraUser;
      group = hydraGroup;
      mode = "0440";
    };
  };

  environment.persistence = {
    "/persist".directories = [ "/var/lib/hydra" ];
  };
}
