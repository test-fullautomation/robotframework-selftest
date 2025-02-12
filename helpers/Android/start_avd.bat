@echo off

set path=%path%;
set ANDROID_HOME=%RobotDevtools%\Android
set EMULATOR=%RobotDevtools%\Android\tools
set ANDROID_SDK_ROOT=%USERPROFILE%\AppData\Local\Android\Sdk

REM Start the emulator
start "Start Emulator" "%EMULATOR%\emulator" -avd my_avd -no-snapshot-load

@echo on
