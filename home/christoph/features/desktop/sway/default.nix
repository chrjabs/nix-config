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

  home.packages = with pkgs; [
    (flameshot.override {enableWlrSupport = true;})
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
        pactl = lib.getExe' pkgs.pulseaudio "pactl";
        playerctl = lib.getExe pkgs.playerctl;
        pass-wofi = lib.getExe pkgs.pass-wofi;
        joshuto = lib.getExe config.programs.joshuto.package;
        brightnessctl = lib.getExe pkgs.brightnessctl;
      in
        lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${kitty}";
          "${modifier}+d" = "exec ${wofi} -S drun";
          "${modifier}+Shift+d" = "exec ${wofi} -S drun";
          "${modifier}+s" = "exec specialisation $(specialisation | ${wofi} -S dmenu)";
          "${modifier}+w" = "exec ${makoctl} dismiss";
          "${modifier}+Shift+w" = "exec ${makoctl} restore";
          "${modifier}+Shift+s" = "exec ${makoctl} mode -t do-not-disturb";
          "${modifier}+p" = "exec ${pass-wofi}";
          "${modifier}+e" = "exec ${kitty} ${joshuto}";
          "${modifier}+Shift+l" = "exec swaylock";
          # Move workspace to other output
          "${modifier}+Ctrl+l" = "move workspace to output right";
          "${modifier}+Ctrl+h" = "move workspace to output left";
          "${modifier}+Ctrl+j" = "move workspace to output down";
          "${modifier}+Ctrl+k" = "move workspace to output up";
          # Media keys
          "XF86AudioMute" = "exec ${pactl} set-sink-mute \\@DEFAULT_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec ${pactl} set-sink-volume \\@DEFAULT_SINK@ -5%";
          "XF86AudioRaiseVolume" = "exec ${pactl} set-sink-volume \\@DEFAULT_SINK@ +5%";
          "XF86AudioPlay" = "exec ${playerctl} play-pause";
          "XF86AudioNext" = "exec ${playerctl} next";
          "XF86AudioPrev" = "exec ${playerctl} previous";
          "XF86MonBrightnessUp" = "exec ${brightnessctl} set 10%+";
          "XF86MonBrightnessDown" = "exec ${brightnessctl} set 10%-";
        };

      bars = [];

      defaultWorkspace = "workspace number 1";

      window.titlebar = false;

      input = {
        "type:touchpad" = {
          dwt = "enabled"; # disable while typing
          tap = "enabled";
        };
      };

      output = builtins.listToAttrs (builtins.map (m: {
          name = m.name;
          value = {
            disable = lib.mkIf (!m.enabled) "";
            res = "${toString m.width}x${toString m.height}";
            scale = toString m.scale;
            position = lib.mkIf (m.position != null) m.position;
          };
        })
        config.monitors);

      workspaceOutputAssign = lib.flatten (builtins.map (m:
        builtins.map (w: {
          workspace = w;
          output = m.name + lib.optionalString (m.fallback != null) " ${m.fallback}";
        })
        m.workspaces)
      config.monitors);
    };

    # extraConfig = lib.concatMapStringsSep "\n" (
    #   m: "output ${m.name} ${
    #     if m.enabled
    #     then "enable res ${toString m.width}x${toString m.height} scale ${toString m.scale} ${lib.optionalString (m.position != null) "position ${m.position}"} ${lib.optionalString (m.rotation != null) "transform ${m.rotation}"}"
    #     else "disable"
    #   }${lib.optionalString (m.workspaces != null) "\n${lib.concatMapStringsSep "\n" (w: "workspace ${w} output ${m.name}${lib.optionalString (m.fallback != null) " ${m.fallback}"}") (m.workspaces)}"}"
    # ) (config.monitors);
  };
}
