{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    slack
    nautilus # needed as file selection dialog
  ];

  # TODO: figure out whether we can persist less
  home.persistence."/persist".directories = [ ".config/Slack" ];
}
