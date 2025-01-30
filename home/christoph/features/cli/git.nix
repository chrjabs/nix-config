{
  pkgs,
  config,
  lib,
  ...
}: let
  ssh = "${pkgs.openssh}/bin/ssh";
in {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    aliases = {
      fpush = "push --force-with-lease";
      p = "pull --ff-only";
      ff = "merge --ff-only";
      graph = "log --decorate --oneline --graph";
    };
    userName = "Christoph Jabs";
    userEmail = lib.mkDefault "contact@christophjabs.info";
    extraConfig = {
      init.defaultBranch = "main";
      user.signing.key = "217C6A439646D51E";
      commit.gpgSign = lib.mkDefault true;
      gpg.program = "${config.programs.gpg.package}/bin/gpg2";

      merge.conflictStyle = "zdiff3";
      commit.verbose = true;
      diff.algorithm = "histogram";
      log.date = "iso";
      column.ui = "auto";
      branch.sort = "committerdate";
      push.autoSetupRemote = true;
      rerere.enabled = true;
      "filter \"dumpsql\"" = let
        sqlite = lib.getExe pkgs.sqlite;
      in {
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

  home.packages = with pkgs; [
    git-crypt
  ];

  specialisation.work.configuration.programs.git.userEmail = "christoph.jabs@helsinki.fi";
}
