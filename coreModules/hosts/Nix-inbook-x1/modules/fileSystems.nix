{ config, lib, ... }:

let
  # Cek apakah sistem sedang dijalankan sebagai VM (build-vm)
  isVM = config.virtualisation.vmVariant != null;
in
{
  # Pengaturan File System yang Aman
  # Kita membungkusnya agar tidak memaksa mount jika sedang di VM
  fileSystems."/" = lib.mkForce {
    device = if isVM then "/dev/disk/by-label/nixos" 
             else "/dev/disk/by-uuid/f2e16302-ca61-486c-96eb-16294ba9b3aa";
    fsType = "ext4"; # Sesuaikan dengan format partisi nixos kamu
  };

  # Jika kamu ingin bereksperimen dengan folder Steam (opsional)
  # lib.mkIf (!isVM) memastikan ini TIDAK akan dijalankan saat build-vm
  fileSystems."/home/tquilla/.steam" = lib.mkIf (!isVM) {
    device = "/dev/disk/by-label/STEAM_DATA"; # Gunakan label agar lebih manusiawi
    fsType = "btrfs";
    options = [ "nofail" ]; # Agar tetap bisa boot meskipun disk tidak terpasang
  };
}
