{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nixvim.nixosModules.nixvim
    inputs.impermanence.nixosModules.impermanence
    ./acme.nix
    ./fish.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./prometheus-node-exporter.nix
    ./sops.nix
    ./styling.nix
    ./tailscale.nix
  ]
  ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs;
      nixosConfig = config;
    };
    backupFileExtension = ".bak";
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays ++ [
      inputs.starship-jj.overlays.default
      inputs.niri.overlays.niri
    ];
    config.allowUnfree = true;
  };

  users.mutableUsers = false;

  services.upower.enable = true;

  environment = {
    systemPackages = with pkgs; [ kitty.terminfo ];
    persistence."/persist".enable = lib.mkDefault false;
  };
}
