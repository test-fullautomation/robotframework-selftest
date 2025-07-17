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
Library    RobotFramework_TestsuitesManagement    WITH NAME    testsuites
Library    AppiumLibrary
Library    Collections
Library    Process
Library    String
Library    OperatingSystem
Suite Setup    Startup
Suite Teardown    Shutdown All Test Services
Test Teardown    Close All Applications
*** Variables ***
${run_on}                      Local Machine
${selftest_path}=              ${CURDIR}/../../../helpers/Android/SelfTest.apk
${calculator_path}=            ${CURDIR}/../../../helpers/Android/calculator.apk
${remote_url}=                 http://127.0.0.1:4723
${platform_name}=              Android
${platform_version}=           14
${automation_name}=            UiAutomator2
${app_package_tmlselftest}=    com.testfullautomation.selftest
${app_activity_tmlselftest}=   com.testfullautomation.selftest.MainActivity
${app_package_calculator}=     com.google.android.calculator
${app_activity_calculator}=    com.android.calculator2.Calculator

${checkbox1_id_locator}             id=com.testfullautomation.selftest:id/checkbox1
${checkbox1_xpath_locator}          xpath=//android.widget.CheckBox[@resource-id="com.testfullautomation.selftest:id/checkbox1"]
${seekbar_id_locator}               id=com.testfullautomation.selftest:id/seekBar
${seekbar_value_locator}            id=com.testfullautomation.selftest:id/seekVal
${register_button_locator}          id=com.testfullautomation.selftest:id/btnRegister
${firstname_text_locator}           id=com.testfullautomation.selftest:id/firstName
${lastname_text_locator}            id=com.testfullautomation.selftest:id/lastName
${userid_text_locator}              id=com.testfullautomation.selftest:id/userID
${password_text_locator}            id=com.testfullautomation.selftest:id/password
${confirm_password_text_locator}    id=com.testfullautomation.selftest:id/confirmPassword
${email_text_locator}               id=com.testfullautomation.selftest:id/email
${phone_number_text_locator}        id=com.testfullautomation.selftest:id/phone
${female_radio_locator}             id=com.testfullautomation.selftest:id/female
${male_radio_locator}               id=com.testfullautomation.selftest:id/male
${add_button_locator}               id=com.testfullautomation.selftest:id/addBtn
${project_button_locator}           id=com.testfullautomation.selftest:id/btnProject
${project_text_locator}             id=com.testfullautomation.selftest:id/inputProjectName
${add_project_button_locator}       id=com.testfullautomation.selftest:id/addProjectBtn
${gm_project_locator}               xpath=//android.widget.TextView[@resource-id="android:id/text1" and @text="GM"]
${project_5_locator}                xpath=//android.widget.TextView[@resource-id="android:id/text1" and @text="project_5"]
${project_8_locator}                xpath=//android.widget.TextView[@resource-id="android:id/text1" and @text="project_8"]
${wait_button}                      xpath=//android.widget.Button[@resource-id="android:id/aerr_wait"]

${uiautomator2_timeout}             90000
${adbExecTimeout}                   90000

${os}                OS
${robot_devtools}    robot_devtools
${android_sdk}    android_sdk

${appium_windows_path}    ${robot_devtools}/nodejs/appium.cmd
${appium_linux_path}      ${robot_devtools}/nodejs/bin/appium
${emulator}               ${robot_devtools}/Android/emulator/emulator.exe
${avd_manager}            ${robot_devtools}/Android/latest/cmdline-tools/bin/avdmanager
${adb}                    ${robot_devtools}/Android/platform-tools/adb

