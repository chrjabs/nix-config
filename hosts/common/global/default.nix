{
  inputs,
  outputs,
  config,
  lib,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      inputs.nixvim.nixosModules.nixvim
      ./fish.nix
      ./locale.nix
      ./nix.nix
      ./openssh.nix
      ./optin-persistence.nix
      ./sops.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  # options.minimal = lib.mkEnableOption "create a minimal system, useful to instal with limited resources";

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs outputs;};
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  users.mutableUsers = false;

  services.upower.enable = true;
}
