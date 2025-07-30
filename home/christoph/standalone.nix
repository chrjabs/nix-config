# This file is only loaded in home-manager standalone mode
{
  lib,
  config,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
  ];
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      flake-registry = ""; # Disable global flake registry
      extra-substituters = lib.mkAfter ["https://chrjabs.cachix.org"];
      extra-trusted-public-keys = ["chrjabs.cachix.org-1:hnjWCdXP+IWya+Y+/xTwyfpNtwOlbR0X3/9OqyLoE1o="];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays ++ [inputs.starship-jj.overlays.default];
    config.allowUnfree = true;
  };

  programs.nh.clean = {
    enable = true;
    extraArgs = "--keep-since 90d --keep 3";
  };
}
