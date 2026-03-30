{ inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, ... }:
    {
      imports = [
        inputs.niri.nixosModules.niri
      ];

      programs.niri = {
        enable = true;
        # Unstable Niri for xwayland-satellite support
        package = pkgs.niri-unstable;
      };
    };
}
