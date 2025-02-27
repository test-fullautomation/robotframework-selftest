@echo off

REM UIAutomator2 driver need to find adb to be able to connect to the device
set path=%path%;
set ANDROID_HOME=%RobotDevtools%\Android
set APPIUM_HOME=%RobotNodeJS%

start /b "Appium" "%RobotNodeJS%\appium" --allow-insecure=adb_shell --log D:\work\robot_fw_AIO_full\robotframework-selftest\testcases\aiotestlogfiles\aiotestlogfile_appium.log
@echo on