{
  programs.nixvim.plugins = {
    rustaceanvim = {
      enable = true;
      settings = {
        on_attach =
          # Lua
          ''
            function(client, bufnr)
              map("n", "<leader>rca", function()
                vim.cmd.RustLsp("codeAction")
              end, { desc = "Rust-specific code action" })
              map("n", "<leader>rco", function()
                vim.cmd.RustLsp("openCargo")
              end, { desc = "Open Cargo.toml" })
              map("n", "<leader>rcu", function()
                require("crates").upgrade_all_crates()
              end, { desc = "Update crates" })
            end
          '';
        default_settings = {
          rust-analyzer = {
            checkOnSave = {
              allFeatures = false;
              command = "clippy";
              extraArgs = ["--no-deps"];
            };
          };
        };
      };
    };
    crates-nvim.enable = true;
  };
}
