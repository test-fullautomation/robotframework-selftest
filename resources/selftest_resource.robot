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
Library     SelfTestHelper.py

*** Variables ***
${ALL_VARIABLES}=           Get Variables
${TIMEOUT_ERROR}=           Unable to match the pattern after '5' time.
${NOT_CONNECT_ERROR}=       The 'NOT_CONNECTED' connection ${SPACE}hasn't been established. Please connect first.
${FAIL_CONNECT_ERROR}=      Unable to create connection. Exception: Not possible to connect.
${EXISTING_CONNECT_ERROR}=  The connection name '${CONNECTION_NAME}' has already existed! Please use other name
${FAIL_AUTH_ERROR}=         Unable to create connection. Exception: Not possible to connect. Reason: 'Authentication failed.'

*** Keywords ***
Variable Is Not Defined
    [Arguments]     ${variablename}
    [Documentation]     Check if the variable is not defined
    Should not be true      "\${${variablename}}" in $ALL_VARIABLES

