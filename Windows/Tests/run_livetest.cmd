@echo off
setlocal
set "runner=%~dp0..\build\App\envispeed_livetest.exe"
if not "%~1"=="" set "runner=%~1"
"%runner%" "%~dp0cases.tsv"
exit /b %errorlevel%
