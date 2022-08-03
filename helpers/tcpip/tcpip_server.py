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

# This is the TCPIP server service
# Which listen to the clients from the Robotframework testcases
# Input parameters <service_name> <listen_port>
import sys
import threading
import socket
import re
import time

# init TCPIP socket as the server
def start_server(host, port):
   """
   Start TCPIP server
   """
   iBacklog = 5
   bSocketAlive = True

   try:
      s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
      s.bind((host, port))
      s.listen(iBacklog)
      print(f"Started TCP/IP server at {host}:{port}")
   except Exception as reason:
      print(f"Could start TCP/IP server at {host}:{port}. Reason: {reason}")
   
   try:
      while bSocketAlive:
         print(f"Waiting for connection at {host}:{port}")

         (client, addr) = s.accept()
         print(f"Connected by {addr}")

         clientThread = threading.Thread(target=start_client, args=(client, addr))
         clientThread.start()
         # clientThread.join()

   except KeyboardInterrupt:
      print('Stoped server.')
      
   s.close()


def start_client(clientSocket, addr):
   iSize = 1024
   bClientAlive = True
   iTimeout = 5

   try:
      while bClientAlive:
         msg = clientSocket.recv(iSize).strip()
         if msg:
            print(f"Message from {addr}: '{msg}'")
            
            # clientSocket.send(msg)
            if msg == b'close':
               break
            elif matched_obj:=re.match('DELAY_(\d+)', msg.decode()):
               time.sleep(int(matched_obj.group(1)))

            clientSocket.send(f"echo: {msg}\r\n".encode())

      clientSocket.close()
      print(f"Disconnected client {addr}")
      
   except Exception as reason:
      clientSocket.close()
      print(f"Corrupted client. Reason '{reason}'")
   



if __name__ == "__main__":
   host = "127.0.0.1"
   port = "12345"

   if len(sys.argv) > 1:
      host = sys.argv[1]
   if len(sys.argv) > 2:
      port = sys.argv[2]

   start_server(host, int(port))
