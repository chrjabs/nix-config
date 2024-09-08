{inputs, ...}: {
  imports = [inputs.stylix.nixosModules.stylix];

  stylix = {
    enable = true;
  };
}
