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
Library     RobotFramework_TestsuitesManagement    WITH NAME    testsuites
Library     QConnectBase.ConnectionManager
Library     Collections
Library     OperatingSystem
Suite Setup      SSH Client Setup
Test Teardown    Release Test Environment

*** Keywords ***
Release Test Environment
    Log To Console  \nDisconnecting from ${CONNECTION_NAME}
    disconnect  ${CONNECTION_NAME}

SSH Client Setup
    testsuites.testsuite_setup    ../../../../config/testsuites_config.json
    Skip If    not ${__TESTBENCH__CONFIG}[sw][has_ssh]    Skip SSH suite

Copy Public Keys To Target
    [Arguments]        @{key_files}
    [Documentation]    Copy Public Keys To Target
    Log    \nCopy keyfiles to target    console=True
    # ssh to target for backup authorized_keys file
    connect             conn_name=${CONNECTION_NAME}_copy_key
    ...                 conn_type=SSHClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][SSH]

    # Log    Waiting for initializing ssh session completely...    console=True
    # ${res}=     verify  conn_name=${CONNECTION_NAME}
    # ...                 search_pattern=(Hi)
    # ...                 send_cmd=echo Hi
    # ...                 timeout=10

    ${status}    ${ret val} =    Run Keyword And Ignore Error    verify          
    ...             conn_name=${CONNECTION_NAME}_copy_key
    ...             search_pattern=(File: '(.*)'$)
    ...             send_cmd=stat ~/.ssh/authorized_keys
    ...             timeout=10

    IF  "${status}"=="PASS"
        Log    Backup current authorized_keys file    console=True
        ${existence_authorized_keys}=     Set Variable     ${True}
        
        send command        conn_name=${CONNECTION_NAME}_copy_key
        ...                 command=mv ~/.ssh/authorized_keys ~/.ssh/${backup_keys_filename}
    ELSE
        Log    Create new authorized_keys file    console=True
        send command        conn_name=${CONNECTION_NAME}_copy_key
        ...                 command=mkdir ~/.ssh

        verify          conn_name=${CONNECTION_NAME}_copy_key
        ...             search_pattern=(DoneCreateKeyFile)
        ...             send_cmd=touch ~/.ssh/authorized_keys && echo DoneCreateKeyFile
        ...             timeout=10
    END

    # append public keys to authorized_keys file
    FOR    ${key_file}    IN    @{key_files}
        Log    Append key file ${key_file} to authorized_keys   console=True
        ${key_content}  Get File    ${key_file}
        Log    ${key_content}    console=True
        verify          conn_name=${CONNECTION_NAME}_copy_key
        ...             search_pattern=(DoneCopyKey)
        ...             send_cmd=echo ${key_content.strip()} >> ~/.ssh/authorized_keys && echo DoneCopyKey
        ...             timeout=10
        
    END

    Log    Chmod authorized_keys file to 600    console=True
    verify              conn_name=${CONNECTION_NAME}_copy_key
    ...                 search_pattern=(DoneChmod)
    ...                 send_cmd=chmod 600 ~/.ssh/authorized_keys && echo DoneChmod
    ...                 timeout=10


    disconnect  ${CONNECTION_NAME}_copy_key

Reset Authorized Keys File
    connect             conn_name=${CONNECTION_NAME}_reset_key
    ...                 conn_type=SSHClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][SSH]

    verify              conn_name=${CONNECTION_NAME}_reset_key
    ...                 search_pattern=(DoneRmKey)
    ...                 send_cmd=rm ~/.ssh/authorized_keys && echo DoneRmKey
    ...                 timeout=10

    IF  ${existence_authorized_keys}
        Log    Restore authorized_keys file    console=True
        verify              conn_name=${CONNECTION_NAME}_reset_key
        ...                 search_pattern=(^DoneResetKeyasdas$)
        ...                 send_cmd=mv ~/.ssh/${backup_keys_filename} ~/.ssh/authorized_keys && echo DoneResetKey
        ...                 timeout=10
    END
    disconnect  ${CONNECTION_NAME}_reset_key

    Release Test Environment
    
*** Variables ***
${CONNECTION_NAME}          SSH_CONNECTION
${keyfile_withoutpwd}       ../../../../config/ssh/id_rsa_nopwd.pub
${keyfile_withpwd}          ../../../../config/ssh/id_rsa_passwdkey.pub
${pwd_keyfile}              tmlselftestpasswdkey
${backup_keys_filename}     zzz_authorized_keys_bk
${existence_authorized_keys}     ${False}

*** Test Cases ***
SSH connect with password authentication
    [Documentation]     Connect SSH base.
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SSHClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][SSH]
    Log To Console      \nConnect to ${CONNECTION_NAME} successfully!

