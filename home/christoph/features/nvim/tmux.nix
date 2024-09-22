{
  programs.nixvim.plugins.tmux-navigator = lib.mkIf config.programs.tmux.enable {
    # TMUX integration
    enable = true;
    keymaps = [
      {
        action = "left";
        key = "<C-h>";
      }
      {
        action = "right";
        key = "<C-l>";
      }
      {
        action = "down";
        key = "<C-j>";
      }
      {
        action = "up";
        key = "<C-k>";
      }
    ];
  };
}
