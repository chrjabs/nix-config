{
  config,
  lib,
  pkgs,
  ...
}:
let
  gpgCmds = import ../../cli/gpg-commands.nix { inherit pkgs config lib; };
  commonDeps = with pkgs; [
    coreutils
    gnugrep
    systemd
  ];
  # Function to simplify making waybar outputs
  mkScript =
    {
      name ? "script",
      deps ? [ ],
      script ? "",
    }:
    lib.getExe (
      pkgs.writeShellApplication {
        inherit name;
        text = script;
        runtimeInputs = commonDeps ++ deps;
      }
    );
  # Specialized for JSON outputs
  mkScriptJson =
    {
      name ? "script",
      deps ? [ ],
      script ? "",
      text ? "",
      tooltip ? "",
      alt ? "",
      class ? "",
      percentage ? "",
    }:
    mkScript {
      inherit name;
      deps = [ pkgs.jq ] ++ deps;
      script = ''
        ${script}
        jq -cn \
          --arg text "${text}" \
          --arg tooltip "${tooltip}" \
          --arg alt "${alt}" \
          --arg class "${class}" \
          --arg percentage "${percentage}" \
          '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
      '';
    };

  swayCfg = config.wayland.windowManager.sway;
  hyprlandCfg = config.wayland.windowManager.hyprland;
