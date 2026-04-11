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
    rev = "ab2bbd9f784c5db6875474b90aadf723b3b5048f";

    # WAJIB: Tambahkan ini agar Nix hanya mengambil folder tema tersebut
    sparseCheckout = [ selectedTheme ];

    sha256 = "sha256-sDH/HYUpNbz4J+0/vPCssAnRKVtD5jAmjmKN2VtC0+U=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ${selectedTheme}/* $out/
  '';
}
