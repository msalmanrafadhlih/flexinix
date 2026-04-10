{ stdenv, fetchFromGitHub }:
let
  # selectedTheme = "MathTheme";
in
stdenv.mkDerivation {
  pname = "my-custom-grub-theme";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "MyGrubThemes";
    rev = "main";
    sha256 = "sha256-Ad4DYmCGoQxXCEDpg/u86TucKGVoTaRjqmsubXv3+T8=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';
}
