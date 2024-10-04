{
  lib,
  python3,
  fetchFromGitHub,
  setuptools,
  wheel,
  python-gbdc,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "gbd";
  version = "4.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Udopia";
    repo = "gbd";
    rev = "gbd-tools-${version}";
    hash = "sha256-8mmCj6syVtch00r/mVwO0IS9AvRf4hQLiWgibSNQ4ns=";
  };

  build-system = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    flask
    tatsu
    pandas
    waitress
    pebble
    python-gbdc
  ];

  pythonImportsCheck = [
    "gbd_main"
    "gbd_core"
    "gbd_init"
    "gbd_server"
  ];

  # Copy gbd.py to its own module to not conflict with the script
  preBuild =
    # bash
    ''
      mkdir gbd_main
      echo "from .gbd import main" > gbd_main/__init__.py
      echo "__all__ = [main]" >> gbd_main/__init__.py
      cp gbd.py gbd_main/
    '';

  patches = [
    ./modify-entry-point.patch
  ];

  meta = {
    description = "Management of Benchmark Instances and Instance Attributes";
    homepage = "https://github.com/udopia/gbd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
  };
}