${appium_log}             ${CURDIR}/../../aiotestlogfiles/appium_log.txt
${avd_install_log}        ${CURDIR}/../../aiotestlogfiles/avd_install_log.txt
${emulator_log}           ${CURDIR}/../../aiotestlogfiles/emulator_log.txt
${start_avd_log}          ${CURDIR}/../../aiotestlogfiles/start_avd_log.txt
*** Test Cases ***
Verify successful opening of Android application
    [Tags]    AndroidSelfTest
    Log    Open TMLselftest application
    Open Android Application    ${app_package_tmlselftest}
    ...                         ${app_activity_tmlselftest}
    ...                         ${selftest_path}


    ${context}=    Get Contexts

    Log    The android selftest app open successfully
    Should Match    ${context}[0]    NATIVE_APP

Verify successful closure of Android Application
    [Tags]    AndroidSelfTest
    Log    Open TMLselftest application
    Open Android Application    ${app_package_tmlselftest}
    ...                         ${app_activity_tmlselftest}
    ...                         ${selftest_path}

    Close Application
    Run Keyword And Expect Error    No application is open    Get Appium SessionId

Verify successful closure of all Android applications
    [Tags]    AndroidSelfTest
    Log    Open TMLselftest application
    Open Android Application    ${app_package_tmlselftest}
    ...                         ${app_activity_tmlselftest}
    ...                         ${selftest_path}

    Sleep    15

    Log    Open Calculator application
    Open Android Application    ${app_package_calculator}
    ...                         ${app_activity_calculator}
    ...                         ${calculator_path}

    Log    Close all application
    Close All Applications
    Run Keyword And Expect Error    No application is open    Get Appium SessionId

Verify successful switching of Android application
    [Tags]    AndroidSelfTest
    Log    Open TMLselftest application
    Open Android Application    ${app_package_tmlselftest}
    ...                         ${app_activity_tmlselftest}
    ...                         ${selftest_path}
    ...                         selftest_app

    Log    Get tml selftest session
    ${session_1st}=    Get Appium SessionId

    Log    Open Caculator application
    Open Android Application    ${app_package_calculator}
    ...                         ${app_activity_calculator}
    ...                         ${calculator_path}
    ...                         calculator_app

    ${session_2nd}=    Get Appium SessionId

    Log    Switch to tml self test app
    Switch Application    selftest_app
    ${session}=    Get Appium SessionId
    Should Match    ${session_1st}    ${session}

    Log    Switch to caculator app
    Switch Application    calculator_app
    ${session}=    Get Appium SessionId
    Should Match    ${session_2nd}    ${session}

Verify failed switching of Android application
    [Tags]    AndroidSelfTest
    Log    Open TMLselftest application
    Open Android Application    ${app_package_tmlselftest}
    ...                         ${app_activity_tmlselftest}
    ...                         ${selftest_path}

    Log    Get tml selftest session
    ${session_1st}=    Get Appium SessionId

    Log    Open Caculator application
    Open Android Application    ${app_package_calculator}
    ...                         ${app_activity_calculator}
    ...                         ${calculator_path}
    ...                         calculator_app

    ${session_2nd}=    Get Appium SessionId

    Log    Switch to Non-existing application has another alias
    ${status}=    Run Keyword And Return Status    Switch Application    non-alias
    Should Be Equal    ${status}    ${False}

Verify successful execution ADB Shell command
    [Tags]    robot:skip
    Log    Open TMLselftest application
    Open Android Application    ${app_package_tmlselftest}
    ...                         ${app_activity_tmlselftest}
    ...                         ${selftest_path}

    ${output}=    Execute Adb Shell    "ls"
    Should Not Be Empty    ${output}

Verify failed execution ADB Shell command
    [Tags]    AndroidSelfTest
    Log    Open TMLselftest application
    Open Android Application    ${app_package_tmlselftest}
    ...                         ${app_activity_tmlselftest}
    ...                         ${selftest_path}

    ${status}=    Run Keyword And Return Status    Execute Adb Shell    "help"
    Should Be Equal    ${status}    ${False}

