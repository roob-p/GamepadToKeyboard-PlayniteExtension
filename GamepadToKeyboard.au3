#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=iconB2T.ico
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=GamepadToKeyboard (64 bit)
#AutoIt3Wrapper_Res_Fileversion=1.0.1.0
#AutoIt3Wrapper_Res_ProductName=GamepadToKeyboard
#AutoIt3Wrapper_Res_ProductVersion=1.0.1
#AutoIt3Wrapper_Res_CompanyName=roob-p (author)
#AutoIt3Wrapper_Res_LegalCopyright=roob-p (author)
#AutoIt3Wrapper_Res_LegalTradeMarks=roob-p (author)
#AutoIt3Wrapper_Res_Language=1040
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <_XInput.au3>
#include <AutoItConstants.au3>
#include <Misc.au3>
#pragma compile(UPX, false)



_singleton("Script")

OnAutoItExitRegister("Onexit")

$inputhwnd = _XInputInit()
$input = _XInputGetInput($inputhwnd)
$buttons = _XInputButtons($input[2])


$analogdeadzone=1
local $ignoreIndices[4]


if $cmdline[0]>0 then
if StringInStr($cmdline[1],".ini") then
	$inifile=$cmdline[1]
	else
;$inifile=@ScriptDir & "\configs.ini"
$inifile=IniRead(@ScriptDir & "\Standalone Profile Loader.config","configToLoad","configToLoad","")
endif
	Else
	;$inifile=@ScriptDir & "\default.ini"
	$inifile=IniRead(@ScriptDir & "\Standalone Profile Loader.config","configToLoad","configToLoad","")
	endif




global $A=$buttons[12],$B=$buttons[13],$X=$buttons[14],$Y=$buttons[15],$start=$buttons[5],$back=$buttons[6],$LS=$buttons[7],$RS=$buttons[8],$LB=$buttons[9],$RB=$buttons[10],$Home=$buttons[11],$Up=$buttons[1],$Down=$buttons[2],$Left=$buttons[3],$Right=$buttons[4]
global $LT=$input[3],$RT=$input[4],	$LSX=$input[5], $LSY=$input[6], $RSX=$input[7], $RSY=$input[8], $LS=$buttons[7], $RS=$buttons[8]


$LSleft = $LSX<-3000
$LSright = $LSX>3000
$LSdown = $LSY<-3000
$LSup = $LSY>3000

$RSleft = $RSX<-3000
$RSright = $RSX>3000
$RSdown = $RSY<-3000
$RSup = $RSY>3000


$lastMouseMove = 0

$mousemovx=0
$mousemovy=0
$prevx=0
$prevy=0

Global $sentKeys[256]


$AnalogToMouse=IniRead($inifile,"Mouse","AnalogToMouse","")
$Stick=IniRead($inifile,"Mouse","Stick","")

global $LSXinverted=IniRead($inifile,"Mouse","LSXaxisInverted",0),$LSYinverted=IniRead($inifile,"Mouse","LSYaxisInverted",0),$RSXinverted=IniRead($inifile,"Mouse","RSXaxisInverted",0),$RSYinverted=IniRead($inifile,"Mouse","RSYaxisInverted",0)



$sensitivity=Iniread($inifile,"Mouse","Sensitivity","")
$smoothFactor=Iniread($inifile,"Mouse","SmoothFactor","")

global $Xleftdeadzone=IniRead($inifile,"Mouse","XleftDeadzone",2000),$Xrightdeadzone=IniRead($inifile,"Mouse","XrightDeadzone",2000),$Yupdeadzone=IniRead($inifile,"Mouse","YupDeadzone",2000),$Ydowndeadzone=IniRead($inifile,"Mouse","YdownDeadzone",2000)
global $Xdeadzone=IniRead($inifile,"Mouse","Xdeadzone",2000), $Ydeadzone=IniRead($inifile,"Mouse","Ydeadzone",2000)
$MouseDeadzone=IniRead($inifile,"Mouse","Deadzone",2000)
$MouseDeadzoneType=IniRead($inifile,"Mouse","DeadzoneType",1)


