@echo off

set INC=-I.
set LNK=
set ADD=

set BASE_PATH=C:\Users\rody.oldenhuis\Desktop\SGEO\EDRSSim\trunk\Software
set BOOST_PATH="%BOOST_ROOT%\include\boost-1_52"

set INC=%INC% -I%BOOST_PATH%

set COMMON_PATH=%BASE_PATH%\EDRS\GemsGeneral
set ADD=%COMMON_PATH%                  && set INC=%INC% -I%ADD%   && if exist %ADD\*.o set LNK=%LNK% %ADD%\*.o
set ADD=%COMMON_PATH%\exception        && set INC=%INC% -I%ADD%   && if exist %ADD\*.o set LNK=%LNK% %ADD%\*.o
set ADD=%COMMON_PATH%\math             && set INC=%INC% -I%ADD%   && if exist %ADD\*.o set LNK=%LNK% %ADD%\*.o
set ADD=%COMMON_PATH%\models           && set INC=%INC% -I%ADD%   && if exist %ADD\*.o set LNK=%LNK% %ADD%\*.o
set ADD=%COMMON_PATH%\referenceFrame   && set INC=%INC% -I%ADD%   && if exist %ADD\*.o set LNK=%LNK% %ADD%\*.o
set ADD=%COMMON_PATH%\time             && set INC=%INC% -I%ADD%   && if exist %ADD\*.o set LNK=%LNK% %ADD%\*.o
set ADD=%COMMON_PATH%\type             && set INC=%INC% -I%ADD%   && if exist %ADD\*.o set LNK=%LNK% %ADD%\*.o
set ADD=%COMMON_PATH%\xml              && set INC=%INC% -I%ADD%   && if exist %ADD\*.o set LNK=%LNK% %ADD%\*.o

set PCDU_PATH=%BASE_PATH%\EdrsPcdu
set ADD=%PCDU_PATH%                    && set INC=%INC% -I%ADD%   && if exist %ADD\*.o set LNK=%LNK% %ADD%\*.o


cls /c

g++ %* %INC%  %LNK%   && a.exe
