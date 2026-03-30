{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        latex =
          (pkgs.texliveSmall.withPackages (
            ps: with ps; [
              # keep-sorted start
              algorithm2e
              algorithmicx
              algorithms
              algpseudocodex
              biblatex
              catchfile
              courier
              csquotes
              esvect
              hypdoc
              ifoddpage
              latexmk
              multirow
              pgf
              pgfopts
              pgfplots
              relsize
              soul
              svg
              tikzfill
              tools
              trimspaces
              # keep-sorted end
            ]
          )).overrideAttrs
            { pname = "latex-default"; };

        latex-lipics =
          (pkgs.texliveSmall.withPackages (
            ps: with ps; [
              # keep-sorted start
              algorithm2e
              algorithms
              catchfile
              changepage
              cleveref
              comment
              fontawesome5
              greek-fontenc
              ifoddpage
              latexmk
              luatex85
              multirow
              mwe
              pdfx
              pgf
              pgfopts
              pgfplots
              relsize
              soul
              standalone
              svg
              svn-prov
              thmtools
              threeparttable
              tikzfill
              tools
              totpages
              transparent
              trimspaces
              type1cm
              urlbst
              xmpincl
              xstring
              # keep-sorted end
            ]
          )).overrideAttrs
            { pname = "latex-lipics"; };
      };
    };
}
