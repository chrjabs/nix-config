{
  lib,
  config,
  pkgs,
  outputs,
  inputs,
  ...
}: {
  imports = [
    ../common
  ];

  wayland.windowManager.sway = {
    enable = true;

    # package = inputs.nixpkgs-stable.legacyPackages.x86_64-linux.sway;

    systemd.enable = true;

    config = {
      modifier = "Mod4";

      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
        kitty = lib.getExe config.programs.kitty.package;
        wofi = lib.getExe config.programs.wofi.package;
        makoctl = lib.getExe' config.services.mako.package "makoctl";
        pactl = lib.getExe' pkgs.pulseaudio "pactl";
        playerctl = lib.getExe pkgs.playerctl;
        pass-wofi = lib.getExe pkgs.pass-wofi;
      in
        lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${kitty}";
          "${modifier}+d" = "exec ${wofi} -S drun";
          "${modifier}+Shift+d" = "exec ${wofi} -S drun";
          "${modifier}+s" = "exec specialisation $(specialisation | ${wofi} -S dmenu)";
          "${modifier}+w" = "exec ${makoctl} dismiss";
          "${modifier}+Shift+w" = "exec ${makoctl} restore";
          "${modifier}+p" = "exec ${pass-wofi}";
          # Media keys
          "XF86AudioMute" = "exec ${pactl} set-sink-mute \\@DEFAULT_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec ${pactl} set-sink-volume \\@DEFAULT_SINK@ -5%";
          "XF86AudioRaiseVolume" = "exec ${pactl} set-sink-volume \\@DEFAULT_SINK@ +5%";
          "XF86AudioPlay" = "exec ${playerctl} play-pause";
          "XF86AudioNext" = "exec ${playerctl} next";
          "XF86AudioPrev" = "exec ${playerctl} previous";
        };

      bars = [];

      defaultWorkspace = "workspace number 1";

      window.titlebar = false;
    };

    extraConfig = lib.concatMapStringsSep "\n" (
      m: "output ${m.name} ${
        if m.enabled
        then "enable res ${toString m.width}x${toString m.height} ${lib.optionalString (m.position != null) "position ${m.position}"} ${lib.optionalString (m.rotation != null) "transform ${m.rotation}"}"
        else "disable"
      }${lib.optionalString (m.workspaces != null) "\n${lib.concatMapStringsSep "\n" (w: "workspace ${w} output ${m.name}${lib.optionalString (m.fallback != null) " ${m.fallback}"}") (m.workspaces)}"}"
    ) (config.monitors);
  };
}
