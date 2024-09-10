{config, ...}: {
  programs.zoxide = {
    enable = true;
    options = ["--cmd cd"];
  };

  home.persistence."/persist/${config.home.homeDirectory}".files = [".local/share/zoxide/db.zo"];
}
