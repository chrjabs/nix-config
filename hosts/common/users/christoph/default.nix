{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.users.christoph = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ifTheyExist [
      "audio"
      "docker"
      "git"
      "podman"
      "video"
      "wheel"
    ];

    hashedPasswordFile = config.sops.secrets.christoph-password.path;
    packages = [pkgs.home-manager];
  };

  sops.secrets.christoph-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.christoph = import ../../../../home/christoph/${config.networking.hostName}.nix;
}
