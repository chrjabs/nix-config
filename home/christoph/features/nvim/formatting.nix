{pkgs, ...}: {
  programs.nixvim = {
    # The plugin itself
    plugins.conform-nvim = {
      # Formatting
      enable = true;
      settings = {
        formatter_by_ft = {
          lua = ["stylua"];
          python = ["black"];
          rust = ["rustfmt"];
          cpp = ["cland_format"];
          toml = ["taplo"];
        };
        format_on_save =
          # Lua
          ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              if slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
              end

              local function on_format(err)
                if err and err:match("timeout$") then
                  slow_format_filetypes[vim.bo[bufnr].filetype] = true
                end
              end

              return { timeout_ms = 200, lsp_fallback = true }, on_format
             end
          '';
        format_after_save =
          # Lua
          ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
              end

              return { lsp_fallback = true }
            end
          '';
      };
    };

    # Keymaps
    keymaps = [
      {
        key = "<leader>fm";
        action = "function() require(\"conform\").format({ async = true, lap_fallback = true }) end";
        mode = "n";
        options.desc = "Format buffer";
      }
    ];

    # User commands for disabling formatting
    userCommands = {
      FormatDisable = {
        bang = true;
        desc = "Disable format on save (only for this buffer with bang)";
        command =
          # Lua
          ''
            if args.bang then
            	vim.b.disable_autoformat = true
            else
            	vim.g.disable_autoformat = true
            end
          '';
      };
      FormatEnable = {
        bang = true;
        desc = "Re-enable format on save (only for this buffer with bang)";
        command =
          # Lua
          ''
            if args.bang then
            	vim.b.disable_autoformat = false
            else
            	vim.g.disable_autoformat = false
            end
          '';
      };
    };

    # Dependencies
    extraPackages = with pkgs; [
      # Formatters
      stylua
      black
      rustfmt
      clang-tools
      taplo
    ];
  };
}
