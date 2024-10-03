# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? <nixpkgs> {}, ...}: {
  # example = pkgs.callPackage ./example { };
  wallpapers = pkgs.callPackage ./wallpapers {};
  latex = pkgs.callPackage ./latex {};
}
