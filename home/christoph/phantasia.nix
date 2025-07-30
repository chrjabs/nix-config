{ ... }:
{
  imports = [
    ./global
    ./features/desktop/sway
    ./features/productivity
    ./features/rust
  ];

  home.sessionVariables.FLAKE = "/mnt/nix-config";

  monitors.layouts = {
    "Virtual-1" = {
      mode = {
        x = 1920;
        y = 1080;
      };
    };
  };
}
