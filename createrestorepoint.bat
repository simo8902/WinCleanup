@echo off
CLS
color 17
mode con cols=90 lines=30

REM CHECK PERMS
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
ping 127.0.0.1 -n 3 > nul

echo CREATING A SYSTEM RESTORE POINT...
echo.
echo Please make sure System Restore is On.
echo System Properties ^> System Protection ^> Configure...
echo.
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "MyRestorePoint", 100, 7

echo.

echo If you see ReturnValue = 0; then you are done! The restore point is added.
echo Everytime you run the script, everytime it will create restore point!
echo.

echo IF YOU WANT TO DELETE ALL RESTORE POINTS - WAIT A FEW SECONDS!
ping 127.0.0.1 -n 3 > nul

SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
echo.
 
call :ColorText 0c "WARNING - THIS WILL DELETE ALL YOUR SYSTEM POINTS!!" 
call :ColorText 0c "IF YOU ARE SURE, PLEASE TYPE YES OR NO!"
CHOICE /C YN 

IF %ERRORLEVEL% EQU 1 goto CONTINUE
IF %ERRORLEVEL% EQU 2 goto END

:CONTINUE 
vssadmin delete shadows /all

:END
call :ColorText 0c "YOU ARE DONE! YOU DON'T HAVE NOW SYSTEM RESTORE POINTS!"
pause

goto :eof

:ColorText
echo off
echo %DEL% > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof