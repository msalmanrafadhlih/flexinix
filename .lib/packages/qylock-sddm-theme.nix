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
    mkdir -p $out/share/sddm/themes

    link_theme() {
      local dir="$1"

      if [ -f "$dir/metadata.desktop" ] \
        && [ -f "$dir/theme.conf" ]; then

        local name
        name="$(basename "$dir")"

        echo "Linking SDDM theme: $name"

        ln -s "$PWD/$dir" \
          "$out/share/sddm/themes/$name"
      fi
    }

    # cek jika themeSubPath sendiri adalah theme
    link_theme "${themeSubPath}"

    # cek subfolder
    for dir in ${themeSubPath}/*; do
      [ -d "$dir" ] || continue
      link_theme "$dir"
    done

    runHook postInstall
  '';
}