SSH connect with password authentication fail
    ${ssh_wrong_pw}=    Copy Dictionary   ${__TESTBENCH__CONFIG}[hw][internal][SSH]   deep_copy=True
    Set To Dictionary   ${ssh_wrong_pw}  password=wrong_pw 

    Run Keyword And Expect Error    ${FAIL_AUTH_ERROR}
    ...                             connect             conn_name=${CONNECTION_NAME}
    ...                             conn_type=SSHClient
    ...                             conn_conf=${ssh_wrong_pw}

SSH connect with keyfile authentication
    [Teardown]    Reset Authorized Keys File
    Copy Public Keys To Target    ${keyfile_withoutpwd}
    ${ssh_auth_keyfile}=    Copy Dictionary   ${__TESTBENCH__CONFIG}[hw][internal][SSH]   deep_copy=True
    Set To Dictionary   ${ssh_auth_keyfile}  authentication=keyfile

    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SSHClient
    ...                 conn_conf=${ssh_auth_keyfile}
    Log To Console      \nConnect to ${CONNECTION_NAME} successfully!

    ${res}=     verify  conn_name=${CONNECTION_NAME}
    ...                 search_pattern=(Linux .*)
    ...                 send_cmd=uname -a
    ...                 timeout=10

    Log To Console      ${res}[1]
    # Reset Authorized Keys File
    
SSH connect with password and keyfile authentication
    [Teardown]    Reset Authorized Keys File
    Copy Public Keys To Target    ${keyfile_withpwd}
    ${ssh_auth_passwordkeyfile}=    Copy Dictionary   ${__TESTBENCH__CONFIG}[hw][internal][SSH]   deep_copy=True
    Set To Dictionary   ${ssh_auth_passwordkeyfile}  authentication=passwordkeyfile
    Set To Dictionary   ${ssh_auth_passwordkeyfile}  key_filename=${keyfile_withpwd.replace(".pub", "")}
    Set To Dictionary   ${ssh_auth_passwordkeyfile}  password=${pwd_keyfile}

    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SSHClient
    ...                 conn_conf=${ssh_auth_passwordkeyfile}
    Log To Console      \nConnect to ${CONNECTION_NAME} successfully!

    ${res}=     verify  conn_name=${CONNECTION_NAME}
    ...                 search_pattern=(Linux .*)
    ...                 send_cmd=uname -a
    ...                 timeout=10

    Log To Console      ${res}[1]

SSH send command
    [Documentation]     Connect SSH base.
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SSHClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][SSH]
    Log To Console      \nConnect to ${CONNECTION_NAME} successfully!

    send command        conn_name=${CONNECTION_NAME}
    ...                 command=uname -a

SSH verify response
    [Documentation]     Connect SSH base.
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SSHClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][SSH]
    Log To Console      \nConnect to ${CONNECTION_NAME} successfully!

    ${res}=     verify  conn_name=${CONNECTION_NAME}
    ...                 search_pattern=(Linux .*)
    ...                 send_cmd=uname -a
    ...                 timeout=10

    Log To Console      ${res}[1]

SSH verify delayed response with fetch_block
    [Documentation]     Connect SSH base.
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SSHClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][SSH]
    Log To Console      \nConnect to ${CONNECTION_NAME} successfully!

    ${res}=     verify  conn_name=${CONNECTION_NAME}
    ...                 fetch_block=True
    ...                 eob_pattern=~~END(\\d+)~~
    ...                 search_pattern=~~START~~\\r\\n(\\d)\\r\\n(\\d)\\r\\n(\\d)\\r\\n(\\d)\\r\\n(\\d)(?:\\r\\n)?~~END(\\d+)~~
    ...                 send_cmd=echo ~~START~~;sleep 1; echo 1; sleep 1; echo 2; sleep 1; echo 3; sleep 1; echo 4; sleep 1; echo 5;echo ~~END$?~~
    ...                 timeout=15

    Log To Console      ${res}

SSH independent parallel sessions
    [Documentation]     Connect SSH base.
    connect             conn_name=${CONNECTION_NAME}
    ...                 conn_type=SSHClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][SSH]
    Log To Console      \nConnect to ${CONNECTION_NAME} successfully!

    connect             conn_name=${CONNECTION_NAME}__second_session
    ...                 conn_type=SSHClient
    ...                 conn_conf=${__TESTBENCH__CONFIG}[hw][internal][SSH]
    Log To Console      \nConnect to ${CONNECTION_NAME}__second_session successfully!

    Sleep               2 seconds
    send command        conn_name=${CONNECTION_NAME}
    ...                 command=cd /

    send command        conn_name=${CONNECTION_NAME}__second_session
    ...                 command=cd ~

    ${res_1}=     verify  conn_name=${CONNECTION_NAME}
    ...                 search_pattern=(/$)
    ...                 send_cmd=pwd

    Log To Console      ${res_1}[1]

    ${res_2}=     verify  conn_name=${CONNECTION_NAME}__second_session
    ...                 search_pattern=(/home/.*)
    ...                 send_cmd=pwd

    Log To Console      ${res_2}[1]

