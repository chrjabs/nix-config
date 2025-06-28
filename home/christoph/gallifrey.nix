{...}: {
  imports = [
    ./global
    ./features/desktop/niri
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

  monitors.layouts = {
    default = {
      "DP-1" = {
        mode = {
          x = 2560;
          y = 1440;
        };
        position = {
          x = 1080;
          y = 270;
        };
        workspaces = ["1" "2" "3" "4" "5"];
      };
      "HDMI-A-1" = {
        mode = {
          x = 1920;
          y = 1080;
          rate = 60.000;
        };
        position = {
          x = 0;
          y = 0;
        };
        rotation = 270;
        workspaces = ["6" "7" "8" "9" "10"];
      };
    };
  };

  services.swayidle.lockTime = 8 * 60; # 8 min

  # For NVidia drivers
  wayland.windowManager.sway.extraOptions = [
    "--unsupported-gpu"
  ];
}
