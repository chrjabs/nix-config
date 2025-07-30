{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [ obsidian ];

  home.persistence."/persist/${config.home.homeDirectory}".directories = [ ".config/obsidian" ];
}
