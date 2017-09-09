Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function Invoke-DockerCommand ($Command, $Arguments) {
    Invoke-Executable("docker", $Command + " " + $Arguments)
}

function Invoke-DockerPs($Arguments) {
    Invoke-DockerCommand -Command "ps" -Arguments $Arguments
}

function Invoke-DockerInspect($Arguments) {
    Invoke-DockerCommand -Command "inspect" -Arguments $Arguments
}