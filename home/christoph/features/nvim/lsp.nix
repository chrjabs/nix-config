{ lib, ... }:
{
  plugins.lsp = {
    enable = true;
    inlayHints = true;
  };

  # LSP progress notification
  extraConfigLuaPre =
    # lua
    ''
      local progress = vim.defaulttable()
    '';
  autoCmd = [
    {
      event = "LspProgress";
      callback =
        lib.nixvim.mkRaw
          # lua
          ''
            function(ev)
              local client = vim.lsp.get_client_by_id(ev.data.client_id)
              local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
              if not client or type(value) ~= "table" then
                return
              end
              local p = progress[client.id]

              for i = 1, #p + 1 do
                if i == #p + 1 or p[i].token == ev.data.params.token then
                  p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                      value.kind == "end" and 100 or value.percentage or 100,
                      value.title or "",
                      value.message and (" **%s**"):format(value.message) or ""
                    ),
                    done = value.kind == "end",
                  }
                  break
                end
              end

              local msg = {} ---@type string[]
              progress[client.id] = vim.tbl_filter(function(v)
                return table.insert(msg, v.msg) or not v.done
              end, p)

              local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
              vim.notify(table.concat(msg, "\n"), "info", {
                id = "lsp_progress",
                title = client.name,
                opts = function(notif)
                  notif.icon = #progress[client.id] == 0 and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                end,
              })
            end
          '';
    }
  ];
  lsp.keymaps = [
    {
      key = "gD";
      lspBufAction = "declaration";
      options.desc = "go to declaration";
    }
    {
      key = "gd";
      lspBufAction = "definition";
      options.desc = "go to definition";
    }
    {
      key = "gi";
      lspBufAction = "implementation";
      options.desc = "go to implementation";
    }
    {
      key = "gr";
      lspBufAction = "references";
      options.desc = "show references";
    }
    {
      key = "<leader>sh";
      lspBufAction = "signature_help";
      options.desc = "show signature help";
    }
    {
      key = "<leader>D";
      lspBufAction = "type_definition";
      options.desc = "got to type definition";
    }
    {
      key = "<leader>ca";
      lspBufAction = "code_action";
      options.desc = "code action";
    }
    {
      key = "<leader>r";
      lspBufAction = "rename";
      options.desc = "rename element";
    }
    # Search
    {
      key = "<leader>ss";
      action = lib.nixvim.mkRaw "function() Snacks.picker.lsp_symbols() end";
      mode = "n";
      options.desc = "LSP symbols";
    }
    {
      key = "<leader>sd";
      action = lib.nixvim.mkRaw "function() Snacks.picker.diagnostics() end";
      mode = "n";
      options.desc = "Diagnostics";
    }
  ];
}
