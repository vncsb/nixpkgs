{ lib
, fetchFromGitHub
, python3
, buildPythonPackage
, fetchPypi
}:
let
  python = python3.override {
    packageOverrides = self: super: {
      impacket = super.impacket.overridePythonAttrs {
        version = "0.12.0.dev1";
        src = fetchFromGitHub {
          owner = "Pennyw0rth";
          repo = "impacket";
          rev = "d370e6359a410063b2c9c68f6572c3b5fb178a38";
          hash = "sha256-Jozn4lKAnLQ2I53+bx0mFY++OH5P4KyqVmrS5XJUY3E=";
        };
      };
      bloodhound-py = super.bloodhound-py.overridePythonAttrs (old: {
        propagatedBuildInputs =
          lib.lists.remove super.impacket old.propagatedBuildInputs
          ++ [ self.impacket ];
      });
    };
  };

  dploot = buildPythonPackage rec {
    pname = "dploot";
    version = "2.2.4";
    pyproject = true;
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-40/5KOlEFvPL9ohCfR3kqoikpKFfJO22MToq3GhamKM=";
    };
    nativeBuildInputs = with python.pkgs; [
      poetry-core
    ];
    propagatedBuildInputs = with python.pkgs; [
      impacket
      cryptography
      pyasn1
      lxml
    ];
  };

  resource = buildPythonPackage rec {
    pname = "Resource";
    version = "0.2.1";
    doCheck = false;
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-mDVKvY7+c9WhDyEJnYC774Xs7ffKIqQW/yAlClGs2RY=";
    };
    propagatedBuildInputs = with python.pkgs; [
      python-easyconfig
      jsonform
      jsonsir
    ];
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "NetExec";
  version = "1.1.0";
  pyproject = true;
  doCheck = true;
  pythonRelaxDeps = true;

  src = fetchFromGitHub {
    owner = "Pennyw0rth";
    repo = "NetExec";
    rev = "refs/tags/v${version}";
    hash = "sha256-cNkZoIdfrKs5ZvHGKGBybCWGwA6C4rqjCOEM+pX70S8=";
  };

  nativeBuildInputs = with python.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python.pkgs; [
    requests
    beautifulsoup4
    lsassy
    termcolor
    msgpack
    neo4j
    pylnk3
    pypsrp
    paramiko
    impacket
    dsinternals
    xmltodict
    terminaltables
    aioconsole
    pywerview
    minikerberos
    pypykatz
    aardwolf
    dploot
    bloodhound-py
    asyauth
    masky
    sqlalchemy
    aiosqlite
    pyasn1-modules
    rich
    python-libnmap
    resource
    oscrypto
  ];

  nativeCheckInputs = with python.pkgs; [
    pytest
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '{ git = "https://github.com/Pennyw0rth/impacket.git", branch = "gkdi" }' '"*"'

    substituteInPlace pyproject.toml \
      --replace '{ git = "https://github.com/Pennyw0rth/oscrypto" }' '"*"'
  '';

  meta = with lib; {
    description = "Network service exploitation tool (Maintaned fork of CrackMapExec)";
    homepage = "https://github.com/Pennyw0rth/NetExec";
    changelog = "https://github.com/Pennyw0rth/NetExec/releases/tag/v${version}";
    license = with licenses; [ bsd2 ];
    mainProgram = "nxc";
  };
}
