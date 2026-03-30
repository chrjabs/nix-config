{ self, ... }:
{
  flake.homeModules.christophGallifrey = {
    imports = [
      self.outputs.homeModules.base
    ];

    home.stateVersion = "24.05";

    # services.swayidle.lockTime = 8 * 60; # 8 min

    # For NVidia drivers
    wayland.windowManager.sway.extraOptions = [
      "--unsupported-gpu"
    ];

    home.sessionVariables.NH_FLAKE = "$HOME/Documents/nix-config";
  };
}
