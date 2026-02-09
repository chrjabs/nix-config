# This file defines overlays
{ inputs, ... }:
let
  addPatches =
    pkg: patches:
    pkg.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ patches;
    });
in
{
  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  flake-inputs = final: _: {
    inputs = builtins.mapAttrs (
      _: flake:
      let
        legacyPackages = (flake.legacyPackages or { }).${final.stdenv.hostPlatform.system} or { };
        packages = (flake.packages or { }).${final.stdenv.hostPlatform.system} or { };
      in
      if legacyPackages != { } then legacyPackages else packages
    ) inputs;
  };

  # Adds pkgs.nixvim == inputs.nixvim.inputs.nixpkgs.legacyPackages.${pkgs.system}
  nixvim = final: _: {
    nixvim = inputs.nixvim.inputs.nixpkgs.legacyPackages.${final.stdenv.hostPlatform.system};
  };

  # This one brings our custom packages from the 'pkgs' directory
  additions =
    final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit inputs;
    };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # https://github.com/mdellweg/pass_secret_service/pull/37
    pass-secret-service = addPatches prev.pass-secret-service [ ./pass-secret-service-native.diff ];

    # Newest Widevine
    widevine-cdm = prev.widevine-cdm.overrideAttrs rec {
      version = "4.10.2830.0";
      src = prev.fetchzip {
        url = "https://dl.google.com/widevine-cdm/${version}-linux-x64.zip";
        hash = "sha256-XDnsan1ulnIK87Owedb2s9XWLzk1K2viGGQe9LN/kcE=";
        stripRoot = false;
      };
    };

    # Make sure to use the home-manager executable from the home-manager input
    inherit (inputs.home-manager.packages.${final.stdenv.hostPlatform.system}) home-manager;

    # Remove once https://github.com/NixOS/nixpkgs/pull/482335 is merged
    cgit-pink = prev.cgit-pink.overrideAttrs {
      env.NIX_CFLAGS_COMPILE = "-std=gnu17";
    };
  };
}
