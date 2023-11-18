Set-ExecutionPolicy RemoteSigned -Scope Process -Force


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

Read-Host "Press Enter to continue..."