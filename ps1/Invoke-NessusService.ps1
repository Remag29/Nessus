<#
.SYNOPSIS
Allows to start, stop or restart the Nessus service

.DESCRIPTION
Allows to start, stop or restart the Nessus service

.PARAMETER Action
The action to apply on the Nessus service. Can be Start, Stop or Restart

.EXAMPLE
Invoke-NessusService -Action Start

#>
function Invoke-NessusService {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet('Start', 'Stop', 'Restart')]
        [string]
        $Action
    )

    # get the service
    $nessusService = Get-Service -Name "Tenable Nessus"

    # Apply the action
    switch ($Action) {
        'Start' {
            if ($nessusService.Status -eq "Running") {
                Write-Host "Nessus is already running !" -ForegroundColor Red
                return
            }
            Start-Service -Name "Tenable Nessus"
            Write-Host "Nessus is starting..." -ForegroundColor Cyan
        }

        'Stop' {
            if ($nessusService.Status -eq "Stopped") {
                Write-Host "Nessus is already stopped !" -ForegroundColor Red
                return
            }
            Stop-Service -Name "Tenable Nessus"
            Write-Host "Nessus is stopping..." -ForegroundColor Cyan
        }

        'Restart' {
            Write-Host "Nessus is restarting..." -ForegroundColor Cyan
            if ($nessusService.Status -ne "Stopped") {
                Stop-Service -Name "Tenable Nessus"
                Start-Sleep -Seconds 5
            }
            Start-Service -Name "Tenable Nessus"
        }

        Default {
            Write-Host "Invalid action !" -ForegroundColor Red
        }
    }

    # get the service
    Start-Sleep -Seconds 1
    $nessusService = Get-Service -Name "Tenable Nessus"

    # check the status
    if ($nessusService.Status -eq "Running") {
        Write-Host "Nessus is running !" -ForegroundColor Green
    }
    elseif ($nessusService.Status -eq "Stopped") {
        Write-Host "Nessus is stopped !" -ForegroundColor Red
    }
    else {
        Write-Host "Nessus is $($nessusService.Status) !" -ForegroundColor Yellow
    }
}