{
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ../common
  ];

  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "Mod4";
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
        kitty = lib.getExe config.programs.kitty.package;
        wofi = lib.getExe config.programs.wofi.package;
      in
        lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${kitty}";
          "${modifier}+d" = "exec ${wofi} -S run";
        };
    };
  };
}
