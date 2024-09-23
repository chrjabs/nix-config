{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      # Git markers
      gitsigns.enable = true;
      # Status line
      airline = {
        enable = true;
        settings = {
          powerline_fonts = 1;
          skip_empty_sections = 1;
        };
      };
      # Tab line
      bufferline.enable = true;
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
    ];

    extraPlugins = with pkgs.vimPlugins; [
      # Airline themes
      vim-airline-themes
    ];
  };
}
