{
  programs.nixvim = {
    plugins = {
      dap.enable = true;
      dap-ui.enable = true;
      # Enable stylix styling of DapUI plugin
      mini.modules.base16.plugins.default = true;
    };

    keymaps = [
      {
        key = "<leader>db";
        action.__raw = "function() require(\"dap\").toggle_breakpoint() end";
        mode = "n";
        options.desc = "Toggle breakpoint at line";
      }
      {
        key = "<leader>dc";
        action.__raw = "function() require(\"dap\").continue() end";
        mode = "n";
        options.desc = "Start or continue the debugger";
      }
      {
        key = "<leader>ds";
        action.__raw = "function() require(\"dap\").step_over() end";
        mode = "n";
        options.desc = "Debugger step over";
      }
      {
        key = "<leader>di";
        action.__raw = "function() require(\"dap\").step_into() end";
        mode = "n";
        options.desc = "Debugger step into";
      }
      {
        key = "<leader>do";
        action.__raw = "function() require(\"dap\").step_out() end";
        mode = "n";
        options.desc = "Debugger step out";
      }
      {
        key = "<leader>dp";
        action.__raw = "function() require(\"dap\").pause() end";
        mode = "n";
        options.desc = "Debugger pause";
      }
      {
        key = "<leader>dt";
        action.__raw = "function() require(\"dap\").terminate() end";
        mode = "n";
        options.desc = "Debugger terminate";
      }
      {
        key = "<leader>dui";
        action.__raw = "function() require(\"dapui\").toggle() end";
        mode = "n";
        options.desc = "Toggle debugger UI";
      }
    ];
  };
}
