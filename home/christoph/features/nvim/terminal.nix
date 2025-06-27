{
  programs.nixvim = {
    plugins = {
      snacks = {
        enable = true;
        settings = {
          terminal.enabled = true;
        };
      };
    };

    keymaps = [
      {
        key = "<leader>t";
        action.__raw = "function() Snacks.terminal.toggle() end";
        mode = "n";
        options.desc = "Toggle terminal";
      }
    ];
  };
}
