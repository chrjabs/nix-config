{
  programs.nixvim = {
    plugins = {
    # Git markers
    gitsigns.enable = true;
    # Status line
    airline.enable = true;
    # Tab line
    bufferline.enable = true;
  };

  keymaps = {
      {
        key = "<leader>b";
        action = "<CMD>enew<CR>";
        mode = "n";
        options.desc = "New empty buffer";
      }
      {
        key = "<leader>x";
        action = "<CMD>bd<CR>";
        mode = "n";
        options.desc = "Close current buffer";
      }
      {
        key = "<tab>";
        action = "<CMD>bn<CR>";
        mode = "n";
        options.desc = "Goto next buffer";
      }
      {
        key = "<S-tab>";
        action = "<CMD>bp<CR>";
        mode = "n";
        options.desc = "Goto previous buffer";
      }
  };
}
