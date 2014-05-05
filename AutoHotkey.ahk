; ^ Ctrl
; ! Alt
; # Winkey
; + Shift



name := "Rody Oldenhuis"
workEmail := "oldenhuis@luxspace.lu"
personalEmail := "oldenhuis@gmail.com"
homeAddress := "Brunnenstraße 7{Enter}54456 Tawern, Deutschland"


; Debug
^!r::Reload


; Remap some keys
; ------------------------------------------------------------------------------------------------------------
RAlt::Alt
SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff
Capslock::F12


; Shortcuts
; ------------------------------------------------------------------------------------------------------------

#z::Run www.google.com
#c::Run calc
#n::Run notepad
#p::Run mspaint
#w::Run winword
#x::Run excel
#e::Run "C:\Program Files (x86)\Total CMA Pack\Total CMA Pack.exe"

#Numpad0::Send !{F4}


; (spawn/unminimize)/minimize Cygwin
; ------------------------------------------------------------------------------------------------------------

`::
    IfWinExist, -bash
    {
        IfWinActive
            WinMinimize
        else
        {
            WinActivate
            WinMaximize
        }
    }
    else
        Run, C:\Cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico -
return




; Media controls
; ------------------------------------------------------------------------------------------------------------

+^PgUp::Send {Volume_Up 3}
+^PgDn::Send {Volume_Down 3}
+^End::Send {Volume_Mute}
+^Numpad4::Send {Media_Prev}
+^Numpad6::Send {Media_Next}


; Horizontal scroll
; ------------------------------------------------------------------------------------------------------------

; Scroll left.
+WheelUp::  
ControlGetFocus, fcontrol, A
Loop 8  ; <-- Increase this value to scroll faster.
    SendMessage, 0x114, 0, 0, %fcontrol%, A  ; 0x114 is WM_HSCROLL and the 0 after it is SB_LINELEFT.
return

; Scroll right.
+WheelDown::  
ControlGetFocus, fcontrol, A
Loop 8  ; <-- Increase this value to scroll faster.
    SendMessage, 0x114, 1, 0, %fcontrol%, A  ; 0x114 is WM_HSCROLL and the 1 after it is SB_LINERIGHT.
return


; Chrome tweaks
; ------------------------------------------------------------------------------------------------------------

; open new tab
; (for some reason, opening a new tab does NOT put the cursor on the omnibox anymore...)
#IfWinActive ahk_class Chrome_WidgetWin_1  
^t::    
    SendInput, ^t
    Sleep 50
    SendInput, {F6}
return


; File manager tweaks
; ------------------------------------------------------------------------------------------------------------

; Make Backspace and middle button perform a regular folder-up action in explorer
#IfWinActive, ahk_class CabinetWClass
MButton:: 
BackSpace::
RControl & WheelUp:: 
    ControlGet renamestatus,Visible,,Edit1,A
    ControlGetFocus focussed, A
    if (renamestatus != 1 && (focussed="DirectUIHWND3"||focussed="SysTreeView321"))
        SendInput !{Up}
    else
        SendInput {BackSpace}
return
#IfWinActive 

; Make mouse wheel down perform a "regular" backspace
#IfWinActive, ahk_class CabinetWClass
^WheelDown::
    SendInput {BackSpace}
return
#IfWinActive



; Text manipulation
; ------------------------------------------------------------------------------------------------------------


; Exclude these from all "editing" hotkeys
GroupAdd, NoEditGroup, ahk_class Chrome_WidgetWin_1  ; web browser (chrome)
GroupAdd, NoEditGroup, ahk_class CabinetWClass       ; file manager (explorer)



; Some handy dandy little functions

Repeat(String,Times)
{
  Loop, %Times%
    Output .= String
  return Output
}

ColumnJustify(lines, lcr="left", del=" ", MinPad=2)
{
    ; Treat multiple consecutive delimiters as a single delimiter
    lines := RegExReplace(lines, del "{2,}", del)

    ; Find required length for each column
    Loop, Parse, lines, `n,`r
    {
        line := RegExReplace(A_LoopField, "^" del "|" del "$", "")
        Loop, Parse, line, %del%
            If ((t := StrLen(A_LoopField)) > c%A_Index%)
                c%A_Index% := t
    }


    ; left-justify
    If (lcr = "left")
        Loop, Parse, lines, `n,`r
        {
            line := RegExReplace(A_LoopField, "^" del "|" del "$", "")
            Loop, Parse, line, %del%
                out .= (A_Index=1 ? "`n" : "")   A_LoopField   Repeat(" ",c%A_Index%-Strlen(A_LoopField)+MinPad)
        }

    ; right-justify
    Else If (lcr = "right")
        Loop, Parse, lines, `n,`r
        {
            line := RegExReplace(A_LoopField, "^" del "|" del "$", "")
            Loop, Parse, line , %del%
                out .= (A_Index=1 ? "`n" : "")   Repeat(" ",c%A_Index%-Strlen(A_LoopField)+(A_Index=1 ? 0 : MinPad))   A_LoopField
        }

    ;; center-justify
    ;Else If (lcr = "centre")
    ; TODO


    ; Omit initial newline
    return SubStr(out, 2)
}

    
; Transpose two lines
#IfWinNotActive, ahk_group NoEditGroup
^+t::        
    Temp := ClipboardAll
    Clipboard =	
    SendInput, {End}+{Home}^x{Up}{Enter}{Up}
    ClipWait, 1
        SendInput, %Clipboard%{Down}{End}{Delete}
    Clipboard := Temp