Verify android interactions
    [Tags]    AndroidSelfTest
    Log    Open TMLselftest application
    Open Android Application    ${app_package_tmlselftest}
    ...                         ${app_activity_tmlselftest}
    ...                         ${selftest_path}

    Log    Click to check the check box 1 using id

    Click Element    ${checkbox1_id_locator}
    ${is_check}=    Get Element Attribute    ${checkbox1_id_locator}    checked
    Should Be Equal    ${is_check}    true

    Log    Click to uncheck the check box 1 using xpath
    Click Element    ${checkbox1_xpath_locator}
    ${is_check}=    Get Element Attribute    ${checkbox1_xpath_locator}    checked
    Should Be Equal    ${is_check}    false

    Log    Swipe seekbar to change seek bar value
    ${begin_value}=    Get Text    ${seekbar_value_locator}
    ${bounds}=    Get Element Attribute    ${seekbar_id_locator}    bounds
    ${x}    ${y}=    Convert bounds to x and y    ${bounds}
    Swipe    ${x}    ${y}    ${500}    ${0}
    Log    Verify seekbar value changed
    ${end_value}=    Get Text    ${seekbar_value_locator}
    Should Not Match    ${begin_value}    ${end_value}

Verify appium can input text
    [Tags]    robot:skip
    Log    Open TMLselftest application
    Open Android Application    ${app_package_tmlselftest}
    ...                         ${app_activity_tmlselftest}
    ...                         ${selftest_path}

    Log    Tap 'Register button'
    Wait Until Element Is Visible    ${register_button_locator}
    Click Element    ${register_button_locator}

    Log    Fill out the form
    Wait Until Element Is Visible    ${firstname_text_locator}
    Input Text    ${firstname_text_locator}    text
    Input Text    ${lastname_text_locator}    text
    Input Text    ${userid_text_locator}    text
    Input Text    ${password_text_locator}    text
    Input Text    ${confirm_password_text_locator}    text

    Log    Verify register button enable after filling out mandatory field
    ${enabled}    Get Element Attribute    ${register_button_locator}    enabled
    Should Be Equal    ${enabled}    true

    Input Text    ${email_text_locator}    text
    Input Text    ${phone_number_text_locator}    text

    Log    Tap 'Register button'
    Click Element    ${register_button_locator}

Verify appium can hide keyboard
    [Tags]    robot:skip
    Log    Open TMLselftest application
    Open Android Application    ${app_package_tmlselftest}
    ...                         ${app_activity_tmlselftest}
    ...                         ${selftest_path}

    Log    Click on Project button
    Click Element    ${project_button_locator}

    Log    Click on add button
    Click Element    ${add_button_locator}

    Log    Click on input text
    Click Element    ${project_text_locator}

    Log    Verify the keyboard is shown
    ${result}    Is Keyboard Shown
    Should Be Equal    ${result}    ${True}

    Log    Hide keyboard
    Hide Keyboard

    ${result}    Is Keyboard Shown
    Should Be Equal    ${result}    ${False}

Verify appium can scroll to view element
    [Tags]    robot:skip
    Log    Open TMLselftest application
    Open Android Application    ${app_package_tmlselftest}
    ...                         ${app_activity_tmlselftest}
    ...                         ${selftest_path}

    Log    Click on Project button
    Click Element    ${project_button_locator}

    Log    Add 10 project into Project List
    ${project_list}=    Create projects in project list    10

    Log    Scroll to 5th in project list
    ${item}    Set Variable    ${project_list}[5]
    ${item_locator}    Set Variable    xpath=//android.widget.TextView[@resource-id='android:id/text1' and @text='${item}']
    Scroll Element Into View    ${item_locator}
    ${item}    Set Variable    ${project_list}[8]
    ${item_locator}    Set Variable    xpath=//android.widget.TextView[@resource-id='android:id/text1' and @text='${item}']
    Page Should Contain Element    ${item_locator}

    Log    Scroll up to GM project
    Scroll Up    ${gm_project_locator}
    Page Should Contain Element    ${gm_project_locator}

    Log    Scroll down to 5th in project list
    Scroll Down    ${project_5_locator}
    Page Should Contain Element    ${project_8_locator}

