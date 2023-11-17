Set-ExecutionPolicy RemoteSigned -Scope Process -Force

$command = 'sc stop "WinDefend" >nul 2>&1 & reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f'
$trustedInstallerSid = [System.Security.Principal.SecurityIdentifier]::new('S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464')
$trustedInstallerName = $trustedInstallerSid.Translate([System.Security.Principal.NTAccount])

$streamOutFile = New-TemporaryFile
$batchFile = New-TemporaryFile

try {
    $batchFile = Rename-Item $batchFile "$($batchFile.BaseName).bat" -PassThru
    "@echo off`r`n$command`r`nexit 0" | Out-File $batchFile -Encoding ASCII

    $taskName = 'privacy.sexy invoke'
    schtasks.exe /delete /tn "$taskName" /f 2>&1 | Out-Null # Clean if something went wrong before, suppress any output

    $taskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "cmd /c `"$batchFile`" > $streamOutFile 2>&1"

    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    Register-ScheduledTask -TaskName $taskName -Action $taskAction -Settings $settings -Force -ErrorAction Stop | Out-Null

    try {
        $scheduleService = New-Object -ComObject Schedule.Service
        $scheduleService.Connect()
        $scheduleService.GetFolder('\').GetTask($taskName).RunEx($null, 0, 0, $trustedInstallerName) | Out-Null

        $timeOutLimit = (Get-Date).AddMinutes(5)
        Write-Host "Running as $trustedInstallerName"

        while ((Get-ScheduledTaskInfo $taskName).LastTaskResult -eq 267009) {
            Start-Sleep -Milliseconds 200
            if ((Get-Date) -gt $timeOutLimit) {
                Write-Warning "Skipping results, it took so long to execute script."
                break
            }
        }

        if (($result = (Get-ScheduledTaskInfo $taskName).LastTaskResult) -ne 0) {
            Write-Error "Failed to execute with exit code: $result."
        }
    } finally {
        schtasks.exe /delete /tn "$taskName" /f | Out-Null # Outputs only errors
    }
    Get-Content $streamOutFile
} finally {
    Remove-Item $streamOutFile, $batchFile
}


PowerShell -ExecutionPolicy Unrestricted -Command {
    $installer = (Get-ChildItem "$($env:ProgramFiles)*\Microsoft\Edge\Application\*\Installer\setup.exe")
    
    if (!$installer) {
        Write-Host 'Installer not found. Microsoft Edge may already be uninstalled.'
    } else {
        $installer | ForEach-Object {
            $uninstallerPath = $_.FullName
            $installerArguments = @("--uninstall", "--system-level", "--verbose-logging", "--force-uninstall")

            Write-Output "Uninstalling through uninstaller: $uninstallerPath"
            $process = Start-Process -FilePath "$uninstallerPath" -ArgumentList $installerArguments -Wait -PassThru
            
            if ($process.ExitCode -eq 0 -or $process.ExitCode -eq 19) {
                Write-Host "Successfully uninstalled Edge."
            } else {
                Write-Error "Failed to uninstall, uninstaller failed with exit code $($process.ExitCode)."
            }
        }
    }
}