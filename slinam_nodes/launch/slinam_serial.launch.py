from launch import LaunchDescription
from launch_ros.actions import Node
from launch.substitutions import LaunchConfiguration
from launch.actions import DeclareLaunchArgument

import os
from ament_index_python.packages import get_package_share_directory

def generate_launch_description():
    use_sim_time = LaunchConfiguration('use_sim_time')

    joy_params = os.path.join(get_package_share_directory('slinam_nodes'),'config','joystick.yaml')
    ydlidar_params = os.path.join(get_package_share_directory('ydlidar_ros2_driver'),'params','X2.yaml')


    joy_node = Node(
            package='joy',
            executable='joy_node',
            parameters=[joy_params, {'use_sim_time': use_sim_time}],
         )

    teleop_node = Node(
            package='teleop_twist_joy',
            executable='teleop_node',
            name='teleop_node',
            parameters=[joy_params, {'use_sim_time': use_sim_time}],
            remappings=[('/cmd_vel','/cmd_vel_unstamped')]
         )

    # twist_stamper = Node(
    #         package='twist_stamper',
    #         executable='twist_stamper',
    #         parameters=[{'use_sim_time': use_sim_time}],
    #         remappings=[('/cmd_vel_in','/diff_cont/cmd_vel_unstamped'),
    #                     ('/cmd_vel_out','/diff_cont/cmd_vel')]
    #      )

    twist_stamper = Node(
            package='twist_stamper',
            executable='twist_stamper',
            parameters=[{'use_sim_time': use_sim_time}],
            remappings=[('/cmd_vel_in','/cmd_vel_unstamped'),
                        ('/cmd_vel_out','/cmd_vel')]
         )

    slinam_serial_node = Node(
            package='slinam_nodes',
            executable='slinam_serial',
            output='screen',
            emulate_tty=True,
            arguments=['/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_A5069RR4-if00-port0', '115200'],
            )

    ydlidar_node = Node(
            package='ydlidar_ros2_driver',
            executable='ydlidar_ros2_driver_node',
            name='ydlidar_ros2_driver_node',
            parameters=[ydlidar_params],
            )

    # this is just to make it work already 

    tf2_node = Node(
            package='tf2_ros',
            executable='static_transform_publisher',
            name='static_tf_pub_laser',
            arguments=['0', '0', '0.02','0', '0', '0', '1','base_link','laser_frame'],
            )


    return LaunchDescription([
        DeclareLaunchArgument(
            'use_sim_time',
            default_value='false',
            description='Use sim time if true'),
        joy_node,
        teleop_node,
        twist_stamper,
        slinam_serial_node,
        # ydlidar_node,
        tf2_node
    ])
