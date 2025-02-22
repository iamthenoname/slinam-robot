{ pkgs, perSystem }:
pkgs.mkShell {
  packages = [
    pkgs.colcon

    pkgs.python3Packages.pyserial
    pkgs.python3Packages.python-can
    pkgs.python3Packages.python-lsp-server

    pkgs.just
    pkgs.nil
    pkgs.nixd

    perSystem.self.ydlidar-sdk
    # ... other non-ROS packages
    (
      with pkgs.rosPackages.jazzy;
      buildEnv {
        paths = [
          ros-core
          ament-cmake-core

          rclcpp

          teleop-twist-joy
          teleop-twist-keyboard
          joy

          twist-stamper

          tf2-ros
          tf2-ros-py
          ros2-control
          diff-drive-controller
          # ... other ROS packages
        ];
      }
    )
  ];
}