global $LSleftdeadzone=IniRead($inifile,"Analogs","LSleftDeadzone",0),$LSrightdeadzone=IniRead($inifile,"Analogs","LSrightDeadzone",0),$LSupdeadzone=IniRead($inifile,"Analogs","LSupDeadzone",0),$LSdowndeadzone=IniRead($inifile,"Analogs","LSdownDeadzone",0)
global $RSleftdeadzone=IniRead($inifile,"Analogs","RSleftDeadzone",0),$RSrightdeadzone=IniRead($inifile,"Analogs","RSrightDeadzone",0),$RSupdeadzone=IniRead($inifile,"Analogs","RSupDeadzone",0),$RSdowndeadzone=IniRead($inifile,"Analogs","RSdownDeadzone",0)
global $LSXdeadzone=IniRead($inifile,"Analogs","LSXdeadzone",0), $LSYdeadzone=IniRead($inifile,"Analogs","LSYdeadzone",0), $RSXdeadzone=IniRead($inifile,"Analogs","RSXdeadzone",0), $RSYdeadzone=IniRead($inifile,"Analogs","RSYdeadzone",0)
global $LSdeadzone=IniRead($inifile,"Analogs","LSdeadzone",0), $RSDeadzone=IniRead($inifile,"Analogs","RSdeadzone",0)
$AnalogsDeadzone=IniRead($inifile,"Analogs","Deadzone",0)
$AnalogsDeadzoneType=IniRead($inifile,"Analogs","DeadzoneType",1)

global $LSXaxisInverted=IniRead($inifile,"Analogs","LSXaxisInverted",0), $LSYaxisInverted=IniRead($inifile,"Analogs","LSYaxisInverted",0), $RSXaxisInverted=IniRead($inifile,"Analogs","RSXaxisInverted",0), $RSYaxisInverted=IniRead($inifile,"Analogs","RSYaxisInverted",0)

$wheelstepup=IniRead($inifile,"[Other]","WheelStepUp",1)
$wheelstepdown=IniRead($inifile,"[Other]","WheelStepDown",1)

Global $WheelSpeedLimiterUp = IniRead($inifile,"[Other]","WheelSpeedLimiterUp",8500)
Global $WheelSpeedlimiterDown = IniRead($inifile,"[Other]","WheelSpeedLimiterDown",8500)
Global $UseSameWheelSpeedLimiter = IniRead($inifile,"[Other]","UseSameWheelSpeedLimiter",1)
Global $WheelSpeedLimiter = IniRead($inifile,"[Other]","WheelSpeedLimiter",8500)
Global $WheelAnalogMode = IniRead($inifile,"[Other]","WheelAnalogMode",1)

If $AnalogToMouse <> "1" and $AnalogToMouse <> "0" Then
	$AnalogToMouse=0
	endif

if $MouseDeadzoneType<> 1 and $MouseDeadzoneType <>  2 and $MouseDeadzoneType <>  4 then
	$MouseDeadzoneType=1
endif

if $AnalogsDeadzoneType<> 1 and $AnalogsDeadzoneType <>  2 and $AnalogsDeadzoneType <>  4 and $AnalogsDeadzoneType <> 8 then
	$AnalogsDeadzoneType=1
endif



;dim $remap=Iniread($inifile, "Remap", "Remap",0), $remapLSX = Iniread($inifile, "Remap", "LSX",""), $remapLSY= Iniread($inifile, "Remap", "LSY","")
$sendkeystype = Iniread($inifile, "Other","SendKeysType",1)




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