in
{
  # Let it try to start a few more times
  systemd.user.services.waybar = {
    Unit.StartLimitBurst = 30;
  };
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
    });
    systemd.enable = true;
    settings = {
      primary = {
        exclusive = false;
        passthrough = false;
        height = 40;
        margin = "6";
        position = "top";
        mode = "dock";
        modules-left = [
          "custom/menu"
        ]
        ++ (lib.optionals swayCfg.enable [
          "sway/workspaces"
          "sway/mode"
        ])
        ++ (lib.optionals hyprlandCfg.enable [
          "hyprland/workspaces"
          "hyprland/submap"
        ])
        ++ [
          "niri/workspaces"
          "niri/submap"
          "custom/currentplayer"
          "custom/player"
        ];

        modules-center = [
          "cpu"
          "custom/gpu"
          "memory"
          "clock"
          "custom/unread-mail"
        ];

        modules-right = [
          "tray"
          "custom/sync-status"
          "custom/gpg-status"
          "custom/rfkill"
          "custom/dnd"
          "network"
          "pulseaudio"
          "battery"
        ];

        clock = {
          interval = 1;
          format = "{:%d/%m %H:%M}";
          format-alt = "{:%Y-%m-%d %H:%M:%S %z}";
          on-click-left = "mode";
          tooltip-format = ''
            <big>{:%Y %B %d}</big>
            <tt><small>{calendar}</small></tt>'';
        };

        cpu = {
          format = "  {usage}%";
        };
        "custom/gpu" = {
          interval = 5;
          exec = mkScript { script = "cat /sys/class/drm/card*/device/gpu_busy_percent | head -1"; };
          format = "󰒋  {}%";
        };
        memory = {
          format = "  {}%";
          interval = 5;
        };

        pulseaudio = {
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭 0%";
          format = "{icon} {volume}% {format_source}";
          format-muted = "󰸈 0% {format_source}";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = lib.getExe pkgs.pavucontrol;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
        };
        battery = {
          bat = "BAT0";
          interval = 10;
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          onclick = "";
        };
        "sway/window" = {
          max-length = 20;
        };
        network = {
          interval = 3;
          format-wifi = "  {essid}";
          format-ethernet = "󰈁";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
        };
        "custom/menu" = {
          format = "";
          on-click = mkScript {
            script = ''
              systemctl --user restart waybar
              echo "$USER@$HOSTNAME"
            '';
          };
        };
        "custom/unread-mail" = {
          interval = 10;
          return-type = "json";
          exec = mkScriptJson {
            deps = [
              pkgs.findutils
              pkgs.gawk
            ];
            script = ''
              inbox_count="$(find ~/Mail/${config.accounts.email.mainAccountPattern}/Inbox/new -type f | cut -d / -f5 | uniq -c | awk '{$1=$1};1')"
              if [ -z "$inbox_count" ]; then
                status="read"
                inbox_count="No new mail!"
              else
                status="unread"
              fi
            '';
            tooltip = "$inbox_count";
            alt = "$status";
          };
          format = "{icon}";
          format-icons = {
            "read" = "󰇯";
            "unread" = "󰇮";
          };
          on-click = mkScript {
            deps = [ pkgs.handlr-regex ];
            script = "handlr launch x-scheme-handler/mailto";
          };
        };
        "custom/next-event" = {
          interval = 10;
          return-type = "json";
          exec = mkScriptJson {
            deps = [
              config.programs.khal.package
            ];
            script = ''
              events="$(khal list now tomorrow --json title --json start-time | jq '.[] | "\(."start-time") \(.title)"' -r)"
              count="$(printf "%s" "$events" | grep -c "^" || true)"
              if [ "$count" == 0 ]; then
                status="no-event"
                events="No events!"
              else
                if test -n "$(khal list now 10m --json title --json start-time | jq '.[] | select(."start-time" != "") | "\(.title)"' -r)"; then
                  status="has-close-event"
                else
                  status="has-event"
                fi
              fi
            '';
            alt = "$status";
            tooltip = "$events";
          };
          format = "{icon}";
          format-icons = {
            has-event = "󰃭";
            has-close-event = "󰨱";
            no-event = "󰃮";
          };
          on-click = mkScript {
            deps = [ pkgs.handlr-regex ];
            script = "handlr launch text/calendar";
          };
        };
        "custom/gpg-status" = {
          interval = 3;
          return-type = "json";
          exec = mkScriptJson {
            script = ''
              if ${gpgCmds.isUnlocked}; then
                status="unlocked"
                tooltip="GPG is unlocked"
              else
                status="locked"
                tooltip="GPG is locked"
              fi
            '';
            alt = "$status";
            tooltip = "$tooltip";
          };
          on-click = mkScript {
            script = ''if ${gpgCmds.isUnlocked}; then ${gpgCmds.lock}; else ${gpgCmds.unlock}; fi'';
          };
          format = "{icon}";
          format-icons = {
            locked = "󰌾";
            unlocked = "󰿆";
          };
        };
        "custom/sync-status" = {
          interval = 3;
          return-type = "json";
          exec-if = gpgCmds.isUnlocked;
          exec = mkScriptJson {
            script = ''
              results="$(systemctl --user show mbsync.service vdirsyncer.service --property Id,Result,ActiveState)"
              last_sync="$(date --date="$(systemctl --user show mbsync.timer vdirsyncer.timer --property LastTriggerUSec --value | head -1)" +%H:%M)"
              if grep -q ActiveState=activating <<< "$results"; then
                tooltip="Syncing calendars and mail"
                status="activating"
              elif grep -q Result=exit-code <<< "$results"; then
                tooltip="Failed to sync calendars and mail"
                status="failed"
              elif grep -q Result=exec-condition <<< "$results"; then
                tooltip="Sync is paused as GPG key is not available"
                status="condition"
              elif [ "$(grep -c Result=success <<< "$results")" == 2 ]; then
                tooltip="Calendars and mail are synced"
                status="success"
              else
                tooltip="Unknown sync state"
                status="unknown"
              fi
              tooltip+=$'\n'"Last sync: $last_sync"
            '';
            tooltip = "$tooltip";
            alt = "$status";
          };
          on-click = mkScript { script = "systemctl --user start mbsync.service vdirsyncer.service"; };
          format = "{icon}";
          format-icons = {
            activating = "󰘿";
            failed = "󰧠";
            condition = "󱇱";
            success = "󰅠";
            unknown = "󰨹";
          };
        };
        "custom/currentplayer" = {
          interval = 2;
          return-type = "json";
          exec = mkScriptJson {
            deps = [ pkgs.playerctl ];
            script = ''
              all_players=$(playerctl -l 2>/dev/null)
              selected_player="$(playerctl status -f "{{playerName}}" 2>/dev/null || true)"
              clean_player="$(echo "$selected_player" | cut -d '.' -f1)"
            '';
            alt = "$clean_player";
            tooltip = "$all_players";
          };
          format = "{icon}{}";
          format-icons = {
            "" = " ";
            "Celluloid" = "󰎁 ";
            "spotify" = "󰓇 ";
            "spotify_player" = "󰓇 ";
            "ncspot" = "󰓇 ";
            "qutebrowser" = "󰖟 ";
            "firefox" = " ";
            "discord" = " 󰙯 ";
            "sublimemusic" = " ";
            "kdeconnect" = "󰄡 ";
            "chromium" = " ";
          };
        };
        "custom/player" = {
          exec-if = mkScript {
            deps = [ pkgs.playerctl ];
            script = ''
              selected_player="$(playerctl status -f "{{playerName}}" 2>/dev/null || true)"
              playerctl status -p "$selected_player" 2>/dev/null
            '';
          };
          exec = mkScript {
            deps = [ pkgs.playerctl ];
            script = ''
              selected_player="$(playerctl status -f "{{playerName}}" 2>/dev/null || true)"
              playerctl metadata -p "$selected_player" \
                --format '{"text": "{{artist}} - {{title}}", "alt": "{{status}}", "tooltip": "{{artist}} - {{title}} ({{album}})"}' 2>/dev/null
            '';
          };
          return-type = "json";
          interval = 2;
          max-length = 30;
          format = "{icon} {}";
          format-icons = {
            "Playing" = "󰐊";
            "Paused" = "󰏤 ";
            "Stopped" = "󰓛";
          };
          on-click = mkScript {
            deps = [ pkgs.playerctl ];
            script = "playerctl play-pause";
          };
        };
        "custom/rfkill" = {
          interval = 3;
          exec-if = mkScript {
            deps = [ pkgs.util-linux ];
            script = "rfkill list wifi | grep yes -q";
          };
          exec = "echo 󰀝";
        };
        "custom/dnd" = {
          interval = 3;
          exec-if = mkScript {
            deps = [ pkgs.mako ];
            script = "makoctl mode | grep 'do-not-disturb' -q";
          };
          exec = "echo 󱏧";
        };
      };
    };
    # Cheatsheet:
    # x -> all sides
    # x y -> vertical, horizontal
    # x y z -> top, horizontal, bottom
    # w x y z -> top, right, bottom, left
    style =
      # css
      ''
        * {
          padding: 0;
          margin: 0 0.4em;
        }

        window#waybar {
          background: rgba(0, 0, 0, 0);
        }
        .modules-left {
          padding: 0 0.4em;
          border-radius: 2em;
          background: alpha(@base01, ${with config.stylix.opacity; builtins.toString desktop});
        }
        .modules-center {
          padding: 0 0.4em;
          border-radius: 2em;
          background: alpha(@base01, ${with config.stylix.opacity; builtins.toString desktop});
        }
        .modules-right {
          padding: 0 0.4em;
          border-radius: 2em;
          background: alpha(@base01, ${with config.stylix.opacity; builtins.toString desktop});
        }

        #workspaces button {
          padding-left: 0.4em;
          padding-right: 0.4em;
          margin-top: 0.15em;
          margin-bottom: 0.15em;
        }

        #clock {
          padding-right: 0.7em;
          padding-left: 0.7em;
          border-radius: 0.5em;
        }

        #custom-menu {
          padding-right: 1.5em;
          padding-left: 1em;
          margin-right: 0;
          border-radius: 0.5em;
        }
        #custom-unread-mail {
          padding-right: 0.7em
        }
        #custom-sync-status {
          padding-right: 0.5em
        }
        #custom-currentplayer {
          padding-right: 0;
        }
        #custom-gpu, #cpu, #memory {
          margin-left: 0.05em;
          margin-right: 0.55em;
        }
      '';
  };
}
