{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
  };
  environment.variables = {
    GLFW_IM_MODULE = "ibus";
  };
}
