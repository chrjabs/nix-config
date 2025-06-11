{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./global
    ./features/desktop/sway
    ./features/desktop/optional/keepass.nix
    ./features/productivity
    ./features/rust
  ];

  specialisation.work.configuration.imports = [
    ./features/desktop/optional/slack.nix
  ];

  monitors = [
    {
      name = "eDP-1";
      width = 2560;
      height = 1440;
      primary = true;
      workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10"];
      scale = 1.5;
    }
  ];

  services.swayidle.lockTime = 8 * 60; # 8 min
}
