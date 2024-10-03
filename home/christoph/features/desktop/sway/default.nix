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

    systemd.enable = true;

    config = {
      modifier = "Mod4";

      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
        kitty = lib.getExe config.programs.kitty.package;
        wofi = lib.getExe config.programs.wofi.package;
        makoctl = lib.getExe' config.services.mako.package "makoctl";
      in
        lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${kitty}";
          "${modifier}+d" = "exec ${wofi} -S run";
          "${modifier}+s" = "exec specialisation $(specialisation | ${wofi} -S dmenu)";
          "${modifier}+w" = "exec ${makoctl} dismiss";
          "${modifier}+Shift+w" = "exec ${makoctl} restore";
        };

      bars = [];

      defaultWorkspace = "workspace number 1";

      window.titlebar = false;
    };

    extraConfig = lib.concatMapStringsSep "\n" (
      m: "output ${m.name} ${
        if m.enabled
        then "enable res ${toString m.width}x${toString m.height}"
        else "disable"
      }"
    ) (config.monitors);
  };
}
