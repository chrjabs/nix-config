{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./browsing.nix
    ./completion.nix
    ./cpp.nix
    ./formatting.nix
    ./highlighting.nix
    ./latex.nix
    ./rust.nix
    ./tmux.nix
    ./ui.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;

    clipboard.register = "unnamedplus";

    plugins = {
      # Language server
      lsp = {
        enable = true;
        inlayHints = true;
      };
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
