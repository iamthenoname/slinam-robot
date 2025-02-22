{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "libserial";
  version = "1.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "crayzeewulf";
    repo = "libserial";
    rev = "master";
    hash = "sha256-vlALjxwUevgMGaQ1la2gldWRXk4ZLQ4+GxFs4j2BoVQ=";
  };
  nativeBuildInputs = with pkgs; [ cmake ];
  cmakeFlags = [
    "-DLIBSERIAL_ENABLE_TESTING=OFF"
    "-DLIBSERIAL_BUILD_EXAMPLES=OFF"
    "-DLIBSERIAL_PYTHON_ENABLE=OFF"
    "-DLIBSERIAL_BUILD_DOCS=OFF"
  ];
}
