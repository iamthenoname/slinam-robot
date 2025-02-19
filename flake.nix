{
  inputs = {
    nix-ros-overlay.url = "github:iamthenoname/nix-ros-overlay/develop";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";  # IMPORTANT!!!
    # XXX: use something like https://github.com/numtide/blueprint so the flake
    # doesn't grow too large and unwieldy
  };
  outputs = { self, nix-ros-overlay, nixpkgs }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nix-ros-overlay.overlays.default ];
        };

        ydlidar_sdk = pkgs.stdenv.mkDerivation {
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
        };
      in {
        devShells.default = pkgs.mkShell {
          name = "Example project";
          packages = [
            pkgs.colcon

            pkgs.python3Packages.pyserial
            pkgs.python3Packages.python-can

            pkgs.just
            
            ydlidar_sdk
            # ... other non-ROS packages
            (with pkgs.rosPackages.jazzy; buildEnv {
              paths = [
                ros-core
                ament-cmake-core

                rclcpp

                teleop-twist-joy
                joy

                twist-stamper

                tf2-ros
                tf2-ros-py
                ros2-control
                diff-drive-controller
                # ... other ROS packages
              ];
            })
          ];
        };
      });
  # nixConfig = {
  #   substituters = [ "https://ros.cachix.org" ];
  #   trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  # };
}