return


; duplicate line
#IfWinNotActive, ahk_group NoEditGroup
^+d::
    Temp := ClipboardAll
    Clipboard =	
    SendInput, {End}+{Home}^c
    ClipWait, 1
    SendInput, {End}{Enter}%Clipboard%
    Clipboard := Temp   
return


; delete line
#IfWinNotActive, ahk_group NoEditGroup
^+k::SendInput, {End}+{Home}{Delete} 



; vertically-align block of text, left align cells

; TODO: automatically decide whether to use space, comma or equals-signs as delimiter
; 
; TODO: also parse funtion call indentation, as in 
;
; [a, b, c] = myFcn(...
; 'option', value,  'option2', value23,...  
; someArray, Sm,...
; I_sp, V_MEA);    
;
; ⇒
;
;[a, b, c] = myFcn('option',   value,  'option2',  value23,...  
;		   someArray,  Sm,...
;		   I_sp,       V_MEA);          

#IfWinNotActive, ahk_group NoEditGroup
!^+l::
    PreviousClipboardContent := ClipboardAll
    Clipboard =
    SendInput, ^c
    ClipWait, 1
    Clipboard := ColumnJustify(Clipboard, "left")
    SendInput, %Clipboard%
    Clipboard := PreviousClipboardContent
return


; vertically-align block of text, right align cells
#IfWinNotActive, ahk_group NoEditGroup
!^+r::
    PreviousClipboardContent := ClipboardAll
    Clipboard =
    SendInput, ^c
    ClipWait, 1
    Clipboard := ColumnJustify(Clipboard, "right")
    SendInput, %Clipboard%
    Clipboard := PreviousClipboardContent
return




; Win+G searches on google for the selected string
; ------------------------------------------------------------------------------------------------------------
#g::
    Send, ^c
    Sleep 50
    Run, http://www.google.com/search?q=%clipboard%
return



; Win+H toggles hidden files
; ------------------------------------------------------------------------------------------------------------
; FIXME: DOES NOT WORK
;#IfWinActive, ahk_class CabinetWClass
;#h::
;    RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
;
;    if(HiddenFiles_Status = 2)
;        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
;    else
;        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
;
;    WinGetClass, eh_Class,A
;
;    if (eh_Class = "#32770" OR A_OSVersion = "WIN_VISTA")
;        send, {F5}
;    else
;        PostMessage, 0x111, 28931,,, A
;return
;#IfWinActive



; System-wide text-expansions
; ------------------------------------------------------------------------------------------------------------


; Normal text
;················································

; Work related
; ··················

