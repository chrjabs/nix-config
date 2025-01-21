{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./global
  ];

  home.persistence."/persist/${config.home.homeDirectory}".enable = false;
}
