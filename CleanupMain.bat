@echo off

echo [31mCheckups[0m 
C:\defender\PowerRun.exe cmd.exe /c "C:\defender\EnableDefender.bat"

timeout /t 10 /nobreak > nul

echo [31mRunning Defender Privacy[0m
call "C:\defender\Defender-Privacy.bat"

C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableSpecialRunningModes" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d 0 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DpaDisabled" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "ForceUpdateFromMU" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d 1 /f

echo [31mDisabling SmartScreen[0m
call "C:\defender\disable-smartscreen.bat"

PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\defender\DisableAV.ps1"

C:\defender\PowerRun.exe regedit.exe /s reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1 /f
C:\defender\PowerRun.exe regedit.exe /s reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdateDev" /v "AllowUninstall" /t REG_DWORD /d "1" /f

echo [31mDisabling auto installing drivers[0m
call "C:\defender\disable-auto-installing-drivers.bat"

echo [31mRemoving preinstalled apps[0m
call "C:\defender\remove-preinstalled-apps.bat"

echo [31mRemoving driver amd/nvidia[0m
call C:\defender\ddu.exe -silent -restart -cleanamd -PreventWinUpdate -removeamddirs
echo [31mRESTART TO APPLY![0m

pause
endlocal
exit /b 0