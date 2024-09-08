# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../common/global
    ../common/users/christoph

    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
    ../common/optional/stylix.nix
  ];

  # Systemd boot
  boot.loader.systemd-boot.enable = true;

  # Virtual machine
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  networking.hostName = "phantasia"; # Define your hostname.

  system.stateVersion = "24.05";
}
