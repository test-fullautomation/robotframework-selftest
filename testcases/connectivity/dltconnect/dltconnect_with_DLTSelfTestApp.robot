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
*** Settings ***
Resource        ../../../resources/selftest_resource.robot
Library         RobotFramework_Testsuites    WITH NAME    testsuites
Library         QConnectBase.ConnectionManager
Suite Setup     DLTSelfTestApp Setup
Suite Teardown  DLTSelfTestApp Teardown

*** Variables ***
${CONNECTION_NAME}  TEST_CONN_DLTSelfTestApp

# Below dlt and ssh connection is used for Apertis SDK 
# which DLTSelfTestApp is already installed on
${DLT_CONNECTION_CONFIG} =  SEPARATOR=
...  {
...      "gen3flex@DLTLSIMWFH": {
...            "target_ip": "127.0.0.1",
...            "target_port": 4490,
...            "mode": 0,
...            "ecu": "ECU1",
...            "com_port": "COM1",
...            "baudrate": 115200,
...            "server_ip": "localhost",
...            "server_port": 1234\,
...            "trcfile" : "C:/MyData/5.CM-domain/BVT_LSIM/cmd/deploy/gen3/lsim/g3g/prj_overall_a.trc"
...      }
...  }
${SSH_CONNECTION_CONFIG} =  SEPARATOR=
...  {
...   "address": "127.0.0.1",
...   "port": 4022,
...   "username": "user",
...   "password": "user",
...   "authentication": "password",
...   "key_filename": null
...  }


*** Keyword ***
Close Connection
   disconnect  ${CONNECTION_NAME}
   Log to console    \nDLT connection has been closed!

Open Connection
   # ${dlt_config} =    evaluate    json.loads('''${DLT_CONNECTION_CONFIG}''')   json
   ${dlt_config} =    ${__TESTBENCH__CONFIG}[hw][external][duts][trc]

   connect             conn_name=${CONNECTION_NAME}
   ...                 conn_type=DLT
   ...                 conn_mode=dltconnector
   ...                 conn_conf=${dlt_config}

   Log to console    \nDLT connection has been opened successfully!

Start DLTSelfTestApp
   [Documentation]    ssh to target to start DLTSelfTestApp application

   ${ssh_config}=      evaluate   json.loads('''${SSH_CONNECTION_CONFIG}''')    json
   ${ssh_conn_name}=   Set Variable    ssh_conn
   # Connect to the target with above configurations.
   connect      conn_name=${ssh_conn_name}
   ...          conn_type=SSHClient
   ...          conn_conf=${ssh_config}

   verify     conn_name=${CONNECTION_NAME}
   ...                   search_pattern=(^Hi$)
   ...                   send_cmd=echo Hi
   
   # Start DLTSelfTestApp
   send command   conn_name=${ssh_conn_name}
   ...            command=/opt/bosch/robfw/dlt/DLTSelfTestApp

   Log to console    \nDLTSelfTestApp has been started on the target successfully!

   disconnect  ${ssh_conn_name}

Exit DLTSelfTestApp
   [Documentation]    terminate DLTSelfTestApp application via DLT injection command
   ${res}=    verify     conn_name=${CONNECTION_NAME}
   ...                   search_pattern=(DLT:0x01.*RBFW.*Bye\.\.\..*)
   ...                   send_cmd=DLT_CALL_SW_INJECTION_ECU ECU1 1000 RBFW TEST 'exit'

   Log to console    \nDLTSelfTestApp has been terminated successfully!

DLTSelfTestApp Setup
   testsuites.testsuite_setup    ../../../config/testsuites_config.json
   Skip If    not ${__TESTBENCH__CONFIG}[sw][has_dlt_selftestapp]    Skip DLT with SelfTestApp suite
   # Start DLTSelfTestApp
   Open Connection

DLTSelfTestApp Teardown
   # Exit DLTSelfTestApp
   Close Connection

*** Test Cases ***
Match log/trace from DLTSelfTestApp
   [Documentation]   Match log/trace from DLTSelfTestApp
   [Tags]   DLTSelfTestApp
   ${res}=    verify     conn_name=${CONNECTION_NAME}
   ...                   search_pattern=(DLT:0x01.*RBFW.*)
   ...                   timeout=6    # DLTSelfTestApp pings a message every 5 seconds

   # log to console     \n${res}[0]
   # verify that reponse message should contain "Ping" keyword
   Should Match Regexp     ${res}[0]    DLT:0x01.*RBFW.*Ping.*   

No match log/trace from DLTSelfTestApp
   [Documentation]   No match log/trace from DLTSelfTestApp
   [Tags]   DLTSelfTestApp
   ${res}=    verify     conn_name=${CONNECTION_NAME}
   ...                   search_pattern=(DLT:0x01.*RBFW.*Ping.*)
   ...                   timeout=6    # DLTSelfTestApp pings a message every 5 seconds

   # log to console     \n${res}[0]
   # verify that reponse message should not contain "Unmatched Message" keyword
   Should Not Match Regexp     ${res}[0]    DLT:0x01.*RBFW.*Unmatched Message.*    

Command injection with DLTSelfTestApp
   [Documentation]   Get log/trace from DLTSelfTestApp
   [Tags]   DLTSelfTestApp
   ${res}=    verify     conn_name=${CONNECTION_NAME}
   ...                   search_pattern=(DLT:0x01.*RBFW.*Welcome.*)
   ...                   send_cmd=DLT_CALL_SW_INJECTION_ECU ECU1 1000 RBFW TEST 'welcome'

   # log to console     \n${res}[0]

   ${res}=    verify     conn_name=${CONNECTION_NAME}
   ...                   search_pattern=(DLT:0x01.*RBFW.*other_cmd.*)
   ...                   send_cmd=DLT_CALL_SW_INJECTION_ECU ECU1 1000 RBFW TEST 'other_cmd'

   # log to console     \n${res}[0]