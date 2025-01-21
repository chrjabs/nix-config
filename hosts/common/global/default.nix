{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      inputs.nixvim.nixosModules.nixvim
      inputs.impermanence.nixosModules.impermanence
      ./fish.nix
      ./locale.nix
      ./nix.nix
      ./openssh.nix
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

  environment = {
    systemPackages = with pkgs; [kitty.terminfo];
    persistence."/persist".enable = lib.mkDefault false;
  };
}
