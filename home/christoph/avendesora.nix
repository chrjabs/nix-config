{ config, ... }:
{
  imports = [
    ./global
  ];

  home.persistence."/persist".enable = false;
}