global $keys[16+1+8]   =[$A, $B, $X, $Y, $LB, $RB, $LT, $RT, $back, $start, $LS, $RS, $Up, $Down, $Left, $Right, $Home, $LSup, $LSdown, $LSleft, $LSright, $RSup, $RSdown, $RSleft, $RSright]
global $pressed[16+1+8]=[False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False ,False, False, False, False,False, False, False, False]
;A, B, X, Y, LB, RB, LT , RT, back, start, LS, RS, UP, DOWN, LEFT, RIGHT, Home,  LSup,  LSdown, LSleft, LSright, RSup, RSdown, RSleft, RSright
;0  1  2  3  4   5   6    7   8     9      10  11  12  13    14    15     16     17	    18	    19	    20	     21	   22	   23	   24

global $values[16+1+8]=[iniR("A"),IniR("B"),IniR("X"),IniR("Y"),IniR("LB"),IniR("RB"),IniR("LT"),IniR("RT"),IniR("Back"),IniR("Start"),IniR("LS"),IniR("RS") _
,IniR("Dup"),IniR("Ddown"),IniR("Dleft"),IniR("Dright"),IniR("Home"),IniR("LSup"),IniR("LSdown"),IniR("LSleft"),IniR("LSright"),IniR("RSup"),IniR("RSdown"),IniR("RSleft"),IniR("RSright")]


func iniR($key)
	$temp=Iniread($inifile,"Buttons",$key,"")
	return $temp
	endfunc



If $AnalogToMouse = "1" Then
    If $Stick = "RS" Then
        local $ignoreIndices = [21,22,23,24]  ; RSup, RSdown, RSleft, RSright
    ElseIf $Stick = "LS" Then
		local $ignoreIndices = [17,18,19,20]  ; LSup, LSdown, LSleft, LSright
    EndIf
EndIf




Global $pressed[UBound($keys)]         ; Stato tasto
Global $lastPress[UBound($keys)]       ; Timer ultimo invio
Global $initialDelay = 500
Global $repeatDelay  = 15


; ===== Array dei timer per ogni tasto =====
Global $lastPressTime[UBound($keys)] = [0]  	 ; memorizza l'ultima volta che è stato inviato "down"
Global $firstPressDone[UBound($keys)] = [False]  ; indica se è passato il delay iniziale


;msgbox("","",$values[0])


HotKeySet("^+5", reloadini)


While 1
	buttons()


global $keys[16+1+8]   =[$A, $B, $X, $Y, $LB, $RB, $LT, $RT, $back, $start, $LS, $RS, $Up, $Down, $Left, $Right, $Home, $LSup, $LSdown, $LSleft, $LSright, $RSup, $RSdown, $RSleft, $RSright]

sleep(1)

	if $AnalogToMouse="1" Then
	mouse()
	endif

if $sendkeystype=1 then
keys()
elseif $sendkeystype=2 then
keys2()
elseif $sendkeystype=3 then
keysDesktop()
elseif $sendkeystype=4 then
keysDesktop2()
endif


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



if $keys[$i] and $pressed[$i]=False Then
;if $keys[$i] Then
	if $values[$i]<>"LBmouse" and $values[$i]<>"RBmouse" and $values[$i]<>"MBmouse" and $values[$i]<>"WheelUp" and $values[$i]<>"WheelDown" and $skip=False then
	$pressed[$i]=True
	$sentKeys[$i]=True
	send ("{" & $values[$i] & " down}")
Else
	switch $values[$i]
		Case "LBmouse"
		MouseDown("left")
		Case "RBmouse"
		MouseDown("right")
		Case "MBmouse"
		MouseDown("middle")
		Case "WheelUp"
		ScrollWheel($i,"up")
		Case "WheelDown"
		ScrollWheel($i,"down")
	endswitch
	$pressed[$i]=True
	endif
