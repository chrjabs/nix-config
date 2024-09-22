{pkgs, ...}: {
  programs.nixvim.plugins = {
    # Treesitter
    treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        make
        markdown
        nix
        regex
        toml
        vim
        vimdoc
        yaml
        cpp
        rust
        julia
        python
      ];
    };
    treesitter-textobjects.enable = true;
    # Highlight TODO comments
    todo-comments.enable = true;
  };
}
