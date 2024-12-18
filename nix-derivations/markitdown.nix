{ pkgs
, lib
, buildPythonPackage
, fetchPypi
, hatchling
, beautifulsoup4
, requests
, markdownify
, numpy
, python-pptx
, pandas
, openpyxl
, pdfminer-six
, puremagic
, pydub
, youtube-transcript-api
, speechrecognition
, pathvalidate
, charset-normalizer
, openai
}:

let
  mammoth = pkgs.python3Packages.callPackage ./mammoth.nix {};
in
buildPythonPackage rec {
  pname = "markitdown";
  version = "0.0.1a3";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9sj19/VUHpHGxTUhgxiWj+/XHipvqg63grNJLgTNAj0=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    beautifulsoup4
    requests
    mammoth
    markdownify
    numpy
    python-pptx
    pandas
    openpyxl
    pdfminer-six
    puremagic
    pydub
    youtube-transcript-api
    speechrecognition
    pathvalidate
    charset-normalizer
    openai
  ];

  meta = {
    changelog = "https://github.com/microsoft/markitdown/releases/tag/v${version}";
    description = "Python tool for converting files and office documents to Markdown";
    homepage = "https://github.com/microsoft/markitdown";
    license = lib.licenses.mit;
  };
}
