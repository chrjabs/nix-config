{
  inputs,
  outputs,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      inputs.disko.nixosModules.disko
      inputs.nixvim.nixosModules.nixvim
      ./fish.nix
      ./locale.nix
      ./nix.nix
      ./openssh.nix
      ./optin-persistence.nix
      ./sops.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

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
