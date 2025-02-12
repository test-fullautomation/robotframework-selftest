@echo off

set AVD=%RobotDevtools%\Android\tools\bin
set AVD_NAME=my_avd

REM Check if AVD exists
"%AVD%\avdmanager" list avd | findstr /C:"Name: %AVD_NAME%" > nul
if errorlevel 1 (
    REM AVD does not exist, create it
	"%AVD%\sdkmanager" "system-images;android-31;google_apis_playstore;x86_64"
    start Install AVD "%AVD%\avdmanager" create avd -n %AVD_NAME% -k "system-images;android-31;google_apis_playstore;x86_64" --force --device "pixel_xl"
)

@echo on
