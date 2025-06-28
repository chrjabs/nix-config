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
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };
}
