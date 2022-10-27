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
Library     RobotFramework_Testsuites    WITH NAME    testsuites
Library     QConnectBase.ConnectionManager
Library     Collections
Suite Setup      Serial Client Setup
Suite Teardown   testsuites.testsuite_teardown
Test Setup       testsuites.testcase_setup
Test Teardown    Release Test Environment

*** Variables ***
${CONNECTION_NAME}  SERIAL_CONNECTION
&{RESULT}   SerialBaseTest=1\r\n2\r\n3\r\n4\r\n5
...         SerialBaseSemicolon=1\r\n2\r\n3\r\n4\r\n5
...         SerialBaseWithNewlines=\r\n\r\n1\r\n2\r\n3\r\n4\r\n5\r\n\r\n
...         SerialBaseWithNewlinesSemicolon=\r\n\r\n1\r\n2\r\n3\r\n4\r\n5\r\n\r\n
...         SerialBaseWithoutResponse=
...         SerialBaseWithoutResponseNegative=
...         SerialBaseDelayedResponse=('1', '2', '3', '4', '5', '0')

*** Keywords ***
Serial Command
    [Arguments]  ${input}
    ${string}=  set variable  echo ~~START~~;${input.rstrip(';')};echo ~~END$?~~
    sleep   1s
    [Return]  ${string}

Release Test Environment
    disconnect      ${CONNECTION_NAME}

Serial Client Setup
    testsuites.testsuite_setup    ../../../config/testsuites_config.json
    Skip If    not ${__TESTBENCH__CONFIG}[sw][has_serial]    Skip SSH suite

*** Test Cases ***
Serial base verify
#    Get COM Status      COM9
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    echo 1; echo 2; echo 3; echo 4; echo 5
    ${res} =    verify      conn_name=${CONNECTION_NAME}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(.*?)(?:\\r\\n)?~~END(\\d+)~~
    ...                     send_cmd=${command}

    Log To Console  ${res}[1]
    Should Be Equal As Strings      ${res}[1]    ${RESULT}[SerialBaseTest]

Serial base verify semicolon
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    echo 1; echo 2; echo 3; echo 4; echo 5;
    ${res} =    verify      conn_name=${CONNECTION_NAME}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(.*?)(?:\\r\\n)?~~END(\\d+)~~
    ...                     send_cmd=${command}

    Log To Console  ${res}[1]
    Should Be Equal As Strings      ${res}[1]    ${RESULT}[SerialBaseSemicolon]

Serial base verify newlines
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    echo; echo; echo 1; echo 2; echo 3; echo 4; echo 5; echo; echo
    ${res} =    verify      conn_name=${CONNECTION_NAME}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(.*?)(?:\\r\\n)?~~END(\\d+)~~
    ...                     send_cmd=${command}

    Log To Console  ${res}[1]
    Should Be Equal As Strings      ${res}[1]    ${RESULT}[SerialBaseWithNewlines]

Serial base verify newlines semicolon
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    echo; echo; echo 1; echo 2; echo 3; echo 4; echo 5; echo; echo;
    ${res} =    verify      conn_name=${CONNECTION_NAME}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(.*?)(?:\\r\\n)?~~END(\\d+)~~
    ...                     send_cmd=${command}

    Log To Console  ${res}[1]
    Should Be Equal As Strings      ${res}[1]    ${RESULT}[SerialBaseWithNewlines]

Serial base verify without response
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    true
    ${res} =    verify      conn_name=${CONNECTION_NAME}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(.*?)(?:\\r\\n)?~~END(\\d+)~~
    ...                     send_cmd=${command}

    Log To Console  ${res}[1]
    Should Be Equal As Strings      ${res}[1]    ${RESULT}[SerialBaseWithoutResponse]

Serial base verify delayed response
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    sleep 1; echo 1; sleep 1; echo 2; sleep 1; echo 3; sleep 1; echo 4; sleep 1; echo 5
    ${res} =    verify      conn_name=${CONNECTION_NAME}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(\\d)\\r\\n(\\d)\\r\\n(\\d)\\r\\n(\\d)\\r\\n(\\d)(?:\\r\\n)?~~END(\\d+)~~
    ...                     send_cmd=${command}
    ...                     timeout=15
    Log To Console  ${res.groups()}
    Should Be Equal As Strings  ${res.groups()}   ${RESULT}[SerialBaseDelayedResponse]