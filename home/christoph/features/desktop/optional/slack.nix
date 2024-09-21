{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [slack];

  # TODO: figure out whether we can persist less
  home.persistence."/persist/${config.home.homeDirectory}".directories = [".config/Slack"];
}
