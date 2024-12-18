{ pkgs
, lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

let
  cobble = pkgs.python3Packages.callPackage ./cobble.nix {};
in
buildPythonPackage rec {
  pname = "mammoth";
  version = "1.8.0";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-foqn21P0qn6WILIr+LcW8aFshOlp3hoLH5IMdWGE49g=";
  };
  pyproject = true;

  build-system = [
    setuptools
  ];

  dependencies = [
    cobble
  ];

  meta = {
    license = lib.licenses.bsd2;
    description = "Convert Word documents (.docx files) to HTML";
    homepage = "https://github.com/mwilliamson/python-mammoth";
  };
}
