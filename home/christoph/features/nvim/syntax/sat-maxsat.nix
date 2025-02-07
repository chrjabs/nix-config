let
  preamble = pre: ''
    " Language: DIMACS ${pre}

    if exists("b:current_syntax")
      finish
    endif
    let b:current_syntax = "${pre}"
  '';
  literal = "-\\?[1-9]\\d*";
  comment = "^c.*$";
  delimiter = " 0$";
  hard = "^h";
  assignHi = pre: ''
    hi def link ${pre}Comment   Comment
    hi def link ${pre}Literal   Identifier
    hi def link ${pre}Delimiter Delimiter
  '';
in {
  programs.nixvim.filetype.extension = {
    "cnf" = "cnf";
    "wcnf" = "wcnf";
    "mcnf" = "mcnf";
  };

  xdg.configFile."nvim/syntax/cnf.vim".text = let
    pre = "cnf";
  in
    /*
    vim
    */
    ''
      ${preamble pre}

      syn match ${pre}Header "^p cnf \d* \d*$"
      syn match ${pre}Literal "${literal}"
      syn match ${pre}Comment "${comment}"
      syn match ${pre}Delimiter "${delimiter}"

      ${assignHi pre}
      hi def link ${pre}Header    Special
    '';

  xdg.configFile."nvim/syntax/wcnf.vim".text = let
    pre = "wcnf";
  in
    /*
    vim
    */
    ''
      ${preamble pre}

      syn match ${pre}Literal "${literal}" contained nextgroup=wcnfLiteral,wcnfDelimiter skipwhite
      syn match ${pre}Delimiter "${delimiter}"
      syn match ${pre}Soft "^\d*" nextgroup=wcnfLiteral skipwhite
      syn match ${pre}Hard "${hard}" nextgroup=wcnfLiteral skipwhite
      syn match ${pre}Comment "${comment}"

      ${assignHi pre}
      hi def link ${pre}Hard      Keyword
      hi def link ${pre}Soft      Number
    '';

  xdg.configFile."nvim/syntax/mcnf.vim".text = let
    pre = "mcnf";
  in
    /*
    vim
    */
    ''
      ${preamble pre}

      syn match ${pre}Delimiter "${delimiter}"
      syn match ${pre}Literal "${literal}" contained nextgroup=mcnfLiteral,mcnfDelimiter skipwhite
      syn match ${pre}Weight "\d*" contained nextgroup=mcnfLiteral skipwhite
      syn match ${pre}Hard "${hard}" nextgroup=mcnfLiteral skipwhite
      syn match ${pre}Soft "^o" nextgroup=mcnfWeight
      syn match ${pre}Comment "${comment}"

      ${assignHi pre}
      hi def link preHard      Keyword
      hi def link preSoft      Keyword
      hi def link preWeight    Number
    '';
}