*** Keywords ***
Startup
    Normalize the path
    Runner info
    Start appium server
    Install AVD
    Start AVD

Runner info
    Log    Environment               console=True
    Log    OS: ${os}                 console=True
    Log    Run on: ${run_on}         console=True

Start appium server
    Log    Start appium server       console=True
    IF    '${os}' == 'Windows'
        Start Process    ${appium_windows_path}    --allow-insecure\=adb_shell    stdout=${appium_log}
    ELSE IF     '${os}' == 'Linux'
        Start Process    ${appium_linux_path}    --allow-insecure\=adb_shell     stdout=${appium_log}
    END
    Sleep    15

Install AVD
    Log    Verify the existence of AVD    console=True
    ${avd}=    Run Process    "${avd_manager}" list avd | findstr /C:"Name: my_avd" > nul    shell=True

    IF    ${avd.rc} == 1
        Log    The AVD is not exist    console=True
        Log    Install AVD    console=True
        IF    '${os}' == 'Windows'
            Run Process     "${avd_manager}" create avd -n my_avd -k "system-images;android-34;google_apis;x86_64" --force --device "pixel_xl"    stdout=${avd_install_log}    stderr=${avd_install_log}     shell=True
        ELSE IF    '${os}' == 'Linux'
            Run Process     "${avd_manager}" create avd -n my_avd -k "system-images;android-34;aosp_atd;x86_64" --force --device "pixel_xl"    stdout=${avd_install_log}    stderr=${avd_install_log}     shell=True
        END

        Sleep    5
        Run Process     "${avd_manager}" list avd    shell=True    stdout=${avd_install_log}    stderr=${avd_install_log}
    ELSE
        Log    The AVD already exists    console=True
    END


    IF    '${os}' == 'Windows'
        IF    ${avd.rc} == 1
            Log    The AVD is not exist    console=True
            Log    Install AVD    console=True
            Run Process     "${avd_manager}" create avd -n my_avd -k "system-images;android-34;google_apis;x86_64" --force --device "pixel_xl"    stdout=${avd_install_log}    stderr=${avd_install_log}     shell=True
            Sleep    5
            Run Process     "${avd_manager}" list avd    shell=True    stdout=${avd_install_log}    stderr=${avd_install_log}
        END
    ELSE IF    '${os}' == 'Linux'
        IF    ${avd.rc} == 1
            Log    The AVD is not exist    console=True
            Log    Install AVD    console=True
            Run Process     "${avd_manager}" create avd -n my_avd -k "system-images;android-34;google_apis;x86_64" --force --device "pixel_xl" --sdcard 512M    stdout=${avd_install_log}    stderr=${avd_install_log}     shell=True
            Sleep    5
            Run Process     "${avd_manager}" list avd    shell=True    stdout=${avd_install_log}    stderr=${avd_install_log}
        END
    END

Start AVD
    Log    Start AVD    console=True
    IF    '${os}' == 'Windows'
        Start Process    "${emulator}" -avd my_avd -accel auto -verbose    shell=True    stdout=${start_avd_log}    stderr=${start_avd_log}
    ELSE IF    '${os}' == 'Linux' and '${run_on}' == 'Gitlab'
        Start Process    "${emulator}" -avd my_avd -no-window -gpu swiftshader_indirect -no-snapshot -noaudio -no-boot-anim -memory 8192 -cores 6 &    shell=True    stdout=${start_avd_log}    stderr=${start_avd_log}
    END
    Sleep    500

Shutdown All Test Services
    Shutdown appium server
    Shutdown AVD

Shutdown appium server
    Log To Console    Shutdown appium server
    IF    '${os}' == 'Windows'
        Run Process    taskkill /F /IM node.exe    shell=True
    ELSE IF     '${os}' == 'Linux'
        Run Process    pkill -f appium    shell=True
    END
    Sleep    5

