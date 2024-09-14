{config, ...}: {
  programs.zoxide = {
    enable = true;
    options = ["--cmd cd"];
  };

  home.persistence."/persist/${config.home.homeDirectory}".directories = [".local/share/zoxide"];
}
