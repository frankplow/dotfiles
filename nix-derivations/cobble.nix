{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "cobble";
  version = "0.1.4";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3ji+FTmZLIoG5WljBxfEhaX5G+IZLEYeorIgYH36eKo=";
  };
  pyproject = true;

  build-system = [
    setuptools
  ];

  meta = {
    license = lib.licenses.bsd2;
    description = "Create Python data objects";
    homepage = "https://github.com/mwilliamson/python-cobble";
  };
}
