{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [zoom-us];

  home.persistence."/persist/${config.home.homeDirectory}" = {
    files = [".config/zoom.conf" ".config/zoomus.conf"];
    directories = [".zoom/data"];
  };

  # NOTE: Following the discussion below, I had to force Zoom to not use xwayland
  # Getting screen sharing to work is still pending
  # https://github.com/YaLTeR/niri/discussions/1453
}
