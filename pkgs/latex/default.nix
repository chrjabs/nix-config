{ texlive, callPackage }:
(texlive.combine {
  inherit (texlive)
    scheme-small
    # Tools
    latexmk
    tools
    # Packages
    algorithm2e
    algorithms
    algorithmicx
    algpseudocodex
    biblatex
    catchfile
    courier
    csquotes
    esvect
    hypdoc
    ifoddpage
    multirow
    pgf
    pgfopts
    pgfplots
    relsize
    soul
    svg
    tikzfill
    trimspaces
    ;
}).overrideAttrs
  (oldAttrs: {
    pname = "latex-default";
    passthru = oldAttrs.passthru // {
      lipics = callPackage ./lipics.nix { };
    };
  })
