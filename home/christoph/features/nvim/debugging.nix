{
  programs.nixvim = {
    plugins.dap = {
      enable = true;
      extensions.dap-ui.enable = true;
    };

    keymaps = [
      {
        key = "<leader>db";
        action = "function() require(\"dap\").toggle_breakpoint() end";
        mode = "n";
        options.desc = "Toggle breakpoint at line";
      }
      {
        key = "<leader>dc";
        action = "function() require(\"dap\").continue() end";
        mode = "n";
        options.desc = "Start or continue the debugger";
      }
      {
        key = "<leader>ds";
        action = "function() require(\"dap\").step_over() end";
        mode = "n";
        options.desc = "Debugger step over";
      }
      {
        key = "<leader>di";
        action = "function() require(\"dap\").step_into() end";
        mode = "n";
        options.desc = "Debugger step into";
      }
      {
        key = "<leader>do";
        action = "function() require(\"dap\").step_out() end";
        mode = "n";
        options.desc = "Debugger step out";
      }
      {
        key = "<leader>dp";
        action = "function() require(\"dap\").pause() end";
        mode = "n";
        options.desc = "Debugger pause";
      }
      {
        key = "<leader>dt";
        action = "function() require(\"dap\").terminate() end";
        mode = "n";
        options.desc = "Debugger terminate";
      }
      {
        key = "<leader>dui";
        action = "function() require(\"dapui\").toggle() end";
        mode = "n";
        options.desc = "Toggle debugger UI";
      }
    ];
  };
}
