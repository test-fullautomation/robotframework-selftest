@echo on

set path=%path%;
set ANDROID_HOME=%RobotDevtools%/Android
set EMULATOR=%RobotDevtools%/Android/tools
set ANDROID_SDK_ROOT=%USERPROFILE%/AppData/Local/Android/Sdk

REM Start the emulator
start /min "Start Emulator" "%EMULATOR%/emulator" -avd my_avd -accel on -gpu auto -no-snapshot-load -wipe-data -memory 4096 -cores 4 -no-window -no-boot-anim
