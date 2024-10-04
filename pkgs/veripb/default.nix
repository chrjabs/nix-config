{
  lib,
  python3,
  fetchFromGitLab,
  gmp,
  zlib,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "veripb";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "MIAOresearch";
    repo = "VeriPB";
    rev = version;
    hash = "sha256-ESEdSIIvhXvrMWGzwjh1PJsynyUmWqu0hfs8hxzgfdM=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cython
    pybind11
    setuptools-git-versioning
  ];

  buildInputs = [
    gmp
    zlib
  ];

  pythonImportsCheck = [
    "veripb"
  ];

  meta = {
    description = "Proof checker for proof logging method using pseudo-Boolean reasoning for various combinatorial solving and optimization algorithms";
    homepage = "https://gitlab.com/MIAOresearch/VeriPB";
    changelog = "https://gitlab.com/MIAOresearch/VeriPB/-/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "veripb";
  };
}
