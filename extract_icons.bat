@echo off
title Windows Icons

echo.
echo  This tool will scan the files in "C:\Windows\System32" directory (sub-dirs are not included)
echo  and will extract every icon it finds. Later, it'll present you a table that shows how many icons
echo  are extracted and from which files.
echo.

pause

if exist "icons" goto stats

:mdicons
mkdir "icons"

:extract
cls
echo.
echo  Extracting the icons. This may take a little...
echo.
"resourcesextract\ResourcesExtract.exe" /Source "%systemroot%\System32\*.*" /DestFolder "icons" /ExtractIcons 1 /FileExistMode 1 /MultiFilesMode 2 /OpenDestFolder 0

:stats
PowerShell.exe -ExecutionPolicy Bypass -Command "& 'powershell\show_stats.ps1'"

pause