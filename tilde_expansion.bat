@echo off

setlocal EnableDelayedExpansion

set arg=
set args=
for %%B in (%*) do (

    set arg=%%~B
    set arg1=!arg:~0,1!

    if "!arg1!"=="~" (
        set args=!args! "%HOME%!arg:~1!"

    ) else (
        if "!arg1!"=="/" (
            set args=!args!^ !arg!
        ) else (
            set args=!args!^ "!arg!"
        )

    )
)

echo %args%


endlocal