endif
if $pressed[$i]=True and not $keys[$i] Then
	if $values[$i]<>"LBmouse" and $values[$i]<>"RBmouse" and $values[$i]<>"MBmouse" and $values[$i]<>"WheelUp" and $values[$i]<>"WheelDown" and $skip=False then
	send ("{" & $values[$i] & " up}")
	$pressed[$i]=False
	Else
	switch $values[$i]
		Case "LBmouse"
		MouseUp("left")
		Case "RBmouse"
		MouseUp("right")
		Case "MBmouse"
		MouseUp("middle")
	endswitch
	$pressed[$i]=False
	endif

	endif

next

	endfunc




func mouse()
	 If TimerDiff($lastMouseMove) < 10 then
		 sleep(1)
        Return
    EndIf

	;$mousemovx=$valx
	;$mousemovy=$valy


	;$mousemovx=$RSX
	;$mousemovy=$RSY

	if $Stick="LS" then
		if $LSXinverted="1" Then
		$mousemovx=-$LSX
		else
		$mousemovx=$LSX
		endif
		if $LSYinverted="1" Then
		$mousemovy=-$LSY
		else
		$mousemovy=$LSY
		endif
	Elseif $Stick="RS" then
		if $RSXinverted="1" Then
		$mousemovx=-$RSX
		else
		$mousemovx=$RSX
		endif
		if $RSYinverted="1" Then
		$mousemovy=-$RSY
		else
		$mousemovy=$RSY
		endif
	endif



		;if $RSXinverted="True" Then
		;$mousemovx=-$mousemovx
		;endif


    $mousePos = MouseGetPos()

	;If Abs($mousemovx) < $deadZone And Abs($mousemovy) < $deadZone Then
	if $mousemovx<$Xrightdeadzone and $mousemovy<$Yupdeadzone and $mousemovx>-$Xleftdeadzone and $mousemovy>-$Ydowndeadzone then





			$prevX = $mousePos[0]
			$prevY = $mousePos[1]

        ;;Sleep(50)
        ;;ContinueLoop
		return ;;instead of ContinueLoop
    EndIf


	$newX = $mousePos[0] + ($mousemovx / 32768) * $sensitivity
    $newY = $mousePos[1] - ($mousemovy / 32768) * $sensitivity


    $newX = Clip($newX, 0, @DesktopWidth)  ;1920
    $newY = Clip($newY, 0, @DesktopHeight) ;1080

	; Smooth movement - interpolation between current and target position
	; $smoothFactor = 0.1 ; How smooth should the movement be? (0 = no smoothing, 1 = very smooth)


    ; Gradually calculate the mouse position
    $finalX = $prevX + ($newX - $prevX) * $smoothFactor
    $finalY = $prevY + ($newY - $prevY) * $smoothFactor

    ; Gradually move the mouse towards the calculated position
    MouseMove($finalX, $finalY, 0)  ; Set "0" for speed since interpolation is used


    $prevX = $finalX
    $prevY = $finalY


	 $lastMouseMove = TimerInit()

;sleep(1)
endfunc

		;If  $mousemovx <  $xrightdeadzone _
		;And $mousemovx > -$xleftdeadzone _
		;Then
		;;$mousemovx = 0
		;$prevX = $mousePos[0]
		;EndIf

		;If  $mousemovy <  $yupdeadzone _
		;And $mousemovy > -$ydowndeadzone _
		;Then
		;;$mousemovy = 0
		;$prevY = $mousePos[1]
		;EndIf






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


$A=$buttons[12]
$B=$buttons[13]
$X=$buttons[14]
$Y=$buttons[15]
$start=$buttons[5]
$back=$buttons[6]
$LS=$buttons[7]
$RS=$buttons[8]
$LB=$buttons[9]
$RB=$buttons[10]
$Home=$buttons[11]


$up=$buttons[1]
$down=$buttons[2]
$left=$buttons[3]
$right=$buttons[4]

$LT=$input[3]
$RT=$input[4]

$LSX=$input[5]
$LSY=$input[6]
$RSX=$input[7]
$RSY=$input[8]

$LS=$buttons[7]
$RS=$buttons[8]


if $LSXaxisInverted	= 1 then
	$LSX=-$LSX
