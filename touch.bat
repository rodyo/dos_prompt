@echo off

if not exist %1 (
    echo. > %1
) else (
    echo. >> %1
)
