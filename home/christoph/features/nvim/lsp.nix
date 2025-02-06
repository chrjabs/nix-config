{
  programs.nixvim.plugins.lsp = {
    enable = true;
    inlayHints = true;
    keymaps.lspBuf = {
      gD = {
        action = "declaration";
        desc = "go to declaration";
      };
      gd = {
        action = "definition";
        desc = "go to definition";
      };
      gi = {
        action = "implementation";
        desc = "go to implementation";
      };
      gr = {
        action = "references";
        desc = "show references";
      };
      "<leader>sh" = {
        action = "signature_help";
        desc = "show signature help";
      };
      "<leader>D" = {
        action = "type_definition";
        desc = "got to type definition";
      };
      "<leader>ca" = {
        action = "code_action";
        desc = "code action";
      };
      "<leader>r" = {
        action = "rename";
        desc = "rename element";
      };
    };
  };
}
