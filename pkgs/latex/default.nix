{pkgs}:
with pkgs; (texlive.combine {
  inherit
    (texlive)
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
    csquotes
    esvect
    hypdoc
    multirow
    pgf
    pgfopts
    pgfplots
    svg
    tikzfill
    trimspaces
    ;
})
