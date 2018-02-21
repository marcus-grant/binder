#!/usr/bin/env python
# -*- coding: utf-8 -*-

""" A screenshot utility, particularly meant for keyboard focused environments
Save as whatever you want the command to be named, somewhere in PATH
bindsym --release Print exect --nostartup-id grapy.py
"""

import os
from subprocess import Popen, PIPE
from tempfile import NamedTemporaryFile

# TODO: Add a checker for scrot's existence & if not, install it w. confirm
SCREENSHOT_UTILITY = '/usr/bin/scrot -s' # /usr/bin/import

def feed_xclipboard(str):
    pipe = Popen("xclip -sel clip", shell=True, stdin=PIPE).stdin
    pipe.write(str)
    pipe.close

def import_screenshot():
    filename = NamedTemporaryFile(
            suffix='.png',
            prefix='screenshot_',
            dir = os.path.expanduser('~/tmp'),
            delete=False).name
    p = Popen(SCREENSHOT_UTILITY + " " + filename, shell=True)
    sts = os.waitpid(p.pid, 0)[1]
    return filename

if __name__ == '__main__':
    screenshot = import_screenshot()
    feed_xclipboard(screenshot)
