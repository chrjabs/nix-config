{
  programs.nixvim.plugins = {
    # Automatic configuration of CMake projects
    cmake-tools.enable = true;
    # Language server
    lsp.servers.clangd.enable = true;
  };
}
