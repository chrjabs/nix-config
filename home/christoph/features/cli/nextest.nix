{
  xdg.configFile."nextest/config.toml".text =
    # toml
    ''
      [experimental]
      record = true

      [record]
      enabled = true
    '';
}
