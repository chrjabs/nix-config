{ self, ... }:
{
  flake.nixosModules.userChristoph =
    {
      lib,
      pkgs,
      config,
      bootstrap ? false,
      ...
    }:
    let
      ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
    in
    {
      imports = [
        self.nixosModules.homeManager
      ];

      users.users.christoph = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = ifGroupsExist [
          "audio"
          "docker"
          "git"
          "podman"
          "video"
          "wheel"
          "fuse"
          "wpa_supplicant"
          "libvirtd"
        ];

        openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ./christoph_ssh.pub);
        hashedPasswordFile = lib.mkIf (!bootstrap) config.sops.secrets.christoph-password.path;
        initialPassword = lib.mkIf bootstrap "bootstrap";
        packages = lib.mkIf (!bootstrap) (with pkgs; [ home-manager ]);
      };

      sops.secrets.christoph-password = lib.mkIf (!bootstrap) {
        sopsFile = ../common-secrets.yaml;
        neededForUsers = true;
      };

      home-manager.users.christoph = lib.mkIf (!bootstrap) self.homeModules.christophGallifrey;

      security.pam.services = lib.mkIf (!bootstrap) {
        swaylock = { };
      };
    };
}
