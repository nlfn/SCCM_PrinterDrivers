:: This is useful if we start from a network share; converts CWD to a drive letter
pushd %~dp0

powershell.exe -executionpolicy bypass -noprofile .\printerz-drivers.ps1

:: Pop back to original directory. This isn't necessary in stand-alone runs of the script, but is needed when being called from another script
popd

:: Return exit code to SCCM/PDQ Deploy/etc
exit /b %errorlevel%