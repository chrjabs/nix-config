{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/christoph

    ../common/optional/home.nix

    ../common/optional/kodi.nix

    ../common/optional/pipewire.nix
    ../common/optional/peripherals/umc1820.nix

    (modulesPath + "/virtualisation/proxmox-image.nix")
    inputs.nixos-generators.nixosModules.all-formats
  ];

  programs.dconf.enable = true;

  networking.hostName = lib.mkOverride 20 "medusa";

  system.stateVersion = "24.11";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # Proxmox VM options
  proxmox.qemuConf = {
    cores = 2;
    memory = 3072;
    bios = "ovmf";
    diskSize = lib.mkForce "30720";
    name = config.networking.hostName;
  };
}
