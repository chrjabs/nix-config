# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs ? <nixpkgs> {},
  inputs,
  ...
}: rec {
  # example = pkgs.callPackage ./example { };

  # Personal wallpaper collection for recoloring with base16 themes
  wallpapers = pkgs.callPackage ./wallpapers {};

  pass-wofi = pkgs.callPackage ./pass-wofi {};

  # Personal set(s) of typically needed latex packages
  latex = {
    default = pkgs.callPackage ./latex {};
    lipics = pkgs.callPackage ./latex/lipics.nix {};
  };

  # Kani Rust Verifier
  kani = pkgs.callPackage ./kani {inherit (inputs) rust-overlay;};

  # VeriPB proof checker
  veripb = pkgs.python3Packages.callPackage ./veripb {};
  pboxide = pkgs.callPackage ./pboxide {};

  # GBD benchmark database ecosystem
  gbd = pkgs.python3Packages.callPackage ./gbd {inherit python-gbdc;};
  gbdc = pkgs.callPackage ./gbdc {};
  python-gbdc = pkgs.python3Packages.callPackage ./python-gbdc {};

  # Python-MIP
  python-cffi-1-15 = pkgs.python3Packages.callPackage ./python-cffi-1-15 {};
  python-mip = pkgs.python3Packages.callPackage ./python-mip {inherit python-cffi-1-15;};

  # Behring WING
  wing-edit = pkgs.callPackage ./wing-edit {};

  # Jack Mixer
  jack-mixer = pkgs.callPackage ./jack-mixer {};

  # csc Calculator
  csc = pkgs.callPackage ./csc {};
}
