{ pkgs, ... }:
{
  plugins = {
    # Treesitter
    treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        # keep-sorted start
        bash
        cpp
        gnuplot
        julia
        just
        make
        markdown
        nix
        nu
        python
        regex
        rust
        toml
        vim
        vimdoc
        yaml
        # keep-sorted end
      ];
    };
    treesitter-textobjects.enable = true;
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 3;
        min_window_height = 25;
      };
    };
    # Highlight TODO comments
    todo-comments.enable = true;
  };
  filetype.extension = {
    "plt" = "gnuplot";
  };
}
