{ pkgs, ... }:
{
  # ensure `services.udisks2` is enabled
  home.packages = with pkgs; [ calibre ];
}
