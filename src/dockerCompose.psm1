Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function Invoke-DockerComposeCommand ($Command, $Arguments) {
    Invoke-Executable("docker-compose", $Arguments + " " + $Command)
}

function Invoke-DockerComposeCommand ($Arguments) {
    Invoke-DockerComposeCommand -Command "up" -Arguments $Arguments
}

function Invoke-DockerComposeDown ($Arguments) {
    Invoke-DockerComposeCommand -Command "down" -Arguments $Arguments
}

function Invoke-DockerComposeKill ($Arguments) {
    Invoke-DockerComposeCommand -Command "down" -Arguments $Arguments
}

Export-ModuleMember -Alias * -Function Invoke-DockerComposeCommand, Invoke-DockerComposeCommand, Invoke-DockerComposeDown, Invoke-DockerComposeKill