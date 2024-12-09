{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/christoph

    ../common/optional/kodi.nix
  ];

  # Systemd boot
  boot.loader.systemd-boot.enable = true;

  programs.dconf.enable = true;

  networking.hostName = "medusa";

  system.stateVersion = "24.11";
}
