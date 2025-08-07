{
  imports = [
    ./vdirsyncer.nix
    ./khal.nix
    ./khard.nix
    ./todoman.nix

    ./mail.nix
    ./neomutt.nix
    ./oama.nix

    # Pass feature is required
    ../pass
  ];
}
