@echo off
:: https://privacy.sexy — v0.12.7 — Wed, 15 Nov 2023 17:22:22 GMT
:: Ensure admin privileges
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select "Run as administrator".
        exit 1
    )
    exit 0
)
:: Initialize environment
setlocal EnableExtensions DisableDelayedExpansion


:: ----------------------------------------------------------
:: ----------Disable SmartScreen for apps and files----------
:: ----------------------------------------------------------
echo --- Disable SmartScreen for apps and files
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Disable SmartScreen in File Explorer-----------
:: ----------------------------------------------------------
echo --- Disable SmartScreen in File Explorer
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: Disable SmartScreen's prevention of application execution-
:: ----------------------------------------------------------
echo --- Disable SmartScreen's prevention of application execution
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "ShellSmartScreenLevel" /t REG_SZ /d "Warn" /f
:: ----------------------------------------------------------


endlocal
exit /b 0