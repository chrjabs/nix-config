{
  pkgs,
  lib,
  config,
  nixosConfig,
  ...
}:
let
  swaylock = lib.getExe config.programs.swaylock.package;
  pgrep = lib.getExe' pkgs.procps "prgrep";
  hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hypercts";
  swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
  niri = lib.getExe config.programs.niri.package;

  isLocked = "${pgrep} -x ${swaylock}";

  # Makes two timeouts: one for when the screen is not locked (lockTime+timeout) and one for when it is.
  afterLockTimeout =
    {
      timeout,
      command,
      resumeCommand ? null,
    }:
    [
      {
        timeout = config.services.swayidle.lockTime + timeout;
        inherit command resumeCommand;
      }
      {
        command = "${isLocked} && ${command}";
        inherit resumeCommand timeout;
      }
    ];

  niri-all-outputs = lib.getExe (
    pkgs.writeShellScriptBin "niri-all-outputs" ''
      outputs=$(${niri} msg outputs | ${lib.getExe pkgs.gnused} -nE 's/Output .+\((.+)\)$/\1/p')
      for output in $outputs; do
        ${niri} msg output $output "$@"
      done
    ''
  );
in
{
  options.services.swayidle.lockTime = lib.mkOption {
    type = lib.types.int;
    default = 4 * 60; # 4 min
    description = "time after which to lock the screen";
  };

  config.services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    timeouts =
      # Lock screen
      [
        {
          timeout = config.services.swayidle.lockTime;
          command = "${swaylock} --daemonize --grace 15";
        }
      ]
      ++
        # Turn off displays (hyprland)
        (lib.optionals config.wayland.windowManager.hyprland.enable (afterLockTimeout {
          timeout = 40;
          command = "${hyprctl} dispatch dpms off";
          resumeCommand = "${hyprctl} dispatch dpms on";
        }))
      ++
        # Turn off displays (sway)
        (lib.optionals config.wayland.windowManager.sway.enable (afterLockTimeout {
          timeout = 40;
          command = "${swaymsg} 'output * dpms off'";
          resumeCommand = "${swaymsg} 'output * dpms on'";
        }))
      ++
        # Turn off displays (niri)
        (lib.optionals (nixosConfig != null && nixosConfig.programs.niri.enable) (afterLockTimeout {
          timeout = 40;
          command = "${niri-all-outputs} off";
          resumeCommand = "${niri-all-outputs} on";
        }));
    # Lock before sleep
    events = {
      before-sleep = "${swaylock} --daemonize";
      lock = "${swaylock} --daemonize --grace 15";
    };
  };
}
