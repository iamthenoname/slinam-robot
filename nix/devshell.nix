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
    perSystem.self.libserial
    # ... other non-ROS packages
    (
      with pkgs.rosPackages.jazzy;
      # XXX: would be better if each package had its own package.nix instead,
      #         but since this is just for development, it's probably okay to
      #         stick with this for now and just change it sometime
      buildEnv {
        paths = [
          ros-core
          ament-cmake-core
          xacro
          rclcpp

          teleop-twist-joy
          joy

          twist-stamper

          tf2-ros
          tf2-ros-py
          ros2-control
          diff-drive-controller

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
      }
    )
  ];
}
