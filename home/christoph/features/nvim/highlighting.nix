{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      # Treesitter
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.nixvim.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          gnuplot
          make
          markdown
          nix
          nu
          regex
          toml
          vim
          vimdoc
          yaml
          cpp
          rust
          julia
          python
          just
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
  };
}
