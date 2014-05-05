@echo off

set arg=%*



REM find (dotless) extention
for /f %%F in ("%arg%") do set ext=%%~xF && set ext=%ext:.=%



REM redirect argument to proper program

set arg=%cd%\%arg%

if %ext%==bat  goto dos
if %ext%==BAT  goto dos

if %ext%==doc  goto word
if %ext%==DOC  goto word
if %ext%==docx goto word
if %ext%==DOCX goto word


if %ext%==txt  goto geany
if %ext%==TXT  goto geany
if %ext%==xml  goto geany
if %ext%==XML  goto geany
if %ext%==c    goto geany
if %ext%==C    goto geany
if %ext%==cc   goto geany
if %ext%==CC   goto geany
if %ext%==cpp  goto geany
if %ext%==CPP  goto geany
if %ext%==h    goto geany
if %ext%==H    goto geany
if %ext%==hh   goto geany
if %ext%==HH   goto geany
if %ext%==hpp  goto geany
if %ext%==HPP  goto geany


if %ext%==pdf  goto foxit
if %ext%==PDF  goto foxit

if %ext%==jpg  goto irfanview
if %ext%==JPG  goto irfanview
if %ext%==jpeg goto irfanview
if %ext%==JPEG goto irfanview
if %ext%==png  goto irfanview
if %ext%==PNG  goto irfanview
if %ext%==bmp  goto irfanview
if %ext%==BMP  goto irfanview
if %ext%==gif  goto irfanview
if %ext%==GIF  goto irfanview


if %ext%==php  goto chrome
if %ext%==PHP  goto chrome
if %ext%==htm  goto chrome
if %ext%==HTM  goto chrome
if %ext%==html goto chrome
if %ext%==HTML goto chrome

goto :eof


: dos
chain "%arg%"
goto :eof


: word
start "" winword "%arg%"
goto :eof


: geany
start "" "c:\Program Files (x86)\Geany\bin\Geany.exe" "%arg%"
goto :eof

: irfanview
start "" "c:\Progam Files (x86)\IrfanView\i_view32.exe" "%arg%"
goto :eof


: foxit
start "" "c:\Progam Files (x86)\Foxit Reader\Foxit Reader.exe" "%arg%"
goto :eof


: chrome
start "" "c:\Progam Files (x86)\Google\Chrome\Application\chrome.exe" "%arg%"
goto :eof

