{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  libarchive,
  cadical,
}:
buildPythonPackage rec {
  pname = "gbdc";
  version = "0.2.46";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrjabs";
    repo = "gbdc";
    rev = "50a86a4a569b65da3934dc95462c1130e9568fec";
    hash = "sha256-p5k3fR7z0bn21K7bpcvPi/X1lpOngCOqMHHLUL/K6gg=";
  };

  build-system = [
    setuptools
    wheel
  ];

  buildInputs = [
    libarchive
    cadical
  ];

  pythonImportsCheck = [
    "gbdc"
  ];

  meta = {
    description = "Instance Identification, Feature Extraction, and Problem Transformation";
    homepage = "https://github.com/Udopia/gbdc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
