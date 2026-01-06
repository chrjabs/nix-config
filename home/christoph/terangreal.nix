{ config, ... }:
{
  imports = [
    ./global
  ];

  home = {
    persistence."/persist".enable = false;
    sessionVariables.NH_FLAKE = "github:chrjabs/nix-config/terangreal";
  };
}