:c:HH::Heinrich Hertz
:c:ED::EDRS-C
:c:H1::HAG 1


; Generic
; ··················

; TODO: add phone number

:c:\A::
    SendInput, %homeAddress%
return

:c:\E::
    SendInput, %workEmail%
return


:c:\e::
    SendInput, %personalEmail%
return

:c:\N::
    SendInput, %name%
return

:c:\D::
    FormatTime, TimeStamp,, yyyy/MMMM/dd
    SendInput, %TimeStamp%
return
:c:\DD::
    FormatTime, TimeStamp,, yyyy/MMMM/dd HH:mm:ss CET
    SendInput, %TimeStamp%
return



; Abbreviations / common typos
; ··················

::donateplz::
    SendInput, If you find this work useful, please consider a donation:{Return}
    SendInput, https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6G3S5UYM7HJ3N
return

::reqs::requirements
::env::environment
::lxs::LuxSpace
::w/::with
::b/c::because
::w/o::without
::b/w::between
::iow::in other words
::sw::software
::s/w::software
::hw::hardware
::h/w::hardware
::tf::therefore
::rsp::respectively
::repo::repository
::btw::by the way
:c:breg::
	SendInput, Best regards,{Return}{Return}
	SendInput, %name%
return
:c:kreg::
	SendInput, Kind regards,{Return}{Return}
	SendInput, %name%
return
:c:vrgr::
	SendInput, Vriendelijke groeten,{Return}{Return}
	SendInput, %name%
return


::ceho::echo
::funcitons::functions
::funtions::functions
::fcuntiosn::functions
::functiosn::functions
::fcns::functions


::funciton::function
::funiton::function
::fcuntion::function
::fnuction::function
::funtion::function
::fucntion::function
::funcituon::function
::fuinction::function
::funciotn::function
::fuciton::function
::fnuciotn::function
::fuciotn::function
::fuicniton::function
::funcoitn::function
::functoin::function
::fcn::function


::mnv::maneuver
::manouvre::maneuver
::personell::personnel 
::pnl::personnel 
::sfl::successful
::sfly::successfully


::sl::Simulink
::tmw::The MathWorks
::rtw::Real-time Workshop
::ml::MATLAB
::slr::Simulink®
::tmwr::The MathWorks®
::rtwr::Real-time Workshop®
::mlr::MATLAB®


::ahk::AutoHotkey


 

; Folder shorts
; ··················

:c::hag1::C:\Users\rody.oldenhuis\Desktop\Work\HAG1\HAG1_Sim\{Enter}
:c::hag1sys::C:\Users\rody.oldenhuis\Desktop\Work\HAG1\HAG1_Sim\trunk\System\{Enter}

:c::edrs::C:\Users\rody.oldenhuis\Desktop\Work\SGEO\EDRSSim\{Enter}

:c::pf::C:\Program Files\{Enter}
:c::pf86::C:\Program Files (x86)\{Enter}

:c::d::C:\Users\rody.oldenhuis\Desktop\{Enter}
:c::db::D:\Dropbox\{Enter}

:c::pwr::C:\Users\rody.oldenhuis\Desktop\Work\SGEO\EDRSSim\trunk\Software\EGSESim\Library\Power\{Enter}
:c::pcdu::C:\Users\rody.oldenhuis\Desktop\Work\SGEO\EDRSSim\trunk\Software\EGSESim\Library\Power\{Enter}

:c::slosh::C:\Users\rody.oldenhuis\Desktop\Work\HAG1\HAG1_Sim\trunk\Library\Sloshing\{Enter}
:c::sloshing::C:\Users\rody.oldenhuis\Desktop\Work\HAG1\HAG1_Sim\trunk\Library\Sloshing\{Enter}




; Programming
; ··················

; MATLAB
; -  -  -  -  -  -

; insert block comment
:o:bc::{%}{{}{Enter}{Tab}{Enter}{%}{}}{Left 3}

; insert basic switch structure
:o:mswitch::switch{Enter}{Tab}case{Enter}{Tab}case{Enter}{Tab}otherwise{Enter}end

; continue line
^+c:: SendInput, ,...{Enter}

