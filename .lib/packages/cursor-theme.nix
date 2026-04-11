{ stdenv, fetchFromGitHub }:
let
  selectedTheme = "Kafka";
in
stdenv.mkDerivation {
  pname = "cursor-memes";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "Cursors-memes";
    rev = "main";

    # WAJIB: Tambahkan ini agar Nix hanya mengambil folder tema tersebut
    sparseCheckout = [ selectedTheme ];

    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  installPhase = ''
    # Buat direktori tujuan standar kursor Linux
    mkdir -p $out/share/icons
    cp -r ${selectedTheme} $out/share/icons/

    # Opsional: Hapus folder 'default' jika tidak sengaja terikut 
    # agar tidak konflik dengan Stylix
    rm -rf $out/share/icons/default
  '';
}
