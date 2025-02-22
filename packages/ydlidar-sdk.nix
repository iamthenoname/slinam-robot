{ pkgs }:
pkgs.stdenv.mkDerivation {
          pname = "ydlidar-sdk";
          version = "1.2.7";
          src = pkgs.fetchFromGitHub {
            owner = "YDLIDAR";
            repo = "YDLidar-SDK";
            rev = "V1.2.7";
            hash = "sha256-9F6pX/1CdzrXnkQ3yiPKTZERtQAXKXzfjclhhQgsn+4=";
          };

          buildInputs = [
            pkgs.cmake
          ];

          hardeningDisable = [
            "format"
          ];

          configurePhase = ''
            cmake -DCMAKE_INSTALL_PREFIX=$out .
          '';
        }
