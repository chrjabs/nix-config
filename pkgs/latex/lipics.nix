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
    greek-fontenc
    ifoddpage
    luatex85
    multirow
    mwe
    pdfx
    pgf
    pgfopts
    pgfplots
    relsize
    standalone
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
    xmpincl
    xstring
    ;
})
