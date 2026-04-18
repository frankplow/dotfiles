{ lib, rustPlatform, fetchFromGitHub, openssh }:

rustPlatform.buildRustPackage rec {
  pname = "ssh-agent-mux";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "overhacked";
    repo = "ssh-agent-mux";
    rev = "v${version}";
    hash = "sha256-tIGrENlZcT9fGke6MRnsLsmm+kb0Mm3C6DckkZi8hpE=";
  };

  cargoHash = "sha256-u5kGYCYDvEhSuGOLnhdt9IpRwzllXbSJDwY1XzpHBCc=";

  nativeBuildInputs = [ openssh ];

  meta = with lib; {
    description = "Combine keys from multiple SSH agents into a single agent socket";
    homepage = "https://github.com/overhacked/ssh-agent-mux";
    license = with licenses; [ asl20 bsd3 ];
    mainProgram = "ssh-agent-mux";
    platforms = platforms.unix;
  };
}
