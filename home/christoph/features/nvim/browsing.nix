{
  programs.nixvim = {
    plugins = {
      telescope = {
        # Fuzzy finder
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
      };
      # File tree
      nvim-tree.enable = true;
    };

    keymaps = [
      # Telescope
      {
        key = "<leader>ff";
        action = "<CMD>Telescope find_files<CR>";
        mode = "n";
        options.desc = "Find file";
      }
      {
        key = "<leader>fa";
        action = "<CMD>Telescope find_files follow=true no_ignore=true hidden=true<CR>";
        mode = "n";
        options.desc = "Find file (include ignored/hidden)";
      }
      {
        key = "<leader>fw";
        action = "<CMD>Telescope live_grep<CR>";
        mode = "n";
        options.desc = "Find in all files";
      }
      {
        key = "<leader>fb";
        action = "<CMD>Telescope buffers<CR>";
        mode = "n";
        options.desc = "Find buffer";
      }
      {
        key = "<leader>fz";
        action = "<CMD>Telescope current_buffer_fuzzy_find<CR>";
        mode = "n";
        options.desc = "Find in current buffer";
      }
      {
        key = "<leader>fz";
        action = "<CMD>Telescope current_buffer_fuzzy_find<CR>";
        mode = "n";
        options.desc = "Find in current buffer";
      }
      {
        key = "<leader>ft";
        action = "<CMD>TodoTelescope<CR>";
        mode = "n";
        options.desc = "Find todos";
      }
      # Nvim Tree
      {
        key = "<C-n>";
        action = "<CMD>NvimTreeToggle<CR>";
        mode = "n";
        options.desc = "Toggle file tree";
      }
      {
        key = "<leader>e";
        action = "<CMD>NvimTreeFocus<CR>";
        mode = "n";
        options.desc = "Focus file tree";
      }
    ];
  };
}
