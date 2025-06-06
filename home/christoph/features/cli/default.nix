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
    ./jj.nix
    ./joshuto.nix
    ./ssh.nix
    ./starship
    ./tmux.nix
    ./zoxide.nix
  ];
  home.packages = with pkgs; [
    eza # Better ls
    ripgrep # Better grep
    diffsitter # Better diff
    csc # CLI Calculator
    dysk # Better df

    nixd # Nix LSP
    alejandra # Nix formatter
    nix-output-monitor
  ];
  programs = {
    bash.enable = true;
  };
}