; flags
:o:massert::
    SendInput, `% ASSERT: (%name%)
return
:o:mbugfix::
    SendInput, `% BUGFIX: (%name%)
return
:o:mnote::
    SendInput, `% NOTE: (%name%)
return
:o:mtbc::
    SendInput, `% TBC: (%name%)
return
:o:mtest::
    SendInput, `% TEST: (%name%)
return
:o:mfix::
    SendInput, `% FIXME: (%name%)
return
:o:mtodo::
    SendInput, `% TODO: (%name%)
return
:o:mstyle::
    SendInput, `% STYLE: (%name%)
return
:o:mbug::
    FormatTime, TimeStamp,, yyyy/MMMM/dd
    SendInput, `% BUG: (%name%, %TimeStamp%)
return
:o:mchange::
    var := mChangeFcn()
    SendInput %var%{Enter}
return

mChangeFcn()
{
    global name
    FormatTime, TimeStamp,, yyyy/MMMM/dd
    return TimeStamp " (" name ")"
}



; boilerplate

:o:merr:: 
    SendInput, error(':',...{Enter}'');
return
:o:mwarn:: 
    SendInput, warning(':',...{Enter}'');
return

:o:mtry::
    SendInput, try{Enter}{Enter}{Backspace}catch ME{Enter}{Enter}{Backspace}end{Up 3}
return

:o:mfcn::  ; top function

    previousClipboardContent := ClipboardAll
    Clipboard =

    var := mChangeFcn()

    mFunctionTemplate =  ; NOTE: indentation here is important
    (
`% <FUNCTION_NAME>      <FUNCTION_DESCRIPTION>
`%
`% USAGE:
`% --------
`%
`%    [<OUTPUTS>] = <FUNCTION_NAME>(<INPUTS>)
`%
`% <LONG DESCRIPTION>
`%
`% EXAMPLE:
`% --------
`%
`% See also <COMPARABLE FUNCTIONS>
function [<OUTPUTS>] = <FUNCTION_NAME>(<INPUTS>) `%#eml

`% Authors
`%{
    %name% (%workEmail%)
`%}

`% Flags
`%{
    All flags should be accompanied by your name!

    ASSERT    : Condition that MUST hold. Typically used to indicate a possible unit test
    TEST      : anything else related to software testing
    BUG       : known bug that was found AFTER delivery
    BUGFIX    : fixed bug; use this comment to warn developers of a particular pitfall
    WORKAROUND: 
    FIXME     : A known bug/inconsistency/incompleteness; needs fixing before delivery
    TODO      : Work left unimplemented. Also use this to indicate any future enhancements.
    PORT      : 
    TBC       : To be confirmed/consulted by/with the customer
    NOTE      : general note to clarify a portion of code
    STYLE     : deliberate deviations from the style guide
`%}

`% Changelog:
`%{
    %var%
        Initial version
`%}

`% References
`%{
`%}

`% TODO
`%{
`%}

    `%`% initialize

    eml.extrinsic('warning', 'error');

    `%<START HERE>

end
    )

    Clipboard := mFunctionTemplate
    ClipWait, 1
    SendInput, ^v
    Sleep, 75
    Clipboard := previousClipboardContent

return

:o:msubfcn::  ; sub function

    previousClipboardContent := ClipboardAll
    Clipboard =

    var := mChangeFcn()

    mSubFunctionTemplate =  ; NOTE: indentation here is important
    (
`% <SUBFUNCTION_NAME>      <SUBFUNCTION_DESCRIPTION>
`%
`% USAGE:
`% --------
`%
`%    [<OUTPUTS>] = <SUBFUNCTION_NAME>(<INPUTS>)
`%
`% <LONG DESCRIPTION>
`%
`% EXAMPLE:
`% --------
`%
`% See also <COMPARABLE FUNCTIONS>
function [<OUTPUTS>] = <SUBFUNCTION_NAME>(<INPUTS>) `%#eml

`% Authors
`%{
    %name%       %workEmail%
`%}

`% CHANGELOG:
`%{
    %var%
        Initial version
`%}

`% References
`%{
`%}

