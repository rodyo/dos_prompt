@echo off

set INC=-I.
set BASE_PATH=C:\Users\rody.oldenhuis\Desktop\SGEO\EDRSSim\trunk\Software
set BOOST_PATH="%BOOST_ROOT%\include\boost-1_52"


set INC=%INC% -I%BOOST_PATH%

set COMMON_PATH=%BASE_PATH%\EDRS\GemsGeneral
set INC=%INC% -I%COMMON_PATH%\
set INC=%INC% -I%COMMON_PATH%\exception
set INC=%INC% -I%COMMON_PATH%\math
set INC=%INC% -I%COMMON_PATH%\models
set INC=%INC% -I%COMMON_PATH%\models\actuator
set INC=%INC% -I%COMMON_PATH%\models\component
set INC=%INC% -I%COMMON_PATH%\models\exception
set INC=%INC% -I%COMMON_PATH%\models\failure_injection
set INC=%INC% -I%COMMON_PATH%\models\sensor
set INC=%INC% -I%COMMON_PATH%\models\telecommand
set INC=%INC% -I%COMMON_PATH%\models\telemetry
set INC=%INC% -I%COMMON_PATH%\referenceFrame
set INC=%INC% -I%COMMON_PATH%\time
set INC=%INC% -I%COMMON_PATH%\type
set INC=%INC% -I%COMMON_PATH%\xml

set PCDU_PATH=%BASE_PATH%\EdrsPcdu
set INC=%INC% -I%PCDU_PATH%\


cls /c

for %a in (%*) do (
    g++ -c %a %INC%
)
