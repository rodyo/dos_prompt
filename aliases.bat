@echo off

set HOME=c:\Users\%USERNAME%\Desktop

REM get shell name
for %%A in ("%comspec%") do set com=%%~nxA

REM set path to scripts and CMD title
set batchpath=%~dp0
title %cd%




REM shell is TCC
if %com%==TCC.EXE (

    alias cd=%batchpath%cd.bat
    for %%b in (A B C D E F G H I J K L M N O P Q R S T U V V X Y Z) do alias %%b:=%batchpath%cd.bat %%b:
    alias ..=%batchpath%cd.bat ..

    set colordir=dirs:yel;pdf:cya;doc:bri cya;docx:bri cya;xls:bri mag;m:blu;cpp:bri blu;hpp:blu;h:blu;mdl:blu


REM shell is CMD: define aliases with doskey
) else if %com%==cmd.exe (

    doskey cd=%batchpath%cd.bat $*
    for %%b in (A B C D E F G H I J K L M N O P Q R S T U V V X Y Z) do @doskey %%b:=%batchpath%cd.bat %%b:

    doskey ..=%batchpath%cd.bat ..

)



