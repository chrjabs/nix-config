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

    openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ../../../../home/christoph/ssh.pub);
    hashedPasswordFile = config.sops.secrets.christoph-password.path;
    packages = with pkgs; [home-manager];
  };

  sops.secrets.christoph-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.christoph = import ../../../../home/christoph/${config.networking.hostName}.nix;

  security.pam.services = {
    swaylock = {};
  };
}
