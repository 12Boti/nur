{ lib, stdenv, fetchFromGitHub, getopt, cmark, wkhtmltopdf, gnused, makeWrapper }:
let
  deps = [
    getopt
    cmark
    wkhtmltopdf
    gnused
  ];
in
stdenv.mkDerivation {
  name = "examdown";
  src = fetchFromGitHub {
    owner = "pldiiw";
    repo = "examdown";
    rev = "574ae6e3f4033080c6d19909829fc7e4c82a3b65";
    sha256 = "sha256-Lbz9Xk5bNdcsgc0y/oBBnJOtDE1EtHOUcB3M3axabnI=";
    fetchSubmodules = true;
  };
  buildPhase = ''
    patchShebangs .
    make -s checkdeps
    make -s build
  '';
  installPhase = ''
    mkdir $out
    make -s install PREFIX=$out
    wrapProgram $out/bin/examdown --prefix PATH : ${lib.makeBinPath deps}
  '';
  buildInputs = deps;
  nativeBuildInputs = [
    makeWrapper
  ];
}