endif

if $LSYaxisInverted	= 1 then
	$LSY=-$LSY
endif

if $RSXaxisInverted	= 1 then
	$RSX=-$RSX

endif

if $RSYaxisInverted	= 1 then
	$RSY=-$RSY
endif




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




func loadini()

$AnalogToMouse=IniRead($inifile,"Mouse","AnalogToMouse","")
$Stick=IniRead($inifile,"Mouse","Stick","")

global $LSXinverted=IniRead($inifile,"Mouse","LSXaxisInverted",0),$LSYinverted=IniRead($inifile,"Mouse","LSYaxisInverted",0),$RSXinverted=IniRead($inifile,"Mouse","RSXaxisInverted",0),$RSYinverted=IniRead($inifile,"Mouse","RSYaxisInverted",0)



$sensitivity=Iniread($inifile,"Mouse","Sensitivity","")
$smoothFactor=Iniread($inifile,"Mouse","SmoothFactor","")

global $Xleftdeadzone=IniRead($inifile,"Mouse","XleftDeadzone",2000),$Xrightdeadzone=IniRead($inifile,"Mouse","XrightDeadzone",2000),$Yupdeadzone=IniRead($inifile,"Mouse","YupDeadzone",2000),$Ydowndeadzone=IniRead($inifile,"Mouse","YdownDeadzone",2000)
global $Xdeadzone=IniRead($inifile,"Mouse","Xdeadzone",2000), $Ydeadzone=IniRead($inifile,"Mouse","Ydeadzone",2000)
$MouseDeadzone=IniRead($inifile,"Mouse","Deadzone",2000)
$MouseDeadzoneType=IniRead($inifile,"Mouse","DeadzoneType",1)


global $LSleftdeadzone=IniRead($inifile,"Analogs","LSleftDeadzone",0),$LSrightdeadzone=IniRead($inifile,"Analogs","LSrightDeadzone",0),$LSupdeadzone=IniRead($inifile,"Analogs","LSupDeadzone",0),$LSdowndeadzone=IniRead($inifile,"Analogs","LSdownDeadzone",0)
global $RSleftdeadzone=IniRead($inifile,"Analogs","RSleftDeadzone",0),$RSrightdeadzone=IniRead($inifile,"Analogs","RSrightDeadzone",0),$RSupdeadzone=IniRead($inifile,"Analogs","RSupDeadzone",0),$RSdowndeadzone=IniRead($inifile,"Analogs","RSdownDeadzone",0)
global $LSXdeadzone=IniRead($inifile,"Analogs","LSXdeadzone",0), $LSYdeadzone=IniRead($inifile,"Analogs","LSYdeadzone",0), $RSXdeadzone=IniRead($inifile,"Analogs","RSXdeadzone",0), $RSYdeadzone=IniRead($inifile,"Analogs","RSYdeadzone",0)
global $LSdeadzone=IniRead($inifile,"Analogs","LSdeadzone",0), $RSDeadzone=IniRead($inifile,"Analogs","RSdeadzone",0)
$AnalogsDeadzone=IniRead($inifile,"Analogs","Deadzone",0)
$AnalogsDeadzoneType=IniRead($inifile,"Analogs","DeadzoneType",1)

global $LSXaxisInverted=IniRead($inifile,"Analogs","LSXaxisInverted",0), $LSYaxisInverted=IniRead($inifile,"Analogs","LSYaxisInverted",0), $RSXaxisInverted=IniRead($inifile,"Analogs","RSXaxisInverted",0), $RSYaxisInverted=IniRead($inifile,"Analogs","RSYaxisInverted",0)



If $AnalogToMouse <> "1" and $AnalogToMouse <> "0" Then
	$AnalogToMouse=0
	endif

if $MouseDeadzoneType<> 1 and $MouseDeadzoneType <>  2 and $MouseDeadzoneType <>  4 then
	$MouseDeadzoneType=1
endif

