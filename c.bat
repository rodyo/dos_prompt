@echo off

:: set /a a=%*
:: echo %a%

set batchpath=%~dp0
%batchpath%\calc.exe %*
