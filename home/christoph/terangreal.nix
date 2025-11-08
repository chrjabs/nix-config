{ config, ... }:
{
  imports = [
    ./global
  ];

  home = {
    persistence."/persist/${config.home.homeDirectory}".enable = false;
    sessionVariables.NH_FLAKE = "github:chrjabs/nix-config/terangreal";
  };
}
