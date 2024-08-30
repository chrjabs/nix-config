{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./fish.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gpg.nix
    ./ssh.nix
    ./starship
    ./tmux.nix
    ./zoxide.nix
  ];
  home.packages = with pkgs; [
    bottom # System viewer
    eza # Better ls
    ripgrep # Better grep
    diffsitter # Better diff

    nixd # Nix LSP
    alejandra # Nix formatter
  ];
  programs = {
    bash.enable = true;
    joshuto.enable = true;
  };
}
