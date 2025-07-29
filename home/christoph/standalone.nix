# This file is only loaded in home-manager standalone mode
{
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
