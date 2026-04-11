{ stdenv, fetchFromGitHub }:
let
  selectedTheme = "Math-theme";
in
stdenv.mkDerivation {
  pname = "my-custom-grub-theme";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "MyGrubThemes";
    rev = "0804a912251abc17fc0978408841f1cb204b277f";

    # WAJIB: Tambahkan ini agar Nix hanya mengambil folder tema tersebut
    sparseCheckout = [ selectedTheme ];

    sha256 = "sha256-DxyBkgZmTUsGN3X8h0OCiz0AYZcOXcgT/ec1M4h1J54=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ${selectedTheme}/* $out/
  '';
}
