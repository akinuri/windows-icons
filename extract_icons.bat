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
"resourcesextract\ResourcesExtract.exe" /Source "%systemroot%\System32\*.*" /DestFolder "icons" /ExtractIcons 1 /ExtractCursors 0 /ExtractBitmaps 0 /ExtractHTML 0 /ExtractManifests 0 /ScanSubFolders 0 /ExtractAnimatedIcons 0 /ExtractAnimatedCursors 0 /ExtractAVI 0 /ExtractTypeLib 0 /ExtractBinary 0 /ExtractStrings 0 /OpenDestFolder 0 /SaveBitmapAsPNG 0 /SubFolderDepth 0 /FileExistMode 1 /MultiFilesMode 2 

:stats
PowerShell.exe -ExecutionPolicy Bypass -Command "& 'powershell\show_stats.ps1'"

pause