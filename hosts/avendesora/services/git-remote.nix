{
  config,
  pkgs,
  ...
}:
{
  environment.persistence = {
    "/persist".directories = [ "/srv/git" ];
  };

  services.gitDaemon = {
    enable = true;
    basePath = "/srv/git";
    exportAll = true;
    repositories = [
      "/srv/git/nix-config"
      "/srv/git/rustsat"
    ];
  };
  networking.firewall.allowedTCPPorts = [ config.services.gitDaemon.port ];

  users = {
    users.git = {
      home = "/srv/git";
      createHome = true;
      homeMode = "755";
      isSystemUser = true;
      shell = "${pkgs.bash}/bin/bash";
      group = "git";
      packages = [ pkgs.git ];
      openssh.authorizedKeys.keys = config.users.users.christoph.openssh.authorizedKeys.keys;
    };
    groups.git = { };
  };
}
