
# ../packages/rip.nix
{ pkgs, fetchFromGitHub, ... }:

pkgs.rustPlatform.buildRustPackage {
  pname = "rip-cli";
  version = "0.1.0";

  # source langsung dari GitHub
  src = fetchFromGitHub {
    owner = "cesarferreira";
    repo = "rip";
    rev = "83f0260229489cd3db2f60316bf2a9939b87c4a6"; 
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; 
  };
  
  # Menggunakan file lock dari source:
  cargoHash = "sha256-............................................"; 

  nativeBuildInputs = with pkgs; [ pkg-config ];

  buildInputs = with pkgs; [ ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
      pkgs.darwin.apple_sdk.frameworks.Security
      pkgs.darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = with pkgs.lib; {
    description = "Fuzzy find and kill processes from your terminal";
    homepage = "https://github.com/cesarferreira/rip";
    license = licenses.mit;
    mainProgram = "rip";
  };
}