if $AnalogsDeadzoneType<> 1 and $AnalogsDeadzoneType <>  2 and $AnalogsDeadzoneType <>  4 and $AnalogsDeadzoneType <> 8 then
	$AnalogsDeadzoneType=1
endif



;dim $remap=Iniread($inifile, "Remap", "Remap",0), $remapLSX = Iniread($inifile, "Remap", "LSX",""), $remapLSY= Iniread($inifile, "Remap", "LSY","")
$sendkeystype = Iniread($inifile, "Other","SendKeysType",1)
$wheelstepup=IniRead($inifile,"[Other]","WheelStepUp",1)
$wheelstepdown=IniRead($inifile,"[Other]","WheelStepDown",1)


Global $WheelSpeedLimiterUp = IniRead($inifile,"[Other]","WheelSpeedLimiterUp",8500)
Global $WheelSpeedlimiterDown = IniRead($inifile,"[Other]","WheelSpeedLimiterDown",8500)
Global $UseSameWheelSpeedLimiter = IniRead($inifile,"[Other]","UseSameWheelSpeedLimiter",1)
Global $WheelSpeedLimiter = IniRead($inifile,"[Other]","WheelSpeedLimiter",8500)
Global $WheelAnalogMode = IniRead($inifile,"[Other]","WheelAnalogMode",1)


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



endfunc


func reloadini()
	loadini()
global $values[16+1+8]=[iniR("A"),IniR("B"),IniR("X"),IniR("Y"),IniR("LB"),IniR("RB"),IniR("LT"),IniR("RT"),IniR("Back"),IniR("Start"),IniR("LS"),IniR("RS") _
,IniR("Dup"),IniR("Ddown"),IniR("Dleft"),IniR("Dright"),IniR("Home"),IniR("LSup"),IniR("LSdown"),IniR("LSleft"),IniR("LSright"),IniR("RSup"),IniR("RSdown"),IniR("RSleft"),IniR("RSright")]
	endfunc




func keys2()
for $i=0 to Ubound($keys) -1
	Local $skip = False


        For $j = 0 To UBound($ignoreIndices) - 1
            If $i = $ignoreIndices[$j] Then
                $skip = True
                ExitLoop
            EndIf
        Next



;if $keys[$i] and $pressed[$i]=False Then
if $keys[$i] Then
	if $values[$i]<>"LBmouse" and $values[$i]<>"RBmouse" and $values[$i]<>"MBmouse" and $values[$i]<>"WheelUp" and $values[$i]<>"WheelDown" and $skip=False then
	$pressed[$i]=True
	$sentKeys[$i]=True
	send ("{" & $values[$i] & " down}")
Else
	switch $values[$i]
		Case "LBmouse"
		MouseDown("left")
		Case "RBmouse"
		MouseDown("right")
		Case "MBmouse"
		MouseDown("middle")
		Case "WheelUp"
		ScrollWheel($i,"up")
		Case "WheelDown"
		ScrollWheel($i,"down")
	endswitch
	$pressed[$i]=True
	endif
endif
if $pressed[$i]=True and not $keys[$i] Then
	if $values[$i]<>"LBmouse" and $values[$i]<>"RBmouse" and $values[$i]<>"MBmouse" and $values[$i]<>"WheelUp" and $values[$i]<>"WheelDown" and $skip=False then
	send ("{" & $values[$i] & " up}")
	$pressed[$i]=False
	Else
	switch $values[$i]
		Case "LBmouse"
		MouseUp("left")
		Case "RBmouse"
		MouseUp("right")
		Case "MBmouse"
		MouseUp("middle")
	endswitch
	$pressed[$i]=False
	endif

	endif

next

endfunc


