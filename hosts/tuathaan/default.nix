{
  lib,
  bootstrap,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix

      ../common/global
      ../common/users/christoph

      ../common/optional/wireless.nix
      ../common/optional/optin-persistence.nix
      ../common/optional/greetd.nix
      ../common/optional/peripherals/remap-caps.nix
    ]
    ++ lib.optionals (!bootstrap) [
      ../common/optional/quietboot.nix
      ../common/optional/pipewire.nix
      ../common/optional/peripherals/ibus.nix
      ../common/optional/uh-vpn.nix
      ../common/optional/niri.nix
    ];

  # Systemd boot
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "tuathaan";

  system.stateVersion = "25.05";

  greetd.custom = {
    autoLogin = {
      enable = true;
      user = "christoph";
      command = "${lib.getExe' config.programs.niri.package "niri-session"} -l";
    };
  };

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

  services.automatic-timezoned.enable = true;
}
