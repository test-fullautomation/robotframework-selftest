@echo on

REM UIAutomator2 driver need to find adb to be able to connect to the device
echo %CD%
set path=%path%;
set ANDROID_HOME=%RobotDevtools%\Android
set APPIUM_HOME=%RobotNodeJS%

start "Appium" "%RobotAppium%\appium" --allow-insecure=adb_shell --log D:\a\RobotFramework_AIO\robotframework-selftest\testcases\aiotestlogfiles\appium.log
@echo on