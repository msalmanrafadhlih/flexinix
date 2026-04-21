{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "cursor-memes";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "Cursors-memes";
    rev = "3ec9c73870a036c7b3f8d8f3741554f9e70e9030";

    # WAJIB: Tambahkan ini agar Nix hanya mengambil folder tema tersebut
    sparseCheckout = [
      "Kafka"                           # red
      "Crelly-Cursor-Pack"              # green
      "Ju-Fufu"                         # yellow
      "Kiana-(Herrscher-of-Flamescion)" # grey
      "Ellen-Joe"                       # black
      "Erika-Furudo"                    # blue
    ];

    sha256 = "";
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