Shutdown AVD
    Log To Console    Shutdown AVD
    IF    '${os}' == 'Windows'
        Run Process    taskkill /F /IM qemu-system-x86_64.exe    shell=True
        Run Process    taskkill /F /IM adb.exe    shell=True
    ELSE IF     '${os}' == 'Linux'
        Run Process    pkill -f qemu    shell=True
    END
    Sleep    5

Open Android Application
    [Arguments]    ${appPackage}    ${appActivity}    ${app}    ${alias}=None
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${appPackage}
    ...                 appActivity=${appActivity}
    ...                 app=${app}
    ...                 alias=${alias}
    ...                 uiautomator2ServerLaunchTimeout=${uiautomator2_timeout}
    ...                 adbExecTimeout=${adbExecTimeout}

Normalize the path
    ${selftest_path}=          Normalize Path    ${selftest_path}
    ${calculator_path}=        Normalize Path    ${calculator_path}

    ${appium_log}=         Normalize Path    ${CURDIR}/../../aiotestlogfiles/appium_log.txt
    ${avd_install_log}=    Normalize Path    ${CURDIR}/../../aiotestlogfiles/avd_install_log.txt
    ${emulator_log}=       Normalize Path    ${CURDIR}/../../aiotestlogfiles/emulator_log.txt
    ${start_avd_log}=      Normalize Path    ${CURDIR}/../../aiotestlogfiles/start_avd_log.txt

    ${os}=                Evaluate                    platform.system()
    ${robot_devtools}=    Get Environment Variable    RobotDevtools

    Set Global Variable    ${os}
    Set Global Variable    ${robot_devtools}

    ${android_sdk}=    Normalize Path    ${robot_devtools}/Android

    ${appium_windows_path}=    Normalize Path    ${robot_devtools}/Appium.bat
    ${appium_linux_path}=      Normalize Path    ${robot_devtools}/appium


    ${emulator}=               Normalize Path    ${android_sdk}/emulator/emulator
    ${avd_manager}             Normalize Path    ${android_sdk}/cmdline-tools/latest/bin/avdmanager
    ${adb}=                    Normalize Path    ${android_sdk}/platform-tools/adb

    Set Global Variable    ${selftest_path}
    Set Global Variable    ${calculator_path}
    Set Global Variable    ${appium_log}
    Set Global Variable    ${avd_install_log}
    Set Global Variable    ${emulator_log}
    Set Global Variable    ${appium_windows_path}
    Set Global Variable    ${appium_linux_path}
    Set Global Variable    ${avd_manager}
    Set Global Variable    ${emulator}
    Set Global Variable    ${adb}

Convert bounds to x and y
    [Arguments]    ${input_string}
    ${values} =    Split String    ${input_string}    ][
    ${x_y} =    Replace String   ${values}[0]    [    ${EMPTY}
    ${xy_values} =    Split String    ${x_y}    ,
    ${x} =    Convert To Integer    ${xy_values}[0]
    ${y} =    Convert To Integer    ${xy_values}[1]
    RETURN    ${x}    ${y}

Create projects in project list
    [Arguments]    ${times}
    Log    Create ${times} project in project list
    ${list_projects}=    Create List    project_0
    Wait Until Element Is Visible    ${add_button_locator}
    FOR    ${counter}    IN RANGE    0    ${times}
        Log    Click on add button
        Click Element    ${add_button_locator}
        Wait Until Element Is Visible    ${project_text_locator}
        ${item}    Set Variable    project_${counter}
        Log    Enter project name: ${item}
        Input Text    ${project_text_locator}    ${item}
        Append To List    ${list_projects}    ${item}
        Log    Click on add project button
        Click Element    ${add_project_button_locator}
        Wait Until Page Does Not Contain Element    ${add_project_button_locator}
    END
    RETURN   ${list_projects}
