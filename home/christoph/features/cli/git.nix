{
  pkgs,
  config,
  lib,
  workMode,
  ...
}:
{
  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
      settings =
        let
          pass = lib.getExe config.programs.password-store.package;
          passCredentialHelper = path: ''!f() { test "$1" = get && echo "password=$(${pass} ${path})"; }; f'';
        in
        {
          aliases = {
            fpush = "push --force-with-lease";
            p = "pull --ff-only";
            ff = "merge --ff-only";
            graph = "log --decorate --oneline --graph";
          };
          user = {
            name = "Christoph Jabs";
            email = if workMode then "christoph.jabs@helsinki.fi" else "contact@christophjabs.info";
          };
          init.defaultBranch = "main";
          user.signing.key = "217C6A439646D51E";
          commit.gpgSign = lib.mkDefault true;
          gpg.program = "${config.programs.gpg.package}/bin/gpg2";
          "credential \"https://git.overleaf.com\"" =
            let
            in
            {
              username = "git";
              helper = passCredentialHelper "git.overleaf.com/chrjabs";
            };

          merge.conflictStyle = "zdiff3";
          commit.verbose = true;
          diff.algorithm = "histogram";
          log.date = "iso";
          column.ui = "auto";
          branch.sort = "committerdate";
          push.autoSetupRemote = true;
          rerere.enabled = true;
          "filter \"dumpsql\"" =
            let
              sqlite = lib.getExe pkgs.sqlite;
            in
            {
              clean = "tmp=$(mktemp); cat > $tmp; ${sqlite} $tmp .dump; rm $tmp";
              smudge = "tmp=$(mktemp); ${sqlite} $tmp; cat $tmp; rm $tmp";
            };
        };
      lfs.enable = true;
      ignores = [
        "**/.ropeproject/"
        "**/.venv/"
        ".direnv"
      ];
    };
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        syntax-theme = lib.mkIf (config.stylix.enable && config.stylix.targets.bat.enable) "base16-stylix";
      };
    };
  };

  home.packages = with pkgs; [
    git-crypt
  ];
}
