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
    gc = {
      automatic = true;
      dates = "weekly";
      # Keep the last 3 generations
      options = "--delete-older-than +3";
    };
  };
}
