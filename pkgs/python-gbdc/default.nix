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
    rev = "a0517cefd4f8438f5a02251032c5f79fda35df56";
    hash = "sha256-aDWYhSP1XlCs+siMyDG4A75KGWCzwnboUc9ywMJjsh0=";
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
    maintainers = with lib.maintainers; [];
  };
}
