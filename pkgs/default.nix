# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs ? <nixpkgs> { },
  ...
}:
rec {
  # example = pkgs.callPackage ./example { };

  # Personal wallpaper collection for recoloring with base16 themes
  wallpapers = pkgs.callPackage ./wallpapers { };

  pass-fuzzel = pkgs.callPackage ./pass-fuzzel { };

  # Personal set(s) of typically needed latex packages
  latex = pkgs.callPackage ./latex { };

  # Behring WING
  wing-edit = pkgs.callPackage ./wing-edit { };

  # Jack Mixer
  jack-mixer = pkgs.callPackage ./jack-mixer { };
}
