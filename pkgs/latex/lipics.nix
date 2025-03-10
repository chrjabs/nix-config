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
    catchfile
    changepage
    cleveref
    comment
    fontawesome5
    multirow
    mwe
    pgf
    pgfopts
    pgfplots
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
