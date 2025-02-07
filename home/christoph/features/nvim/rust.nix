{pkgs, ...}: {
  programs.nixvim.plugins = {
    rustaceanvim = {
      enable = true;
      settings.server = {
        on_attach =
          # Lua
          ''
            function(client, bufnr)
              local ret = _M.lspOnAttach(client, bufnr)
              local map = vim.keymap.set
              map("n", "<leader>ca", function()
                vim.cmd.RustLsp("codeAction")
              end, { desc = "rust-specific code action" })
              map("n", "<leader>co", function()
                vim.cmd.RustLsp("openCargo")
              end, { desc = "open Cargo.toml" })
              map("n", "<leader>cu", function()
                require("crates").upgrade_all_crates()
              end, { desc = "update crates" })
              map("n", "<ctrl>wd", function()
                vim.cmd.RustLsp({'renderDiagnostic', 'current'})
              end, { desc = "render diagnostic" })
              return ret
            end
          '';
        #default_settings = {
        #  rust-analyzer = {
        #    check = {
        #      command = "clippy";
        #      extraArgs = ["--no-deps"];
        #    };
        #    checkOnSave = true;
        #  };
        #};
      };
    };
    crates.enable = true;
  };
  # With codelldb on the path, the plugin automatically detects it
  home.packages = let
    codelldb = pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter;
  in [codelldb];
}
