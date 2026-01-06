{ config, ... }:
{
  home.persistence."/persist" = {
    directories = [
      ".rustup"
      ".cargo"
    ];
  };
}
