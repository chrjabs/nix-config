{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [zoom-us];

  home.persistence."/persist/${config.home.homeDirectory}" = {
    files = [".config/zoom.conf"];
    directories = [".zoom/data"];
  };
}
