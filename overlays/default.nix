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
        legacyPackages = (flake.legacyPackages or { }).${final.system} or { };
        packages = (flake.packages or { }).${final.system} or { };
      in
      if legacyPackages != { } then legacyPackages else packages
    ) inputs;
  };

  # Adds pkgs.custom == inputs.custom-nixpkgs.legacyPackages.${pkgs.system}
  custom = final: _: {
    custom = inputs.custom-nixpkgs.legacyPackages.${final.system};
  };

  # Adds pkgs.nixvim == inputs.nixvim.inputs.nixpkgs.legacyPackages.${pkgs.system}
  nixvim = final: _: {
    nixvim = inputs.nixvim.inputs.nixpkgs.legacyPackages.${final.system};
  };

  # This one brings our custom packages from the 'pkgs' directory
  additions =
    final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit inputs;
    };

  plymouth-theme = final: _: {
    inherit (inputs.misterio.packages.${final.system}) plymouth-spinner-monochrome;
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _: prev: {
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
  };
}
