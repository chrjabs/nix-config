{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./btop.nix
    ./carapace.nix
    ./devenv.nix
    ./direnv.nix
    ./fish.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gpg.nix
    ./jj.nix
    ./joshuto.nix
    ./newsboat.nix
    ./ssh.nix
    ./starship
    ./tmux.nix
    ./zoxide.nix
  ];
  home.packages = with pkgs; [
    eza # Better ls
    ripgrep # Better grep
    csc # CLI Calculator
    dysk # Better df
    delta # Better diff
    glow # CLI markdown renderer

    nixd # Nix LSP
    alejandra # Nix formatter
    nix-output-monitor
  ];
  programs = {
    bash.enable = true;
    fd.enable = true;
  };
}
