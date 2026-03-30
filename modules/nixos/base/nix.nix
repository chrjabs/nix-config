{ self, inputs, ... }:
{
  flake.nixosModules.base =
    { lib, ... }:
    {
      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          flake-registry = ""; # Disable global flake registry
          warn-dirty = false;
          extra-substituters = lib.mkAfter [ "https://chrjabs.cachix.org" ];
          extra-trusted-public-keys = [ "chrjabs.cachix.org-1:hnjWCdXP+IWya+Y+/xTwyfpNtwOlbR0X3/9OqyLoE1o=" ];
          trusted-users = [
            "root"
            "@wheel"
          ];
        };
      };

      nixpkgs = {
        overlays = builtins.attrValues self.outputs.overlays ++ [
          inputs.starship-jj.overlays.default
          inputs.niri.overlays.niri
        ];
      };

      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 3 --no-gcroots";
          dates = "weekly";
        };
      };
    };
}
