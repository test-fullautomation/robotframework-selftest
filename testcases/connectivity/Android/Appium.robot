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
Documentation  This is selftest for Android Appium

Library          AppiumLibrary
Library          Process

Suite Setup     Android Appium Setup
Suite Teardown  Android Appium Teardown

*** Variables ***
# ${MY_APPIUM_FOLDER}    D:/trash/RobotFramework/devtools/node_modules/.bin
${MY_APPIUM_FOLDER}    %RobotAppium%
${APPIUM_SERVER_COMMAND}    ${MY_APPIUM_FOLDER}/appium
${APPIUM_SERVER_PROCESS}    ${Empty}

*** Keywords ***
Android Appium Setup
   [Documentation]    Start the Appium server
   ${APPIUM_SERVER_PROCESS}=    Start Process    cmd     /C    ${APPIUM_SERVER_COMMAND}    >    appium.log
   Sleep    10s
   Log    stdout: ${APPIUM_SERVER_PROCESS.stdout}    console=${True}
   Log    Appium process: ${APPIUM_SERVER_PROCESS.pid}    console=${True}
   Set Suite Variable    ${APPIUM_SERVER_PROCESS}
   # Wait For Process    ${APPIUM_SERVER_PROCESS}
   # Log    Appium process: ${APPIUM_SERVER_PROCESS.pid}    console=${True}

Android Appium Teardown
   [Documentation]    Stop the Appium server
   Terminate Process    ${APPIUM_SERVER_PROCESS}

*** Test Cases ***
Check Calculator App
   Open Application    http://127.0.0.1:4723
   ...    deviceName=emulator-5554
   ...    platformName=Android
   ...    platformVersion=12
   ...    appPackage=com.google.android.calculator
   ...    appActivity=com.android.calculator2.Calculator    
   ...    automationName=UIAutomator2
    
   ${Current_act}=    Get Activity
   Log    ${Current_act}    console=${True}

   Click Element    id=com.google.android.calculator:id/digit_7
   Click Element    id=com.google.android.calculator:id/digit_1
   Click Element    id=com.google.android.calculator:id/digit_7
   Click Element    id=com.google.android.calculator:id/op_add
   Click Element    id=com.google.android.calculator:id/digit_3
   Click Element    id=com.google.android.calculator:id/eq

   ${result}=    Get Element Attribute   id=com.google.android.calculator:id/result_final    text

   Log    \nCalculation result: ${result}    console=${True}