{ lib
, python3
, buildPythonPackage
, fetchPypi
}:
buildPythonPackage rec {
  pname = "JsonSir";
  version = "0.0.2";
  doCheck = false;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QBRHxekx94h4Uc6b8kB/401aqwsUZ7sku787dg5b0/s=";
  };
}
