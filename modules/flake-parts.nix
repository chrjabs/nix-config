{ inputs, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
    inputs.flake-parts.flakeModules.easyOverlay
    inputs.treefmt-nix.flakeModule
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem =
    {
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = builtins.attrValues inputs.self.outputs.overlays;
      };
    };
}
