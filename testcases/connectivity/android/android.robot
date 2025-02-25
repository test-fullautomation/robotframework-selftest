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
Suite Teardown    Close All Apps
*** Variables ***
${selftest_path}=            ${CURDIR}/../../../helpers/Android/Selftest.apk
${calculator_path}=          ${CURDIR}/../../../helpers/Android/calculator.apk
${appium_server_command}=      cmd.exe /c "$env:APPIUM_HOME\appium" --relaxed-security
${remote_url}=                 http://127.0.0.1:4723
${platform_name}=              Android
${platform_version}=           14
${automation_name}=            UiAutomator2
${app_package_tmlselftest}=    com.testfullautomation.selftest
${app_activity_tmlselftest}=   com.testfullautomation.selftest.MainActivity
${app_package_calculator}=     com.google.android.calculator
${app_activity_calculator}=    com.android.calculator2.Calculator

${checkbox1_id_locator}    id=com.testfullautomation.selftest:id/checkbox1
${checkbox1_xpath_locator}    xpath=//android.widget.CheckBox[@resource-id="com.testfullautomation.selftest:id/checkbox1"]
${seekbar_id_locator}    id=com.testfullautomation.selftest:id/seekBar
${seekbar_value_locator}    id=com.testfullautomation.selftest:id/seekVal
${register_button_locator}    id=com.testfullautomation.selftest:id/btnRegister
${firstname_text_locator}    id=com.testfullautomation.selftest:id/firstName
${lastname_text_locator}    id=com.testfullautomation.selftest:id/lastName
${userid_text_locator}    id=com.testfullautomation.selftest:id/userID
${password_text_locator}    id=com.testfullautomation.selftest:id/password
${confirm_password_text_locator}    id=com.testfullautomation.selftest:id/confirmPassword
${email_text_locator}    id=com.testfullautomation.selftest:id/email
${phone_number_text_locator}    id=com.testfullautomation.selftest:id/phone
${female_radio_locator}    id=com.testfullautomation.selftest:id/female
${male_radio_locator}    id=com.testfullautomation.selftest:id/male
${add_button_locator}    id=com.testfullautomation.selftest:id/addBtn
${project_button_locator}    id=com.testfullautomation.selftest:id/btnProject
${project_text_locator}    id=com.testfullautomation.selftest:id/inputProjectName
${add_project_button_locator}    id=com.testfullautomation.selftest:id/addProjectBtn
${gm_project_locator}    xpath=//android.widget.TextView[@resource-id="android:id/text1" and @text="GM"]
${project_5_locator}    xpath=xpath=//android.widget.TextView[@resource-id="android:id/text1" and @text="project_5"]
${project_8_locator}    xpath=xpath=//android.widget.TextView[@resource-id="android:id/text1" and @text="project_8"]
*** Test Cases ***
Verify successful opening of Android application
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 appActivity=${app_activity_tmlselftest}
    ...                 app=${selftest_path}
    ...                 platformVersion=${platform_version}

    ${context}=    Get Contexts

    Log    The android selftest app open successfully
    Should Match    ${context}[0]    NATIVE_APP

Verify successful closure of Android Application
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 appActivity=${app_activity_tmlselftest}
    ...                 app=${selftest_path}
    ...                 platformVersion=${platform_version}

    Close Application
    Run Keyword And Expect Error    No application is open    Get Appium SessionId

Verify successful closure of all Android applications
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 appActivity=${app_activity_tmlselftest}
    ...                 app=${selftest_path}
    ...                 platformVersion=${platform_version}

    Log    Open Caculator application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_calculator}
    ...                 appActivity=${app_activity_calculator}
    ...                 app=${calculator_path}
    ...                 platformVersion=${platform_version}

    Log    Close all application
    Close All Applications
    Run Keyword And Expect Error    No application is open    Get Appium SessionId

