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
Resource    ../../../../resources/selftest_resource.robot
Library     RobotFramework_Testsuites    WITH NAME    testsuites
Library     QConnectBase.ConnectionManager
Library     Collections
Suite Setup      TCPIP Client Setup
Suite Teardown   Stop TCPIP Server
Test Teardown    Release Test Environment

*** Keywords ***
Release Test Environment
    Log To Console  \nDisconnecting from ${CONNECTION_NAME}
    disconnect  ${CONNECTION_NAME}

Start TCP/IP selftest server
    Log To Console  \nStart TCP/IP server
    Start TCPIP Server    ${__TESTBENCH__CONFIG}[hw][internal][TCPIP][address]  
    ...                   ${__TESTBENCH__CONFIG}[hw][internal][TCPIP][port]

TCPIP Client Setup
    testsuites.testsuite_setup    ../../../../config/testsuites_config.json
    Start TCP/IP selftest server

*** Variables ***
${CONNECTION_NAME}  TCPIP_CONNECTION

*** Test Cases ***
TCPIP base connect client
    [Documentation]     Connect TCP/IP base.
    # &{config}           Create Dictionary    address="127.0.0.1"    port=12345345
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=TCPIPClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]
    Log To Console      \nConnect to ${CONNECTION_NAME} successfully!

TCPIP base connect existing conn_name
    [Documentation]     Connect to connected device.
    Log To Console      \nConnecting to ${CONNECTION_NAME} ...
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=TCPIPClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]

    Log To Console      \nConnecting to existing connection ${CONNECTION_NAME} ...
    Run Keyword And Expect Error    ${EXISTING_CONNECT_ERROR}
    ...                             connect             conn_name=${CONNECTION_NAME}
    ...                             conn_type=TCPIPClient
    ...                             conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]

TCPIP base connect client no address server
    [Documentation]     Connect to no TCP/IP address server.

    Log To Console      \nModify the address for TCP/IP server
    ${wrong_addr_server}=    Copy Dictionary   ${__TESTBENCH__CONFIG}[hw][internal][TCPIP]  deep_copy=True
    Log To Console      ${wrong_addr_server}
    Set To Dictionary   ${wrong_addr_server}  address=192.168.2.2
    Log To Console      ${wrong_addr_server}

    Log To Console      \nConnecting to ${CONNECTION_NAME} ...
    Run Keyword And Expect Error    ${FAIL_CONNECT_ERROR}
    ...                             connect             conn_name=${CONNECTION_NAME}
    ...                             conn_type=TCPIPClient
    ...                             conn_conf=${wrong_addr_server}

TCPIP base connect client no listening port server
    [Documentation]     Connect to no listening port TCP/IP server.

    Log To Console      \nModify the port for TCP/IP server
    ${wrong_port_server}=    Copy Dictionary   ${__TESTBENCH__CONFIG}[hw][internal][TCPIP]  deep_copy=True
    Log To Console      ${wrong_port_server}
    Set To Dictionary   ${wrong_port_server}  port=9999
    Log To Console      ${wrong_port_server}

    Log To Console      \nConnecting to ${CONNECTION_NAME} ...
    Run Keyword And Expect Error    ${FAIL_CONNECT_ERROR}
    ...                             connect             conn_name=${CONNECTION_NAME}
    ...                             conn_type=TCPIPClient
    ...                             conn_conf=${wrong_port_server}

TCPIP base disconnect wrong conn_name
    [Documentation]     Disconnect a not connected device.
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=TCPIPClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]

    disconnect  No existing connection

TCPIP base disconnect a disconnected conn_name
    [Documentation]     Disconnect an already disconnected device.
    Log To Console      \nConnecting to ${CONNECTION_NAME} ...
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=TCPIPClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]

    Log To Console      \nDisconnecting to ${CONNECTION_NAME} ...
    disconnect  ${CONNECTION_NAME}
    Log To Console      \nDisconnecting again to ${CONNECTION_NAME} ...
    disconnect  ${CONNECTION_NAME}


