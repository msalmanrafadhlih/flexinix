{ stdenv, fetchFromGitHub }:

let
  selectedTheme = "R1999_2";
in
stdenv.mkDerivation {
  pname = "qylock-sddm-theme-${selectedTheme}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "qylock";
    rev = "main";
    sha256 = "sha256-7BRVt43Dx5zTC7nbOwZXMK2yfwyhtwlNoyEP+F4ha/8="; 
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/${selectedTheme}
    cp -r themes/${selectedTheme}/* $out/share/sddm/themes/${selectedTheme}/
  '';
}
