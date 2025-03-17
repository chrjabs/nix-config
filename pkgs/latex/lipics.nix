{pkgs}:
with pkgs; (texlive.combine {
  inherit
    (texlive)
    scheme-small
    # Tools
    
    latexmk
    tools
    # Packages
    
    algorithms
    algorithm2e
    catchfile
    changepage
    cleveref
    comment
    fontawesome5
    ifoddpage
    multirow
    mwe
    pgf
    pgfopts
    pgfplots
    relsize
    soul
    svg
    thmtools
    threeparttable
    tikzfill
    transparent
    trimspaces
    totpages
    type1cm
    urlbst
    xstring
    ;
})