Func ScrollWheel($k,$dir)
local $ver
if $WheelAnalogMode=1 and $k>=17 then


	$k=$k-17
	local $values=[$LSY, $LSY, $LSX, $LSX,   $RSY,$RSY, $RSX,$RSX]
	$value=$values[$k]

	;if $dir="down" Then
	;	$ver=$MOUSE_WHEEL_DOWN
	;	endif

		 if $UseSameWheelSpeedLimiter = 1 then
			$WheelSpeedLimiterUp=$WheelSpeedLimiter
			$WheelSpeedLimiterDown=$WheelSpeedLimiter
		 endif

		Local $stepsUp = Ceiling(Abs($value)/ $WheelSpeedLimiterUp)
		Local $stepsDown = Ceiling(Abs($value)/ $WheelSpeedLimiterDown)

	if $dir = "up" Then
	$steps=$stepsUp
	elseif $dir = "down" Then
	$steps=$stepsDown
	endif


        If $value < 0 Then
			MouseWheel($dir, $steps)
			;MouseWheel($MOUSE_WHEEL_DOWN, $steps)
            ;MouseWheel($MOUSE_WHEEL_DOWN, $steps+$wheelstepdown)
			Else
			MouseWheel($dir, $steps)
			;MouseWheel($MOUSE_WHEEL_UP, $steps)
            ;MouseWheel($MOUSE_WHEEL_UP, $steps+$wheelstepup)
        EndIf
else

		if $dir="down" then
			MouseWheel($MOUSE_WHEEL_DOWN, $wheelstepdown)
		Elseif $dir="up" then
            MouseWheel($MOUSE_WHEEL_UP, $wheelstepup)
		endif

endif
	;sleep(1)
EndFunc



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
    ;If $keys[$i] and $pressed[$i]=False Then
	If $keys[$i] Then
        If $values[$i] <> "LBmouse" And $values[$i] <> "RBmouse" And $values[$i] <> "MBmouse" _
            And $values[$i] <> "WheelUp" And $values[$i] <> "WheelDown" And $skip = False Then

            ; Se è la prima volta che premiamo il tasto
            If Not $pressed[$i] Then
                $pressed[$i] = True
				$sentKeys[$i]=True
                $lastPressTime[$i] = TimerInit()  ; inizializza timer
                $firstPressDone[$i] = False
                Send("{" & $values[$i] & " down}")
            Else
                ; se il delay iniziale è già passato
                If Not $firstPressDone[$i] Then
                    If TimerDiff($lastPressTime[$i]) >= $InitialDelay Then
                        $lastPressTime[$i] = TimerInit()
                        $firstPressDone[$i] = True
                        Send("{" & $values[$i] & " down}")
						$sentKeys[$i]=True
                    EndIf
                Else
                    ; ripetizione rapida
                    If TimerDiff($lastPressTime[$i]) >= $RepeatDelay Then
                        $lastPressTime[$i] = TimerInit()
                        Send("{" & $values[$i] & " down}")
						$sentKeys[$i]=True
                    EndIf
                EndIf
            EndIf
        ;EndIf
		Else
        ; ===== gestione tasti mouse e ruota =====
			Switch $values[$i]
				Case "LBmouse"
					MouseDown("left")
				Case "RBmouse"
					MouseDown("right")
				Case "MBmouse"
					MouseDown("middle")
				Case "WheelUp"
				;MouseWheel("up", $wheelstepup)
				ScrollWheel($i,"up")
				Case "WheelDown"
				;MouseWheel("down",$wheelstepdown)
				ScrollWheel($i,"down")
			EndSwitch
			$pressed[$i] = True
			$sentKeys[$i]=True
		EndIf
	Endif

If $pressed[$i] and not $keys[$i] Then
        If $values[$i] <> "LBmouse" And $values[$i] <> "RBmouse" And $values[$i] <> "MBmouse" _
            And $values[$i] <> "WheelUp" And $values[$i] <> "WheelDown" And $skip = False Then
            Send("{" & $values[$i] & " up}")
			$sentKeys[$i]=True

		Else
			Switch $values[$i]
				Case "LBmouse"
					MouseUp("left")
				Case "RBmouse"
					MouseUp("right")
				Case "MBmouse"
					MouseUp("middle")
			EndSwitch

        EndIf
        $pressed[$i] = False
        $firstPressDone[$i] = False
    EndIf
