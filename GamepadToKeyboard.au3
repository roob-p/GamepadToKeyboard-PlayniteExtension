#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=GamepadToKeyboard (64 bit)
#AutoIt3Wrapper_Res_Fileversion=1.2.3.0
#AutoIt3Wrapper_Res_ProductName=GamepadToKeyboard
#AutoIt3Wrapper_Res_ProductVersion=1.2.3
#AutoIt3Wrapper_Res_CompanyName=roob-p (author)
#AutoIt3Wrapper_Res_LegalCopyright=roob-p (author)
#AutoIt3Wrapper_Res_LegalTradeMarks=roob-p (author)
#AutoIt3Wrapper_Res_Language=1040
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <_XInput.au3>
#include <AutoItConstants.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <WinAPIProc.au3>
#include <Timers.au3>
#include <ColorConstants.au3>
#include <WindowsSysColorConstants.au3>

#pragma compile(UPX, false)

_singleton("Script")

OnAutoItExitRegister("Onexit")
opt("SendKeyDelay",0)
opt("SendKeyDownDelay",0)
Opt("WinWaitDelay",500)

$inputhwnd = _XInputInit()
$input = _XInputGetInput($inputhwnd)
$buttons = _XInputButtons($input[2])


global $analogdeadzone=1, $sentKeys[256], $ignoreIndices[4]

$programName="GamepadToKeyboard"


if $cmdline[0]>0 then
if StringInStr($cmdline[1],".ini") then
	$inifile=$cmdline[1]
	else

