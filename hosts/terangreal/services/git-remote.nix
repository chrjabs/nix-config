{
  config,
  pkgs,
  ...
}:
{
  services.gitDaemon = {
    enable = true;
    basePath = "/srv/git";
    exportAll = true;
    repositories = map (n: "/srv/git/${n}") (builtins.attrNames config.services.gitMirror.repos);
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
      openssh.authorizedKeys.keys = config.users.users.christoph.openssh.authorizedKeys.keys ++ [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+zRuUJvg7xWtipSGh8jjk1j4tGi+Ayyjz6W6Acx90l christoph@phone"
      ];
    };
    groups.git = { };
  };
}
