Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

$Script:ComposeFiles = New-Object System.Collections.ArrayList;
$Script:ProjectId = $null;

function _generateProjectId {
    $id = [guid]::NewGuid().ToString().Replace('-', '')
    Write-Output "dockercompose$($id)"
}

function Get-DockerComposeFiles {
    for ($i = 0; $i -lt $Script:ComposeFiles.Count; $i++) 
    { 
        Write-Output $Script:ComposeFiles[$i]
    }
}

function Add-DockerComposeFile($Path) {
    $Script:ComposeFiles.Add($Path) | Out-Null
    Get-DockerComposeFiles
}

function Remove-DockerComposeFile ($Path) {
    if(-not $Path) {
        Clear-DockerComposeFiles
    }else{
        $Script:ComposeFiles.Remove($Path)
    }

    Get-DockerComposeFiles
}

function Clear-DockerComposeFiles {
    $Script:ComposeFiles = New-Object System.Collections.ArrayList
    Get-DockerComposeFiles
}

function Get-DockerComposeProjectId {
    Write-Output $Script:ProjectId
}

function Set-DockerComposeProjectId($Id) {
    if(-not $Id) {
        $Script:ProjectId = _generateProjectId
    }else{
        $Script:ProjectId = $Id
    }

    Write-Output $Script:ProjectId
}

function Clear-DockerComposeProjectId {
    $Script:ProjectId = $null
}

function Invoke-DockerComposeCommand ([string]$Command, [string]$Arguments, [switch] $WhatIf) {
    [string]$options = " ";

    foreach($file in $Script:ComposeFiles) {
        $options += "-f `"$file`" "
    }

    if($Script:ProjectId -ne $null) {
        $options += "-p $($Script:ProjectId) "
    }

    Invoke-Executable -Executable "docker-compose" -Arguments "$($options.Trim(' ')) $Command $Arguments" -WhatIf:$WhatIf
}

function Invoke-DockerComposeUp ($Arguments, [switch] $WhatIf) {
    Invoke-DockerComposeCommand -Command "up" -Arguments $Arguments -WhatIf:$WhatIf
}

function Invoke-DockerComposeDown ($Arguments, [switch] $WhatIf) {
    Invoke-DockerComposeCommand -Command "down" -Arguments $Arguments -WhatIf:$WhatIf
}

function Invoke-DockerComposeKill ($Arguments, [switch] $WhatIf) {
    Invoke-DockerComposeCommand -Command "kill" -Arguments $Arguments -WhatIf:$WhatIf
}

Export-ModuleMember -Alias * -Function Invoke-DockerComposeCommand, Invoke-DockerComposeUp, Invoke-DockerComposeDown, Invoke-DockerComposeKill, Get-DockerComposeFiles, Add-DockerComposeFile, Remove-DockerComposeFile, Clear-DockerComposeFiles, Get-DockerComposeProjectId, Set-DockerComposeProjectId, Clear-DockerComposeProjectId