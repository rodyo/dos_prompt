@echo off

REM no arguments (go to home dir)
set argc=0
for %%X in (%*) do set /A argc+=1
if %argc%==0 (
    call cd %HOME%
    goto finish
)


REM minus (go to previous dir)
if %~1==- (
    popd
    goto finish
)


REM execute command with tilde-expansion (replace with home dir)
for /f "tokens=* delims=" %%A in ('call tilde_expansion ^%*') do set argv=%%A
pushd %argv%
goto finish


:finish
if errorlevel==0 (
    title %cd%
    cls
    dir /og
    exit /b 0
)
exit /b errorlevel



