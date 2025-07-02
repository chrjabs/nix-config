{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../common
  ];

  programs.niri = {
    settings = {
      layout = {
        gaps = 8;
        default-column-width = {proportion = 1. / 2.;};
        preset-column-widths = [
          {proportion = 1. / 3.;}
          {proportion = 1. / 2.;}
          {proportion = 2. / 3.;}
          {proportion = 1.;}
        ];
        border.width = 3;
        always-center-single-column = true;
        empty-workspace-above-first = true;
      };
      prefer-no-csd = true;
      animations.slowdown = 0.8;

      input.focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "10%";
      };

      binds = with config.lib.niri.actions; let
        kitty = lib.getExe config.programs.kitty.package;
        fuzzel = lib.getExe config.programs.fuzzel.package;
        makoctl = lib.getExe' config.services.mako.package "makoctl";
        pactl = lib.getExe' pkgs.pulseaudio "pactl";
        playerctl = lib.getExe pkgs.playerctl;
        pass-fuzzel = lib.getExe pkgs.pass-fuzzel;
        joshuto = lib.getExe config.programs.joshuto.package;
        brightnessctl = lib.getExe pkgs.brightnessctl;
        swaylock = lib.getExe config.programs.swaylock.package;
      in {
        "Mod+Shift+Slash".action = show-hotkey-overlay;
        "Mod+Shift+e".action = quit;

        "Mod+Return".action.spawn = kitty;
        "Mod+d".action.spawn = fuzzel;
        "Mod+s".action.spawn = ["sh" "-c" "specialisation $(specialisation | ${fuzzel} --dmenu)"];
        "Mod+w".action.spawn = [makoctl "dismiss"];
        "Mod+Shift+w".action.spawn = [makoctl "restore"];
        "Mod+Shift+s".action.spawn = [makoctl "mode" "-t" "do-not-disturb"];
        "Mod+p".action.spawn = pass-fuzzel;
        "Mod+e".action.spawn = [kitty joshuto];
        "Mod+Alt+l".action.spawn = [swaylock "--daemonize" "--grace" "15"];
        "Mod+Shift+q".action = close-window;
        "Mod+o" = {
          action = toggle-overview;
          repeat = false;
        };
        "Mod+h".action = focus-column-or-monitor-left;
        "Mod+j".action = focus-window-or-workspace-down;
        "Mod+k".action = focus-window-or-workspace-up;
        "Mod+l".action = focus-column-or-monitor-right;
        "Mod+Shift+h".action = move-column-left-or-to-monitor-left;
        "Mod+Shift+j".action = move-window-down-or-to-workspace-down;
        "Mod+Shift+k".action = move-window-up-or-to-workspace-up;
        "Mod+Shift+l".action = move-column-right-or-to-monitor-right;
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+0".action.focus-workspace = 10;
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;
        "Mod+Shift+0".action.move-column-to-workspace = 10;
        "Mod+c".action = center-column;
        "Mod+m".action = maximize-column;
        "Mod+f".action = fullscreen-window;
        "Mod+r".action = switch-preset-column-width;
        "Mod+Shift+r".action = switch-preset-window-height;
        "Mod+Shift+space".action = toggle-window-floating;
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;
        "Mod+Comma".action = focus-monitor-next;
        "Mod+Ctrl+s".action = screenshot-window;
        # Media keys
        "XF86AudioMute" = {
          action.spawn = [pactl "set-sink-mute" "@DEFAULT_SINK@" "toggle"];
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action.spawn = [pactl "set-sink-volume" "@DEFAULT_SINK@" "-5%"];
          allow-when-locked = true;
        };
        "XF86AudioRaiseVolume" = {
          action.spawn = [pactl "set-sink-volume" "@DEFAULT_SINK@" "+5%"];
          allow-when-locked = true;
        };
        "XF86AudioPlay" = {
          action.spawn = [playerctl "play-pause"];
          allow-when-locked = true;
        };
        "XF86AudioNext" = {
          action.spawn = [playerctl "next"];
          allow-when-locked = true;
        };
        "XF86AudioPrev" = {
          action.spawn = [playerctl "previous"];
          allow-when-locked = true;
        };
        "XF86MonBrightnessUp" = {
          action.spawn = [brightnessctl "set" "10%+"];
          allow-when-locked = true;
        };
        "XF86MonBrightnessDown" = {
          action.spawn = [brightnessctl "set" "10%-"];
          allow-when-locked = true;
        };
      };

      hotkey-overlay.skip-at-startup = true;

      outputs = lib.mkIf (config.monitors.layouts.default != null) (builtins.mapAttrs (_: m: {
          inherit (m) scale position;
          enable = m.enabled;
          mode = lib.mkIf (m.mode != null) {
            width = m.mode.x;
            height = m.mode.y;
            refresh = lib.mkIf (m.mode.rate != null) m.mode.rate;
          };
          transform.rotation =
            if (m.rotation == null)
            then 0
            else 360 - m.rotation;
        })
        config.monitors.layouts.default);

      window-rules = [
        # Zoom popups
        {
          matches = [
            {
              app-id = "Zoom Workplace";
              title = ".*menu.*";
            }
          ];
          open-floating = true;
          min-width = 250;
          open-focused = true;
        }
        # Zoom screensharing overlay
        {
          matches = [
            {
              app-id = "Zoom Workplace";
              title = "as_toolbar";
            }
          ];
          open-floating = true;
          open-focused = true;
        }
        {
          matches = [
            {
              app-id = "firefox$";
            }
          ];
          open-maximized = true;
        }
      ];

      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite-unstable;
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    config.niri = {
      default = ["gnome" "gtk"];
    };
  };

  # Swaybg as systemd unit so that it gets reloaded on specialisation change
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Set desktop background";
      After = ["niri.service"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} --image ${config.stylix.image} --mode fill";
      Restart = "on-failure";
    };
    Install.WantedBy = ["niri.service"];
  };
}
