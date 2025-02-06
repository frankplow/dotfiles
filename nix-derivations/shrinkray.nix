{ stdenv
, lib
, fetchFromGitHub
, python
}:
let
  defaultOverrides = 
    self: super: {
      trio = super.trio.overridePythonAttrs (oldAttrs: rec {
        version = "0.28.0";
        src = fetchFromGitHub {
          owner = "python-trio";
          repo = "trio";
          tag = "v${version}";
          hash = "sha256-ru5Q7YHpnA/hLwh2Og5Hp3z6XJCv/BHHW0S26N1oTJ0=";
        };
      });
    };
  python' = python.override {
    self = python';
    packageOverrides = defaultOverrides;
  };
in
  python'.pkgs.buildPythonPackage rec {
    pname = "shrinkray";
    version = "0.0.0";
    pyproject = true;
    src = fetchFromGitHub {
      owner = "DRMacIver";
      repo = pname;
      rev = "185b0f627435f39c048c1a891911429f6d7176af";
      hash = "sha256-EjC8Xm91N08Cg9Gvue/AfYggamHE2lKT/cDHKMnELMY=";
    };
    build-system = with python'.pkgs; [ poetry-core ];
    dependencies = with python'.pkgs; [
      click
      chardet
      trio
      urwid
      humanize
      libcst
      exceptiongroup
      binaryornot
    ];
    nativeCheckInputs = with python'.pkgs; [
      # hypothesis
      # hypothesmith
    ];
    meta = with lib; {
      description = "Shrinkray is a modern multi-format test-case reducer ";
      homepage = "https://github.com/DRMacIver/shrinkray";
      license = licenses.mit;
      platforms = [ "aarch64-darwin" "x86_64-darwin" ];
      mainProgram = "shrinkray";
    };
  }
