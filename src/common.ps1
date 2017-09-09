Set-StrictMode -Version Latest

function Invoke-Executable ($Executable, $Arguments, [switch]$WhatIf) {
    $expression = "$Executable $Arguments"
    
        if($WhatIf) {
            Write-Host "WhatIf: would invoke expression: $expression"
           
        }else{
            Invoke-Expression "& $expression"
        }
}