let
  preamble = pre: ''
    " Language: ${pre}

    if exists("b:current_syntax")
      finish
    endif
    let b:current_syntax = "${pre}"
  '';
in
{
  programs.nixvim.filetype.extension = {
    "opb" = "opb";
    "mopb" = "opb";
    "pbmo" = "opb";
    "pbp" = "veripb";
  };

  xdg.configFile."nvim/syntax/opb.vim".text =
    let
      pre = "opb";
    in
    # vim
    ''
      ${preamble pre}
      syn match ${pre}Obj "min:"
      syn match ${pre}Eq "="
      syn match ${pre}Gte ">="
      syn match ${pre}Delimiter ";"
      syn match ${pre}Var "x\d*"
      syn match ${pre}Comment "\*.*$"

      hi def link ${pre}Comment   Comment
      hi def link ${pre}Gte       Operator
      hi def link ${pre}Eq        Operator
      hi def link ${pre}Var       Identifier
      hi def link ${pre}Delimiter Delimiter
    '';

  xdg.configFile."nvim/syntax/veripb.vim".text =
    let
      pre = "veripb";
    in
    # vim
    ''
      ${preamble pre}

      syn match ${pre}Begin "pseudo-Boolean proof"
      syn match ${pre}End "end pseudo-Boolean proof"
      syn keyword ${pre}Rules f e rup pol red dom def_order load_order del core sol solx solu
      syn match ${pre}Gte ">="
      syn match ${pre}Maps "->"
      syn match ${pre}Delimiter ";"
      syn match ${pre}Comment "^\*.*$"

      hi def link ${pre}Comment   Comment
      hi def link ${pre}Rules     Keyword
      hi def link ${pre}Begin     Statement
      hi def link ${pre}End       Statement
      hi def link ${pre}Gte       Operator
      hi def link ${pre}Maps      Operator
      hi def link ${pre}Delimiter Delimiter
    '';
}
