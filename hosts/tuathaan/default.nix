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

    ../common/optional/wireless.nix
    ../common/optional/optin-persistence.nix
    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
    ../common/optional/peripherals/ibus.nix
    ../common/optional/peripherals/remap-caps.nix

    ../common/optional/uh-vpn.nix
  ];

  # Systemd boot
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "tuathaan";

  system.stateVersion = "25.05";

  # Needed for GTK
  programs.dconf.enable = true;

  hardware.graphics.enable = true;
}
