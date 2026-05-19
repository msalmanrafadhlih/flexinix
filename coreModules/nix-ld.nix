{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # 1. Pustaka Grafik Dasar & Layar (X11 & Wayland)
      libX11
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXinerama
      libXrandr
      libXrender
      libXScrnSaver
      libXtst
      libxcb
      libXft
      libxkbcommon

      # 2. Akselerasi Grafis & Render (OpenGL / Vulkan / Driver)
      libGL
      libva
      libvdpau
      mesa
      libdrm
      pixman

      # 3. Audio & Media (Suara, Video, Games)
      pipewire
      alsa-lib
      pulseaudio
      ffmpeg
      libogg
      libvorbis
      flac
      libtheora
      SDL
      SDL2
      SDL2_image
      SDL2_mixer
      SDL2_ttf

      # 4. Desktop Lingkungan & Toolkit UI (GTK & GNOME Esensial)
      glib
      gtk3
      cairo
      pango
      atk
      gdk-pixbuf
      fontconfig
      freetype
      gsettings-desktop-schemas
      libnotify
      librsvg

      # 5. Keamanan, Web, & Sistem Inti Electron
      nspr
      nss
      openssl
      libcap
      dbus
      expat
      icu
      zlib

      # 6. Kompatibilitas Runtime Khasiat Khusus (AppImage & Matplotlib)
      stdenv.cc.cc.lib       # Menyediakan libstdc++.so.6 yang sangat krusial
      gcc-unwrapped.lib      # Perbaikan sintaks: langsung ditulis tanpa 'pkgs.' di depan
      fuse                   # Sangat dibutuhkan untuk menjalankan AppImage langsung
      e2fsprogs
      fribidi
    ];
  };
}