$inifile=IniRead(@ScriptDir & "\" & $programName &".config","configToLoad","configToLoad","default.ini")
endif
	Else

	$inifile=IniRead(@ScriptDir & "\" & $programName &".config","configToLoad","configToLoad","default.ini")
	endif

	;$inifile=@ScriptDir & "\" & "s.ini"


global $A=$buttons[12],$B=$buttons[13],$X=$buttons[14],$Y=$buttons[15],$start=$buttons[5],$back=$buttons[6],$LS=$buttons[7],$RS=$buttons[8],$LB=$buttons[9],$RB=$buttons[10],$Home=$buttons[11],$Up=$buttons[1],$Down=$buttons[2],$Left=$buttons[3],$Right=$buttons[4]
global $LT=$input[3],$RT=$input[4],	$LSX=$input[5], $LSY=$input[6], $RSX=$input[7], $RSY=$input[8], $LS=$buttons[7], $RS=$buttons[8]


global $LSleft = $LSX<-3000, $LSright = $LSX>3000, $LSdown = $LSY<-3000, $LSup = $LSY>3000
global $RSleft = $RSX<-3000,$RSright = $RSX>3000, $RSdown = $RSY<-3000, $RSup = $RSY>3000

global $mousemovx=0, $mousemovy=0, $prevx=0, $prevy=0, $lastMouseMove = 0


global $AnalogToMouse=IniRead($inifile,"Mouse","AnalogToMouse","")
global $Stick=IniRead($inifile,"Mouse","Stick","")
global $splash=IniRead($inifile,"Other","ShowConfigReloadMessage","1"), $splashExit=IniRead($inifile,"Other","ShowForceQuitMessage","1"), $splashEx=0

global $LSXinverted=IniRead($inifile,"Mouse","LSXaxisInverted",0),$LSYinverted=IniRead($inifile,"Mouse","LSYaxisInverted",0),$RSXinverted=IniRead($inifile,"Mouse","RSXaxisInverted",0),$RSYinverted=IniRead($inifile,"Mouse","RSYaxisInverted",0)

global $sensitivity=Iniread($inifile,"Mouse","Sensitivity","")
global $smoothFactor=Iniread($inifile,"Mouse","SmoothFactor","")

global $Xleftdeadzone=IniRead($inifile,"Mouse","XleftDeadzone",2000),$Xrightdeadzone=IniRead($inifile,"Mouse","XrightDeadzone",2000),$Yupdeadzone=IniRead($inifile,"Mouse","YupDeadzone",2000),$Ydowndeadzone=IniRead($inifile,"Mouse","YdownDeadzone",2000)
global $Xdeadzone=IniRead($inifile,"Mouse","Xdeadzone",2000), $Ydeadzone=IniRead($inifile,"Mouse","Ydeadzone",2000)
$MouseDeadzone=IniRead($inifile,"Mouse","Deadzone",2000)
$MouseDeadzoneType=IniRead($inifile,"Mouse","DeadzoneType",1)


global $LSleftdeadzone=IniRead($inifile,"Analogs","LSleftDeadzone",0),$LSrightdeadzone=IniRead($inifile,"Analogs","LSrightDeadzone",0),$LSupdeadzone=IniRead($inifile,"Analogs","LSupDeadzone",0),$LSdowndeadzone=IniRead($inifile,"Analogs","LSdownDeadzone",0)
global $RSleftdeadzone=IniRead($inifile,"Analogs","RSleftDeadzone",0),$RSrightdeadzone=IniRead($inifile,"Analogs","RSrightDeadzone",0),$RSupdeadzone=IniRead($inifile,"Analogs","RSupDeadzone",0),$RSdowndeadzone=IniRead($inifile,"Analogs","RSdownDeadzone",0)
global $LSXdeadzone=IniRead($inifile,"Analogs","LSXdeadzone",0), $LSYdeadzone=IniRead($inifile,"Analogs","LSYdeadzone",0), $RSXdeadzone=IniRead($inifile,"Analogs","RSXdeadzone",0), $RSYdeadzone=IniRead($inifile,"Analogs","RSYdeadzone",0)
global $LSdeadzone=IniRead($inifile,"Analogs","LSdeadzone",0), $RSDeadzone=IniRead($inifile,"Analogs","RSdeadzone",0)
global $AnalogsDeadzone=IniRead($inifile,"Analogs","Deadzone",0)
global $AnalogsDeadzoneType=IniRead($inifile,"Analogs","DeadzoneType",1)

global $LSXaxisInverted=IniRead($inifile,"Analogs","LSXaxisInverted",0), $LSYaxisInverted=IniRead($inifile,"Analogs","LSYaxisInverted",0), $RSXaxisInverted=IniRead($inifile,"Analogs","RSXaxisInverted",0), $RSYaxisInverted=IniRead($inifile,"Analogs","RSYaxisInverted",0)

global $wheelstepup=IniRead($inifile,"Wheel","WheelStepUp",1), $wheelstepdown=IniRead($inifile,"Wheel","WheelStepDown",1)
Global $WheelSpeedLimiterUp = IniRead($inifile,"Wheel","WheelSpeedLimiterUp",8500), $WheelSpeedlimiterDown = IniRead($inifile,"Wheel","WheelSpeedLimiterDown",8500)
Global $UseSameWheelSpeedLimiter = IniRead($inifile,"Wheel","UseSameWheelSpeedLimiter",1), $WheelSpeedLimiter = IniRead($inifile,"Wheel","WheelSpeedLimiter",8500)
Global $WheelAnalogMode = IniRead($inifile,"Wheel","WheelAnalogMode",1), $Digitalscrollrepeat = IniRead($inifile,"Wheel","DigitalScrollrepeat",1),$Analogscrollrepeat = IniRead($inifile,"Wheel","AnalogScrollrepeat",1)
global $dir, $steps, $td=128

global $deadzoneshape = IniRead($inifile,"Mouse","DeadzoneShape",1)
global $repeatTime = IniRead($inifile,"Other","TurboRepeatTime",50)
global $combotime = IniRead($inifile,"Other","ComboAsyncDelay",50), $SequenceTime= IniRead($inifile,"Other","SequenceTime",50)

If $AnalogToMouse <> "1" and $AnalogToMouse <> "0" Then	$AnalogToMouse=0
if $MouseDeadzoneType<> 1 and $MouseDeadzoneType <>  2 and $MouseDeadzoneType <>  4 then  $MouseDeadzoneType=1
if $AnalogsDeadzoneType<> 1 and $AnalogsDeadzoneType <>  2 and $AnalogsDeadzoneType <>  4 and $AnalogsDeadzoneType <> 8 then $AnalogsDeadzoneType=1


global $sendkeystype = Iniread($inifile, "Other","SendKeysType",1)
global $hotkey =Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","Hotkey","^+5") 	;default: Ctrl+Shift+5
$hotkey=String($hotkey)
HotKeySet($hotkey, reloadini)

global $lx=1,$ly=1,	$rx=1,$ry=1, $sticks=0, $mx=1, $my=1

if $LSXaxisInverted=1 Then $lx=-1
if $LSYaxisInverted=1 Then $ly=-1
if $RSXaxisInverted=1 Then $rx=-1
if $RSYaxisInverted=1 Then $ry=-1


	if $Stick="LS" then
		$sticks=1
		if $LSXinverted="1" Then $mx=-1
		if $LSYinverted="1" Then $my=-1
	Elseif $Stick="RS" then
		$sticks=2
		if $RSXinverted="1" Then $mx=-1
		if $RSYinverted="1" Then $my=-1
	Endif


switch $MouseDeadzoneType
	case 1
	$XleftDeadzone=$MouseDeadzone
	$XrightDeadzone=$MouseDeadzone
	$YupDeadzone=$MouseDeadzone
	$YdownDeadzone=$MouseDeadzone
	case 2
	$XleftDeadzone=$Xdeadzone
	$XrightDeadzone=$Xdeadzone
	$YupDeadzone=$Ydeadzone
	$YdownDeadzone=$Ydeadzone
	;case 4
endswitch

global $asize=16+1+8
global $ef[$asize] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False ,False, False, False, False,False, False, False, False]
global $ez[$asize] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

global $keys[16+1+8]   = [$A, $B, $X, $Y, $LB, $RB, $LT, $RT, $back, $start, $LS, $RS, $Up, $Down, $Left, $Right, $Home, $LSup, $LSdown, $LSleft, $LSright, $RSup, $RSdown, $RSleft, $RSright]
global $pressed=$ef
;A, B, X, Y, LB, RB, LT , RT, back, start, LS, RS, UP, DOWN, LEFT, RIGHT, Home,  LSup,  LSdown, LSleft, LSright, RSup, RSdown, RSleft, RSright
;0  1  2  3  4   5   6    7   8     9      10  11  12  13    14    15     16     17	    18	    19	    20	     21	   22	   23	   24

global $values[16+1+8]=[iniR("A"),IniR("B"),IniR("X"),IniR("Y"),IniR("LB"),IniR("RB"),IniR("LT"),IniR("RT"),IniR("Back"),IniR("Start"),IniR("LS"),IniR("RS") _
,IniR("Dup"),IniR("Ddown"),IniR("Dleft"),IniR("Dright"),IniR("Home"),IniR("LSup"),IniR("LSdown"),IniR("LSleft"),IniR("LSright"),IniR("RSup"),IniR("RSdown"),IniR("RSleft"),IniR("RSright")]

global $toggle=$ef, $toggleOn=$ef,	$Turbo=$ef, $TurboToggle=$ef, $TurboToggleOn=$ef, $TurboOn=$ef, $alreadytimer=$ef, $alreadytimer2=$ef,		$TurboComboalreadyTimer=$ef, $TurboToggleComboalreadyTimer=$ef
global $TimerT[$asize], $TimerT2[$asize], $Timer[$asize], $timersplash,		$TurboComboTimerT[$asize]
global $released=$ef, $combo=$ef, $Comboasync=$ef,	$toup=$ef,		$comboOn=$ef, $combosize=11,	$SequenceMax=16,		$comboasyncOn=$ef,	$simpleMacroOn=$ef

global $ToggleComboOn=$ef, $ToggleCombo=$ef, $TurboCombo=$ef, $TurboToggleCombo=$ef,	$TurboComboOn=$ef, $TurboToggleOn=$ef, $TurboToggleComboOn=$ef
global $keysfromcombo[$asize], $combokeys[$asize][$combosize], $keysfromcomboup[$asize], $keysfromcombodown[$asize]
global $keysfromcomboasync[$asize], $combokeysasync[$asize][$combosize], $keysfromcomboupasync[$asize], $keysfromcombodownasync[$asize], $combK[$asize]
global $MacroOn=$ef, $macrosize=25, $Macrokeys[$asize][$macrosize]
global $stringmax=200,  $text=$ef ; $textOn=$ef, $textkeys[$asize][$stringsize]

global $Togglekeysfromcombo[$asize],$Togglecombokeys[$asize][$combosize],$Togglekeysfromcomboup[$asize],$Togglekeysfromcombodown[$asize]
global $Turbokeysfromcombo[$asize],$Turbocombokeys[$asize][$combosize],$Turbokeysfromcomboup[$asize],$Turbokeysfromcombodown[$asize]
;global $TurboTogglekeysfromcombo[$asize],$TurboTogglecombokeys[$asize][$combosize],$TurboTogglekeysfromcomboup[$asize],$TurboTogglekeysfromcombodown[$asize],		$TurboToggleComboTimerT[$asize], 	$releasedC=$ef
global $simplemacro[$asize], $macro[$asize],	$SmacroK[$asize], $SimpleMacroKeys[$asize][$SequenceMax], $keysfromSimpleMacro[$asize]
global $alreadyTimerSimpleMacro=$ef, $timerSimpleMacro=$ef

global $comboNum[$asize], $comboasyncNum[$asize], $sequenceNum[$asize], 		$ToggleComboNum[$asize],$turboComboNum[$asize]
global $ComboType[$asize][$combosize],	$comboAsyncType[$asize][$combosize],	$ToggleComboType[$asize][$combosize],	$TurboComboType[$asize][$combosize], $SimpleMacroType[$asize][$SequenceMax]

global $send[$asize]= [True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True]
global $async=$ef, $alreadytimerasync=$ef, $timerasync[$asize]

global $execute=$ef
global $buttonaction=$ez ;0: normal, 1: toggle, 2: turbo, 3: turbotoggle, 4: execute, 5: combo, 6: comboasync
global $buttontype=$ez   ;0: keyboard, 1:mousebutton, 2: scrollupdown

global $mousemovv[2]
global $alreadytimerscroll=$ef, $timerscroll[$asize]
Global $hNTDLL = DllOpen("ntdll.dll")
global $fkeys, $DW=@DesktopWidth/15,$DH=@DesktopHeight/18
global $specialkeys=$ef, $specialkeys2DCombo[$asize][$combosize], $specialkeys2DSequence[$asize][$SequenceMax]


parse()

func iniR($key)
	$temp=Iniread($inifile,"Buttons",$key,"")
	return $temp
	endfunc


If $AnalogToMouse = "1" Then
    If $Stick = "RS" Then
        global $ignoreIndices = [21,22,23,24]  ; RSup, RSdown, RSleft, RSright
		global $ignore[25] = [21,22,23,24]
    ElseIf $Stick = "LS" Then
		global $ignoreIndices = [17,18,19,20]  ; LSup, LSdown, LSleft, LSright
		global $ignore[25] = [17,18,19,20]
	;ElseIf $Stick = "LTRT" or $Stick = "RTLT"  Then
	;	global $ignoreIndices = [6,7]  ;LT, RT
	;	global $ignore[25] = [6,7]
    EndIf
EndIf



Global $pressed[UBound($keys)]
Global $lastPress[UBound($keys)]
Global $initialDelay = 500, $repeatDelay  = 15


Global $lastPressTime[UBound($keys)] = [0]
Global $firstPressDone[UBound($keys)] = [False]


if $sendkeystype=2 then
$fkeys="keysDesktop"
Else
$fkeys="keys"
endif

AdlibRegister("mouse",1)

While 1

global $keys[16+1+8]   =[$A, $B, $X, $Y, $LB, $RB, $LT, $RT, $back, $start, $LS, $RS, $Up, $Down, $Left, $Right, $Home, $LSup, $LSdown, $LSleft, $LSright, $RSup, $RSdown, $RSleft, $RSright]

buttons()
if _IsPressed("1b") and _ispressed("10") and _isPressed("31") then  ;ESC+Shift+1
	if $splashExit=1 then $splashEx=1
	exit
endif

call($fkeys)

_HighPrecisionSleep(1)
wend


func keys()


for $i=0 to Ubound($keys) -1
	Local $skip = False

        For $j = 0 To UBound($ignoreIndices) - 1
            If $i = $ignoreIndices[$j] Then
                $skip = True
                ExitLoop
            EndIf
		Next

if $keys[$i] and $pressed[$i]=False then
	if $skip=False then
	if $values[$i]="" then ContinueLoop
	$pressed[$i]=True
	$sentKeys[$i]=True

	inpt($i,$values[$i],0,$buttontype[$i],$buttonaction[$i],$specialkeys[$i])

	endif

endif

if $pressed[$i]=True and not $keys[$i] Then
	if $skip=False then
		if $values[$i]="" then ContinueLoop
	if $buttonaction[$i]<>3 and $buttonaction[$i]<>4 and $buttonaction[$i]<>7 and $buttonaction[$i]<>9 then inpt($i,$values[$i],1,$buttontype[$i],$buttonaction[$i],$specialkeys[$i])
	$pressed[$i]=False
	$sentkeys[$i]=False

	$alreadyTimer[$i]=False
	$timerT[$i]=0

	;$TurboComboalreadyTimer[$i]=False
	;$TurboCombotimerT[$i]=0

	endif
endif


if not $keys[$i] Then
	if $ToggleOn[$i]=False then
$alreadyTimerscroll[$i]=False
$timerscroll[$i]=0
;$pressed[$i] = False
	endif
$TurboOn[$i]=False
endif



if $keys[$i] and $Turbo[$i]=True Then Turbo($i,$values[$i],3,$buttontype[$i])	  ; Turbo (uses send down + send up in sender rather than normal send, otherwise keys like Space may be sent literally if StringLower is not used.
;if $keys[$i] and $Turbo[$i]=True Then Turbo3($i,$values[$i],0,$buttontype[$i])	  ; Turbo (Turbo3 function has send down + send up, but I prefer passing state 3 to Turbo() instead of using a separate Turbo3() function).
if $TurboToggleOn[$i]=true Then Turbo($i,$values[$i],3,$buttontype[$i])			  ; TurboToggleOn with send
if $TurboToggleComboOn[$i]=true Then TurboCombo($i,$values[$i],3,$buttontype[$i]) ; TurboToggleCombo
if $ToggleOn[$i]=True and $buttontype[$i]=2 Then  scrollWheelT($i,$values[$i])    ; ToggleOn with Wheel
if $comboasyncOn[$i]=True Then comboasync($i,$values[$i],0,$buttontype[$i])		  ; ComboAsyncOn
if $SimpleMacroOn[$i]=True Then	Sequence($i,$values[$i],3,$buttontype[$i])		  ; $Sequence
; buttonaction[9] uses the same arrays as buttonaction[8] except for $TurboToggleComboOn. This condition is only for standard TurboCombo:
if $keys[$i] and $TurboCombo[$i]=True and $TurboToggleComboOn[$i]=False Then  TurboCombo($i,$values[$i],3,$buttontype[$i])

;not keys[$i]
if $combo[$i]=True and not $keys[$i] Then $pressed[$i]= False
if $TurboToggle[$i]=true and not $keys[$i] Then $released[$i]=True
if $TurboToggleCombo[$i]=true and not $keys[$i] Then $released[$i]=True

next

endfunc




func keysDesktop()
	for $i=0 to Ubound($keys) -1
	Local $skip = False


        For $j = 0 To UBound($ignoreIndices) - 1
            If $i = $ignoreIndices[$j] Then
                $skip = True
                ExitLoop
            EndIf
        Next

	; ===== Ciclo principale =====
	If $keys[$i] Then
		if $values[$i]="" then ContinueLoop
				if $pressed[$i]=False and $buttonaction[$i]=4 then inptD($i,$values[$i],0,$buttontype[$i],$buttonaction[$i],$specialkeys[$i])	;Executes, no repeat
				if $buttontype[$i]=1 and $pressed[$i]=False then inptD($i,$values[$i],0,$buttontype[$i],$buttonaction[$i],$specialkeys[$i])		;Mousebuttons (no repeat)
				if $buttontype[$i]=2 and $pressed[$i]=False then inptD($i,$values[$i],0,$buttontype[$i],$buttonaction[$i],$specialkeys[$i])		;Scrollwheel
            ; Se è la prima volta che premiamo il tasto
            If Not $pressed[$i] Then
                $pressed[$i] = True
				$sentKeys[$i]=True
                $lastPressTime[$i] = TimerInit()  ; inizializza timer
                $firstPressDone[$i] = False

				if $buttontype[$i]=0 and $buttonaction[$i]<>4 then	inptD($i,$values[$i],0,$buttontype[$i],$buttonaction[$i],$specialkeys[$i])
            Else
                ; se il delay iniziale è già passato
                If Not $firstPressDone[$i] Then
                    If TimerDiff($lastPressTime[$i]) >= $InitialDelay Then
                        $lastPressTime[$i] = TimerInit()
                        $firstPressDone[$i] = True

						if $buttontype[$i]=0 and $buttonaction[$i]<>4 then	inptD($i,$values[$i],0,$buttontype[$i],$buttonaction[$i],$specialkeys[$i])
						$sentKeys[$i]=True
                    EndIf
                Else
                    ; ripetizione rapida
                    If TimerDiff($lastPressTime[$i]) >= $RepeatDelay Then
                        $lastPressTime[$i] = TimerInit()

						if $buttontype[$i]=0 and $buttonaction[$i]<>4 then	inptD($i,$values[$i],0,$buttontype[$i],$buttonaction[$i],$specialkeys[$i])
						$sentKeys[$i]=True
                    EndIf
                EndIf
            EndIf
	Endif



If $pressed[$i] and not $keys[$i] Then

			if $values[$i]="" then ContinueLoop
			if $buttonaction[$i]<>4 then inptD($i,$values[$i],1,$buttontype[$i],$buttonaction[$i],$specialkeys[$i])
			$sentKeys[$i]=False

        $pressed[$i] = False
        $firstPressDone[$i] = False
EndIf


if not $keys[$i] Then
	if $ToggleOn[$i]=False then
$alreadyTimerscroll[$i]=False
$timerscroll[$i]=0
;;;;$pressed[$i] = False
	endif
endif



		if $ToggleOn[$i]=True and $buttontype[$i]=2 Then  scrollWheelT($i,$values[$i])	  ; Toggle with ScrollWheel
		if $SimpleMacroOn[$i]=True Then	Sequence($i,$values[$i],2,$buttontype[$i])		  ; Sequence
		if $comboasyncOn[$i]=True Then comboasync($i,$values[$i],0,$buttontype[$i])		  ; ComboAsyncOn

		if $combo[$i]=True and not $keys[$i] Then $pressed[$i] = False
Next
endfunc



func inpt($ix,$value,$state,$btype,$baction,$specialkey)

switch $baction
	case 0 ; normal key
		;sender($ix,$value,$state,$btype)
		sender($ix,$value,$state,$btype,$specialkey)
	case 1 ; Toggle
		Toggle($ix,$value,0,$btype)
	case 2 ; Turbo
		;
	case 3 ; TurboToggle
$released[$ix]=False
$TurboToggleOn[$ix]=not $TurboToggleOn[$ix]
	case 4 ; executes
		executes($ix,$value)
	case 5 ; combo
		Combo($ix,$value,$state,$btype)
	case 6 ; comboasync
		Comboasync($ix,$value,$state,$btype)
	case 7 ; ToggleCombo
		ToggleCombo($ix,$value,0,$btype)
	case 8 ; TurboCombo
		;
	case 9 ; TurboToggleCombo
$released[$ix]=False
$TurboToggleComboOn[$ix]=not $TurboToggleComboOn[$ix]
	case 10; Sequence
		Sequence($ix,$value,$state,$btype)
	case 11; Text
		senderText($ix,$value,$state)
endswitch

endfunc


func sender($ix,$value,$state,$btype,$specialkey)

switch $btype
	Case 0
		switch $state
		  case 0
			if $specialkey=False then
		   send ("{" & $value & " down}")
			else
		   local $val=exception($value)
		   $value=$val[0]
		   $code=$val[1]
		   $flags=$val[2]
		   DllCall("user32.dll", "none", "keybd_event", "byte", $value, "byte", $code, "long", $flags, "ptr", 0)
		  endif
		  case 1
			if $specialkey=False then
		   send ("{" & $value & " up}")
			else
			local $val=exception($value)
		   $value=$val[0]
		   $code=$val[1]
		   $flags=$val[2]
			 DllCall("user32.dll", "none", "keybd_event", "byte", $value, "byte", $code, "long",  BitOR($flags, 0x0002), "ptr", 0)
		  endif
		  case 2
		   ;$$value=Stringlower($value)
		   send("{"&$value&"}")
		  case 3
		   if $specialkey=False then
		   send ("{" & $value & " down}")
		   send ("{" & $value & " up}")
		   else
			local $val=exception($value)
		   $value=$val[0]
		   $code=$val[1]
		   $flags=$val[2]
		   DllCall("user32.dll", "none", "keybd_event", "byte", $value, "byte", $code, "long", $flags, "ptr", 0)
		   DllCall("user32.dll", "none", "keybd_event", "byte", $value, "byte", $code, "long",  BitOR($flags, 0x0002), "ptr", 0)
		   endif
		endswitch
	Case 1
		switch $state
		  case 0
		   MouseDown($value)
		  case 1
		   MouseUp($value)
		  case 2, 3
		   ;$value=Stringlower($value)
		   MouseDown($value)
		   MouseUp($value)
		endswitch
	Case 2
		if $state=0 then scrollwheelT($ix,$value)
endswitch

endfunc

func exception($value)

Switch $value
	case "Lctrl"
		$value = $VK_LCONTROL
		$code  = 0x1D
		$flags = 0
	case "LAlt"
		$value = $VK_LMENU
		$code  = 0x38
		$flags = 0
	case "RAlt"
		$value = $VK_RMENU
		$code  = 0x38
		$flags = 0x0001
	case "Rctrl"
		$value = $VK_RCONTROL
		$code  = 0x1D
		$flags = 0x0001
	case "Lwin"
		$value = $VK_LWIN
		$code  = 0x5B
		$flags = 0x0001
	case "Rwin"
		$value = $VK_RWIN
		$code  = 0x5C
		$flags = 0x0001
endswitch

	local $val[3]
	$val[0]=$value
	$val[1]=$code
	$val[2]=$flags

	return $val
endfunc


func sendertext($ix,$value, $state)

if $state=0 then send($value)

endfunc

func scrollwheelT($ix,$value)

	if ($Analogscrollrepeat=1 and ($ix>=17 or $ix=6 or $ix=7)) or ($Digitalscrollrepeat=1 and $ix<17 and $ix<>6 and $ix<>7) then
		if $ToggleOn[$ix]=False then $pressed[$ix]=False

		if $alreadytimerscroll[$ix]=False then
		scrollwheel($ix,$value)
		$alreadytimerscroll[$ix]=True
		$timerscroll[$ix]=TimerInit()

		elseif TimerDiff($timerscroll[$ix])>150 then
		scrollwheel($ix,$value)
		$timerscroll[$ix]=TimerInit()
		endif

	Else
	scrollwheel($ix,$value)
	endif


	endfunc


func Toggle($ix,$value,$state,$btype)

	if $toggleOn[$ix]=False and $keys[$ix]=True Then
	$toggleOn[$ix]=True

	sender($ix,$value,0,$btype,$specialkeys[$ix])

	elseif $toggleOn[$ix]=True and $keys[$ix]=True then
	$toggleOn[$ix]=False
	sender($ix,$value,1,$btype,$specialkeys[$ix])
	endif

endfunc


func Turbo($ix,$value,$state,$btype)
	if $alreadyTimer[$ix]=False then
	sender($ix,$value,$state,$btype,$specialkeys[$ix])
	$alreadyTimer[$ix]=True
	$timerT[$ix]=_Timer_Init()
	endif

	if _Timer_Diff($timerT[$ix])>$repeatTime then
	sender($ix,$value,$state,$btype,$specialkeys[$ix])
	$timerT[$ix]=_Timer_Init()
	endif
endfunc


func Turbo3($ix,$value,$state,$btype)
	if $alreadyTimer[$ix]=False then
	sender($ix,$value,0,$btype,$specialkeys[$ix])
	$alreadyTimer[$ix]=True
	$timerT[$ix]=_Timer_Init()
	endif

	if _Timer_Diff($timerT[$ix])>$repeatTime then
	sender($ix,$value,0,$btype,$specialkeys[$ix])
	sender($ix,$value,1,$btype,$specialkeys[$ix])
	$timerT[$ix]=_Timer_Init()
	endif
endfunc



func TurboCombo($ix,$value,$state,$btype)

	if $TurboComboalreadyTimer[$ix]=False then

	for $k=1 to Ubound($Turbocombokeys,$UBOUND_COLUMNS)-1

			if $Turbocombokeys[$ix][$k] then
				sender($ix,$Turbocombokeys[$ix][$k],$state,$TurbocomboType[$ix][$k],$specialkeys2DCombo[$ix][$k])
				$sentkeys[$ix]=True
			endif
	next

	$TurboComboalreadyTimer[$ix]=True
	$TurboCombotimerT[$ix]=_Timer_Init()
	endif


	if _Timer_Diff($TurboCombotimerT[$ix])>$repeatTime then

	for $ki=1 to Ubound($Turbocombokeys,$UBOUND_COLUMNS)-1

			if $Turbocombokeys[$ix][$ki] then
				sender($ix,$Turbocombokeys[$ix][$ki],$state,$TurbocomboType[$ix][$ki],$specialkeys2DCombo[$ix][$k])
				$sentkeys[$ix]=True
			endif
	next

	$TurboCombotimerT[$ix]=_Timer_Init()
	;$pressed[$i]=False
	endif

endfunc


func inptD($ix,$value,$state,$btype,$baction,$specialkey)

switch $baction
	case 0 ; normal key
		sender($ix,$value,$state,$btype,$specialkey)
	case 1 ; Toggle
		Toggle($ix,$value,0,$btype)
	case 2 ; Turbo not available in keysDesktop
		sender($ix,$value,$state,$btype,$specialkey)
	case 3 ; TurboToggle not available in keysDesktop
		sender($ix,$value,$state,$btype,$specialkey)
	case 4 ; executes
		executes($ix,$value)
	case 5 ; combo
		Combo($ix,$value,$state,$btype)
	case 6 ; comboasync
		Comboasync($ix,$value,$state,$btype)
	case 7 ; ToggleCombo
		ToggleCombo($ix,$value,0,$btype)
	case 8 ; TurboCombo not available
		sender($ix,$value,$state,$btype,$specialkey)
	case 9 ; TurboToggleCombo not available
		sender($ix,$value,$state,$btype,$specialkey)
	case 10; Sequence
		Sequence($ix,$value,$state,$btype)
	case 11; Text
		senderText($ix,$value,$state)
endswitch

endfunc


func ToggleCombo($ix,$value,$state,$btype)

	if $toggleComboOn[$ix]=False and $keys[$ix]=True Then
	$toggleComboOn[$ix]=True


	for $k=1 to Ubound($Togglecombokeys,$UBOUND_COLUMNS)-1
		if $Togglecombokeys[$ix][$k] then
			sender($ix,$Togglecombokeys[$ix][$k],0,$TogglecomboType[$ix][$k],$specialkeys2DCombo[$ix][$k])
			$sentkeys[$ix]=True
		endif
	next


	elseif $toggleComboOn[$ix]=True and $keys[$ix]=True then
	$toggleComboOn[$ix]=False

	for $k=1 to Ubound($combokeys,$UBOUND_COLUMNS)-1
			if $Togglecombokeys[$ix][$k] then sender($ix,$Togglecombokeys[$ix][$k],1,$TogglecomboType[$ix][$k],$specialkeys2DCombo[$ix][$k])
	next


	endif

endfunc

func COMBO($ix,$value,$state,$btype)
	for $k=1 to Ubound($combokeys,$UBOUND_COLUMNS)-1
		if $combokeys[$ix][$k]="" then continueloop
			$sentkeys[$ix]=True
			sender($ix,$combokeys[$ix][$k],$state,$combotype[$ix][$k],$specialkeys2DCombo[$ix][$k])
	next
endfunc


func COMBOasync($ix,$value,$state,$btype)

if $state=1 then return

	if $alreadytimerasync[$ix]=False then
	$comboasyncOn[$ix]=True
		if $combokeysasync[$ix][1] then
			sender($ix,$combokeysasync[$ix][1],0,$comboAsyncType[$ix][1],$specialkeys2DCombo[$ix][1])
			$sentkeys[$ix]=True
		endif
	$timerasync[$ix]=TimerInit()
	$alreadytimerasync[$ix]=True
	$combK[$ix]=1
	endif

if $comboasyncOn[$ix]=True then

	if TimerDiff($timerasync[$ix])>$combotime then
			if $combK[$ix]<$comboasyncNum[$ix] then $combK[$ix]+=1
		if $combokeysasync[$ix][$combK[$ix]] then
			sender($ix,$combokeysasync[$ix][$combK[$ix]],0,$comboAsyncType[$ix][$combK[$ix]],$specialkeys2DCombo[$ix][$combK[$ix]])
			$sentkeys[$ix]=True
		endif
	$timerasync[$ix]=TimerInit()
	endif


	if $combK[$ix]>=$comboasyncNum[$ix] then
	for $k=1 to $comboasyncNum[$ix]
		if $combokeysasync[$ix][$k]="" then ContinueLoop
			sender($ix,$combokeysasync[$ix][$k],1,$comboAsyncType[$ix][$k],$specialkeys2DCombo[$ix][$k])
			$sentkeys[$ix]=True
	next
	$comboasyncOn[$ix]=False
	$alreadytimerasync[$ix]=False
	$timerasync[$ix]=0
	endif

endif
;consolewrite("On: "&$comboAsyncOn[$ix] &" Num: "&$comboasyncNum[$ix]& " counter: "&$combK[$ix] & " key: "& $combokeysasync[$ix][$combK[$ix]]& @CRLF)
endfunc



func Sequence($ix,$value,$state,$btype)

if $state=1 then return

	if $alreadytimerSimplemacro[$ix]=False then
	$simpleMacroOn[$ix]=True
		if $simpleMacrokeys[$ix][1] then
			sender($ix,$simpleMacrokeys[$ix][1],3,$simpleMacroType[$ix][1],$specialkeys2DSequence[$ix][1])
			$sentkeys[$ix]=True
		endif
	$timerSimpleMacro[$ix]=TimerInit()
	$alreadytimerSimplemacro[$ix]=True
	$SmacroK[$ix]=1
	endif


if $simpleMacroOn[$ix]=True then

	if TimerDiff($timerSimpleMacro[$ix])>$SequenceTime then
			if $SmacroK[$ix]<$SequenceNum[$ix] then $SmacroK[$ix]+=1
		if $simpleMacrokeys[$ix][$SmacroK[$ix]] then
			sender($ix,$simpleMacrokeys[$ix][$SmacroK[$ix]],$state,$simpleMacroType[$ix][$SmacroK[$ix]],$specialkeys2DSequence[$ix][$SmacroK[$ix]])
			$sentkeys[$ix]=True
		endif
	$timerSimpleMacro[$ix]=TimerInit()
	endif


	if $SmacroK[$ix]>=$SequenceNum[$ix] then
		$simpleMacroOn[$ix]=False
		$alreadytimerSimplemacro[$ix]=False
		$timerSimpleMacro[$ix]=0
	endif

endif
;consolewrite("SeqOn: "&$simpleMacroOn[$ix] &" Num: "&$sequenceNum& " counter: "&$SmacroK[$ix] & " key: "&$simpleMacrokeys[$ix][$SmacroK[$ix]] & @CRLF)

endfunc


Func ScrollWheel($k,$dir)
local $ver
local $mult

if $WheelAnalogMode=1 and ($k>=17 or $k=6 or $k=7) and $ToggleOn[$k]=False then

	if $k>=17 then
	$v=$k-17
	local $values=[$LSY, $LSY, $LSX, $LSX,   $RSY,$RSY, $RSX,$RSX]
	$value=$values[$v]
	$mul=1
	else
	$vt=$k-6
	local $values=[$LT, $RT]
	$value=$values[$vt]
	$mul=100
	endif


		 if $UseSameWheelSpeedLimiter = 1 then
			$WheelSpeedLimiterUp=$WheelSpeedLimiter
			$WheelSpeedLimiterDown=$WheelSpeedLimiter
		 endif

		Local $stepsUp = Ceiling(Abs($value)/ $WheelSpeedLimiterUp*$mul)
		Local $stepsDown = Ceiling(Abs($value)/ $WheelSpeedLimiterDown*$mul)


	if $dir = "up" Then
	$steps=$stepsUp
	elseif $dir = "down" Then
	$steps=$stepsDown
	endif



		if $value <>0 then MouseWheel($dir, $steps)
		;$pressed[$k]=False

else

		if $dir="down" then
			MouseWheel($MOUSE_WHEEL_DOWN, $wheelstepdown)
		Elseif $dir="up" then
            MouseWheel($MOUSE_WHEEL_UP, $wheelstepup)
		endif

endif


EndFunc



func parse()

for $i=0 to Ubound($values)-1
	if (StringInStr($values[$i], "[Toggle]")) Then
		$toggle[$i]=True
		$values[$i]= stringreplace ($values[$i],"[Toggle]","")
		$values[$i]= StringStripWS($values[$i],8)
		$buttonaction[$i]=1
		endif

	if (StringInStr($values[$i], "[TURBO]")) Then
		$Turbo[$i]=True
		;$values[$i]=Stringlower($values[$i])
		$values[$i]= stringreplace($values[$i],"[Turbo]","")
		$values[$i]= StringStripWS($values[$i],8)
		$buttonaction[$i]=2
	endif

	if (StringInStr($values[$i], "[TURBOtoggle]")) Then
		$TurboToggle[$i]=True
		;$values[$i]=Stringlower($values[$i])
		$values[$i]= stringreplace($values[$i],"[TurboToggle]","")
		$values[$i]= StringStripWS($values[$i],8)
		$buttonaction[$i]=3
	endif


	if (StringInStr($values[$i], "[execute]")) Then
	$execute[$i]=True
	$values[$i]= stringreplace($values[$i],"[execute]","")
	$values[$i]= StringStripWS($values[$i],3)
	$buttonaction[$i]=4
	endif


		if (StringInStr($values[$i], "[COMBO]")) Then
		$Combo[$i]=True
		$values[$i]=stringreplace($values[$i],"[COMBO]","")
		local $combokeysL=StringSplit($values[$i],",")
			if $combokeysL[0]>$combosize-1 then $combokeysL[0]=$combosize-1

		for $j=1 to $combokeysL[0]
			$combokeys[$i][$j]=$combokeysL[$j]
			;$combokeys[$i][$j]=Stringlower($combokeys[$i][$j])
			$combokeys[$i][$j]=StringStripWS($combokeys[$i][$j],8)
			$keysfromcombo[$i]&= "{" & ($combokeys[$i][$j]) & "}"
			$keysfromcombodown[$i]&= "{" & ($combokeys[$i][$j]) & " down} "
			$keysfromcomboup[$i]&= "{" & ($combokeys[$i][$j]) & " up} "

			local $val=buttontype($combokeys,$combotype,$i,$j)
			$combokeys[$i][$j]=$val[0]
			$combotype[$i][$j]=$val[1]

			if $combokeys[$i][$j]= "Lctrl" or $combokeys[$i][$j]="Lalt" or $combokeys[$i][$j]="Lwin" or $combokeys[$i][$j]="Rwin" or $combokeys[$i][$j]="Rctrl" or $combokeys[$i][$j]="Ralt" then $specialkeys2DCombo[$i][$j]=True
		next

		$values[$i]=$keysfromcombo[$i]

	$buttonaction[$i]=5
	endif



	if (StringInStr($values[$i], "[COMBOasync]")) Then
		$ComboAsync[$i]=True
		$values[$i]=stringreplace($values[$i],"[COMBOasync]","")
		 local $combokeysLasync=StringSplit($values[$i],",")
			if $combokeysLasync[0]>$combosize-1 then $combokeysLasync[0]=$combosize-1
			$comboasyncNum[$i]=$combokeysLasync[0]
			;msgbox("","",$i &" "&$comboasyncnum[$i])


		for $j=1 to $combokeysLasync[0]
			$combokeysasync[$i][$j]=$combokeysLasync[$j]
			$combokeysasync[$i][$j]=StringStripWS($combokeysasync[$i][$j],8)
			$keysfromcomboasync[$i]&= "{" & ($combokeysasync[$i][$j]) & "}"
			$keysfromcombodownasync[$i]&= "{" & ($combokeysasync[$i][$j]) & " down} "
			$keysfromcomboupasync[$i]&= "{" & ($combokeysasync[$i][$j]) & " up} "
			$comboasynctype[$i][$j]=$buttontype[$i]

			local $val=buttontype($combokeysasync,$comboasynctype,$i,$j)
			$combokeysasync[$i][$j]=$val[0]
			$comboasynctype[$i][$j]=$val[1]

			if $combokeysasync[$i][$j]= "Lctrl" or $combokeysasync[$i][$j]="Lalt" or $combokeysasync[$i][$j]="Lwin" or $combokeysasync[$i][$j]="Rwin" or $combokeysasync[$i][$j]="Rctrl" or $combokeysasync[$i][$j]="Ralt" then $specialkeys2DCombo[$i][$j]=True
		next

	$values[$i]=$keysfromcomboasync[$i]
	$async[$i] = True

	$buttonaction[$i]=6

	endif



	if (StringInStr($values[$i], "[ToggleCOMBO]")) Then
		$ToggleCombo[$i]=True
		$values[$i]=stringreplace($values[$i],"[ToggleCOMBO]","")
		local $TogglecombokeysL=StringSplit($values[$i],",")
			if $TogglecombokeysL[0]>$combosize-1 then $TogglecombokeysL[0]=$combosize-1

		for $j=1 to $TogglecombokeysL[0]
			$Togglecombokeys[$i][$j]=$TogglecombokeysL[$j]
			;$Togglecombokeys[$i][$j]=Stringlower($Togglecombokeys[$i][$j])
			$Togglecombokeys[$i][$j]=StringStripWS($Togglecombokeys[$i][$j],8)
			$Togglekeysfromcombo[$i]&= "{" & ($Togglecombokeys[$i][$j]) & "}"
			$Togglekeysfromcombodown[$i]&= "{" & ($Togglecombokeys[$i][$j]) & " down} "
			$Togglekeysfromcomboup[$i]&= "{" & ($Togglecombokeys[$i][$j]) & " up} "
			$ToggleComboType[$i][$j]=$buttontype[$i]

			local $val=buttontype($Togglecombokeys,$Togglecombotype,$i,$j)
			$Togglecombokeys[$i][$j]=$val[0]
			$Togglecombotype[$i][$j]=$val[1]

			if $Togglecombokeys[$i][$j]= "Lctrl" or $Togglecombokeys[$i][$j]="Lalt" or $Togglecombokeys[$i][$j]="Lwin" or $Togglecombokeys[$i][$j]="Rwin" or $Togglecombokeys[$i][$j]="Rctrl" or $Togglecombokeys[$i][$j]="Ralt" then $specialkeys2DCombo[$i][$j]=True
		next

		$values[$i]=$Togglekeysfromcombo[$i]

	$buttonaction[$i]=7
	endif


		if (StringInStr($values[$i], "[TurboCOMBO]")) Then
		$TurboCombo[$i]=True
		$values[$i]=stringreplace($values[$i],"[TurboCOMBO]","")
		local $TurbocombokeysL=StringSplit($values[$i],",")
			if $TurbocombokeysL[0]>$combosize-1 then $TurbocombokeysL[0]=$combosize-1

		for $j=1 to $TurbocombokeysL[0]
			$Turbocombokeys[$i][$j]=$TurbocombokeysL[$j]
			;$Turbocombokeys[$i][$j]=Stringlower($Turbocombokeys[$i][$j])
			$Turbocombokeys[$i][$j]=StringStripWS($Turbocombokeys[$i][$j],8)
			$Turbokeysfromcombo[$i]&= "{" & ($Turbocombokeys[$i][$j]) & "}"
			$Turbokeysfromcombodown[$i]&= "{" & ($Turbocombokeys[$i][$j]) & " down} "
			$Turbokeysfromcomboup[$i]&= "{" & ($Turbocombokeys[$i][$j]) & " up} "
			$TurboComboType[$i][$j]=$buttontype[$i]

			local $val=buttontype($Turbocombokeys,$Turbocombotype,$i,$j)
			$Turbocombokeys[$i][$j]=$val[0]
			$Turbocombotype[$i][$j]=$val[1]

			if $Turbocombokeys[$i][$j]= "Lctrl" or $Turbocombokeys[$i][$j]="Lalt" or $Turbocombokeys[$i][$j]="Lwin" or $Turbocombokeys[$i][$j]="Rwin" or $Turbocombokeys[$i][$j]="Rctrl" or $Turbocombokeys[$i][$j]="Ralt" then $specialkeys2DCombo[$i][$j]=True
		next

		$values[$i]=$Turbokeysfromcombo[$i]

	$buttonaction[$i]=8
	endif




		if (StringInStr($values[$i], "[TurboToggleCOMBO]")) Then
		$TurboCombo[$i]=True
		$values[$i]=stringreplace($values[$i],"[TurboToggleCOMBO]","")
		local $TurbocombokeysL=StringSplit($values[$i],",")

		if $TurbocombokeysL[0]>$combosize-1 then $TurbocombokeysL[0]=$combosize-1

		for $j=1 to $TurbocombokeysL[0]
			$Turbocombokeys[$i][$j]=$TurbocombokeysL[$j]
			;$Turbocombokeys[$i][$j]=Stringlower($Turbocombokeys[$i][$j])
			$Turbocombokeys[$i][$j]=StringStripWS($Turbocombokeys[$i][$j],8)
			$Turbokeysfromcombo[$i]&= "{" & ($Turbocombokeys[$i][$j]) & "}"
			$Turbokeysfromcombodown[$i]&= "{" & ($Turbocombokeys[$i][$j]) & " down} "
			$Turbokeysfromcomboup[$i]&= "{" & ($Turbocombokeys[$i][$j]) & " up} "
			$TurboComboType[$i][$j]=$buttontype[$i]

			local $val=buttontype($Turbocombokeys,$Turbocombotype,$i,$j)
			$Turbocombokeys[$i][$j]=$val[0]
			$Turbocombotype[$i][$j]=$val[1]

			if $Turbocombokeys[$i][$j]= "Lctrl" or $Turbocombokeys[$i][$j]="Lalt" or $Turbocombokeys[$i][$j]="Lwin" or $Turbocombokeys[$i][$j]="Rwin" or $Turbocombokeys[$i][$j]="Rctrl" or $Turbocombokeys[$i][$j]="Ralt" then $specialkeys2DCombo[$i][$j]=True
		next

		$values[$i]=$Turbokeysfromcombo[$i]
	$buttonaction[$i]=9

		endif


		if (StringInStr($values[$i], "[Sequence]")) Then
		$SimpleMacro[$i]=True
		$values[$i]=stringreplace($values[$i],"[Sequence]","")
		local $simpleMacrokeysL=StringSplit($values[$i],",")
			if $simpleMacrokeysL[0]>$SequenceMax-1 then $simpleMacrokeysL[0]=$SequenceMax-1
				$SequenceNum[$i]=$simpleMacrokeysL[0]

		for $j=1 to $simpleMacrokeysL[0]
			$SimpleMacroKeys[$i][$j]=$SimpleMacroKeysL[$j]
			;$SimpleMacroKeys[$i][$j]=Stringlower($SimpleMacroKeys[$i][$j])
			$SimpleMacroKeys[$i][$j]=StringStripWS($SimpleMacroKeys[$i][$j],8)
			$KeysFromSimpleMacro[$i]&= "{" & ($SimpleMacroKeys[$i][$j]) & "}"

			local $val=buttontype($simpleMacroKeys,$simpleMacrotype,$i,$j)
			$simpleMacroKeys[$i][$j]=$val[0]
			$simpleMacrotype[$i][$j]=$val[1]

			if $simpleMacroKeys[$i][$j]= "Lctrl" or $simpleMacroKeys[$i][$j]="Lalt" or $simpleMacroKeys[$i][$j]="Lwin" or $simpleMacroKeys[$i][$j]="Rwin" or $simpleMacroKeys[$i][$j]="Rctrl" or $simpleMacroKeys[$i][$j]="Ralt" then $specialkeys2DSequence[$i][$j]=True

		next

		$values[$i]=$KeysFromSimpleMacro[$i]

	$buttonaction[$i]=10
		endif



		if (StringInStr($values[$i], "[TEXT]")) Then
		$Text[$i]=True
		$values[$i]=stringreplace($values[$i],"[TEXT]","")
		if stringlen($values[$i])>=$stringmax then $values[$i]=Stringleft($values[$i],$stringmax)

		$buttonaction[$i]=11
		endif




;#comments-start

if $buttonaction[$i]<5 then

if $values[$i]= "LBmouse" or $values[$i]= "RBmouse" or $values[$i]= "MBmouse" Then
$buttontype[$i]=1
elseif $values[$i]="WheelUp" or $values[$i]="WheelDown" Then
$buttontype[$i]=2
endif

if $values[$i]="LBmouse" then $values[$i]="left"
if $values[$i]="RBmouse" then $values[$i]="right"
if $values[$i]="MBmouse" then $values[$i]="middle"

if $values[$i]="WheelUp" then $values[$i]="up"
if $values[$i]="WheelDown" then $values[$i]="down"


if $values[$i]= "Lctrl" or $values[$i]="Lalt" or $values[$i]="Lwin" or $values[$i]="Rwin" or $values[$i]="Rctrl" or $values[$i]="Ralt" then $specialkeys[$i]=True


endif

;#comments-end





next

endfunc




func buttontype($array,$typee,$i,$j)

if $array[$i][$j]= "LBmouse" or $array[$i][$j]= "RBmouse" or $array[$i][$j]= "MBmouse" Then
$typee[$i][$j]=1
elseif $array[$i][$j]="WheelUp" or $array[$i][$j]="WheelDown" Then
$typee[$i][$j]=2
Else
$typee[$i][$j]=0
endif

if $array[$i][$j]="LBmouse" then $array[$i][$j]="left"
if $array[$i][$j]="RBmouse" then $array[$i][$j]="right"
if $array[$i][$j]="MBmouse" then $array[$i][$j]="middle"

if $array[$i][$j]="WheelUp" then $array[$i][$j]="up"
if $array[$i][$j]="WheelDown" then $array[$i][$j]="down"

local $val[2]
$val[0]=$array[$i][$j]
$val[1]=$typee[$i][$j]

return $val

endfunc

func executes($ix,$value)
	shellexecute($value)
	endfunc


func mouse()
	 If TimerDiff($lastMouseMove) < 4 then Return

if $sticks=2 then
$mousemovx=$RSX*$mx
$mousemovy=$RSY*$my
else
$mousemovx=$LSX*$mx
$mousemovy=$LSY*$my

endif

    $mousePos = MouseGetPos()

	;If Abs($mousemovx) < $deadZone And Abs($mousemovy) < $deadZone Then
	;if $mousemovx<$Xrightdeadzone and $mousemovy<$Yupdeadzone and $mousemovx>-$Xleftdeadzone and $mousemovy>-$Ydowndeadzone then


	if $mousemovx<$Xrightdeadzone and $mousemovx>-$Xleftdeadzone then
		$mousemovx=0
		;$prevX = $mousePos[0]
	endif

	if $mousemovy<$Yupdeadzone and $mousemovy>-$Ydowndeadzone then
		$mousemovy=0
		;$prevY = $mousePos[1]
	endif


If $mousemovx = 0 And $mousemovy = 0 Then
    $prevX = $mousePos[0]
    $prevY = $mousePos[1]
    Return
EndIf


	;Rescale: output = (input - deadzone) / (max - deadzone)

if $deadzoneshape = 2 Then
$mousemovv=DeadzoneCircularSimple($mousemovx, $mousemovy,$Mousedeadzone)
$mousemovx=$mousemovv[0]
$mousemovy=$mousemovv[1]
elseif $deadzoneshape = 3 Then
$mousemovv=DeadzoneRescaleCircular($mousemovx, $mousemovy,$Mousedeadzone)
$mousemovx=$mousemovv[0]
$mousemovy=$mousemovv[1]
else
$mousemovx = DeadzoneRescale($mousemovx, $XleftDeadzone, $XrightDeadzone)
$mousemovy = DeadzoneRescale($mousemovy, $YdownDeadzone, $YupDeadzone)
endif


	$newX = $mousePos[0] + ($mousemovx / 32768) * $sensitivity
    $newY = $mousePos[1] - ($mousemovy / 32768) * $sensitivity

    $newX = Clip($newX, 0, @DesktopWidth)  ;1920
    $newY = Clip($newY, 0, @DesktopHeight) ;1080

	; Smooth movement - interpolation between current and target position
	; How smooth should the movement be? (1 = no smoothing, near 0 = very smooth, values below 0.1 may make the cursor too slow, 0 blocks the cursor – be cautious)

;;;;;;;;;;;;;;;;;
	;#comments-start
    ; Gradually calculate the mouse position
    $finalX = $prevX + ($newX - $prevX) * $smoothFactor
    $finalY = $prevY + ($newY - $prevY) * $smoothFactor

    ; Gradually move the mouse towards the calculated position
    MouseMove($finalX, $finalY, 0)  ; Set "0" for speed since interpolation is used


    $prevX = $finalX
    $prevY = $finalY
	;#comments-end
;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;
#comments-start
	MouseMove($newX, $newY, 0)

$prevX = $newX
$prevY = $newY
#comments-end
;;;;;;;;;;;;;;;;


	 $lastMouseMove = TimerInit()
endfunc


func DeadzoneRescale($mousemov,$deadzone1,$deadzone2)

	Local $max = 32768
	local $deadzone=0


	if ($mousemov<0) then
	$adjusted = $mousemov + $deadzone1
	$deadzone = $deadzone1
 If $adjusted > 0 Then $adjusted = 0
else
	;elseif($mousemov>=0) then
	 $adjusted = $mousemov - $deadzone2
	 $deadzone = $deadzone2
	  If $adjusted < 0 Then $adjusted = 0
	EndIf

	$adjusted=(($adjusted)/($max - $deadzone))*$max

	return $adjusted

endfunc


Func DeadzoneCircularSimple($x, $y, $deadzone)

    Local $out[2]
    Local $len = Sqrt(($x * $x) + ($y * $y))


    If $len <= $deadzone Then
        $out[0] = 0
        $out[1] = 0
        Return $out
    EndIf

    ; nessun rescale
    $out[0] = $x
    $out[1] = $y

    Return $out

EndFunc

Func DeadzoneRescaleCircular($x, $y, $deadzonee)
    Local $max = 32768
    Local $val[2]

    Local $len = Sqrt($x*$x + $y*$y)

    If $len <= $deadzonee Then
        $val[0] = 0
        $val[1] = 0
        Return $val
    EndIf

    ; rescale radiale
    Local $newLen = (($len - $deadzonee) / ($max - $deadzonee)) * $max
    Local $scale = $newLen / $len

    $val[0] = $x * $scale
    $val[1] = $y * $scale

    Return $val
EndFunc


Func Clip($value, $min, $max)
    If $value < $min Then
        Return $min
    ElseIf $value > $max Then
        Return $max
    Else
        Return $value
    EndIf
EndFunc



func buttons()
$input = _XInputGetInput($inputhwnd)
$buttons = _XInputButtons($input[2])

global $A=$buttons[12],$B=$buttons[13],$X=$buttons[14],$Y=$buttons[15],$start=$buttons[5],$back=$buttons[6],$LS=$buttons[7],$RS=$buttons[8],$LB=$buttons[9],$RB=$buttons[10],$Home=$buttons[11],$Up=$buttons[1],$Down=$buttons[2],$Left=$buttons[3],$Right=$buttons[4]
global $LT=$input[3],$RT=$input[4],	$LSX=$input[5], $LSY=$input[6], $RSX=$input[7], $RSY=$input[8], $LS=$buttons[7], $RS=$buttons[8]


$LSX=$LSX*$lx
$LSY=$LSY*$ly
$RSX=$RSX*$rx
$RSY=$RSY*$ry



switch $AnalogsDeadzoneType
	case 1
$LSleft  = $LSX<-3000 - $AnalogsDeadzone
$LSright = $LSX>3000  + $AnalogsDeadzone
$LSdown  = $LSY<-3000 - $AnalogsDeadzone
$LSup    = $LSY>3000  + $AnalogsDeadzone

$RSleft  = $RSX<-3000 - $AnalogsDeadzone
$RSright = $RSX>3000  + $AnalogsDeadzone
$RSdown  = $RSY<-3000 - $AnalogsDeadzone
$RSup    = $RSY>3000  + $AnalogsDeadzone
	case 2
$LSleft  = $LSX<-3000 - $LSdeadzone
$LSright = $LSX>3000  + $LSdeadzone
$LSdown  = $LSY<-3000 - $LSdeadzone
$LSup    = $LSY>3000  + $LSdeadzone

$RSleft  = $RSX<-3000 - $RSdeadzone
$RSright = $RSX>3000  + $RSdeadzone
$RSdown  = $RSY<-3000 - $RSdeadzone
$RSup    = $RSY>3000  + $RSdeadzone
	case 4
$LSleft  = $LSX<-3000 - $LSXdeadzone
$LSright = $LSX>3000  + $LSXdeadzone
$LSdown  = $LSY<-3000 - $LSYdeadzone
$LSup    = $LSY>3000  + $LSYdeadzone

$RSleft  = $RSX<-3000 - $RSXdeadzone
$RSright = $RSX>3000  + $RSXdeadzone
$RSdown  = $RSY<-3000 - $RSYdeadzone
$RSup    = $RSY>3000  + $RSYdeadzone
	case 8
$LSleft  = $LSX<-3000 - $LSleftDeadzone
$LSright = $LSX>3000  + $LSrightDeadzone
$LSdown  = $LSY<-3000 - $LSupDeadzone
$LSup    = $LSY>3000  + $LSdownDeadzone

$RSleft  = $RSX<-3000 - $RSleftDeadzone
$RSright = $RSX>3000  + $RSrightDeadzone
$RSdown  = $RSY<-3000 - $RSupDeadzone
$RSup    = $RSY>3000  + $RSdownDeadzone
endswitch

endfunc


Func _HighPrecisionSleep($iMicroSeconds,$hDll=False)
    Local $hStruct, $bLoaded
    If Not $hDll Then
        $hDll=DllOpen("ntdll.dll")
        $bLoaded=True
    EndIf
    $hStruct=DllStructCreate("int64 time;")
    DllStructSetData($hStruct,"time",-1*($iMicroSeconds*10))
    DllCall($hDll,"dword","ZwDelayExecution","int",0,"ptr",DllStructGetPtr($hStruct))
    If $bLoaded Then DllClose($hDll)
EndFunc


Func _HighPrecisionSleep2($iMicroSeconds)
    Local $t = DllStructCreate("int64")
    DllStructSetData($t, 1, -($iMicroSeconds * 10))
    DllCall($hNTDLL, "dword", "ZwDelayExecution", "int", 0, "ptr", DllStructGetPtr($t))
EndFunc



Func _Sleep($ms)
    DllCall("kernel32.dll", "DWORD", "Sleep", "int", $ms)
EndFunc

func loadini()

global $AnalogToMouse=IniRead($inifile,"Mouse","AnalogToMouse","")
global $Stick=IniRead($inifile,"Mouse","Stick","")
global $splash=IniRead($inifile,"Other","ShowConfigReloadMessage","1"), $splashExit=IniRead($inifile,"Other","ShowForceQuitMessage","1"), $splashEx=0

global $LSXinverted=IniRead($inifile,"Mouse","LSXaxisInverted",0),$LSYinverted=IniRead($inifile,"Mouse","LSYaxisInverted",0),$RSXinverted=IniRead($inifile,"Mouse","RSXaxisInverted",0),$RSYinverted=IniRead($inifile,"Mouse","RSYaxisInverted",0)

global $sensitivity=Iniread($inifile,"Mouse","Sensitivity","")
global $smoothFactor=Iniread($inifile,"Mouse","SmoothFactor","")

global $Xleftdeadzone=IniRead($inifile,"Mouse","XleftDeadzone",2000),$Xrightdeadzone=IniRead($inifile,"Mouse","XrightDeadzone",2000),$Yupdeadzone=IniRead($inifile,"Mouse","YupDeadzone",2000),$Ydowndeadzone=IniRead($inifile,"Mouse","YdownDeadzone",2000)
global $Xdeadzone=IniRead($inifile,"Mouse","Xdeadzone",2000), $Ydeadzone=IniRead($inifile,"Mouse","Ydeadzone",2000)
$MouseDeadzone=IniRead($inifile,"Mouse","Deadzone",2000)
$MouseDeadzoneType=IniRead($inifile,"Mouse","DeadzoneType",1)


global $LSleftdeadzone=IniRead($inifile,"Analogs","LSleftDeadzone",0),$LSrightdeadzone=IniRead($inifile,"Analogs","LSrightDeadzone",0),$LSupdeadzone=IniRead($inifile,"Analogs","LSupDeadzone",0),$LSdowndeadzone=IniRead($inifile,"Analogs","LSdownDeadzone",0)
global $RSleftdeadzone=IniRead($inifile,"Analogs","RSleftDeadzone",0),$RSrightdeadzone=IniRead($inifile,"Analogs","RSrightDeadzone",0),$RSupdeadzone=IniRead($inifile,"Analogs","RSupDeadzone",0),$RSdowndeadzone=IniRead($inifile,"Analogs","RSdownDeadzone",0)
global $LSXdeadzone=IniRead($inifile,"Analogs","LSXdeadzone",0), $LSYdeadzone=IniRead($inifile,"Analogs","LSYdeadzone",0), $RSXdeadzone=IniRead($inifile,"Analogs","RSXdeadzone",0), $RSYdeadzone=IniRead($inifile,"Analogs","RSYdeadzone",0)
global $LSdeadzone=IniRead($inifile,"Analogs","LSdeadzone",0), $RSDeadzone=IniRead($inifile,"Analogs","RSdeadzone",0)
global $AnalogsDeadzone=IniRead($inifile,"Analogs","Deadzone",0)
global $AnalogsDeadzoneType=IniRead($inifile,"Analogs","DeadzoneType",1)

global $LSXaxisInverted=IniRead($inifile,"Analogs","LSXaxisInverted",0), $LSYaxisInverted=IniRead($inifile,"Analogs","LSYaxisInverted",0), $RSXaxisInverted=IniRead($inifile,"Analogs","RSXaxisInverted",0), $RSYaxisInverted=IniRead($inifile,"Analogs","RSYaxisInverted",0)

global $wheelstepup=IniRead($inifile,"Wheel","WheelStepUp",1), $wheelstepdown=IniRead($inifile,"Wheel","WheelStepDown",1)
Global $WheelSpeedLimiterUp = IniRead($inifile,"Wheel","WheelSpeedLimiterUp",8500), $WheelSpeedlimiterDown = IniRead($inifile,"Wheel","WheelSpeedLimiterDown",8500)
Global $UseSameWheelSpeedLimiter = IniRead($inifile,"Wheel","UseSameWheelSpeedLimiter",1), $WheelSpeedLimiter = IniRead($inifile,"Wheel","WheelSpeedLimiter",8500)
Global $WheelAnalogMode = IniRead($inifile,"Wheel","WheelAnalogMode",1), $Digitalscrollrepeat = IniRead($inifile,"Wheel","DigitalScrollrepeat",1),$Analogscrollrepeat = IniRead($inifile,"Wheel","AnalogScrollrepeat",1)
global $dir, $steps

global $deadzoneshape = IniRead($inifile,"Mouse","DeadzoneShape",1)
global $repeatTime = IniRead($inifile,"Other","TurboRepeatTime",50)
global $combotime = IniRead($inifile,"Other","ComboAsyncDelay",50), $SimpleMacroTime= IniRead($inifile,"Other","SimpleMacroTime",50)

If $AnalogToMouse <> "1" and $AnalogToMouse <> "0" Then	$AnalogToMouse=0
if $MouseDeadzoneType<> 1 and $MouseDeadzoneType <>  2 and $MouseDeadzoneType <>  4 then  $MouseDeadzoneType=1
if $AnalogsDeadzoneType<> 1 and $AnalogsDeadzoneType <>  2 and $AnalogsDeadzoneType <>  4 and $AnalogsDeadzoneType <> 8 then $AnalogsDeadzoneType=1

global $sendkeystype = Iniread($inifile, "Other","SendKeysType",1)
global $hotkey =Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","Hotkey","^+5") 	;default: Ctrl+Shift+5
$hotkey=String($hotkey)
HotKeySet($hotkey, reloadini)

global $lx=1,$ly=1,	$rx=1,$ry=1, $sticks=0, $mx=1, $my=1


if $LSXaxisInverted=1 Then $lx=-1
if $LSYaxisInverted=1 Then $ly=-1
if $RSXaxisInverted=1 Then $rx=-1
if $RSYaxisInverted=1 Then $ry=-1


	if $Stick="LS" then
		$sticks=1
		if $LSXinverted="1" Then $mx=-1
		if $LSYinverted="1" Then $my=-1
	Elseif $Stick="RS" then
		$sticks=2
		if $RSXinverted="1" Then $mx=-1
		if $RSYinverted="1" Then $my=-1
	Endif


switch $MouseDeadzoneType
	case 1
	$XleftDeadzone=$MouseDeadzone
	$XrightDeadzone=$MouseDeadzone
	$YupDeadzone=$MouseDeadzone
	$YdownDeadzone=$MouseDeadzone
	case 2
	$XleftDeadzone=$Xdeadzone
	$XrightDeadzone=$Xdeadzone
	$YupDeadzone=$Ydeadzone
	$YdownDeadzone=$Ydeadzone
	;case 4
endswitch


global $asize=16+1+8
global $ef[$asize] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False ,False, False, False, False,False, False, False, False]
global $ez[$asize] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

global $keys[16+1+8]   = [$A, $B, $X, $Y, $LB, $RB, $LT, $RT, $back, $start, $LS, $RS, $Up, $Down, $Left, $Right, $Home, $LSup, $LSdown, $LSleft, $LSright, $RSup, $RSdown, $RSleft, $RSright]
global $pressed=$ef
;A, B, X, Y, LB, RB, LT , RT, back, start, LS, RS, UP, DOWN, LEFT, RIGHT, Home,  LSup,  LSdown, LSleft, LSright, RSup, RSdown, RSleft, RSright
;0  1  2  3  4   5   6    7   8     9      10  11  12  13    14    15     16     17	    18	    19	    20	     21	   22	   23	   24

global $values[16+1+8]=[iniR("A"),IniR("B"),IniR("X"),IniR("Y"),IniR("LB"),IniR("RB"),IniR("LT"),IniR("RT"),IniR("Back"),IniR("Start"),IniR("LS"),IniR("RS") _
,IniR("Dup"),IniR("Ddown"),IniR("Dleft"),IniR("Dright"),IniR("Home"),IniR("LSup"),IniR("LSdown"),IniR("LSleft"),IniR("LSright"),IniR("RSup"),IniR("RSdown"),IniR("RSleft"),IniR("RSright")]

global $toggle=$ef, $toggleOn=$ef,	$Turbo=$ef, $TurboToggle=$ef, $TurboToggleOn=$ef, $TurboOn=$ef, $alreadytimer=$ef, $alreadytimer2=$ef,		$TurboComboalreadyTimer=$ef, $TurboToggleComboalreadyTimer=$ef
global $TimerT[$asize], $TimerT2[$asize], $Timer[$asize], $timersplash,		$TurboComboTimerT[$asize]
global $released=$ef, $combo=$ef, $Comboasync=$ef,	$toup=$ef,		$comboOn=$ef, $combosize=11,	$SequenceMax=16,		$comboasyncOn=$ef,	$simpleMacroOn=$ef

global $ToggleComboOn=$ef, $ToggleCombo=$ef, $TurboCombo=$ef, $TurboToggleCombo=$ef,	$TurboComboOn=$ef, $TurboToggleOn=$ef, $TurboToggleComboOn=$ef
global $keysfromcombo[$asize], $combokeys[$asize][$combosize], $keysfromcomboup[$asize], $keysfromcombodown[$asize]
global $keysfromcomboasync[$asize], $combokeysasync[$asize][$combosize], $keysfromcomboupasync[$asize], $keysfromcombodownasync[$asize], $combK[$asize]
global $MacroOn=$ef, $macrosize=25, $Macrokeys[$asize][$macrosize]
global $stringmax=200,  $text=$ef ; $textOn=$ef, $textkeys[$asize][$stringsize]

global $Togglekeysfromcombo[$asize],$Togglecombokeys[$asize][$combosize],$Togglekeysfromcomboup[$asize],$Togglekeysfromcombodown[$asize]
global $Turbokeysfromcombo[$asize],$Turbocombokeys[$asize][$combosize],$Turbokeysfromcomboup[$asize],$Turbokeysfromcombodown[$asize]
;global $TurboTogglekeysfromcombo[$asize],$TurboTogglecombokeys[$asize][$combosize],$TurboTogglekeysfromcomboup[$asize],$TurboTogglekeysfromcombodown[$asize],		$TurboToggleComboTimerT[$asize], 	$releasedC=$ef
global $simplemacro[$asize], $macro[$asize],	$SmacroK[$asize], $SimpleMacroKeys[$asize][$SequenceMax], $keysfromSimpleMacro[$asize]
global $alreadyTimerSimpleMacro=$ef, $timerSimpleMacro=$ef

global $comboNum[$asize], $comboasyncNum[$asize], $sequenceNum[$asize], 		$ToggleComboNum[$asize],$turboComboNum[$asize]
global $ComboType[$asize][$combosize],	$comboAsyncType[$asize][$combosize],	$ToggleComboType[$asize][$combosize],	$TurboComboType[$asize][$combosize], $SimpleMacroType[$asize][$SequenceMax]

global $send[$asize]= [True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True]
global $async=$ef, $alreadytimerasync=$ef, $timerasync[$asize]

global $execute=$ef
global $buttonaction=$ez ;0: normal, 1: toggle, 2: turbo, 3: turbotoggle, 4: execute, 5: combo, 6: comboasync
global $buttontype=$ez   ;0: keyboard, 1:mousebutton, 2: scrollupdown

global $mousemovv[2]
global $alreadytimerscroll=$ef, $timerscroll[$asize]
Global $hNTDLL = DllOpen("ntdll.dll")
global $fkeys, $DW=@DesktopWidth/15,$DH=@DesktopHeight/18
global $specialkeys=$ef, $specialkeys2DCombo[$asize][$combosize], $specialkeys2DSequence[$asize][$SequenceMax]


parse()

If $AnalogToMouse = "1" Then
    If $Stick = "RS" Then
        global $ignoreIndices = [21,22,23,24]  ; RSup, RSdown, RSleft, RSright
		global $ignore[25] = [21,22,23,24]
    ElseIf $Stick = "LS" Then
		global $ignoreIndices = [17,18,19,20]  ; LSup, LSdown, LSleft, LSright
		global $ignore[25] = [17,18,19,20]
	;ElseIf $Stick = "LTRT" or $Stick = "RTLT"  Then
	;global $ignoreIndices = [6,7]  ;LT, RT
	;global $ignore[25] = [6,7]
    EndIf
EndIf


if $sendkeystype=2 then
$fkeys="keysDesktop"
Else
$fkeys="keys"
endif


endfunc

func timeout()
	if timerdiff($timersplash)>750 then
		SplashOff()
		AdlibUnRegister(timeout)
	endif
endfunc

func reloadini()
	loadini()
	if $splash=1 then
	$ST=SplashTextOn("","Config reloaded!",$DW,$DH,@DesktopWidth-$DW,@DesktopHeight-$DH,1,13*@DesktopWidth/2000,"",400)
	$timersplash=timerinit()
	AdlibRegister("timeout",50)
	endif
endfunc


func onexit()
	if $splashEx=1 then
	SplashTextOn("","Quitting",$DW,$DH,@DesktopWidth-$DW,@DesktopHeight-$DH,1,13*@DesktopWidth/2000,"",400)
	$timersplash=timerinit()
	AdlibRegister("timeout",50)
	sleep(1000)
	endif


	For $i = 0 To UBound($sentKeys) - 1
		If Not $sentKeys[$i] Then ContinueLoop
		if $values[$i]="" then continueloop
If ($sendkeystype=1 and $buttonaction[$i] <=4 and $sentkeys[$i]) or ($sentkeys[$i] and $sendkeystype=2 and ($buttonaction[$i]<>5 and $buttonaction[$i]>6 and $buttonaction[$i]<>7 and $buttonaction[$i]<>10)) then
	if $values[$i]="" then continueloop
	if $buttontype[$i]=0 Then Send("{" & $values[$i] & " up}")
	if $buttontype[$i]=1 then mouseup($values[$i])


Elseif ($sendkeystype=1 and $buttonaction[$i]>4) or ($sendkeystype=2 and ($buttonaction[$i]=5 or $buttonaction[$i]=6 or $buttonaction[$i]=7 or $buttonaction[$i]=10)) then


		For $k=1 To UBound($combokeys, $UBOUND_COLUMNS) - 1
		  If $sentKeys[$i] Then
            If $combokeys[$i][$k] <> "" Then Send("{" & $combokeys[$i][$k] & " up}")
		  endif
        Next

		For $k=1 To UBound($combokeysasync, $UBOUND_COLUMNS) - 1
		  If $sentKeys[$i] Then
            If $combokeysasync[$i][$k] <> "" Then Send("{" & $combokeysasync[$i][$k] & " up}")
		  endif
        Next

		For $k=1 To UBound($Togglecombokeys, $UBOUND_COLUMNS) - 1
		  If $sentKeys[$i] Then
            If $Togglecombokeys[$i][$k] <> "" Then Send("{" & $Togglecombokeys[$i][$k] & " up}")
		  endif
        Next

		For $k=1 To UBound($Turbocombokeys, $UBOUND_COLUMNS) - 1
		  If $sentKeys[$i] Then
            If $Turbocombokeys[$i][$k] <> "" Then Send("{" & $Turbocombokeys[$i][$k] & " up}")
		  Endif
		Next
Endif
	Next

up()

endfunc


func up()

		$value = $VK_LCONTROL
		$code  = 0x1D
		$flags = 0

	DllCall("user32.dll", "none", "keybd_event", "byte", $value, "byte", $code, "long",  BitOR($flags, 0x0002), "ptr", 0)

		$value = $VK_LMENU
		$code  = 0x38
		$flags = 0

	DllCall("user32.dll", "none", "keybd_event", "byte", $value, "byte", $code, "long",  BitOR($flags, 0x0002), "ptr", 0)

		$value = $VK_RMENU
		$code  = 0x38
		$flags = 0x0001

	DllCall("user32.dll", "none", "keybd_event", "byte", $value, "byte", $code, "long",  BitOR($flags, 0x0002), "ptr", 0)

		$value = $VK_RCONTROL
		$code  = 0x1D
		$flags = 0x0001

	DllCall("user32.dll", "none", "keybd_event", "byte", $value, "byte", $code, "long",  BitOR($flags, 0x0002), "ptr", 0)

		$value = $VK_LWIN
		$code  = 0x5B
		$flags = 0x0001

	DllCall("user32.dll", "none", "keybd_event", "byte", $value, "byte", $code, "long",  BitOR($flags, 0x0002), "ptr", 0)

		$value = $VK_RWIN
		$code  = 0x5C
		$flags = 0x0001

	DllCall("user32.dll", "none", "keybd_event", "byte", $value, "byte", $code, "long",  BitOR($flags, 0x0002), "ptr", 0)

endfunc



