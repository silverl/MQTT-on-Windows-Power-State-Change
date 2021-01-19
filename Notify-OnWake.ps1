Add-Type -Path "C:\lib\M2Mqtt.4.3.0.0\lib\net45\M2Mqtt.Net.dll"

$maxretries = 20
$retries = 0
while (($retries -lt $maxretries) -and ((Test-NetConnection $ENV:MQTT_HOST -Port $ENV:MQTT_PORT).TcpTestSucceeded -eq $false))
{
    Write-Output "waiting..."
    # Don't need to sleep because a failing Test-NetConnection call takes about two seconds.
    $retries = $retries + 1
}

$MqttClient = [uPLibrary.Networking.M2Mqtt.MqttClient]($ENV:MQTT_HOST)

# Connect with username and password.
$mqttclient.Connect([guid]::NewGuid(), $ENV:MQTT_USERNAME, $ENV:MQTT_PWD) | Out-Null

# Publish a message that this computer is awake.
$MqttClient.Publish("windows/wakeup", [System.Text.Encoding]::UTF8.GetBytes("ON")) | Out-Null
exit 0