`% TODO
`%{
`%}

    `%`% initialize

    eml.extrinsic('warning', 'error');

    `%<START HERE>

end
    )

    Clipboard := mSubFunctionTemplate
    ClipWait, 1
    SendInput, ^v
    Sleep, 75
    Clipboard := previousClipboardContent

return




; Special chars
; ··················


:o:\eur::€
:o:\euro::€
:oc:EUR::€
:oc:\cent::¢
:oc:\promille::‰
:oc:\pound::£
:oc:\pounds::₤

:oc:\<<::«
:oc:\>>::»

:?oc:\copyright::©
:?oc:\reg::®
:?oc:\tm::™

:oc:\div::§
:oc:\par::¶


:?oc:\half::½
:?oc:\quarter::¼
:?oc:\threequarters::¾

:?o*c:\grave::{ASC 096}

:oc:\maccommand::⌘
:oc:\telephone::☏


:oc:\quarternote::♩
:oc:\eigthnote::♪
:oc:\eigthnotes::♫
:oc:\sixteenthnotes::♬
:oc:\flat::♭
:oc:\natural::♮
:oc:\sharp::♯


:oc:\Sun::☉
:oc:\Moon::☽
:oc:\Mercury::☿
:oc:\Venus::♀
:oc:\Earth::ⴲ
:oc:\Mars::♂
:oc:\Jupiter::♃
:oc:\Saturn::♄
:oc:\Uranus::♅
:oc:\Neptune::♆
:oc:\Pluto::♇

:oc:\AscendingNode::☊
:oc:\DescendingNode::☋
:oc:\Conjunction::☌
:oc:\Opposition::☍
:oc:\Comet::☄
:oc:\Star::★

:oc:\Aries::♈
:oc:\Taurus::♉
:oc:\Gemini::♊
:oc:\Cancer::♋
:oc:\Leo::♌
:oc:\Virgo::♍
:oc:\Libra::♎
:oc:\Scorpius::♏
:oc:\Sagitarius::♐
:oc:\Capricornus::♑
:oc:\Aquarius::♒
:oc:\Pisces::♓



; Math
; · · · · · · 


:?*oc:\frac17::⅐
:?*oc:\frac19::⅑
:?*oc:\frac110::⅒
:?*oc:\frac13::⅓
:?*oc:\frac23::⅔
:?*oc:\frac15::⅕
:?*oc:\frac25::⅖
:?*oc:\frac35::⅗
:?*oc:\frac45::⅘
:?*oc:\frac16::⅙
:?*oc:\frac56::⅚
:?*oc:\frac18::⅛
:?*oc:\frac38::⅜
:?*oc:\frac58::⅝
:?*oc:\frac78::⅞


:?*oc:\Sq::²
:?*oc:\Cb::³


:?*oc:\pow0::⁰
:?*oc:\pow1::¹
:?*oc:\pow2::²
:?*oc:\pow3::³
:?*oc:\pow4::⁴
:?*oc:\pow5::⁵
:?*oc:\pow6::⁶
:?*oc:\pow7::⁷
:?*oc:\pow8::⁸
:?*oc:\pow9::⁹
:?*oc:\pown::ⁿ
:?*oc:\pow+::⁺
:?*oc:\pow-::⁻
:?*oc:\pow=::⁼
:?*oc:\pow(::⁽
:?*oc:\pow)::⁾



:?*oc:\sub0::₀
:?*oc:\sub1::₁
:?*oc:\sub2::₂
:?*oc:\sub3::₃
:?*oc:\sub4::₄
:?*oc:\sub5::₅
:?*oc:\sub6::₆
:?*oc:\sub7::₇
:?*oc:\sub8::₈
:?*oc:\sub9::₉
:?*oc:\sub+::₊
:?*oc:\sub-::₋
:?*oc:\sub=::₌
:?*oc:\sub(::₍
:?*oc:\sub)::₎



