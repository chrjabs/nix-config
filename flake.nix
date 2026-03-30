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

    import-tree.url = "github:vic/import-tree";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        flake-parts.follows = "flake-parts";
        # intentionally not following nixpkgs here
      };
    };

    # SopsNix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix
    stylix = {
      url = "github:nix-community/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # Firefox Addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # xremap
    xremap = {
      url = "github:xremap/nix-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # Niri compositor
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Starship JJ plugin
    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

    };

    # Stylix LS_COLORS theming through vivid
    base16-vivid = {
      url = "github:tinted-theming/base16-vivid";
      flake = false;
    };

    # Mailserver
    nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # AI robots information for crawler blocking
    ai-robots-txt = {
      url = "github:ai-robots-txt/ai.robots.txt";
      flake = false;
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
