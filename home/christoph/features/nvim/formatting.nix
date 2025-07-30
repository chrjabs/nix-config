{ pkgs, ... }:
{
  programs.nixvim = {
    # The plugin itself
    plugins.conform-nvim = {
      # Formatting
      enable = true;
      settings = {
        formatters_by_ft = {
          "*" = [ "injected" ];
          lua = [ "stylua" ];
          python = [ "black" ];
          rust = [ "rustfmt" ];
          cpp = [ "clang_format" ];
          toml = [ "taplo" ];
          nix = [ "nixfmt" ];
          just = [ "just" ];
        };
        format_on_save =
          # Lua
          ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              return { timeout_ms = 200, lsp_fallback = true }
            end
          '';
        format_after_save =
          # Lua
          ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
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
        action.__raw = "function() require(\"conform\").format({ async = true, lsp_fallback = true }) end";
        mode = "n";
        options.desc = "Format buffer";
      }
    ];

    # User commands for disabling formatting
    userCommands = {
      FormatDisable = {
        bang = true;
        desc = "Disable format on save (only for this buffer with bang)";
        command.__raw =
          # Lua
          ''
            function(args)
              if args.bang then
              	vim.b.disable_autoformat = true
              else
              	vim.g.disable_autoformat = true
              end
            end
          '';
      };
      FormatEnable = {
        desc = "Re-enable format on save";
        command.__raw =
          # Lua
          ''
            function()
              vim.b.disable_autoformat = false
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
      nixfmt-rfc-style
    ];
  };
}
