{ stdenv, fetchFromGitHub }: let
  # selectedTheme = "MathTheme";
in
stdenv.mkDerivation {
  pname = "my-custom-grub-theme";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "MyGrubThemes";
    rev = "main";
    sha256 = ""; 
  };

  installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
  '';
}
