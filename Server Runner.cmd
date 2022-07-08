@echo off
powershell "D:\nh-base\arti\FXServer.exe +exec resources.cfg +exec server.cfg +svgui +set onesync on +set sv_enforceGameBuild 2372

pause


|tee console_$(Get-Date -f yyyy-MM-dd-HHmm).log