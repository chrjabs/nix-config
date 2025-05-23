{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs.edge; [zoom-us];

  home.persistence."/persist/${config.home.homeDirectory}".files = [".config/zoomus.conf"];
}
