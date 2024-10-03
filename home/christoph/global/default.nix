{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: {
  imports =
    [
      inputs.impermanence.nixosModules.home-manager.impermanence
      inputs.nixvim.homeManagerModules.nixvim
      ./styling.nix
      ../features/cli
      ../features/nvim
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "christoph";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.05";
    sessionVariables.FLAKE = lib.mkDefault "$HOME/Documents/nix-config";

    packages = let
      specialisation = pkgs.writeShellScriptBin "specialisation" ''
        profiles="$HOME/.local/state/nix/profiles"
        current="$profiles/home-manager"
        base="$profiles/home-manager-base"

        # If current contains specialisation, link it as base
        if [ -d "$current/specialisation" ]; then
          echo >&2 "Using current profile as base"
          ln -sfT "$(readlink "$current")" "$base"
        # Check that $base contains specialisation before proceeding
        elif [ -d "$base/specialisation" ]; then
          echo >&2 "Using previously linked base profile"
        else
          echo >&2 "No suitable base config found. Try 'home-manager switch' again."
          exit 1
        fi

        if [ -z "$1" ] || [ "$1" = "list" ] || [ "$1" = "-l" ] || [ "$1" = "--list" ]; then
          find "$base/specialisation" -type l -printf "%f\n"
          echo "base"
          exit 0
        fi

        echo >&2 "Switching to $1 specialisation"
        if [ "$1" == "base" ]; then
          "$base/activate"
        else
          "$base/specialisation/$1/activate"
        fi
      '';
    in [
      specialisation
    ];

    persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          "Documents"
          "Downloads"
          "Pictures"
          "Videos"
          ".local/bin"
          ".local/share/nix" # trusted settings and repl history
        ];
        allowOther = true;
      };
    };
  };
}
