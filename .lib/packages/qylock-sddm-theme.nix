{ stdenv, fetchFromGitHub }:

let
  selectedTheme = "clockwork";
  themeSubPath = "themes/${selectedTheme}";
in
stdenv.mkDerivation {
  pname = "qylock-sddm-theme-${selectedTheme}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "qylock";
    rev = "ca5bd56cbe587f4f115be439d4a120f2721224a6";
    sparseCheckout = [ themeSubPath ];
    sha256 = "sha256-bX1jo+4xgh5Jgtjqk82G2b3jMkeMvIiAIk4ICWOtLq0=";
  };

  # SDDM theme biasanya butuh struktur folder yang spesifik
  installPhase = ''
    runHook preInstall

    # mkdir -p $out/share/sddm/themes/${selectedTheme}
    # cp -r ${themeSubPath}/* $out/share/sddm/themes/${selectedTheme}/

    mkdir -p $out/share/sddm/themes/orbital
    mkdir -p $out/share/sddm/themes/clockwork
    cp -r ${themeSubPath}/orbital/* $out/share/sddm/themes/orbital/
    cp -r ${themeSubPath}/tape/* $out/share/sddm/themes/tape/

    runHook postInstall
  '';
}
