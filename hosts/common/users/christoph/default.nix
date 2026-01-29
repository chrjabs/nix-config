{
  pkgs,
  config,
  lib,
  bootstrap ? false,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
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
      "fuse"
      "wpa_supplicant"
    ];

    openssh.authorizedKeys.keys = lib.splitString "\n" (
      builtins.readFile ../../../../home/christoph/ssh.pub
    );
    hashedPasswordFile = lib.mkIf (!bootstrap) config.sops.secrets.christoph-password.path;
    initialPassword = lib.mkIf bootstrap "bootstrap";
    packages = lib.mkIf (!bootstrap) (with pkgs; [ home-manager ]);
  };

  sops.secrets.christoph-password = lib.mkIf (!bootstrap) {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.christoph = lib.mkIf (!bootstrap) (
    import ../../../../home/christoph/${config.networking.hostName}.nix
  );

  security.pam.services = lib.mkIf (!bootstrap) {
    swaylock = { };
  };
}
