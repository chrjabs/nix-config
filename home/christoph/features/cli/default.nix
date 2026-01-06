{ pkgs, ... }:
{
  imports = [
    ./bat.nix
    ./btop.nix
    ./carapace.nix
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
    programmer-calculator # CLI Calculator
    dysk # Better df
    delta # Better diff
    glow # CLI markdown renderer
    tree

    nixd # Nix LSP
    nix-output-monitor
  ];
  programs = {
    bash.enable = true;
    fd.enable = true;
  };
}
