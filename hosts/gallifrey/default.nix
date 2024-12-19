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
    ../common/optional/peripherals/umc1820.nix
    ../common/optional/peripherals/ibus.nix

    ../common/optional/virtualization.nix
  ];

  # Systemd boot
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "gallifrey";

  system.stateVersion = "24.05";

  # Sway on NVidia
  # environment.sessionVariables.WLR_RENDERER = "vulkan";

  # Greetd output config
  greetd.custom.outputConfig = lib.concatStringsSep "\n" ["output HDMI-A-1 disable" "output DP-3 enable"];

  # Needed for GTK
  programs.dconf.enable = true;

  # Nvidia GPU
  hardware.graphics.enable = true;
  # services.xserver.videoDrivers = ["nvidia"];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   powerManagement.finegrained = false;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };
}
