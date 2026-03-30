{ inputs, ... }:
{
  flake.nixosModules.ibus = {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
    };
    environment.variables = {
      GLFW_IM_MODULE = "ibus";
    };
  };

  flake.nixosModules.remapCaps = {
    imports = [
      inputs.xremap.nixosModules.default
    ];

    services.xremap = {
      enable = true;
      withWlroots = true;
      config.modmap = [
        {
          name = "Global";
          remap = {
            CapsLock = "Esc";
          };
        }
      ];
    };
  };
}
