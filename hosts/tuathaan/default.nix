{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/christoph

    ../common/optional/quietboot.nix
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

  # Laptop power management
  powerManagement.enable = true;
  services.tlp.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
  services.logind = {
    # Don't shutdown on power button press
    powerKey = "ignore";
    # Give swaylock a bit more time to lock before suspend
    extraConfig = ''
      InhibitDelayMaxSec=10
    '';
  };
}
