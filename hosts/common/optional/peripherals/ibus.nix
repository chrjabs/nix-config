{pkgs, ...}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };
  environment.variables = {
    GLFW_IM_MODULE = "ibus";
  };
}
