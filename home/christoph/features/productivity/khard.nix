{pkgs, ...}: {
  home.packages = with pkgs; [khard];

  # Need to manually configure khard because home manager does not support
  # specifying a subcollection for khard
  xdg.configFile."khard/khard.conf".text =
    /*
    toml
    */
    ''
      [addressbooks]
      [[contacts]]
      path = ~/Contacts/nextcloud/contacts

      [general]
      default_action=list
    '';
}