Verify successful switching of Android application
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 appActivity=${app_activity_tmlselftest}
    ...                 app=${selftest_path}
    ...                 platformVersion=${platform_version}
    ...                 alias=selftest_app
    Log    Get tml selftest session
    ${session_1st}=    Get Appium SessionId

    Log    Open Caculator application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_calculator}
    ...                 appActivity=${app_activity_calculator}
    ...                 app=${calculator_path}
    ...                 platformVersion=${platform_version}
    ...                 alias=calculator_app
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
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 appActivity=${app_activity_tmlselftest}
    ...                 app=${selftest_path}
    ...                 platformVersion=${platform_version}

    Log    Get tml selftest session
    ${session_1st}=    Get Appium SessionId

    Log    Open Caculator application
    Open Application    remote_url=${remote_url}
    ...                 alias=calculator_app
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_calculator}
    ...                 appActivity=${app_activity_calculator}
    ...                 app=${calculator_path}
    ...                 platformVersion=${platform_version}

    ${session_2nd}=    Get Appium SessionId

    Log    Switch to Non-existing application has another alias
    ${status}=    Run Keyword And Return Status    Switch Application    non-alias
    Should Be Equal    ${status}    ${False}

Verify successful execution ADB Shell command
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 appActivity=${app_activity_tmlselftest}
    ...                 app=${selftest_path}
    ...                 platformVersion=${platform_version}

    ${output}=    Execute Adb Shell    "ls"
    Should Not Be Empty    ${output}

Verify failed execution ADB Shell command
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 appActivity=${app_activity_tmlselftest}
    ...                 app=${selftest_path}
    ...                 platformVersion=${platform_version}

    ${status}=    Run Keyword And Return Status    Execute Adb Shell    "help"
    Should Be Equal    ${status}    ${False}
    Close All Applications

Verify android interactions
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 appActivity=${app_activity_tmlselftest}
    ...                 app=${selftest_path}
    ...                 platformVersion=${platform_version}

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
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 appActivity=${app_activity_tmlselftest}
    ...                 app=${selftest_path}
    ...                 platformVersion=${platform_version}

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
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 appActivity=${app_activity_tmlselftest}
    ...                 app=${selftest_path}
    ...                 platformVersion=${platform_version}

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
    Close All Applications

Verify appium can scroll to view element
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 appActivity=${app_activity_tmlselftest}
    ...                 app=${selftest_path}
    ...                 platformVersion=${platform_version}

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
    Start appium server
    Install AVD
    Start AVD

Start appium server
    Log    Start appium server
    Start Process    cmd.exe /c "${CURDIR}/../../../helpers/Android/Appium.bat"    shell=True
    Sleep    15

Install AVD
    Log     Install avd
    Start Process    cmd.exe /c "${CURDIR}/../../../helpers/Android/install_avd.bat"    shell=True
    Sleep    5

Start AVD
    Log    Start AVD
    Start Process    cmd.exe /c "${CURDIR}/../../../helpers/Android/start_avd.bat"    shell=True
    Sleep    60

Close All Apps
    Close appium server
    Close AVD

Close appium server
    Log To Console    Close appium server
    Run Process    cmd.exe /c taskkill /F /IM node.exe    shell=True
    Sleep    5

Close AVD
    Log To Console    Close AVD
    Run Process    cmd.exe /c taskkill /F /IM qemu-system-x86_64.exe    shell=True
    Run Process    cmd.exe /c taskkill /F /IM emulator.exe    shell=True
    Sleep    5

Convert bounds to x and y
    [Arguments]    ${input_string}
    ${values} =    Split String    ${input_string}    ][
    ${x_y} =    Replace String   ${values}[0]    [    ${EMPTY}
    ${xy_values} =    Split String    ${x_y}    ,
    ${x} =    Convert To Integer    ${xy_values}[0]
    ${y} =    Convert To Integer    ${xy_values}[1]
    [Return]    ${x}    ${y}

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
    [Return]   ${list_projects}
