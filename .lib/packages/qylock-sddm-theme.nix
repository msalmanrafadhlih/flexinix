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
    rev = "main";
    sparseCheckout = [ themeSubPath ];
    sha256 = "sha256-0000000000000000000000000000000000000000000=";
  };

  # SDDM theme biasanya butuh struktur folder yang spesifik
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sddm/themes/${selectedTheme}
    cp -r ${themeSubPath}/* $out/share/sddm/themes/${selectedTheme}/

    runHook postInstall
  '';
}
