{inputs, ...}: {
  imports = [
    inputs.xremap.nixosModules.default
  ];

  services.xremap = {
    enable = true;
    withWlroots = true;
    config.modmap = [
      {
        name = "Global";
        remap = {CapsLock = "Esc";};
      }
    ];
  };
}
