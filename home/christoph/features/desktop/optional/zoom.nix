{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [ zoom-us ];

  home.persistence."/persist" = {
    files = [
      ".config/zoom.conf"
      ".config/zoomus.conf"
    ];
    directories = [ ".zoom/data" ];
  };
}
