{ lib
, python3
, buildPythonPackage
, fetchPypi
}:
buildPythonPackage rec {
  pname = "JsonForm";
  version = "0.0.2";
  doCheck = false;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cfi3ohU44wyphLad3gTwKYDNbNwhg6GKp8oC2VCZiOY=";
  };
  propagatedBuildInputs = [
    python3.pkgs.jsonschema
  ];
}


