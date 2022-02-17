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
Library     QConnectionLibrary.ConnectionManager
Library    Collections
Suite Setup      testsuites.testsuite_setup    ../../../config/testsuites_config.json
Suite Teardown   testsuites.testsuite_teardown
Test Setup       testsuites.testcase_setup
Test Teardown    Close Connection

*** Variables ***
${TEST_CONNECTION}  TEST_CONNECTION

*** Keywords ***
Serial Command
    [Arguments]  ${input}
    ${string}=  set variable  echo ~~START~~;${input.rstrip(';')};echo ~~END$?~~
    sleep   1s
    [Return]  ${string}

Close Connection
    disconnect      ${TEST_CONNECTION}

Get COM Status
    [Arguments]  ${com_name}
    ${conf}=    Create Dictionary   port=${com_name}
    ${level}=   Set Log Level   NONE
    ${dummy}    ${msg}=     Run Keyword And Ignore Error
    ...     connect     conn_name=check_status
    ...                 conn_type=SerialClient
    ...                 conn_conf=${conf}

    ${match}    ${dummy}=    Run Keyword And Ignore Error    Should Contain  ${msg}    PermissionError(13, 'Access is denied.', None, 5)
    Set Log Level   ${level}
    ${status}=  Set Variable If     '${match}' == 'PASS'    Unavailable   Unknown
#    ${status}=  Set Variable If     ${msg}    Available   ${status}
    Run keyword if  '${status}' == 'Available'    disconnect  check_status
    [Return]    ${status}

*** Test Cases ***
Serial Base Test
#    Get COM Status      COM9
    connect             conn_name=${TEST_CONNECTION}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    echo 1; echo 2; echo 3; echo 4; echo 5
    ${res} =    verify      conn_name=${TEST_CONNECTION}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(.*?)(?:\\r\\n){0,1}~~END(\\d+)~~
    ...                     send_cmd=${command}

    log to console  ${res}[1]
    Should Be Equal As Strings      ${res}[1]    ${qconnect}[qconnect][SerialBaseTest]

Serial Base Semicolon
    connect             conn_name=${TEST_CONNECTION}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    echo 1; echo 2; echo 3; echo 4; echo 5;
    ${res} =    verify      conn_name=${TEST_CONNECTION}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(.*?)(?:\\r\\n){0,1}~~END(\\d+)~~
    ...                     send_cmd=${command}

    log to console  ${res}[1]
    Should Be Equal As Strings      ${res}[1]    ${qconnect}[qconnect][SerialBaseSemicolon]

Serial Base Newlines
    connect             conn_name=${TEST_CONNECTION}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    echo; echo; echo 1; echo 2; echo 3; echo 4; echo 5; echo; echo
    ${res} =    verify      conn_name=${TEST_CONNECTION}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(.*?)(?:\\r\\n){0,1}~~END(\\d+)~~
    ...                     send_cmd=${command}

    log to console  ${res}[1]
    Should Be Equal As Strings      ${res}[1]    ${qconnect}[qconnect][SerialBaseWithNewlines]

Serial Base Newlines Semicolon
    connect             conn_name=${TEST_CONNECTION}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    echo; echo; echo 1; echo 2; echo 3; echo 4; echo 5; echo; echo;
    ${res} =    verify      conn_name=${TEST_CONNECTION}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(.*?)(?:\\r\\n){0,1}~~END(\\d+)~~
    ...                     send_cmd=${command}

    log to console  ${res}[1]
    Should Be Equal As Strings      ${res}[1]    ${qconnect}[qconnect][SerialBaseWithNewlines]

Serial Base Without Response
    connect             conn_name=${TEST_CONNECTION}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    true
    ${res} =    verify      conn_name=${TEST_CONNECTION}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(.*?)(?:\\r\\n){0,1}~~END(\\d+)~~
    ...                     send_cmd=${command}

    log to console  ${res}[1]
    Should Be Equal As Strings      ${res}[1]    ${qconnect}[qconnect][SerialBaseWithoutResponse]

Serial Base Without Response Negative Result
    connect             conn_name=${TEST_CONNECTION}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    false
    ${res} =    verify      conn_name=${TEST_CONNECTION}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(.*?)(?:\\r\\n){0,1}~~END(\\d+)~~
    ...                     send_cmd=${command}

    log to console  ${res}[1]
    Should Be Equal As Strings      ${res}[1]    ${qconnect}[qconnect][SerialBaseWithoutResponse]

Serial Base Delayed Response
    connect             conn_name=${TEST_CONNECTION}
    ...                 conn_type=SerialClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][serial]
    ${command} =    Serial Command    sleep 1; echo 1; sleep 1; echo 2; sleep 1; echo 3; sleep 1; echo 4; sleep 1; echo 5
    ${res} =    verify      conn_name=${TEST_CONNECTION}
    ...                     fetch_block=True
    ...                     eob_pattern=~~END(\\d+)~~
    ...                     search_pattern=~~START~~\\r\\n(\\d)\\r\\n(\\d)\\r\\n(\\d)\\r\\n(\\d)\\r\\n(\\d)(?:\\r\\n){0,1}~~END(\\d+)~~
    ...                     send_cmd=${command}
    ...                     timeout=15
    log to console  ${res.groups()}
    Should Be Equal As Strings      ${res.groups()}    ${qconnect}[qconnect][SerialBaseDelayedResponse]