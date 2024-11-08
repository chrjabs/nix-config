{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./btop.nix
    ./devenv.nix
    ./direnv.nix
    ./fish.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gpg.nix
    ./joshuto.nix
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
  };
}
