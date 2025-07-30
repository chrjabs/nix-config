{
  pkgs,
  lib,
  ...
}:
{
  programs.nixvim.plugins = {
    dap-lldb = {
      enable = true;
      settings.codelldb_path = lib.getExe' pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter "codelldb";
    };
    # language server for `.vscode/launch.json`
    lsp.servers.jsonls.enable = true;
  };
}
