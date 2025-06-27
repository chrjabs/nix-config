{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  python-cffi-1-15,
}:
buildPythonPackage rec {
  pname = "mip";
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f28Dgc/ixSwbhkAgPaLLVpdLJuI5UN37GnazfZFvGX4=";
  };

  propagatedBuildInputs = [
    setuptools
    setuptools-scm
    python-cffi-1-15
  ];

  pythonImportsCheck = [
    "mip"
  ];

  pyproject = true;
  build-system = [setuptools setuptools-scm wheel];
}
