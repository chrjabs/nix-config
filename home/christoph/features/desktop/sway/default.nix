{
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;

    config = {};
  };
}
