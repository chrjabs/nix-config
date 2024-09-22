{
  lib,
  config,
  ...
}: {
  programs.nixvim.plugins = {
    # Vimtex
    vimtex = lib.mkIf config.programs.texlive.enable {
      enable = true;
      texlivePackage = null;
      settings.view_method = "zathura";
    };
    # Language server / spell checking
    lsp.servers = {
      ltex = lib.mkIf config.programs.texlive.enable {
        enable = true;
        settings = {
          language = "en";
          additionalrules = {
            motherTongue = "de-DE";
            enablePickyRules = true;
          };
          diagnosticSeverity = {
            PASSIVE_VOICE = "hint";
            TOO_LONG_SENTENCE = "hint";
            TOO_LONG_PARAGRAPH = "hint";
            default = "information";
          };
          dictionary = {
            "en" = ["Jeremias" "Niskanen" "Matti" "Järvisalo" "MaxSAT"];
          };
          disabledRules = {
            "en" = ["EN_FOR_DE_SPEAKERS_FALSE_FRIENDS_FORMULA_FORM" "OXFORD_SPELLING_Z_NOT_S"];
          };
          latex = {
            environments = {
              CCSXML = "ignore";
              algorithmic = "ignore";
            };
            commands = {
              "\\bioptsat{}" = "dummy";
              "\\unsat{}" = "dummy";
              "\\sat{}" = "dummy";
              "\\satunsat{}" = "dummy";
              "\\unsatsat{}" = "dummy";
              "\\msu{}" = "dummy";
              "\\oll{}" = "dummy";
              "\\msh{}" = "dummy";
              "\\osh{}" = "dummy";
              "\\Simpr{}" = "dummy";
              "\\Min{}" = "dummy";
            };
          };
        };
        filetypes = ["bibtex" "gitcommit" "markdown" "org" "tex" "restructuredtext" "rsweave" "latex" "quarto" "rmd" "context"];
      };
    };
  };
}
