{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    shortcut = "Space";
    baseIndex = 1;

    plugins = with pkgs.tmuxPlugins; [
      sensible # Sensible defaults
      yank # Clipboard support
      vim-tmux-navigator # Tie in tmux pane and vim window navigation
      catppuccin # Theme
    ];
  };
}
