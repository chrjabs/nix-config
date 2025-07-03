{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ../global
    inputs.sops-nix.homeManagerModules.sops
  ];

  home = {
    homeDirectory = "/tank/home/${config.home.username}";

    persistence."/persist/${config.home.homeDirectory}".enable = false;

    sessionVariables.NH_FLAKE = "$HOME/nix-config";

    packages = let
      dcmp = pkgs.writeShellScriptBin "dcmp" ''
        source ${config.sops.secrets.docker.path}
        cd ~/jabsserver_docker/$1
        sudo -E docker compose --project-name "$1" "''${@:2}"
      '';
    in [dcmp];
  };

  programs.nh.enable = true;

  sops = {
    age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
    secrets.docker.sopsFile = ./secrets.yaml;
  };

  # No dconf
  stylix.targets = {
    gtk.enable = false;
    gnome.enable = false;
    gnome-text-editor.enable = false;
    eog.enable = false;
  };

  # No signing
  programs.git.extraConfig.commit.gpgSign = false;
  programs.jujutsu.settings.git.sign-on-push = false;
}
