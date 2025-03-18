{
  programs.nixvim = {
    plugins = {
      snacks = {
        enable = true;
        settings = {
          # Fuzzy finder
          picker.enabled = true;
          # File tree
          explorer.enabled = true;
        };
      };
    };

    keymaps = [
      # Picker
      {
        key = "<leader>ff";
        action.__raw = "function() Snacks.picker.files() end";
        mode = "n";
        options.desc = "Find file";
      }
      {
        key = "<leader>fa";
        action.__raw = "function() Snacks.picker.files({ hidden = true, ignored = true, follow = true }) end";
        mode = "n";
        options.desc = "Find file (include ignored/hidden)";
      }
      {
        key = "<leader>fw";
        action.__raw = "function() Snacks.picker.grep() end";
        mode = "n";
        options.desc = "Find in all files";
      }
      {
        key = "<leader>fb";
        action.__raw = "function() Snacks.picker.buffers() end";
        mode = "n";
        options.desc = "Find buffer";
      }
      {
        key = "<leader>fz";
        action.__raw = "function() Snacks.picker.lines() end";
        mode = "n";
        options.desc = "Find in current buffer";
      }
      {
        key = "<leader>ft";
        action.__raw = "function() Snacks.picker.todo_comments() end";
        mode = "n";
        options.desc = "Find todos";
      }
      {
        key = "<leader>gl";
        action.__raw = "function() Snacks.picker.git_log() end";
        mode = "n";
        options.desc = "Find in git log";
      }
      # Explorer
      {
        key = "<leader>e";
        action.__raw = "function() Snacks.explorer.reveal() end";
        mode = "n";
        options.desc = "Reveal current file in explorer";
      }
    ];
  };
}
