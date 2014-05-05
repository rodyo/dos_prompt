@echo off

for /f "tokens=* delims=" %%A in ('call tilde_expansion ^%*') do set argv=%%A

copy /s %argv%

if errorlevel==0 (
    cls
    dir /og
)
