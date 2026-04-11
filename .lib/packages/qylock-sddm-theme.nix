{ stdenv, fetchFromGitHub }:

let
  selectedTheme = "R1999_2";
  themeSubPath = "themes/${selectedTheme}";
in
stdenv.mkDerivation {
  pname = "qylock-sddm-theme-${selectedTheme}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "qylock";
    rev = "b8260cb043df9a2a0175a0a04027d42cf7283239";
    sparseCheckout = [ themeSubPath ];
    sha256 = "sha256-qYhW5tgGGnhRsrRQAt/nsfG5ezNIaN2Dge1sLFEmw/g=";
  };

  # SDDM theme biasanya butuh struktur folder yang spesifik
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sddm/themes/${selectedTheme}
    cp -r ${themeSubPath}/* $out/share/sddm/themes/${selectedTheme}/

    runHook postInstall
  '';
}
