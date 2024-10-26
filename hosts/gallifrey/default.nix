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

    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
  ];

  # Systemd boot
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "gallifrey";

  system.stateVersion = "24.05";

  # Needed for GTK
  programs.dconf.enable = true;
}
