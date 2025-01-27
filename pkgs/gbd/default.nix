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
    rev = "bac1eda7186b79ed183347df51d8aaa01a7d2d48";
    hash = "sha256-HM200KqJTS3oo1THl8KDpkgDraRqRTPpdq089UwwLwo=";
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
  };
}
