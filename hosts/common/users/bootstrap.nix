{
  users.users.bootstrap = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    initialPassword = "bootstrapPwd";
  };
}
