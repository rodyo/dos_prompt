@echo off

for /f "tokens=* delims=" %%A in ('call tilde_expansion ^%*') do set argv=%%A

mv %argv% C:\StuffToDelete\deleted\ > nul

if errorlevel==0 (
    cls
    dir /og
)

