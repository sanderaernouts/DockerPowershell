Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function Invoke-DockerCommand ($Command, $Arguments, [switch]$WhatIf) {
    Invoke-Executable -Executable "docker" -Arguments "$Command $Arguments" -WhatIf:$WhatIf
}

function Invoke-DockerPs($Arguments, [switch]$WhatIf) {
    Invoke-DockerCommand -Command "ps" -Arguments $Arguments -WhatIf:$WhatIf
}

function Invoke-DockerInspect($Arguments, [switch]$WhatIf) {
    Invoke-DockerCommand -Command "inspect" -Arguments $Arguments -WhatIf:$WhatIf
}

function Get-ContainerId([system.array]$Filters, $Top, [switch]$WhatIf) {
    $filterArguments = "";

    foreach($filter in $Filters) {
        if($filterArguments -ne "") {
            $filterArguments += " "
        }

        $filterArguments += "--filter `"$filter`""
    }

    $arguments = "$filterArguments --format `"{{.ID}}`""

    if($Top) {
        $arguments += " -n $Top"
    }

    Invoke-DockerPs -Arguments $arguments -WhatIf:$WhatIf
}

function Get-ContainerIp([string]$ContainerId, [switch]$WhatIf) {
    Invoke-DockerInspect -Arguments "--format=`"{{.NetworkSettings.Networks.nat.IPAddress}}`" $containerId" -WhatIf:$WhatIf
}

function Wait-Container($ContainerId, [switch]$WhatIf) {
    while((docker  inspect --format="{{.State.Running}}" $ContainerId) -eq $true) {}
}

Export-ModuleMember -Alias * -Function Invoke-DockerCommand, Invoke-DockerPs, Invoke-DockerInspect, Get-ContainerIp, Wait-Container
