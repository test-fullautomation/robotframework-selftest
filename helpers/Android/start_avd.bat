@echo off

set path=%path%;
set ANDROID_HOME=%RobotDevtools%\Android
set EMULATOR=%RobotDevtools%\Android\tools

REM Start the emulator
start "Start Emulator" "%EMULATOR%"\emulator\emulator -avd my_avd -no-snapshot-load

@echo on