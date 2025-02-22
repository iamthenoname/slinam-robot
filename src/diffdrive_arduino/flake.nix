
{
  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";  # IMPORTANT!!!
  };
  outputs = { self, nix-ros-overlay, nixpkgs }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        applyDistroOverlay =
          rosOverlay: rosPackages:
          rosPackages
          // builtins.mapAttrs (
            rosDistro: rosPkgs: if rosPkgs ? overrideScope then rosPkgs.overrideScope rosOverlay else rosPkgs
          ) rosPackages;
        # rosDistroOverlays = final: prev: {
          # Apply the overlay to multiple ROS distributions
          # rosPackages = applyDistroOverlay (import ./overlay.nix) prev.rosPackages;
        # };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            nix-ros-overlay.overlays.default
            # rosDistroOverlays
          ];
        };

        rosDistro = "jazzy";

        libserial = pkgs.stdenv.mkDerivation {
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
        };
      in {
        legacyPackages = pkgs.rosPackages;
        # packages = builtins.intersectAttrs (import ./overlay.nix null null) pkgs.rosPackages.${rosDistro};
        # checks = builtins.intersectAttrs (import ./overlay.nix null null) pkgs.rosPackages.${rosDistro};
        devShells.default = pkgs.mkShell {
          name = "Example project";
          packages = [
            pkgs.colcon
            libserial
            # ... other non-ROS packages
            (with pkgs.rosPackages.${rosDistro}; buildEnv {
              paths = [
                ros-core
                ament-cmake-core
                xacro

                teleop-twist-keyboard
                
                controller-manager
                diff-drive-controller
                hardware-interface
                joint-state-broadcaster
                robot-state-publisher
                pluginlib
                rclcpp
                rclcpp-lifecycle
                ros2-control
                rviz2
                # ... other ROS packages
              ];
            })
          ];
        };
      });
  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
