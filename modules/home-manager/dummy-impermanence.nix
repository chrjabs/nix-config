{ lib, ... }:
{
  options = {
    home.persistence = lib.mkOption {
      type = lib.types.attributes;
      default = { };
      description = "dummy option for when impermanence isn't imported";
    };
  };
}
