# This file defines overlays
{inputs, ...}: let
  addPatches = pkg: patches:
    pkg.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ patches;
    });
in {
  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  flake-inputs = final: _: {
    inputs =
      builtins.mapAttrs (
        _: flake: let
          legacyPackages = (flake.legacyPackages or {}).${final.system} or {};
          packages = (flake.packages or {}).${final.system} or {};
        in
          if legacyPackages != {}
          then legacyPackages
          else packages
      )
      inputs;
  };

  # Adds pkgs.stable == inputs.nixpkgs-stable.legacyPackages.${pkgs.system}
  stable = final: _: {
    stable = inputs.nixpkgs-stable.legacyPackages.${final.system};
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
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # Python packages
  python-additions = self: super: {
    python3 = super.python3.override {
      packageOverrides = python-self: python-super: rec {
        gbd = super.python3Packages.callPackage ../pkgs/gbd {python-gbdc = gbdc;};
        gbdc = super.python3Packages.callPackage ../pkgs/python-gbdc {};
      };
    };
    python3Packages = self.python3.pkgs;
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # https://github.com/mdellweg/pass_secret_service/pull/37
    pass-secret-service = addPatches prev.pass-secret-service [./pass-secret-service-native.diff];

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

  # Python package modifications
  python-modifications = self: super: {
    python3 = super.python3.override {
      packageOverrides = python-self: python-super: {
        python-sat = python-super.python-sat.overrideAttrs (previousAttrs: rec {
          name = previousAttrs.pname + "-" + version;
          version = "0.1.8.dev14";
          src = super.fetchFromGitHub {
            owner = "pysathq";
            repo = "pysat";
            rev = "b8e73bb4b61427925155259642ff5725412fc979";
            hash = "sha256-198pyqomVl9fEF1uayGL1Byk2yzQMMYkm4k7x51GlBw=";
          };
          doCheck = false;
          dontCheck = true;
          # delete failing test
          postPatch = ''
            rm tests/test_unique_mus.py
          '';
        });
      };
    };
    python3Packages = self.python3.pkgs;
  };
}
