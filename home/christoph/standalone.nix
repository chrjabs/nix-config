# This file is only loaded in home-manager standalone mode
{
  config,
  outputs,
  ...
}: {
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