TCPIP base send command
    [Documentation]     Send command to connected device.
    Log To Console      \nConnecting to ${CONNECTION_NAME} ...
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=TCPIPClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]

    send command        conn_name=${CONNECTION_NAME}
    ...                 command=CMD

TCPIP base send command to not connected conn_name
    [Documentation]     Send command to not connected device.
    Log To Console      \nConnecting to ${CONNECTION_NAME} ...
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=TCPIPClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]

    Run Keyword And Expect Error    ${NOT_CONNECT_ERROR}
    ...                             send command        conn_name=NOT_CONNECTED
    ...                             command=CMD

TCPIP base verify match log/trace
    [Documentation]     Verify response successfully.
    FOR     ${cnt}    IN RANGE    10
        Log To Console      \nConnecting to ${CONNECTION_NAME} ...    
        connect             conn_name=${CONNECTION_NAME}
        ...                 conn_type=TCPIPClient
        ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]

        ${res}=     verify  conn_name=${CONNECTION_NAME}
        ...                 search_pattern=(echo:.*)
        ...                 send_cmd=VERIFY
        # ...                 timeout=10

        Log To Console      ${res}

        Log To Console      Disconnecting from ${CONNECTION_NAME} ...
        disconnect  ${CONNECTION_NAME}
    END

TCPIP base verify no match log/trace
    [Documentation]     Verify without matched log/trace.
    Log To Console      \nConnecting to ${CONNECTION_NAME} ...    
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=TCPIPClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]

    Run Keyword And Expect Error    ${TIMEOUT_ERROR}
    ...                             verify  conn_name=${CONNECTION_NAME}
    ...                             search_pattern=(not match)
    ...                             send_cmd=VERIFY

TCPIP base verify with timeout successfully
    [Documentation]     Verify with timeout successfully.
    Log To Console      \nConnecting to ${CONNECTION_NAME} ...    
    connect             conn_name=${CONNECTION_NAME}
    
    ...                 conn_type=TCPIPClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]

    ${res}=     verify      conn_name=${CONNECTION_NAME}
    ...                     search_pattern=(echo:.*)
    ...                     send_cmd=DELAY_6
    ...                     timeout=10

    Log    ${res}    console=True

TCPIP base verify with timeout unsuccessfully
    [Documentation]     Verify with timeout unsuccessfully.
    Log To Console      \nConnecting to ${CONNECTION_NAME} ...    
    connect             conn_name=${CONNECTION_NAME}
    
    ...                 conn_type=TCPIPClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]

    Run Keyword And Expect Error    ${TIMEOUT_ERROR}
    ...                             verify  conn_name=${CONNECTION_NAME}
    ...                             search_pattern=(echo:.*)
    ...                             send_cmd=DELAY_6

TCPIP base verify not connected conn_name
    [Documentation]     Verify response from a not connected device.
    Log To Console      \nConnecting to ${CONNECTION_NAME} ...    
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=TCPIPClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]
 
    Run Keyword And Expect Error    ${NOT_CONNECT_ERROR}
    ...                             verify  conn_name=NOT_CONNECTED
    ...                             search_pattern=(.*)
    ...                             send_cmd=VERIFY
    # Log To Console    ${res}

TCPIP multiple client communications
    [Documentation]     Multiple TCP/IP client communications with server.
    Log To Console      \nConnecting to ${CONNECTION_NAME}_1 ...    
    connect             conn_name=${CONNECTION_NAME}_1
    ...                 conn_type=TCPIPClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]

    Log To Console      \nConnecting to ${CONNECTION_NAME}_2 ...    
    connect             conn_name=${CONNECTION_NAME}_2
    ...                 conn_type=TCPIPClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][TCPIP]

    ${res_1}=     verify  conn_name=${CONNECTION_NAME}_1
    ...                 search_pattern=(echo:.*)
    ...                 send_cmd=VERIFY

    Log To Console      ${res_1}
    
    ${res_2}=     verify  conn_name=${CONNECTION_NAME}_2
    ...                 search_pattern=(echo:.*)
    ...                 send_cmd=VERIFY

    Log To Console      ${res_2}

    disconnect  ${CONNECTION_NAME}_1
    disconnect  ${CONNECTION_NAME}_2