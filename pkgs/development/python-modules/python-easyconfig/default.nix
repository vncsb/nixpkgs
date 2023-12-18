{ lib
, python3
, buildPythonPackage
, fetchPypi
}:
buildPythonPackage rec {
  pname = "Python-EasyConfig";
  version = "0.1.7";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tUjxmrhQtVFU9hFi8xTj27J24R47JpUbio+gaDwGuyk=";
  };
  propagatedBuildInputs = with python3.pkgs; [
    six
    pyyaml
  ];
}

