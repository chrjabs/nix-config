# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  workMode = import ./work-mode.nix;
  specialisationScript = import ./specialisation-script.nix;
}