:?*oc:\cdot::·
:?*oc:\times::×
:?*oc:\to::→
:?*oc:\rightarrow::⇒
:?*oc:\therefore::∴
:?*oc:\deg::°
:?*oc:\circ::°
:?*oc:\pm::±
:?*oc:\partial::∂
:?*oc:\nabla::∇
:?*oc:\DEL::∇     ; conflicts with \delta \Delta
:?*oc:\surd::√
:?*oc:\root::√
:?*oc:\cuberoot::∛
:?*oc:\quarticroot::∜
:?*oc:\In::∈
:?*oc:\notin::∉
:?*oc:\forall::∀
:?*oc:\exists::∃
:?*oc:\emptyset::∅
:?*oc:\Real::ℝ
:?*oc:\Complex::ℂ
:?*oc:\Rational::ℚ
:?*oc:\Integer::ℤ
:?*oc:\Quaternion::ℍ
:?*oc:\Prime::ℙ
:?*oc:\inf::∞
:?*oc:\infty::∞
:?*oc:\int::∫
:?*oc:\intint::∬
:?*oc:\intintint::∭
:?*oc:\circint::∮
:?*oc:\circintint::∯
:?*oc:\approx::≈
:?*oc:\neq::≠
:?*oc:\leq::≤
:?*oc:\geq::≥
:?*oc:\def::≣
:?*oc:\Laplace::ℒ
:?*oc:\hbar::ħ


:oc:\no::№



; Accent Roman 
; · · · · · · 


:?*o:\'a::à
:?*o:\'e::è
:?*o:\'i::ì 
:?*o:\'o::ò
:?*o:\'u::ù  

:?*o:\''a::á
:?*o:\''e::é
:?*o:\''i::í 
:?*o:\''o::ó
:?*o:\''u::ú
:?*o:\''c::ć

:?*o:\^a::â
:?*o:\^e::ê
:?*o:\^i::î
:?*o:\^o::ô
:?*o:\^u::û
:?*o:\^c::č

:?*o:\"a::ä
:?*o:\"e::ë
:?*o:\"i::ï
:?*o:\"o::ö
:?*o:\"u::ü

:?*o:\cc::ç
:?*o:\/o::ø
:?*oc:\oa::å
:?*o:\ss::ß
:?*o:\~n::ñ
:?*o:\ae::æ


; Greek 
; · · · · · · 

:?*oc:\alpha::α
:?*oc:\Alpha::A
:?*oc:\beta::β
:?*oc:\Beta::Β
:?*oc:\gamma::γ
:?*oc:\Gamma::Γ
:?*oc:\delta::δ
:?*oc:\Delta::Δ
:?*oc:\epsilon::ε
:?*oc:\Epsilon::ε::Ε
:?*oc:\zeta::ζ
:?*oc:\Zeta::Ζ
:?*oc:\eta::η
:?*oc:\Eta::Η
:?*oc:\theta::θ
:?*oc:\Theta::Θ
:?*oc:\iota::ι
:?*oc:\Iota::Ι
:?*oc:\kappa::κ
:?*oc:\Kappa::Κ
:?*oc:\lambda::λ
:?*oc:\Lambda::Λ
:?*oc:\mu::μ
:?*oc:\Mu::Μ
:?*oc:\nu::ν
:?*oc:\Nu::Ν
:?*oc:\xi::ξ
:?*oc:\Xi::Ξ
:?*oc:\omicron::ο
:?*oc:\Omicron::Ο
:?*oc:\pi::π
:?*oc:\Pi::Π
:?*oc:\rho::ρ
:?*oc:\Rho::Ρr
:?*oc:\sigma::σ
:?*oc:\varsigma::ς
:?*oc:\Sigma::Σ
:?*oc:\tau::τ
:?*oc:\Tau::Τ
:?*oc:\upsilon::υ
:?*oc:\Upsilon::Υ
:?*oc:\phi::φ
:?*oc:\Phi::Φ
:?*oc:\chi::χ
:?*oc:\Chi::Χ
:?*oc:\psi::ψ
:?*oc:\Psi::Ψ
:?*oc:\omega::ω
:?*oc:\Omega::Ω



; TODO:  add Cyrilic, Hiragana, Katakana