Next
endfunc



func keysDesktop2()
	for $i=0 to Ubound($keys) -1
	Local $skip = False


        For $j = 0 To UBound($ignoreIndices) - 1
            If $i = $ignoreIndices[$j] Then
                $skip = True
                ExitLoop
            EndIf
        Next

	; ===== Ciclo principale =====
    If $keys[$i] and $pressed[$i]=False Then
	;If $keys[$i] Then
        If $values[$i] <> "LBmouse" And $values[$i] <> "RBmouse" And $values[$i] <> "MBmouse" _
            And $values[$i] <> "WheelUp" And $values[$i] <> "WheelDown" And $skip = False Then

            ; Se è la prima volta che premiamo il tasto
            If Not $pressed[$i] Then
                $pressed[$i] = True
				$sentKeys[$i]=True
                $lastPressTime[$i] = TimerInit()  ; inizializza timer
                $firstPressDone[$i] = False
                Send("{" & $values[$i] & " down}")
            Else
                ; se il delay iniziale è già passato
                If Not $firstPressDone[$i] Then
                    If TimerDiff($lastPressTime[$i]) >= $InitialDelay Then
                        $lastPressTime[$i] = TimerInit()
                        $firstPressDone[$i] = True
                        Send("{" & $values[$i] & " down}")
						$sentKeys[$i]=True
                    EndIf
                Else
                    ; ripetizione rapida
                    If TimerDiff($lastPressTime[$i]) >= $RepeatDelay Then
                        $lastPressTime[$i] = TimerInit()
                        Send("{" & $values[$i] & " down}")
						$sentKeys[$i]=True
                    EndIf
                EndIf
            EndIf
        ;EndIf
		Else
        ; ===== gestione tasti mouse e ruota =====
			Switch $values[$i]
				Case "LBmouse"
					MouseDown("left")
				Case "RBmouse"
					MouseDown("right")
				Case "MBmouse"
					MouseDown("middle")
				Case "WheelUp"
				;MouseWheel("up", $wheelstepup)
				ScrollWheel($i,"up")
				Case "WheelDown"
				;MouseWheel("down",$wheelstepdown)
				ScrollWheel($i,"down")
			EndSwitch
			$pressed[$i] = True
			$sentKeys[$i]=True
		EndIf
	Endif

If $pressed[$i] and not $keys[$i] Then
        If $values[$i] <> "LBmouse" And $values[$i] <> "RBmouse" And $values[$i] <> "MBmouse" _
            And $values[$i] <> "WheelUp" And $values[$i] <> "WheelDown" And $skip = False Then
            Send("{" & $values[$i] & " up}")
			$sentKeys[$i]=True

		Else
			Switch $values[$i]
				Case "LBmouse"
					MouseUp("left")
				Case "RBmouse"
					MouseUp("right")
				Case "MBmouse"
					MouseUp("middle")
			EndSwitch

        EndIf
        $pressed[$i] = False
        $firstPressDone[$i] = False
    EndIf
Next
endfunc







func onexit()
	;send("{LCTRL up}{LSHIFT up}{LALT up}{RCTRL up}{RSHIFT up}{RALT up}{LWIN up}{RWIN up}{TAB up}")
	For $i = 0 To UBound($sentKeys) - 1
    If $sentKeys[$i] Then
        Send("{" & $values[$i] & " up}")
    EndIf
Next
	endfunc








Func IsRepeatable($val)
    Switch $val
        Case "LBmouse", "RBmouse", "MBmouse", _
             "WheelUp", "WheelDown", _
             "MouseMoveUp", "MouseMoveDown", _
             "MouseMoveLeft", "MouseMoveRight"
            Return False
    EndSwitch
    Return True
EndFunc



