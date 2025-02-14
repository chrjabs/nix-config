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
  version = "4.9.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrjabs";
    repo = "gbd";
    rev = "0509d0a9a993f94d05bbc15049dcacd430f45c40";
    hash = "sha256-DH5/I1GAjrlYIsLGDriifOCYmBIBxEh5JaxW526uql4=";
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
    ipython
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
    mainProgram = "gbd";
  };
}
