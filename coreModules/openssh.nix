{
  username,
  lib,
  ...
}:
let
  githubMeta = builtins.fromJSON (
    builtins.readFile (
      builtins.fetchurl {
        url = "https://api.github.com/meta";
        sha256 = "sha256:17qg28s2a1wlssyw6xpklfgc0p0yjjky93ahbbq4s8yazib351qs";
      }
    )
  );

  githubSshEd25519 = lib.findFirst (
    k: lib.hasPrefix "ssh-ed25519" k
  ) (throw "GitHub meta: tidak ada ssh-ed25519 key, cek ulang JSON-nya") githubMeta.ssh_keys;
in
{
  # 2. Tailscale Tanpa Flag SSH (Gunakan OpenSSH saja)
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };
  # Trik rahasia NixOS agar binary tetap ada tapi service tidak jalan otomatis:
  # saat ingin dijalankan `sudo systemctl start tailscaled`, jika sudah `.. stop ..`
  systemd.services.tailscaled.wantedBy = lib.mkForce [ ];

  # 3. OpenSSH yang Solid & Hemat RAM
  services.openssh = {
    enable = true;
    openFirewall = false; # Hanya lewat interface tailscale0 di atas
    startWhenNeeded = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      AllowUsers = [ username ];
      X11Forwarding = false;

      # Menjaga koneksi tetap hidup & membersihkan sesi mati
      ClientAliveInterval = 60;
      ClientAliveCountMax = 3;
    };
  };

  programs.ssh.knownHosts = {
    github-ed25519 = {
      hostNames = [ "github.com" ];
      publicKey = githubSshEd25519;
    };
  };

  # 4. Mosh untuk koneksi yang lebih stabil di jalan
  programs.mosh = {
    enable = true;
    openFirewall = false;
  };
}
