{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      # Git markers
      gitsigns.enable = true;
      # Status column
      snacks = {
        enable = true;
        settings = {
          statuscolumn.enabled = true;
          indent = {
            enabled = true;
            indent.char = "┊";
          };
          input.enabled = true;
          notifier.enabled = true;
          zen = {
            enabled = true;
            on_open.__raw = "function(win) vim.opt.scrolloff = 200 end";
            on_close.__raw = "function(win) vim.opt.scrolloff = 5 end";
          };
        };
      };
      # Status line
      airline = {
        enable = true;
        settings = {
          powerline_fonts = 1;
          skip_empty_sections = 1;
          theme = "base16";
        };
      };
      # Tab line
      bufferline.enable = true;
      # Dev icons
      web-devicons.enable = true;
    };

    opts = {
      # Always draw sign column
      signcolumn = "yes";
      # Don't show '~' for empty lines
      fillchars.eob = " ";
      # Disable nvim into
      shortmess = "I";
      # Numbers
      number = true;
      numberwidth = 2;
      # Indenting
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      softtabstop = 2;
    };

    keymaps = [
      {
        key = "<leader>b";
        action = "<CMD>enew<CR>";
        mode = "n";
        options.desc = "New empty buffer";
      }
      {
        key = "<leader>x";
        action.__raw = "function() Snacks.bufdelete() end";
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
      {
        key = "<leader>z";
        action.__raw = "function() Snacks.zen() end";
        mode = "n";
        options.desc = "Goto previous buffer";
      }
    ];

    extraPlugins = with pkgs.vimPlugins; [
      # Airline themes
      vim-airline-themes
    ];
  };
}
