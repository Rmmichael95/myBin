#!/usr/bin/env python

import zmq
import sys
import subprocess


def zmq_ffmpeg(bind_address, option):
    context = zmq.Context()
    requester = context.socket(zmq.REQ)
    requester.connect(bind_address)
    requester.send_string(option)
    message = requester.recv()
    subprocess.Popen(['notify-send', message])


if __name__.__eq__('__main__'):
    args = sys.argv

    bind_address = 'tcp://127.0.0.1:'
    bind_address += args[1]
    option = args[2]

    zmq_ffmpeg(bind_address, option)
