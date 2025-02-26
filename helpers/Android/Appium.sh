#!/bin/bash

# UIAutomator2 driver needs to find adb to be able to connect to the device
export PATH="$PATH:"
export ANDROID_HOME="$RobotDevtools/Android"
export APPIUM_HOME="$RobotNodeJS"

# Start Appium in the background and redirect logs
"$RobotAppium/appium" --allow-insecure=adb_shell --log "/home/runner/work/RobotFramework_AIO/robotframework-selftest/testcases/aiotestlogfiles/aiotestlogfiles\aiotestlogfile_appium.log" &