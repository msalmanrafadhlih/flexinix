{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "cursor-memes";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "Cursors-memes";
    rev = "dacec46c777667c54aa1e427d8d442ddef8cdb09";

    # WAJIB: Tambahkan ini agar Nix hanya mengambil folder tema tersebut
    sparseCheckout = [
      "Kafka"                           # red
      "Crelly-Cursor-Pack"              # green
      "Ju-Fufu"                         # yellow
      "Kiana"                           # grey
      "Ellen-Joe"                       # black
      "Erika-Furudo"                    # blue
      "Tumi-Crystal"                    # default
    ];

    sha256 = "sha256-O+YTAFe+BR7jOmqOoV0biHO8Me71XcbPyeg6MzgfsxI=";
  };

  installPhase = ''
    # Buat direktori tujuan standar kursor Linux
    mkdir -p $out/share/icons

    for d in *; do
      # Cek apakah itu direktori dan memiliki file index.theme di dalamnya
      if [ -d "$d" ] && [ -f "$d/index.theme" ]; then
        echo "Installing cursor pack: $d"
        cp -pr "$d" $out/share/icons/
      fi
    done

    # Opsional: Hapus folder 'default' jika tidak sengaja terikut 
    # agar tidak konflik dengan Stylix
    rm -rf $out/share/icons/default
  '';
}
