{
  description = "My NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://chrjabs.cachix.org"
    ];
    extra-trusted-public-keys = [
      "chrjabs.cachix.org-1:hnjWCdXP+IWya+Y+/xTwyfpNtwOlbR0X3/9OqyLoE1o="
    ];
  };

  inputs = {
    # Nix ecosystem
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Custom Nixpkgs
    custom-nixpkgs.url = "github:chrjabs/nixpkgs/custom";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixVim
    nixvim.url = "github:nix-community/nixvim";

    # SopsNix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Firefox Addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # xremap
    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Using plymouth theme from here
    misterio = {
      url = "github:Misterio77/nix-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Niri compositor
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Starship JJ plugin
    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix LS_COLORS theming through vivid
    base16-vivid = {
      url = "github:tinted-theming/base16-vivid";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    # https://flake.parts/module-arguments.html
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        config,
        ...
      }:
      {
        imports = [
          inputs.flake-parts.flakeModules.easyOverlay
          inputs.treefmt-nix.flakeModule
        ];

        flake =
          let
            outputs = inputs.self.outputs;
          in
          {
            # Your custom packages and modifications, exported as overlays
            overlays = import ./overlays { inherit inputs; };
            # Reusable nixos modules you might want to export
            # These are usually stuff you would upstream into nixpkgs
            nixosModules = import ./modules/nixos;
            # Reusable home-manager modules you might want to export
            # These are usually stuff you would upstream into home-manager
            homeManagerModules = import ./modules/home-manager;

            # NixOS configuration entrypoint
            # Available through 'nixos-rebuild --flake .#your-hostname'
            nixosConfigurations = {
              phantasia = inputs.nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit inputs outputs;
                  bootstrap = false;
                };
                modules = [ ./hosts/phantasia ];
              };
              gallifrey = inputs.nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit inputs outputs;
                  bootstrap = false;
                };
                modules = [ ./hosts/gallifrey ];
              };
              tuathaan = inputs.nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit inputs outputs;
                  bootstrap = false;
                };
                modules = [ ./hosts/tuathaan ];
              };
              medusa = inputs.nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit inputs outputs;
                  bootstrap = false;
                };
                modules = [ ./hosts/medusa ];
              };
            };

            # Standalone home-manager configuration entrypoint
            # Available through 'home-manager --flake .#your-username@your-hostname'
            homeConfigurations = {
              "christoph@jabsserver" = inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
                extraSpecialArgs = { inherit inputs outputs; };
                modules = [
                  ./home/christoph/jabsserver
                  ./home/christoph/standalone.nix
                ];
              };
            };
          };

        systems = [
          "x86_64-linux"
        ];

        perSystem =
          {
            system,
            pkgs,
            ...
          }:
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };

            packages = import ./pkgs { inherit pkgs inputs; };
            devShells = import ./shell.nix { inherit pkgs; };

            treefmt = {
              settings = {
                global.on-unmatched = "error";
                formatter.shellcheck.options = [ "--shell=bash" ];
              };
              programs = {
                # Nix
                deadnix.enable = true;
                nixfmt.enable = true;
                # Shell
                shellcheck = {
                  enable = true;
                  excludes = [ ".envrc" ];
                };
                shfmt.enable = true;
                # TOML
                taplo.enable = true;
                # YAML
                actionlint.enable = true;
                yamlfmt = {
                  enable = true;
                  excludes = [
                    ".sops.yaml"
                    "**/*secrets.yaml"
                  ];
                };
              };
            };
          };
      }
    );
}
