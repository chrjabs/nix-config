{
  lib,
  config,
  pkgs,
  nixosConfig ? null,
  ...
}:
{
  imports = [
    ../common
  ];

  home.packages = with pkgs; [
    (flameshot.override { enableWlrSupport = true; })
    config.monitors.swayLayoutsScript
  ];

  wayland.windowManager.sway = {
    enable = true;

    systemd.enable = true;

    config = {
      modifier = "Mod4";

      modes = {
        resize = {
          Escape = "mode default";
          Return = "mode default";
          h = "resize shrink width 10 px";
          j = "resize grow height 10 px";
          k = "resize shrink height 10 px";
          l = "resize grow width 10 px";
        };
        move = {
          Escape = "mode default";
          Return = "mode default";
          h = "move left";
          j = "move down";
          k = "move up";
          l = "move right";
        };
        move-workspace = {
          Escape = "mode default";
          Return = "mode default";
          h = "move workspace to output left";
          j = "move workspace to output down";
          k = "move workspace to output up";
          l = "move workspace to output right";
        };
      };

      keybindings =
        let
          inherit (config.wayland.windowManager.sway.config) modifier;
          kitty = lib.getExe config.programs.kitty.package;
          fuzzel = lib.getExe config.programs.fuzzel.package;
          makoctl = lib.getExe' config.services.mako.package "makoctl";
          pactl = lib.getExe' pkgs.pulseaudio "pactl";
          playerctl = lib.getExe pkgs.playerctl;
          pass-fuzzel = lib.getExe pkgs.pass-fuzzel;
          joshuto = lib.getExe config.programs.joshuto.package;
          brightnessctl = lib.getExe pkgs.brightnessctl;
          swaylock = lib.getExe config.programs.swaylock.package;
          monitorLayouts = lib.getExe config.monitors.swayLayoutsScript;
        in
        lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${kitty}";
          "${modifier}+d" = "exec ${fuzzel}";
          "${modifier}+s" = "exec ${specialisation} $(${specialisation} | ${fuzzel} --dmenu)";
          "${modifier}+w" = "exec ${makoctl} dismiss";
          "${modifier}+Shift+w" = "exec ${makoctl} restore";
          "${modifier}+Shift+s" = "exec ${makoctl} mode -t do-not-disturb";
          "${modifier}+p" = "exec ${pass-fuzzel}";
          "${modifier}+e" = "exec ${kitty} ${joshuto}";
          "${modifier}+Alt+l" = "exec ${swaylock} --daemonize --grace 15";
          "${modifier}+Shift+o" = "exec ${monitorLayouts} $(${monitorLayouts} | ${fuzzel} --dmenu)";
          "${modifier}+m" = "mode move";
          "${modifier}+Shift+m" = "mode move-workspace";
          # Media keys
          "XF86AudioMute" = "exec ${pactl} set-sink-mute \\@DEFAULT_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec ${pactl} set-sink-volume \\@DEFAULT_SINK@ -5%";
          "XF86AudioRaiseVolume" = "exec ${pactl} set-sink-volume \\@DEFAULT_SINK@ +5%";
          "XF86AudioPlay" = "exec ${playerctl} play-pause";
          "XF86AudioNext" = "exec ${playerctl} next";
          "XF86AudioPrev" = "exec ${playerctl} previous";
          "XF86MonBrightnessUp" = "exec ${brightnessctl} set 10%+";
          "XF86MonBrightnessDown" = "exec ${brightnessctl} set 10%-";
        }
        // lib.attrsets.optionalAttrs (nixosConfig != null) {
          "${modifier}+s" =
            let
              specialisation = lib.getExe nixosConfig.specialisationScript;
            in
            "exec ${specialisation} $(${specialisation} | ${fuzzel} --dmenu)";
        };

      bars = [ ];

      defaultWorkspace = "workspace number 1";

      window.titlebar = false;

      input = {
        "type:touchpad" = {
          dwt = "enabled"; # disable while typing
          tap = "enabled";
        };
      };

      output = lib.mkIf (config.monitors.layouts.default != null) (
        builtins.mapAttrs (_: m: {
          # somwhat hacky way of getting `disable` to show up if a monitor is not enabled
          disable = lib.mkIf (!m.enabled) "";
          mode = lib.mkIf (m.mode != null) (
            "${toString m.mode.x}x${toString m.mode.y}"
            + lib.optionalString (m.mode.rate != null) "@${toString m.mode.rate}Hz"
          );
          scale = lib.mkIf (m.scale != null) (toString m.scale);
          position = lib.mkIf (m.position != null) "${toString m.position.x} ${toString m.position.y}";
          transform = lib.mkIf (m.rotation != null) (toString m.rotation);
        }) config.monitors.layouts.default
      );

      workspaceOutputAssign = lib.mkIf (config.monitors.layouts.default != null) (
        lib.flatten (
          lib.mapAttrsToList (
            name: m:
            (builtins.map (w: {
              workspace = w;
              output = [ name ] ++ lib.optionals (m.fallback != null) [ m.fallback ];
            }) m.workspaces)
          ) config.monitors.layouts.default
        )
      );
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    config.sway = {
      default = [
        "wlr"
        "gtk"
      ];
    };
  };
}
