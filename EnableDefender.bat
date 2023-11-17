@echo off
echo Stopping WinDefend service...
net stop WinDefend

echo Setting WinDefend service to Manual startup...
sc config WinDefend start= demand

echo Starting WinDefend service...
net start WinDefend

echo WinDefend service set to Manual and started successfully.
