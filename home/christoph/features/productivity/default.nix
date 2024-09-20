{
  imports = [
    ./vdirsyncer.nix
    ./khal.nix
    ./khard.nix
    ./todoman.nix

    ./mail.nix
    ./neomutt.nix

    # Pass feature is required
    ../pass
  ];
}
