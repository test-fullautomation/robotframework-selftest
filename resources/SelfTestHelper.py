#  Copyright 2020-2022 Robert Bosch Car Multimedia GmbH
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
from JsonPreprocessor import CJsonPreprocessor
from robot.api import logger
import os
import subprocess
import time
import sys
import signal

PY_SERVER_SCRIPT = os.path.join(os.path.split(os.path.abspath(__file__))[0], 
                                '..', 
                                'helpers', 
                                'tcpip', 
                                'tcpip_server.py')
PYTHON = os.path.join(os.environ['RobotPythonPath'], 'python' if sys.platform.startswith('win') else "python3")

class SelfTestHelper(object):
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LISTENER_API_VERSION = 3

    def __init__(self):
        self.ROBOT_LIBRARY_LISTENER = self
        self.process_bits = None
        self.process_tcpip_server = None

    def parse_data_from_json(self, pathfile):
        return CJsonPreprocessor().jsonLoad(pathfile)

    def start_BITS(self):
        """
        Start BITS Platform application.
        """
        if 'ATSWorkPath' not in os.environ:
            logger.error("Can not find the installed BITS application folder %ATSWorkPath%.")
            return None

        logger.info("Starting BITS application ...")
        cwd = os.getcwd()
        os.chdir(os.environ['ATSWorkPath'])
        self.process_bits = subprocess.Popen("BITS.Platform.exe")
        os.chdir(cwd)
        time.sleep(15)

        return self.process_bits

    def stop_BITS(self):
        """
        Strop running BITS Platform application.
        """
        try:
            if self.process_bits:
                self.process_bits.terminate() 
        except Exception as reason:
            logger.error(f"Error when terminate process. Reason: {reason}")

    def start_TCPIP_server(self, ip=None, port=None):
        """
        Start TCP/IP server.
        """
        if sys.platform.startswith('win'):
            self.process_tcpip_server = subprocess.Popen([PYTHON, PY_SERVER_SCRIPT, ip, str(port)], creationflags=subprocess.CREATE_NEW_CONSOLE)
        elif sys.platform.startswith('linux'):
            self.process_tcpip_server = subprocess.Popen(f"gnome-terminal --disable-factory -- {PYTHON} {PY_SERVER_SCRIPT} {ip} {str(port)}", shell=True, preexec_fn=os.setpgrp)

        time.sleep(2)
        return self.process_tcpip_server

    def stop_TCPIP_server(self):
        """
        Stop running TCP/IP server.
        """
        try:
            if self.process_tcpip_server:
                if sys.platform.startswith('win'):
                    self.process_tcpip_server.terminate()
                elif sys.platform.startswith('linux'):
                    os.killpg(self.process_tcpip_server.pid, signal.SIGTERM)
        except Exception as reason:
            logger.error(f"Error when terminate process. Reason: {reason}")