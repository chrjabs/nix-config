{
  description = "My NixOS configuration";

  inputs = {
    # Nix ecosystem
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

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

    # Rust overlay for building kani
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
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
      inputs.systems.follows = "systems";
    };

    # Stylix LS_COLORS theming through vivid
    base16-vivid = {
      url = "github:tinted-theming/base16-vivid";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs inputs;});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forEachSystem (pkgs: pkgs.alejandra);
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      phantasia = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          bootstrap = false;
        };
        modules = [./hosts/phantasia];
      };
      gallifrey = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          bootstrap = false;
        };
        modules = [./hosts/gallifrey];
      };
      tuathaan = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          bootstrap = false;
        };
        modules = [./hosts/tuathaan];
      };
      medusa = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          bootstrap = false;
        };
        modules = [./hosts/medusa];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "christoph@jabsserver" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/christoph/jabsserver ./home/christoph/standalone.nix];
      };
    };
  };
}
