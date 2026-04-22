{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "cursor-memes";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "Cursors-memes";
    rev = "15ccff6b20945cf5d71ad61a9cfe736be9b3aadf";

    # WAJIB: Tambahkan ini agar Nix hanya mengambil folder tema tersebut
    sparseCheckout = [
      "Kafka"                           # red
      "Crelly-Cursor-Pack"              # green
      "Ju-Fufu"                         # yellow
      "Kiana"                           # grey
      "Ellen-Joe"                       # black
      "Erika-Furudo"                    # blue
    ];

    sha256 = "sha256-/oC7Mu8iZjRrdHgtJARBGZsYZ5cHFcyBkvpdZX79XFs=";
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
