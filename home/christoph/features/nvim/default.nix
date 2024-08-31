{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./lsp.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;

    clipboard.register = "unnamedplus";

    plugins = {
      # File tree
      nvim-tree.enable = true;

      # Fuzzy finder
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
      };

      # Formatting
      conform-nvim = {
        enable = true;
        settings = {
          formatter_by_ft = {
            lua = ["stylua"];
            python = ["black"];
            rust = ["rustfmt"];
            cpp = ["cland_format"];
            toml = ["taplo"];
          };
        };
      };

      # Git markers
      gitsigns.enable = true;

      # Completion
      cmp = {
        enable = true;
        settings = {
          mapping = {
            "<S-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };

      # Treesitter language parsing
      treesitter.enable = true;
      treesitter-textobjects.enable = true;

      # Vimtex
      vimtex = lib.mkIf config.programs.texlive.enable {
        enable = true;
        texlivePackage = null;
        settings.view_method = "zathura";
      };

      # Automatic configuration of CMake projects
      cmake-tools.enable = true;

      # UI
      airline.enable = true;
      bufferline.enable = true;

      # TMUX integration
      tmux-navigator = lib.mkIf config.programs.tmux.enable {
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
    };

    extraPackages = with pkgs; [
      # Formatters
      stylua
      black
      rustfmt
      clang-tools
      taplo
    ];
  };

  xdg.desktopEntries = {
    nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "nvim %F";
      icon = "nvim";
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "text/x-c"
        "text/x-c++"
        "application/x-shellscript"
      ];
      terminal = true;
      type = "Application";
      categories = [
        "Utility"
        "TextEditor"
      ];
    };
  };
}
