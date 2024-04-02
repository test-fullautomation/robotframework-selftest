*** Settings ***
Library    RobotFramework_TestsuitesManagement    WITH NAME    testsuites
Library    AppiumLibrary
Library    Collections
Library    Process
Library    String
# Suite Setup    Start appium server
# Suite Teardown    Close appium server
*** Variables ***
${appium_server_command}=      cmd.exe /c "$env:APPIUM_HOME\appium" --relaxed-security
${remote_url}=                 http://127.0.0.1:4723
${platform_name}=              Android
${platform_version}=           11
${automation_name}=            UiAutomator2
${app_package_tmlselftest}=    com.example.ntd1hc.tmlselftest
${app_activity_tmlselftest}=   com.example.ntd1hc.tmlselftest.MainActivity
${app_package_calculator}=     com.oneplus.calculator
${app_activity_calculator}=    com.oneplus.calculator.Calculator

${checkbox1_id_locator}    id=com.example.ntd1hc.tmlselftest:id/checkbox1
${checkbox1_xpath_locator}    xpath=//android.widget.CheckBox[@resource-id="com.example.ntd1hc.tmlselftest:id/checkbox1"]
${seekbar_id_locator}    id=com.example.ntd1hc.tmlselftest:id/seekBar
${seekbar_value_locator}    id=com.example.ntd1hc.tmlselftest:id/seekVal
*** Test Cases ***
Verify successful opening of Android application
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 platformVersion=${platform_version}
    ...                 appActivity=${app_activity_tmlselftest}

    ${context}=    Get Contexts

    Log    The android selftest app open successfully
    Should Match    ${context}[0]    NATIVE_APP

Verify successful closure of Android Application
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 platformVersion=${platform_version}
    ...                 appActivity=${app_activity_tmlselftest}

    Close Application
    Run Keyword And Expect Error    No application is open    Get Appium SessionId

Verify successful closure of all Android applications
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 platformVersion=${platform_version}
    ...                 appActivity=${app_activity_tmlselftest}

    Log    Open Caculator application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_calculator}
    ...                 platformVersion=${platform_version}
    ...                 appActivity=${app_activity_calculator}

    Log    Close all application
    Close All Applications
    Run Keyword And Expect Error    No application is open    Get Appium SessionId

Verify successful switching of Android application
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 platformVersion=${platform_version}
    ...                 appActivity=${app_activity_tmlselftest}
    ...                 alias=selftest_app
    Log    Get tml selftest session
    ${session_1st}=    Get Appium SessionId

    Log    Open Caculator application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_calculator}
    ...                 platformVersion=${platform_version}
    ...                 appActivity=${app_activity_calculator}
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
    ...                 alias=selftest_app
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 platformVersion=${platform_version}
    ...                 appActivity=${app_activity_tmlselftest}

    Log    Get tml selftest session
    ${session_1st}=    Get Appium SessionId

    Log    Open Caculator application
    Open Application    remote_url=${remote_url}
    ...                 alias=calculator_app
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_calculator}
    ...                 platformVersion=${platform_version}
    ...                 appActivity=${app_activity_calculator}

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
    ...                 platformVersion=${platform_version}
    ...                 appActivity=${app_activity_tmlselftest}

    ${output}=    Execute Adb Shell    "ls"
    Should Not Be Empty    ${output}

Verify failed execution ADB Shell command
    Log    Open TMLselftest application
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 platformVersion=${platform_version}
    ...                 appActivity=${app_activity_tmlselftest}

    ${status}=    Run Keyword And Return Status    Execute Adb Shell    "help"
    Should Be Equal    ${status}    ${False}

Verify android interactions
    Log    message
    Open Application    remote_url=${remote_url}
    ...                 platformName=${platform_name}
    ...                 automationName=${automation_name}
    ...                 appPackage=${app_package_tmlselftest}
    ...                 platformVersion=${platform_version}
    ...                 appActivity=${app_activity_tmlselftest}

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

*** Keywords ***
Start appium server
    Log To Console    Start appium server
    ${process}=    Start Process    cmd.exe /c "C:/Program Files/RobotFramework/devtools/Appium.bat"    shell=True    alias=appium
    Log To Console    ${process.pid}
    Sleep    10
    Start Process    cmd.exe /c "taskkill /F /PID ${process.pid}"    shell=True

Close appium server
    Log To Console    Close appium server
    Sleep    5
    terminate_all_processes    kill=True

Convert bounds to x and y
    [Arguments]    ${input_string}
    # ${cleaned_string} =    Replace String    ${input_string}    ,    .
    ${values} =    Split String    ${input_string}    ][
    ${x_y} =    Replace String   ${values}[0]    [    ${EMPTY}
    ${xy_values} =    Split String    ${x_y}    ,
    ${x} =    Convert To Integer    ${xy_values}[0]
    ${y} =    Convert To Integer    ${xy_values}[1]
    [Return]    ${x}    ${y}
