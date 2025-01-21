{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./global
    ./features/desktop/sway
    ./features/desktop/optional/zoom.nix
    ./features/desktop/optional/keepass.nix
    ./features/productivity
    ./features/rust
    ./features/homeassistant

    ./features/desktop/optional/virtualization.nix
  ];

  specialisation.work.configuration.imports = [
    ./features/desktop/optional/slack.nix
  ];

  monitors = [
    {
      # name = "DP-1";
      name = "DP-3";
      width = 2560;
      height = 1440;
      position = "1080 270";
      primary = true;
      workspaces = ["1" "2" "3" "4" "5"];
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      rotation = "270";
      position = "0 0";
      workspaces = ["6" "7" "8" "9" "10"];
    }
  ];

  services.swayidle.lockTime = 8 * 60; # 8 min

  # For NVidia drivers
  wayland.windowManager.sway.extraOptions = [
    "--unsupported-gpu"
  ];
}
