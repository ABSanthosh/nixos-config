{
  pkgs ? import <nixpkgs> { },
}:

pkgs.python3Packages.buildPythonApplication {
  pname = "ingest";
  version = "1.0.0";

  src = ./.;

  # Entry point
  # This will copy and install main.py as an executable named "ingest"
  # into your environment
  # (alternatively, use `installPhase` manually if you want more control)
  doCheck = false;

  format = "other"; # Not using setup.py or pyproject.toml

  propagatedBuildInputs = with pkgs.python3Packages; [
    tiktoken
    tqdm
    argcomplete
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${./main.py} $out/bin/ingest
    chmod +x $out/bin/ingest
  '';
}
