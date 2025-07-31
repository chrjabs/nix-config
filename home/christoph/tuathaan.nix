{ lib, workMode, ... }:
{
  imports = [
    ./global
    ./features/desktop/niri
    ./features/desktop/optional/keepass.nix
    ./features/desktop/optional/zoom.nix
    ./features/desktop/optional/bluetui.nix
    ./features/productivity
    ./features/rust
  ]
  ++ lib.optionals workMode [
    ./features/desktop/optional/slack.nix
  ];

  monitors.layouts = {
    # reassigning workspaces to outputs is not possible in sway after start, so
    # I'm using DP-1 for when the external display should be the main display,
    # and DP-2 for when it is secondary
    default = {
      "eDP-1" = {
        mode = {
          x = 2560;
          y = 1600;
        };
        position = {
          x = 0;
          y = 373;
        };
        scale = 1.5;
        workspaces = [
          "6"
          "7"
          "8"
          "9"
        ];
      };
      "DP-1" = {
        mode = {
          x = 2560;
          y = 1440;
        };
        position = {
          x = 1707;
          y = 0;
        };
        workspaces = [
          "1"
          "2"
          "3"
          "4"
          "5"
        ];
        fallback = "eDP-1";
      };
      "DP-2" = {
        workspaces = [ "10" ];
        fallback = "eDP-1";
      };
    };
  };

  services.swayidle.lockTime = 8 * 60; # 8 min
}
