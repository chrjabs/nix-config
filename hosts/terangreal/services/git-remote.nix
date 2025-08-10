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
      openssh.authorizedKeys.keys = config.users.users.christoph.openssh.authorizedKeys.keys;
    };
    groups.git = { };
  };
}
