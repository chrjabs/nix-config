{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./browsing.nix
    ./codelldb.nix
    ./completion.nix
    ./cpp.nix
    ./debugging.nix
    ./formatting.nix
    ./highlighting.nix
    ./latex.nix
    ./lsp.nix
    ./rust.nix
    ./tmux.nix
    ./ui.nix

    ./syntax
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;

    clipboard.register = "unnamedplus";

    globals = {
      # Leader keys
      mapleader = " ";
      maplocalleader = ",";
    };

    opts = {
      # Matching case
      ignorecase = true;
      smartcase = true;
      # More intuitive splitting
      splitbelow = true;
      splitright = true;
      # Interval of writing swap file and updating gitsigns
      updatetime = 250;
      # Keep cursor away from top/bottom
      scrolloff = 5;
    };
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
