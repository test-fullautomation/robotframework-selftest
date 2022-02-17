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
Documentation     Simple example using SerialPort.
Library           SerialLibrary         encoding=ascii

*** Variables ***
${END_STR0}  ~~END0~~
${END_STR1}  ~~END1~~


*** Test Cases ***
Serial Base
    [Setup]     Open Serial Port
    [Teardown]  Delete All Ports
    ${command} =    Serial Command    echo 1; echo 2; echo 3; echo 4; echo 5
    Write Data   ${command}
    ${read} =    Read Until
    ${read} =    Read Until     ${END_STR0}
    Log   ${read}

*** Test Cases ***
Serial Base Semicolon
    [Setup]     Open Serial Port
    [Teardown]  Delete All Ports
    ${command} =    Serial Command    echo 1; echo 2; echo 3; echo 4; echo 5
    Write Data   ${command}
    ${read} =    Read Until
    ${read} =    Read Until     ${END_STR0}
    Log   ${read}

*** Test Cases ***
Serial Base New lines
    [Setup]     Open Serial Port
    [Teardown]  Delete All Ports
    ${command} =    Serial Command    echo; echo; echo 1; echo 2; echo 3; echo 4; echo 5; echo; echo
    Write Data   ${command}
    ${read} =    Read Until
    ${read} =    Read Until     ${END_STR0}
    Log   ${read}

*** Test Cases ***
Serial Base New lines Semicolon
    [Setup]     Open Serial Port
    [Teardown]  Delete All Ports
    ${command} =    Serial Command    echo; echo; echo 1; echo 2; echo 3; echo 4; echo 5; echo; echo
    Write Data   ${command}
    ${read} =    Read Until
    ${read} =    Read Until     ${END_STR0}
    Log   ${read}

*** Test Cases ***
Serial Base withoput response
    [Setup]     Open Serial Port
    [Teardown]  Delete All Ports
    ${command} =    Serial Command    true
    Write Data   ${command}
    ${read} =    Read Until
    ${read} =    Read Until     ${END_STR0}
    Should Contain     ${read}  ${EMPTY}
    ${matches} =	   Should Match Regexp     ${read}     ~~START~~\\r\n(.*?)(?:\\r\\n){0,1}~~END(\\d+)~~
    FOR    ${group}    IN    ${matches[1:]}
        Log    ${group}
    END

*** Test Cases ***
Serial Base withoput response negative result
    [Setup]     Open Serial Port
    [Teardown]  Delete All Ports
    ${command} =    Serial Command    false
    Write Data   ${command}
    ${read} =    Read Until
    ${read} =    Read Until     ${END_STR1}  timeout=10
    ${matches} =	   Should Match Regexp     ${read}     ~~START~~\\r\n(.*?)(?:\\r\\n){0,1}~~END(\\d+)~~
    FOR    ${group}    IN    ${matches[1:]}
        Log    ${group}
    END

*** Test Cases ***
Serial Base delayed response
    [Setup]     Open Serial Port
    [Teardown]  Delete All Ports
    ${command} =    Serial Command    sleep 1; echo 1; sleep 1; echo 2; sleep 1; echo 3; sleep 1; echo 4; sleep 1; echo 5
    Write Data   ${command}
    ${read} =    Read Until
    ${read} =    Read Until     ${END_STR0}     timeout=10
    ${matches} =	   Should Match Regexp     ${read}     (\\d)\\r\\n(\\d)\\r\\n(\\d)\\r\\n(\\d)\\r\\n(\\d)
    FOR    ${group}    IN    ${matches[1:]}
        Log    ${group}
    END


*** Keywords ***
Open Serial Port
     Add Port   COM11
    ...        baudrate=115200
    ...        bytesize=8
    ...        parity=N
    ...        stopbits=1
    ...        timeout=999

Serial Command
  [Arguments]  ${input}
  ${string}=  set variable  echo ~~START~~;${input};echo ~~END$?~~\r
  [Return]  ${string}

