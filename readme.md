# Notify-OnWake Powershell Script

## About

On Windows, this script can be called from a Task Scheduler job to send a message to MQTT. I use this to communicate with Home Assistant that my PC has woken up.

## Prerequisites

### M2Mqtt Nuget Library

Thanks to Alexander Gruber at https://jackgruber.github.io/2019-06-05-ps-mqtt/ for his sharing how to use the M2Mqtt nuget library.

Download the M2Mqtt library manually, or by nuget.exe. The nuget.exe can be downlaoded here.

`nuget.exe install M2Mqtt -o c:\lib`

In Powershell, the DLL can then be included via Add-Type -Path "C:\lib\M2Mqtt.4.3.0.0\lib\net45\M2Mqtt.Net.dll" so that the contained classes can be used.

### Set Environment Variables

If your MQTT requires username and password as mine does, then set up the following environment variables with the appropriate values: `MQTT_USERNAME` and `MQTT_PWD`


## Create Task Scheduler Job

Create a Windows Task Scheduler job with the following properties:

### General

Run whether user is logged on or not.

Running as SYSTEM or running with elevated privileges is not necessary.

### Triggers

Create a trigger to begin the task "On an event"

Log: System

Source: Power-Troubleshooter (be careful, there may be 2 of these in the list. If one doesn't work, try the other.)

Event ID: 1

### Actions

Action: Start a program

Program/script: `powershell.exe`

Arguments: `-ExecutionPolicy Bypass –NoProfile –Command "& {C:\Code\NotifyOnWake\Notify-OnWake.ps1; exit $LastExitCode}" > C:\code\NotifyOnWake\out.log`

This structure for running scheduled tasks is what I've found works well to get the scripts last exit code reported back to Task Scheduler. Using powershell.exe's `-File` argument results in powershell.exe's exit code to be reported, not the script.

### Settings

Check: Stop the task if it runs longer than 1 hour.

Shouldn't be necessary since the script has a number of retries embedded, but just in case...
