import rclpy
import serial
import can
import sys
import numpy as np
import struct

can.rc['interface'] = 'serial'

from rclpy.node import Node

from geometry_msgs.msg import TwistStamped
from geometry_msgs.msg import TransformStamped
from tf2_ros import TransformBroadcaster

class SlinamSerial(Node):

    def __init__(self):
        super().__init__('slinam_serial')
        print("slinam_serial v1.0")
        self.subscription = self.create_subscription(TwistStamped, 
                                                     'cmd_vel', 
                                                     self.twist_to_serial,
                                                     10,
                                                     )

        if not sys.argv[1] and sys.argv[2]:
            print("please enter the port and baud rate as arguments")
            # TODO: look for the ros2 equivalent
            exit()

        port = sys.argv[1]
        baud = sys.argv[2]

        self.serial = serial.Serial(port, baud)
        self.can_bus = can.interface.Bus(channel=port, bitrate=baud)
        # self.counter = 0

        # self.serialTimer = self.create_timer(1.0 / 10.0, self.serialCallback)


        # velocity/wheel encoder publisher
        # self.publisher = self.create_publisher(
        self.tf_broadcaster = TransformBroadcaster(self)

    def serial_callback(self):
        # pass
        buf = self.can_bus.recv().data
        # print(buf)
        l_buf = buf[0:4]
        r_buf = buf[4:8]

        l_rpm = np.float32(struct.unpack('f', l_buf))
        r_rpm = np.float32(struct.unpack('f', r_buf))
        # print(np.float32(l_rpm), np.float32(r_rpm))
        # print(r_rpm)
        # print(self.serial.read_until(b'\n'))
        # print("Callback Time!")

    def twist_to_serial(self, msg):
        # this is a differential drive system, so only l_x and a_z is used.
        l_x = np.float32(msg.twist.linear.x)
        a_z = np.float32(msg.twist.angular.z)

        # each float32 is 4 bytes each
        self.serial.write(struct.pack('ff', l_x, a_z))
        # print("Twistie time!")
        

def main(args=None):
    rclpy.init(args=args)

    slinam_serial = SlinamSerial()

    while rclpy.ok():
        rclpy.spin_once(slinam_serial)
        slinam_serial.serial_callback();

    rclpy.shutdown()

if __name__ == '__main__':
    main()

