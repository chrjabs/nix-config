{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  workMode,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./styling.nix
    ../features/cli
    ../features/nvim
  ]
  ++ (builtins.attrValues outputs.homeModules);

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
    nh.enable = true;
  };

  home = {
    username = lib.mkDefault "christoph";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.05";
    sessionVariables.NH_FLAKE = lib.mkDefault "github:chrjabs/nix-config";

    persistence = {
      "/persist" = {
        directories = [
          "Documents"
          "Downloads"
          "Pictures"
          "Videos"
          ".local/bin"
          ".local/share/nix" # trusted settings and repl history
          ".cache/nix"
        ]
        ++ lib.optionals workMode [
          "Work"
        ];
      };
    };
  };
}
