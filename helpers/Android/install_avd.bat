@echo on

set AVD=%RobotDevtools%\Android\tools\bin
set AVD_NAME=my_avd
set AEHD=%RobotDevtools%\Android\aehd-windows

REM Check if AVD exists
"%AVD%\avdmanager" list avd | findstr /C:"Name: %AVD_NAME%" > nul
if errorlevel 1 (
    REM AVD does not exist, create it
    "%AEHD%\silent_install.bat"
    "%AVD%\avdmanager" create avd -n my_avd -k "system-images;android-34;google_apis;x86_64" --force --device "pixel_xl"
)
