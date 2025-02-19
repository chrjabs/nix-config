{
  pkgs,
  lib,
  ...
}: {
  programs.bat = {
    enable = true;
    syntaxes = let
      dimacs_syntax_header = prefix:
      /*
      yaml
      */
      ''
        %YAML 1.2
        ---
        name: DIMACS ${lib.toUpper prefix}
        file_extensions:
          - ${prefix}
        scope: text.${prefix}
      '';
      dimacs_header_start = prefix:
      /*
      yaml
      */
      ''
        - match: ^p
              scope: keyword.other.${prefix}
              push: header
      '';
      dimacs_comment_start = prefix:
      /*
      yaml
      */
      ''
        - match: ^c
              scope: punctuation.definition.comment.${prefix}
              push: line_comment
      '';
      dimacs_comment_context = prefix:
      /*
      yaml
      */
      ''
        line_comment:
            - meta_scope: comment.line.${prefix}
              match: $
              pop: true
      '';
      dimacs_cnf_clause_start = prefix:
      /*
      yaml
      */
      ''
        - match: ^[^pc]
              push: hard_clause
      '';
      dimacs_clause_context = prefix:
      /*
      yaml
      */
      ''
        clause:
            - match: '[1-9]\d*'
              scope: variable.other.${prefix}
            - match: '-'
              scope: keyword.operator.logical.${prefix}
            - match: \w0
              scope: punctuation.terminator.${prefix}
            - match: $
              pop: true
      '';
    in {
      cnf.src = let
        prefix = "cnf";
      in
        pkgs.writeText "${prefix}.sublime-syntax"
        /*
        yaml
        */
        ''
          ${dimacs_syntax_header prefix}
          contexts:
            main:
              ${dimacs_header_start prefix}
              ${dimacs_comment_start prefix}
              - match: '^-'
                scope: keyword.operator.logical.${prefix}
                push: clause
              - match: '^[1-9]\d*'
                scope: variable.other.${prefix}
                push: clause
            header:
              - meta_scope: meta.type.${prefix}
              - match: '[1-9]\d*'
                scope: constant.numeric.integer.${prefix}
              - match: ${prefix}
                scope: keyword.other.${prefix}
              - match: $
                pop: true
            ${dimacs_comment_context prefix}
            ${dimacs_clause_context prefix}
        '';
      wcnf.src = let
        prefix = "wcnf";
      in
        pkgs.writeText "${prefix}.sublime-syntax"
        /*
        yaml
        */
        ''
          ${dimacs_syntax_header prefix}
          contexts:
            main:
              ${dimacs_header_start prefix}
              ${dimacs_comment_start prefix}
              - match: ^h
                scope: keyword.other.${prefix}
                push: clause
              - match: '^[1-9]\d*'
                scope: constant.numeric.integer.${prefix}
                push: clause
            header:
              - meta_scope: meta.type.${prefix}
              - match: '[1-9]\d*'
                scope: constant.numeric.integer.${prefix}
              - match: ${prefix}
                scope: keyword.other.${prefix}
              - match: $
                pop: true
            ${dimacs_comment_context prefix}
            ${dimacs_clause_context prefix}
        '';
      mcnf.src = let
        prefix = "mcnf";
      in
        pkgs.writeText "${prefix}.sublime-syntax"
        /*
        yaml
        */
        ''
          ${dimacs_syntax_header prefix}
          contexts:
            main:
              ${dimacs_comment_start prefix}
              - match: ^h
                scope: keyword.other.${prefix}
                push: clause
              - match: '^(o)([1-9]\d*)\s+([1-9]\d*)'
                captures:
                  1: keyword.other.${prefix}
                  2: constant.numeric.integer.${prefix}
                  3: constant.numeric.integer.${prefix}
                push: clause
            ${dimacs_comment_context prefix}
            ${dimacs_clause_context prefix}
        '';
    };
  };
}
