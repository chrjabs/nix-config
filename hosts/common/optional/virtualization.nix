{
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;
  users.users.christoph.extraGroups = [ "libvirtd" ];
}
