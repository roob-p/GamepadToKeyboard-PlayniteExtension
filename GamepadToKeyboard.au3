#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico"
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=GamepadToKeyboard (64 bit)
#AutoIt3Wrapper_Res_Fileversion=1.2.6.0
#AutoIt3Wrapper_Res_ProductName=GamepadToKeyboard
#AutoIt3Wrapper_Res_ProductVersion=1.2.6
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
#include <Math.au3>


#pragma compile(UPX, false)

_singleton("Script")

OnAutoItExitRegister("Onexit")
opt("SendKeyDelay",0)
opt("SendKeyDownDelay",0)
Opt("WinWaitDelay",500)

$inputhwnd = _XInputInit()
$input = _XInputGetInput($inputhwnd)
$buttons = _XInputButtons($input[2])




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



#Region Var
global $analogdeadzone=1, $sentKeys[256], $ignoreIndices[4]
global $A=$buttons[12],$B=$buttons[13],$X=$buttons[14],$Y=$buttons[15],$start=$buttons[5],$back=$buttons[6],$LS=$buttons[7],$RS=$buttons[8],$LB=$buttons[9],$RB=$buttons[10],$Home=$buttons[11],$Up=$buttons[1],$Down=$buttons[2],$Left=$buttons[3],$Right=$buttons[4]
global $LT=$input[3],$RT=$input[4],	$LSX=$input[5], $LSY=$input[6], $RSX=$input[7], $RSY=$input[8], $LS=$buttons[7], $RS=$buttons[8]


global $LSleft = $LSX<-3000, $LSright = $LSX>3000, $LSdown = $LSY<-3000, $LSup = $LSY>3000
global $RSleft = $RSX<-3000,$RSright = $RSX>3000, $RSdown = $RSY<-3000, $RSup = $RSY>3000

global $TriggerDeadzone=IniRead($inifile,"Other","TriggerDeadzone",20)

global $mousemovx=0, $mousemovy=0, $prevx=0, $prevy=0, $lastMouseMove = 0


global $AnalogToMouse=IniRead($inifile,"Mouse","AnalogToMouse",""), $AnalogToMouseWasTrue="0"
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
global $combotime = IniRead($inifile,"Other","ComboAsyncDelay",50), $SequenceTime= IniRead($inifile,"Other","SequenceTime",50), $HoldTime= IniRead($inifile,"Other","HoldTime",300)
global $fastPressTime = IniRead($inifile,"Other","fastPressTime",150)

If $AnalogToMouse <> "1" and $AnalogToMouse <> "0" Then	$AnalogToMouse=0
if $MouseDeadzoneType<> 1 and $MouseDeadzoneType <>  2 and $MouseDeadzoneType <>  4 then  $MouseDeadzoneType=1
if $AnalogsDeadzoneType<> 1 and $AnalogsDeadzoneType <>  2 and $AnalogsDeadzoneType <>  4 and $AnalogsDeadzoneType <> 8 then $AnalogsDeadzoneType=1

global $VibrateBmaxN=16+8+1, $VibrateButtonS[$VibrateBmaxN], $VibrateButton[$VibrateBmaxN], $VibrateIsTrigger[$VibrateBmaxN], $vibrationEnabled=False, $VibrateEnabled = IniRead($inifile,"Vibration","Enabled",0)
global $VibrateButton_strength[$VibrateBmaxN], $VibrateButton_SingleDuration[$VibrateBmaxN], $VibrateButton_RepeatDuration[$VibrateBmaxN] ,$VibrateButton_RepeatInterval[$VibrateBmaxN], $VibrateButton_Motor[$VibrateBmaxN]
global $VibrateButton_LeftMotorStrength[$VibrateBmaxN], $VibrateButton_RightMotorStrength[$VibrateBmaxN], $VibrateButton_Style[$VibrateBmaxN], $VibrateButton_Style[$VibrateBmaxN]
global $VibrateButton_Modifier[$VibrateBmaxN], $VibrateButton_ModifierS[$VibrateBmaxN]

for $i=0 to $VibrateBmaxN-1
	$VibrateButtonS[$i] = IniRead($inifile,"Vibration", "VibrateButton" & $i+1,"")
	if $VibrateButtonS[$i]<>"" then $vibrationEnabled=True
	if $VibrateButtonS[$i]="LT" or $VibrateButtonS[$i]="RT" then $VibrateisTrigger[$i]=True
next

global $VibrateModifierButton = IniRead($inifile,"Vibration", "ModifierButton",""), $VibrateStyle= IniRead($inifile,"Vibration","Style",1), $VibrateUseSameStrengthVal=IniRead($inifile,"Vibration","UseSameStrengthVal",0)
global $VibrateStrength = IniRead($inifile,"Vibration","Strength",100), $LeftMotorStrength = IniRead($inifile,"Vibration","LeftMotorStrength",100), $RightMotorStrength = IniRead($inifile,"Vibration","RightMotorStrength",100)
global $VibrateSingleDuration = IniRead($inifile,"Vibration","SingleDuration",400), $VibrateRepeatDuration = IniRead($inifile,"Vibration","RepeatDuration",300), $VibrateRepeatInterval = IniRead($inifile,"Vibration","RepeatInterval",100)
global $VibrationWasEnabled = False, $VibrateProgressiveTrigger=IniRead($inifile,"Vibration","ProgressiveTrigger",0), $VibrateMotor=IniRead($inifile,"Vibration","Motor","Both")
global $vibrationValSX, $vibrationValDX



if $VibrateEnabled=1 and $VibrationEnabled = 1 then
$VibrationWasEnabled = True

for $i=0 to $VibrateBmaxN-1
	$VibrateButtonS[$i]="$"&$vibrateButtonS[$i]

	$VibrateButton_LeftMotorStrength[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".LeftMotorStrength","")
	$VibrateButton_RightMotorStrength[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".RightMotorStrength","")
	$VibrateButton_Strength[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".Strength","")
	$VibrateButton_Motor[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".Motor","")
	$VibrateButton_SingleDuration[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".SingleDuration","")
	$VibrateButton_RepeatDuration[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".RepeatDuration","")
	$VibrateButton_RepeatInterval[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".RepeatInterval","")
	$VibrateButton_Style[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".Style","")
	$VibrateButton_ModifierS[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".Modifier","")

	if $VibrateButton_ModifierS[$i]<>"" then
		$VibrateButton_ModifierS[$i]="$" & $VibrateButton_ModifierS[$i]
	Else
		$VibrateButton_Modifier[$i]="NAA"
	endif


	if $VibrateButton_LeftMotorStrength[$i]="" then
		if $VibrateButton_Strength[$i]<>"" Then $VibrateButton_LeftMotorStrength[$i]=$VibrateButton_Strength[$i]
		if $VibrateButton_Strength[$i]="" then
			if $VibrateUseSameStrengthVal="1" then $VibrateButton_LeftMotorStrength[$i]=$VibrateStrength
			if $VibrateUseSameStrengthVal<>"1" then $VibrateButton_LeftMotorStrength[$i]=$LeftMotorStrength
		endif
	endif

	if $VibrateButton_RightMotorStrength[$i]="" then
		if $VibrateButton_Strength[$i]<>"" Then $VibrateButton_RightMotorStrength[$i]=$VibrateButton_Strength[$i]
		if $VibrateButton_Strength[$i]="" then
			if $VibrateUseSameStrengthVal="1" then $VibrateButton_RightMotorStrength[$i]=$VibrateStrength
			if $VibrateUseSameStrengthVal<>"1" then $VibrateButton_RightMotorStrength[$i]=$RightMotorStrength
		endif
	endif


if $VibrateButton_Motor[$i]="Left" then $VibrateButton_RightMotorStrength[$i]=0
if $VibrateButton_Motor[$i]="Right" then $VibrateButton_LeftMotorStrength[$i]=0

	if $VibrateButton_Style[$i]="" then $VibrateButton_Style[$i]= $VibrateStyle
	if $VibrateButton_SingleDuration[$i]="" then $VibrateButton_SingleDuration[$i]=$VibrateSingleDuration
	if $VibrateButton_RepeatDuration[$i]="" then $VibrateButton_RepeatDuration[$i]=$VibrateRepeatDuration
	if $VibrateButton_RepeatInterval[$i]="" then $VibrateButton_RepeatInterval[$i]=$VibrateRepeatInterval


next


AdlibRegister("Vibrate",50)



endif


global $sendkeystype = Iniread($inifile, "Other","SendKeysType",1)

;;;;;;;;;; RELOAD & STATS
global $ReloadHotkeyEnabledWasTrue=False, $StatsHotkeyEnabledWasTrue=False, $KeyboardShiftToggleEnabledWasTrue=False, $KeyboardShiftCycleEnabledWasTrue=False
global $ReloadHotkeyEnabled=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","ReloadHotkeyEnabled","True"), $StatsHotkeyEnabled=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","StatsHotkeyEnabled","True")


if $ReloadHotkeyEnabled="True" then
global $hotkey =Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","ReloadHotkey","^+5") 	  ;default: Ctrl+Shift+5
$hotkey=String($hotkey)
HotKeySet($hotkey, reloadini)
$ReloadHotkeyEnabledWasTrue=True
endif

if $StatsHotkeyEnabled="True" then
global $statshotkey =Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","StatsHotkey","^+6") ;default: Ctrl+Shift+6
$statshotkey=String($statshotkey)
HotKeySet($statshotkey, statsstart)
$StatsHotkeyEnabledWasTrue=True
endif

;;;;;;;;;;;;; SHIFT (keyboard)
global $KeyboardShiftToggleEnabled=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","KeyboardShiftToggleEnabled","False") , $KeyboardShiftCycleEnabled=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","KeyboardShiftCycleEnabled","False")

if $KeyboardShiftToggleEnabled="True" then
	global $ShiftModeTogglehotkey=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","ShiftModeToggle","^+9")
	hotkeyset(String($ShiftModeTogglehotkey),ShiftModeToggleK)
	$KeyboardShiftToggleEnabledWasTrue=True
endif
global $ShiftModeToggleKOn=false, $ShiftModeToggleKVal=IniRead($inifile,"Other","ShiftToggleKeyboardValue",3)

if $KeyboardShiftCycleEnabled="True" then
global $ShiftModeCycleMinushotkey=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","ShiftModeCycle-","^+7"), $ShiftModeCyclePlushotkey=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","ShiftModeCycle+","^+8")
hotkeyset(String($ShiftModeCycleMinushotkey),ShiftModeCycleMinusK)
hotkeyset(String($ShiftModeCyclePlushotkey),ShiftModeCyclePlusK)
$KeyboardShiftCycleEnabledWasTrue=True
endif

;;;;;;;;;;;;; LAYER (keyboard)
global $KeyboardLayerToJump, $KeyboardPrevLayer
global $layerToggleKOn=False, $LayerToggleKtype=IniRead($inifile,"Other","KeyboardTogglelayerType",0), $LayerToggleKVal=IniRead($inifile,"Other","KeyboardToggleLayerName","")
global $KeyboardLayerToggle=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","KeyboardLayerToggleEnabled","False"), $KeyboardLayerCycle=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","KeyboardLayerCycleEnabled","False")

if $KeyboardLayerToggle="True" then
global $LayerTogglehotkey=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","LayerToggle","^+3")
hotkeyset(String($LayerTogglehotkey),LayerToggleK)
$KeyboardLayerToggleEnabledWasTrue=True
endif


if $KeyboardLayerCycle="True" then
global $LayerCycleMinushotkey=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","LayerCycle-","^+1"), $LayerCyclePlushotkey=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","LayerCycle+","^+2")
hotkeyset(String($LayerCycleMinushotkey),LayerCycleMinusK)
hotkeyset(String($LayerCyclePlushotkey), LayerCyclePlusK)
$KeyboardLayerCycleEnabledWasTrue=True
endif
;;;;;;;;;;;;;;;;;;


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
#Endregion

#Region var2
global $ml=16, $l=0
global $asize=16+1+8
global $ef[$ml][$asize], $ez[$ml][$asize], $ee[$ml][$asize]
global $ef1[$asize]
For $i=0 To $ml-1
    For $j=0 To $asize-1
        $ef[$i][$j]=False
        $ez[$i][$j]=0
        $ee[$i][$j]=""
		$ef1[$j]=False
    Next
Next
global $keys[16+1+8]   		= [$A, $B, $X, $Y, $LB, $RB, $LT, $RT, $back, $start, $LS, $RS, $Up, $Down, $Left, $Right, $Home, $LSup, $LSdown, $LSleft, $LSright, $RSup, $RSdown, $RSleft, $RSright]
global $keystring[16+1+8]   = ["A", "B", "X", "Y", "LB", "RB", "LT", "RT", "Back", "Start", "LS", "RS", "DUp", "Ddown", "Dleft", "Dright", "Home", "LSup", "LSdown", "LSleft", "LSright", "RSup", "RSdown", "RSleft", "RSright"]
global $pressed=$ef
;A, B, X, Y, LB, RB, LT , RT, back, start, LS, RS, UP, DOWN, LEFT, RIGHT, Home,  LSup,  LSdown, LSleft, LSright, RSup, RSdown, RSleft, RSright
;0  1  2  3  4   5   6    7   8     9      10  11  12  13    14    15     16     17	    18	    19	    20	     21	   22	   23	   24


global $values[$ml][$asize], $valuesS[$ml][$asize]

For $i = 0 To $asize-1
    $values[0][$i] = IniR($keystring[$i])
Next

global $curValues=$values

global $buttonsname=["A","B","X","Y","LB","RB","LT","RT","Back","Start","LS","RS","Dup","Ddown","Dleft","Dright","Home","LSup","LSdown","LSleft","LSright","RSup","RSdown","RSleft","RSright"]

global $toggle=$ef, $toggleOn=$ef,	$Turbo=$ef, $TurboToggle=$ef, $TurboToggleOn=$ef, $TurboOn=$ef, $alreadytimer=$ef, $alreadytimer2=$ef,		$TurboComboalreadyTimer=$ef, $TurboToggleComboalreadyTimer=$ef
global $TimerT[$ml][$asize], $TimerT2[$ml][$asize], $Timer[$ml][$asize], $timersplash,		$TurboComboTimerT[$ml][$asize]
global $released=$ef1, $combo=$ef, $Comboasync=$ef,	$toup=$ef,		$comboOn=$ef, $combosize=11,	$SequenceMax=16,		$comboasyncOn=$ef,	$simpleMacroOn=$ef

global $ToggleComboOn=$ef, $ToggleCombo=$ef, $TurboCombo=$ef, $TurboToggleCombo=$ef,	$TurboComboOn=$ef, $TurboToggleOn=$ef, $TurboToggleComboOn=$ef
global $keysfromcombo[$ml][$asize], $combokeys[$ml][$asize][$combosize], $keysfromcomboup[$ml][$asize], $keysfromcombodown[$ml][$asize]
global $keysfromcomboasync[$ml][$asize], $combokeysasync[$ml][$asize][$combosize], $keysfromcomboupasync[$ml][$asize], $keysfromcombodownasync[$ml][$asize], $combK[$ml][$asize]
global $MacroOn=$ef, $macrosize=26, $Macrokeys[$ml][$asize][$macrosize]
global $stringmax=200,  $text=$ef ; $textOn=$ef, $textkeys[$asize][$stringsize]

global $Togglekeysfromcombo[$ml][$asize],$Togglecombokeys[$ml][$asize][$combosize],$Togglekeysfromcomboup[$ml][$asize],$Togglekeysfromcombodown[$ml][$asize]
global $Turbokeysfromcombo[$ml][$asize],$Turbocombokeys[$ml][$asize][$combosize],$Turbokeysfromcomboup[$ml][$asize],$Turbokeysfromcombodown[$ml][$asize]
;global $TurboTogglekeysfromcombo[$asize],$TurboTogglecombokeys[$asize][$combosize],$TurboTogglekeysfromcomboup[$asize],$TurboTogglekeysfromcombodown[$asize],		$TurboToggleComboTimerT[$asize], 	$releasedC=$ef
global $simplemacro[$ml][$asize], $macro[$ml][$asize],	$SmacroK[$ml][$asize], $SimpleMacroKeys[$ml][$asize][$SequenceMax], $keysfromSimpleMacro[$ml][$asize]
global $alreadyTimerSimpleMacro=$ef, $timerSimpleMacro=$ef

global $comboNum[$ml][$asize], $comboasyncNum[$ml][$asize], $sequenceNum[$ml][$asize], 		$ToggleComboNum[$ml][$asize],$turboComboNum[$ml][$asize]
global $ComboType[$ml][$asize][$combosize],	$comboAsyncType[$ml][$asize][$combosize],	$ToggleComboType[$ml][$asize][$combosize],	$TurboComboType[$ml][$asize][$combosize], $SimpleMacroType[$ml][$asize][$SequenceMax]

global $async=$ef, $alreadytimerasync=$ef, $timerasync=$ef;;;$timerasync[$asize]

global $execute=$ef
global $buttonaction=$ez ;0: normal, 1: toggle, 2: turbo, 3: turbotoggle, 4: execute, 5: combo, 6: comboasync
global $buttontype=$ez   ;0: keyboard, 1:mousebutton, 2: scrollupdown


global $mousemovv[2], $LastStatsText
global $alreadytimerscroll=$ef, $timerscroll[$ml][$asize]
Global $hNTDLL = DllOpen("ntdll.dll")
global $fkeys, $DW=@DesktopWidth/15,$DH=@DesktopHeight/18
global $specialkeys=$ef, $specialkeys2DCombo[$ml][$asize][$combosize], $specialkeys2DSequence[$ml][$asize][$SequenceMax]
global $textstats, $textstats2, $statsOn=False, $stats, $statstime[$ml][$asize], $statstimer, $splashreload=False
global $holdmax=3+(1), $holdnum[$ml][$asize], $holdtype[$ml][$asize][$Holdmax],$hold=$ef,$holdOn=$ef, $KeysfromHold[$ml][$asize], $HoldKeys[$ml][$asize][$Holdmax], $specialkeys2DHold[$ml][$asize][$holdmax], $holdtimer=$ef
global $shiftmax=5+1, $shiftNum[$ml][$asize], $shift=$ef, $ShiftKeys[$ml][$asize][$shiftmax], $KeysfromShift[$ml][$asize], $ShiftType[$ml][$asize][$shiftmax], $specialkeys2DShift[$ml][$asize][$shiftmax]
global $ShiftMode=$ef, $ShiftModeToggle=$ef, $ShiftmodeCycle=$ef
global $actionName=$ee, $actionNameS=$ee
global $shinum=1, $tempshinum, $shiftModeToggleOn=$ef, $newshinum=1, $shilimit, $previouslimit
global $FastpressMax=3+1, $FastpressNum=$ez, $Fastpress=$ef, $Fastpresstimer[$ml][$asize], $fastpressOn=$ef, $FastpressKeys[$ml][$asize][$FastpressMax], $fastpressOnH=$ef
global $keysfromFastpress[$ml][$asize], $FastpressType[$ml][$asize][$FastpressMax], $specialkeys2DFastPress[$ml][$asize][$FastpressMax], $tap=$ez, $oldtap=$ez, $fastpressSent=$ef
global $statepress=$ee
global $ml=16, $bl=1, $tl=5 , $l=0, $layervalexists=False, $prefix=$ee, $layeracc[$asize], $layeraccnum=0
global $sectionName[$ml][$asize], $layercount=0, $layertype[$ml], $layerToggleOn=$ef1, $layercycle[$ml], $layervalue[$ml], $layerToCycle[$ml], $buttonL=$ee, $curLayer=0, $prevLayer=0, $cycleLayerCount=0, $layerToCycleSS, $layerToCycleS[$ml], $layerName[$ml]
;global $timerVibrate, $TimerInterval, $vibrateOn=False
global $timerVibrate[$VibrateBmaxN], $TimerInterval[$VibrateBmaxN], $vibrateOn[$VibrateBmaxN], $VibratePressed[$asize] ;global $VibratePressed[$VibrateBmaxN]

$hashValues = ObjCreate("Scripting.Dictionary")
$hashValuesx = ObjCreate("Scripting.Dictionary")
$hashVibrate = ObjCreate("Scripting.Dictionary")
global $VibrateIndex[$VibrateBmaxN], $VibrateIndex2[$VibrateBmaxN]

	for $i=0 to $VibrateBmaxN-1
		$vibrateOn[$i]=0
		$hashValues.Add("$"&$buttonsname[$i],$i)
		$hashValuesx.Add($i,"$"&$buttonsname[$i])
		if $VibrateButtonS[$i]<>"$" then $hashVibrate.Add($VibrateButtonS[$i],$i)
	next

	for $i=0 to $VibrateBmaxN-1
		;$VibrateIndex[$i]=$hashVibrate.Item($hashValuesx.Item($i))
		$VibrateIndex[$i]=$hashVibrate.Item($hashValues.Keys[$i]) ;  $VibrateIndex[$i]=$hashVibrate.Item($hashValues.Keys()[$i]) also ok   ;$VibrateIndex[$i]=$hashVibrate.Item($hashValues.Keys()($i)) ;SAME
		$VibrateIndex2[$i]=$hashValues.Item($VibrateButtonS[$i])
	next

	#Endregion var2

parseL0()

func iniR($key)
	$temp=Iniread($inifile,"Buttons",$key,"")
	return $temp
endfunc

func iniRR($key,$num)
	$temp=Iniread($inifile,"Buttons"& $num,$key,"")
	if $temp="" then Iniread($inifile,"Buttons",$key,"")
	return $temp
	endfunc


If $AnalogToMouse = "1" Then
	$AnalogToMouseWasTrue="1"
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

TraySetToolTip($inifile)
statsvar()

if $AnalogTomouse="1" then AdlibRegister("mouse",1)

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

#Region keys()
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
	if $values[$l][$i]="" then ContinueLoop
	$pressed[$i]=True
	$sentKeys[$i]=True
	$statePress[$l][$i]=0


	;consolewrite(" L: " & $l)
	inpt($i,$values[$l][$i],0,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])


	endif

endif

if $pressed[$i]=True and not $keys[$i] Then
	if $skip=False then
		if $values[$l][$i]="" then ContinueLoop
		$statePress[$l][$i]=1
	if $buttonaction[$l][$i]<>3 and $buttonaction[$l][$i]<>4 and $buttonaction[$l][$i]<>7 and $buttonaction[$l][$i]<>9 then inpt($i,$values[$l][$i],1,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])
	$pressed[$i]=False
	$sentkeys[$i]=False

	$alreadyTimer[$l][$i]=False
	$timerT[$l][$i]=0


	$VibratePressed[$VibrateIndex[$i]]=False



	endif
endif


if not $keys[$i] Then
	if $ToggleOn[$l][$i]=False then
$alreadyTimerscroll[$l][$i]=False
$timerscroll[$l][$i]=0
;$pressed[$i] = False
	endif
$TurboOn[$l][$i]=False
endif



if $keys[$i] and $Turbo[$l][$i]=True Then Turbo($i,$values[$l][$i],3,$buttontype[$l][$i])	  				; Turbo (uses send down + send up in sender rather than normal send, otherwise keys like Space may be sent literally if StringLower is not used.
;if $keys[$i] and $Turbo[$i]=True Then Turbo3($i,$values[$i],0,$buttontype[$i])	  							; Turbo (Turbo3 function has send down + send up, but I prefer passing state 3 to Turbo() instead of using a separate Turbo3() function).
if $TurboToggleOn[$l][$i]=true Then Turbo($i,$values[$l][$i],3,$buttontype[$l][$i])			  				; TurboToggleOn with send
if $TurboToggleComboOn[$l][$i]=true Then TurboCombo($i,$values[$l][$i],3,$buttontype[$l][$i]) 				; TurboToggleCombo
if $ToggleOn[$l][$i]=True and $buttontype[$l][$i]=2 Then  scrollWheelT($i,$values[$l][$i])    				; ToggleOn with Wheel
if $comboasyncOn[$l][$i]=True Then comboasync($i,$values[$l][$i],0,$buttontype[$l][$i])		  				; ComboAsyncOn
if $SimpleMacroOn[$l][$i]=True Then	Sequence($i,$values[$l][$i],3,$buttontype[$l][$i])		  			    ; Sequence
if $HoldOn[$l][$i]=True then Hold($i,$values[$l][$i],0,$buttontype[$l][$i])					  				; Hold
if $fastpressOn[$l][$i] then fastpresscheck($i,$values[$l][$i],0,$buttontype[$l][$i])		  				; Fastpress
if $fastpressOnH[$l][$i] then fastpresscheckH($i,$values[$l][$i],$statePress[$l][$i],$buttontype[$l][$i])   ; Fastpress "helper" for release
; buttonaction[9] uses the same arrays as buttonaction[8] except for $TurboToggleComboOn. This condition is only for standard TurboCombo:
if $keys[$i] and $TurboCombo[$l][$i]=True and $TurboToggleComboOn[$l][$i]=False Then  TurboCombo($i,$values[$l][$i],3,$buttontype[$l][$i])

;not keys[$i]
if $combo[$l][$i]=True and not $keys[$i] Then $pressed[$i]= False
if $TurboToggle[$l][$i]=true and not $keys[$i] Then $released[$i]=True
if $TurboToggleCombo[$l][$i]=true and not $keys[$i] Then $released[$i]=True

next

endfunc
#EndRegion


#Region keysDesktop()
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
		if $values[$l][$i]="" then ContinueLoop
				if $pressed[$i]=False and $buttonaction[$l][$i]=4 then inptD($i,$values[$l][$i],0,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])	;Executes, no repeat
				if $buttontype[$l][$i]=1 and $pressed[$i]=False then inptD($i,$values[$l][$i],0,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])		;Mousebuttons (no repeat)
				if $buttontype[$l][$i]=2 and $pressed[$i]=False then inptD($i,$values[$l][$i],0,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])		;Scrollwheel
            ; Se è la prima volta che premiamo il tasto
            If Not $pressed[$i] Then
                $pressed[$i] = True
				$sentKeys[$i]=True
                $lastPressTime[$i] = TimerInit()  ; inizializza timer
                $firstPressDone[$i] = False

				$statepress[$l][$i]=0
				if $buttontype[$l][$i]=0 and $buttonaction[$l][$i]<>4 then	inptD($i,$values[$l][$i],0,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])
            Else
                ; se il delay iniziale è già passato
                If Not $firstPressDone[$i] Then
                    If TimerDiff($lastPressTime[$i]) >= $InitialDelay Then
                        $lastPressTime[$i] = TimerInit()
                        $firstPressDone[$i] = True

						if $buttontype[$l][$i]=0 and $buttonaction[$l][$i]<>4 and $buttonaction[$l][$i]<>12 and $buttonaction[$l][$i]<>13 then inptD($i,$values[$l][$i],0,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])
						$sentKeys[$i]=True
                    EndIf
                Else
                    ; ripetizione rapida
                    If TimerDiff($lastPressTime[$i]) >= $RepeatDelay Then
                        $lastPressTime[$i] = TimerInit()

						if $buttontype[$l][$i]=0 and $buttonaction[$l][$i]<>4 and $buttonaction[$l][$i]<>12 and $buttonaction[$l][$i]<>13 then inptD($i,$values[$l][$i],0,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])
						$sentKeys[$i]=True
                    EndIf
                EndIf
            EndIf
	Endif



If $pressed[$i] and not $keys[$i] Then
			$statepress[$l][$i]=1
			if $values[$l][$i]="" then ContinueLoop
			;if $buttonaction[$l][$i]<>4 then inptD($i,$values[$l][$i],1,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])
			if $buttonaction[$l][$i]<>3 and $buttonaction[$l][$i]<>4 and $buttonaction[$l][$i]<>7 and $buttonaction[$l][$i]<>9 then inptD($i,$values[$l][$i],1,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])

			$sentKeys[$i]=False

        $pressed[$i] = False
        $firstPressDone[$i] = False

		$VibratePressed[$VibrateIndex[$i]]=False

EndIf


if not $keys[$i] Then
	if $ToggleOn[$l][$i]=False then
$alreadyTimerscroll[$l][$i]=False
$timerscroll[$l][$i]=0
;;;;$pressed[$i] = False
	endif
endif

		if $keys[$i] and $Turbo[$l][$i]=True Then Turbo($i,$values[$l][$i],3,$buttontype[$l][$i])	  ; Turbo
		if $TurboToggleOn[$l][$i]=true Then Turbo($i,$values[$l][$i],3,$buttontype[$l][$i])			  ; TurboToggleOn with send
		if $TurboToggleComboOn[$l][$i]=true Then TurboCombo($i,$values[$l][$i],3,$buttontype[$l][$i]) ; TurboToggleCOmbo

		if $ToggleOn[$l][$i]=True and $buttontype[$l][$i]=2 Then  scrollWheelT($i,$values[$l][$i])	  ; Toggle with ScrollWheel
		if $SimpleMacroOn[$l][$i]=True Then	Sequence($i,$values[$l][$i],2,$buttontype[$l][$i])		  ; Sequence
		if $comboasyncOn[$l][$i]=True Then comboasync($i,$values[$l][$i],0,$buttontype[$l][$i])		  ; ComboAsyncOn
		if $HoldOn[$l][$i]=True then Hold($i,$values[$l][$i],0,$buttontype[$l][$i])					  ; Hold
		if $fastpressOn[$l][$i] then fastpresscheck($i,$values[$l][$i],0,$buttontype[$l][$i])		  ; Fastpress
		if $fastpressOnH[$l][$i] then fastpresscheckH($i,$values[$l][$i],$statePress[$l][$i],$buttontype[$l][$i]) ; Fastpress "helper" for release

		if $keys[$i] and $TurboCombo[$l][$i]=True and $TurboToggleComboOn[$l][$i]=False Then  TurboCombo($i,$values[$l][$i],3,$buttontype[$l][$i])


		if $combo[$l][$i]=True and not $keys[$i] Then $pressed[$i] = False

		if $TurboToggle[$l][$i]=true and not $keys[$i] Then $released[$i]=True
		if $TurboToggleCombo[$l][$i]=true and not $keys[$i] Then $released[$i]=True
Next
endfunc
#EndRegion

#Region Inpt() e InptD()
func inpt($ix,$value,$state,$btype,$baction,$specialkey)
consolewrite($buttonaction[$l][$ix] & @CRLF)
switch $baction
	case 0 ; normal key
		sender($ix,$value,$state,$btype,$specialkey)
	case 1 ; Toggle
		Toggle($ix,$value,0,$btype)
	case 2 ; Turbo
		;
	case 3 ; TurboToggle
$released[$ix]=False
$TurboToggleOn[$l][$ix]=not $TurboToggleOn[$l][$ix]
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
$TurboToggleComboOn[$l][$ix]=not $TurboToggleComboOn[$l][$ix]
	case 10; Sequence
		Sequence($ix,$value,$state,$btype)
	case 11; Text
		senderText($ix,$value,$state)
	case 12; Hold
		Hold($ix,$value,$state,$btype)
	case 13; Fastpress
		Fastpress($ix,$value,$state,$btype)
	case 14; Shiftmode
		ShiftMode($ix,$value,$state,$btype)
	case 15; ShiftModeToggle
		ShiftModeToggle($ix,$value,$state,$btype)
	case 16; ShiftModeCycle-
		ShiftModeCycleMinus($ix,$value,$state,$btype)
	case 17; ShiftModeCycle+
		ShiftModeCyclePlus($ix,$value,$state,$btype)
	case 18; Shift
		shift($ix,$value,$state,$btype)
	case 19; Layer/set back
		Layerchange($ix,$value,$state,$btype)
	case 20; Layer/set change
		Layerchange($ix,$value,$state,$btype)
	case 21; LayerModeToggle/SetModeToggle
		LayerToggle($ix,$value,$state,$btype)
	case 22; Layer/set cycle-
		LayercycleMinus($ix,$value,$state,$btype)
	case 23; Layer/set cycle+
		LayercyclePlus($ix,$value,$state,$btype)
endswitch

endfunc


func inptD($ix,$value,$state,$btype,$baction,$specialkey)

switch $baction
	case 0 ; normal key
		sender($ix,$value,$state,$btype,$specialkey)
	case 1 ; Toggle
		Toggle($ix,$value,0,$btype)
	case 2 ; Turbo
		;
	case 3 ; TurboToggle
$released[$ix]=False
$TurboToggleOn[$l][$ix]=not $TurboToggleOn[$l][$ix]
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
$TurboToggleComboOn[$l][$ix]=not $TurboToggleComboOn[$l][$ix]
	case 10; Sequence
		Sequence($ix,$value,$state,$btype)
	case 11; Text
		senderText($ix,$value,$state)
	case 12; Hold
		Hold($ix,$value,$state,$btype)
	case 13; Fastpress
		Fastpress($ix,$value,$state,$btype)
	case 14; Shiftmode
		ShiftMode($ix,$value,$state,$btype)
	case 15; ShiftModeToggle
		ShiftModeToggle($ix,$value,$state,$btype)
	case 16; ShiftModeCycle-
		ShiftModeCycleMinus($ix,$value,$state,$btype)
	case 17; ShiftModeCycle+
		ShiftModeCyclePlus($ix,$value,$state,$btype)
	case 18; Shift
		shift($ix,$value,$state,$btype)
	case 19; Layer/set back
		Layerchange($ix,$value,$state,$btype)
	case 20; Layer/set change
		Layerchange($ix,$value,$state,$btype)
	case 21; LayerModeToggle/SetModeToggle
		LayerToggle($ix,$value,$state,$btype)
	case 22; Layer/set cycle-
		LayercycleMinus($ix,$value,$state,$btype)
	case 23; Layer/set cycle+
		LayercyclePlus($ix,$value,$state,$btype)
endswitch

endfunc
#EndRegion



func vibrate()

for $i=0 to $VibrateBmaxN-1


switch $VibrateButton_Style[$i]

case 0
	if ($values[$l][$vibrateIndex2[$i]]<>"" and $VibrateButton[$i]=True) and ($VibrateButton_Modifier[$i]="NAA" or ($VibrateButton_Modifier[$i]=True and $VibrateButton_Modifier[$i]>0) ) then
	;if ($values[$l][$hashValues.Item($VibrateButtonS[$i])]<>"" and $VibrateButton[$i]=True) and ($VibrateButton_Modifier[$i]="NAA" or ($VibrateButton_Modifier[$i]=True and $VibrateButton_Modifier[$i]>0) ) then
	;if $VibrateButton[$i]=True and $VibrateButton_Modifier[$i]=True then
		VibrateAccumulator($i,$VibrateButton_LeftMotorStrength[$i], $VibrateButton_RightMotorStrength[$i])
		$vibrateOn[$i]=1
	elseif 	$VibrateButton[$i]=False and $vibrateOn[$i]=1  Then
		$vibrateOn[$i]=False
		VibrateAccumulator($inputhwnd, 0, 0)
	endif

case 1
	if ($values[$l][$vibrateIndex2[$i]]<>"" and $VibrateButton[$i]=True and $vibrateOn[$i]=0 and $vibratePressed[$i]=False) and ($VibrateButton_Modifier[$i]="NAA" or ($VibrateButton_Modifier[$i]=True and $VibrateButton_Modifier[$i]>0) ) Then
	;if ($values[$l][$hashValues.Item($VibrateButtonS[$i])]<>"" and $VibrateButton[$i]=True and $vibrateOn[$i]=0 and $vibratePressed[$i]=False) and ($VibrateButton_Modifier[$i]="NAA" or ($VibrateButton_Modifier[$i]=True and $VibrateButton_Modifier[$i]>0) ) Then
	;if $VibrateButton[$i]=True and $vibrateOn[$i]=0 and $vibratePressed[$i]=False and $VibrateButton_Modifier[$i]=True then
		$TimerVibrate[$i]= timerInit()
		$vibrateOn[$i]=1
		$VibratePressed[$i]=True
		VibrateAccumulator($i,$VibrateButton_LeftMotorStrength[$i], $VibrateButton_RightMotorStrength[$i])
	endif

	if $vibrateOn[$i]= 1 then
			if timerdiff($TimerVibrate[$i])>=$VibrateButton_SingleDuration[$i] then
				$vibrateOn[$i]=0
				VibrateAccumulator($inputhwnd, 0, 0)
			endif
	endif

case 2
	;if ($values[$l][$i]<>"" and $VibrateButton[$i]=True and $vibrateOn[$i]=0) and ($VibrateButton_Modifier[$i]="NAA" or $VibrateButton_Modifier[$i]=True) Then
	;if ($values[$l][$hashValues.Item($VibrateButtonS[$i])]<>"" and $VibrateButton[$i]=True and $vibrateOn[$i]=0) and ($VibrateButton_Modifier[$i]="NAA" or ($VibrateButton_Modifier[$i]=True and $VibrateButton_Modifier[$i]>0 ) ) Then
	if ($values[$l][$vibrateIndex2[$i]]<>"" and $VibrateButton[$i]=True and $vibrateOn[$i]=0) and ($VibrateButton_Modifier[$i]="NAA" or ($VibrateButton_Modifier[$i]=True and $VibrateButton_Modifier[$i]>0 ) ) Then

		$TimerVibrate[$i]= timerInit()
		$vibrateOn[$i]=1
		VibrateAccumulator($i,$VibrateButton_LeftMotorStrength[$i], $VibrateButton_RightMotorStrength[$i])
	endif

	if $vibrateOn[$i]= 1 then
			if timerdiff($TimerVibrate[$i])>=$VibrateButton_RepeatDuration[$i] then
			$TimerInterval[$i]=timerinit()
			$TimerVibrate[$i]=0
			$vibrateOn[$i]= 2
			VibrateAccumulator($inputhwnd, 0, 0)
			endif
	endif

	if $vibrateOn[$i]= 2 then
			if timerdiff($TimerInterval[$i])>=$VibrateButton_RepeatInterval[$i] Then
			;$TimerVibrate[$i]= timerInit()
			$vibrateOn[$i]= 0
			VibrateAccumulator($inputhwnd, 0, 0)
			endif
	endif


Endswitch
next

endfunc


func VibrateAccumulator($ix, $SX, $DX)

$vibrationValSX=$SX
$vibrationValDX=$DX

;$vibrationValSX=0
;$vibrationValDX=0

for $u=0 to $VibrateBmaxN-1


	if $vibrateOn[$u]=1 then
if $VibrateButton_LeftMotorStrength[$u]>$vibrationValSX then $vibrationValSX= $VibrateButton_LeftMotorStrength[$u]
if $VibrateButton_RightMotorStrength[$u]>$vibrationValDX then $vibrationValDX= $VibrateButton_RightMotorStrength[$u]
		;_XinputVibrate($inputhwnd, $vibrationValSX, $vibrationValDX)
	endif


next


if $vibrationValSX>0 or $vibrationValDX>0 then
_XinputVibrate($inputhwnd, $vibrationValSX, $vibrationValDX)
;Elseif $vibrationValSX=0 and $vibrationValDX=0 then
else
_XinputVibrate($inputhwnd, 0, 0)
endif



endfunc



#Region funcs group1()
func fastpress($ix,$value,$state,$btype)

if $state=0 then
	if $fastpresson[$l][$ix]=False then
		$fastpresson[$l][$ix]=True
		$tap[$l][$ix]=1
		$fastpresstimer[$l][$ix]=Timerinit()


	elseif $fastpresson[$l][$ix]=True then
		if $keys[$ix] then
			$tap[$l][$ix]+=1
			$fastpresstimer[$l][$ix]=Timerinit()
		endif
	endif
endif

endfunc

func fastpresscheckH($ix,$value,$state,$btype)
	if $state=1 then
sender($ix,$FastpressKeys[$l][$ix][$oldtap[$l][$ix]],1,$btype,$specialkeys2DFastpress[$l][$ix][$oldtap[$l][$ix]])
	$fastpressOnH[$l][$ix]=False
	endif

endfunc

func fastpresscheck($ix,$value,$state,$btype)

if $tap[$l][$ix]=1 and timerdiff($fastpresstimer[$l][$ix])>$fastPressTime then
sender($ix,$FastpressKeys[$l][$ix][1],0,$btype,$specialkeys2DFastpress[$l][$ix][1])
$fastpresson[$l][$ix]=False
$fastpresstimer[$l][$ix]=0
$tap[$l][$ix]=0
$oldtap[$l][$ix]=1
$fastpressOnH[$l][$ix]=True


elseif $tap[$l][$ix]=2 and timerdiff($fastpresstimer[$l][$ix])>$fastPressTime then
;sender($ix,$FastpressKeys[$l][$ix][2],0,$btype,$specialkeys2DFastpress[$l][$ix][1])
sender($ix,$FastpressKeys[$l][$ix][2],0,$btype,$specialkeys2DFastpress[$l][$ix][2])
$fastpresson[$l][$ix]=False
$fastpresstimer[$l][$ix]=0
$tap[$l][$ix]=0
$oldtap[$l][$ix]=2
$fastpressOnH[$l][$ix]=True

elseif $tap[$l][$ix]=3 and timerdiff($fastpresstimer[$l][$ix])>$fastPressTime then
;sender($ix,$FastpressKeys[$l][$ix][3],0,$btype,$specialkeys2DFastpress[$l][$ix][1])
sender($ix,$FastpressKeys[$l][$ix][3],0,$btype,$specialkeys2DFastpress[$l][$ix][3])
$fastpresson[$l][$ix]=False
$fastpresstimer[$l][$ix]=0
$tap[$l][$ix]=0
$oldtap[$l][$ix]=3
$fastpressOnH[$l][$ix]=True

elseif $tap[$l][$ix]>3 then
	$tap[$l][$ix]=1
	$fastpresstimer[$l][$ix]=TimerInit() ;probably not necessary
endif

endfunc


func shift($ix,$value,$state,$btype)
		if $state=0 then
					;$shilimit=$shiftnum[$ix]
					$shilimit=$shiftnum[$l][$ix]
			$tempshinum=$shinum
			if $tempshinum>$shiftnum[$l][$ix] then $tempshinum=$shiftnum[$l][$ix]
			if $shinum>$shiftnum[$l][$ix] then
					$previouslimit=$shinum
				$shinum=$shiftnum[$l][$ix]
				$shilimit=$shiftnum[$l][$ix]
			endif
				if $previouslimit=$shiftnum[$l][$ix] then
					$shinum=$previouslimit
					$shilimit=$shiftnum[$l][$ix]
					$previouslimit=""
				endif
				if $shinum<$shiftnum[$l][$ix] and $previouslimit>$shinum  then
					$shinum=$previouslimit
					$shilimit=$shiftnum[$l][$ix]
					$previouslimit=""
				endif
			sender($ix,$shiftkeys[$l][$ix][$shinum],$state,$shifttype[$l][$ix][$shinum],$specialkeys2DShift[$l][$ix][$shinum])
		endif
		if $state=1 Then sender($ix,$shiftkeys[$l][$ix][$tempshinum],$state,$shifttype[$l][$ix][$tempshinum],$specialkeys2DShift[$l][$ix][$tempshinum])
endfunc

func ShiftMode($ix,$value,$state,$btype)
	if $state=0 then $shinum=$values[$l][$ix]
	if $state=1 Then $shinum=$newshinum
endfunc

func ShiftModeToggle($ix,$value,$state,$btype)
	if $ShiftModeToggleOn[$l][$ix]=False and $keys[$ix] Then
		$ShiftModeToggleOn[$l][$ix]=True
		$shinum=$values[$l][$ix]
		$newshinum=$shinum
	elseif $ShiftModeToggleOn[$l][$ix]=True and $keys[$ix] Then
		$shinum=1
		$newshinum=$shinum
		$ShiftModeToggleOn[$l][$ix]=False
	endif

endfunc


func ShiftModeCyclePlus($ix,$value,$state,$btype)
	if $state=0 then $shinum+=1
	if $shinum>$shiLimit then
		$shinum=1
		$shiLimit=$shiftMax-1
		$previouslimit=""
		Return
	endif

endfunc


func ShiftModeCycleMinus($ix,$value,$state,$btype)
	if $state=0 and $shinum>=1 then
		$shinum-=1
		$previouslimit=""
	endif

	if $shinum<1 then
		$shinum=$shiftMax-1
		$shiLimit=$shiftMax-1
		Return
	endif
endfunc

func sendertext($ix,$value, $state)
	if $state=0 then send($value)
endfunc
#endregion


#Region Sender()
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
#EndRegion

#Region Stats

func statsstart()
	if not $splashreload then $statsOn=not $statsOn

if $statsOn then
	$stats=SplashTextOn($inifile,$textstats,@DesktopWidth/2.5,@DesktopHeight/2,0,0,4,"Consolas",@DesktopWidth/174.545)
	;$stats=SplashTextOn($inifile,$textstats,@DesktopWidth/3,@DesktopHeight/2.4,0,0,4,"Consolas",@DesktopWidth/174.545)
	;;;$stats2=SplashTextOn("",$textstats,@DesktopWidth/6,@DesktopHeight/3,@DesktopWidth/6,0,4,"Consolas",11)
	adlibregister(stats,50)
endif
if not $statsOn and not $splashreload  then
	SplashOff()
	adlibunregister(stats)
endif


endfunc

func statsvar()


	global $deadzoneshapetext, $AnalogToMouseText, $MouseDeadzoneTypeText, $Mousedeadzonetext, $MouseAxisInvertedText, $AnalogsDeadzoneTypeText, $AnalogsDeadzoneText, $AnalogsAxisInvertedText, $assignmentstext, $sendkeystypetext

	if $deadzoneshape=1 and $Mousedeadzonetype=1 then $deadzoneshapetext="Square"
	if $deadzoneshape=1 and $Mousedeadzonetype<>1 then $deadzoneshapetext="Rectangular"
	if $deadzoneshape=2 then $deadzoneshapetext="Circular"
	if $deadzoneshape=3 then $deadzoneshapetext="Circular with rescale"


	if $MouseDeadzoneType=1 Then
	$MouseDeadzoneTypeText="Both axis"
	$MouseDeadzoneText=$MouseDeadzone
	endif

	if $MouseDeadzoneType=2 Then
	$MouseDeadzoneTypeText="Per axis"
	$MouseDeadzoneText="X: " & $Xdeadzone & " Y:" & $Ydeadzone
	endif

	if $MouseDeadzoneType=3 Then
	$MouseDeadzoneTypeText="Per direction"
	$MouseDeadzoneText="Left: " & $Xleftdeadzone & " Right:" & $Xrightdeadzone  &  " Up: " & $Yupdeadzone & " Down: " & $Ydowndeadzone
	endif

	$MouseAxisInvertedText="No"
	if $LSXInverted=1 or $LSYInverted=1 or $RSXInverted=1 or $RSYInverted=1 then $MouseAxisInvertedText=""

	if ($LSXInverted=1 and $Stick="LS") or ($RSXInverted=1 and $Stick="RS") then $MouseAxisInvertedText&="X "
	if ($LSYInverted=1 and $Stick="LS") or ($RSYInverted=1 and $Stick="RS") then $MouseAxisInvertedText&="Y "


	if $AnalogToMouse=1 then $AnalogToMouseText="Yes"
	if $AnalogToMouse<>1 then $AnalogToMouseText="  "

	if $AnalogsDeadzoneType=1 then
		$AnalogsDeadzoneTypeText="Global"
		$AnalogsDeadzoneText= $AnalogsDeadzone
	endif
	if $AnalogsDeadzoneType=2 then
		$AnalogsDeadzoneTypeText="Per stick"
		$AnalogsDeadzoneText= "LS: " & $LSdeadzone & " RS: " & $RSdeadzone
	endif
	if $AnalogsDeadzoneType=3 then
		$AnalogsDeadzoneTypeText="Per axis"
		$AnalogsDeadzoneText= "LSx: " & $LSXdeadzone & " LSy: " & $LSYdeadzone & " RSx: " & $RSxdeadzone & " RSy: " & $RSydeadzone
	endif
	if $AnalogsDeadzoneType=4 then
		$AnalogsDeadzoneTypeText="Per direction"
		$AnalogsDeadzoneText= "LSleft: " & $LSleft & " LSright: " & $LSright & 	" LSup: " & $LSup & " LSdown: " & $LSdown	 &  		"RSleft: " & $RSleft & " RSright: " & $RSright & " RSup: " & $RSup & " RSdown: " & $RSdown
	endif


	$AnalogsAxisInvertedText="No"
	if $LSXaxisInverted=1 or $LSYaxisInverted=1 or $RSXaxisInverted=1 or $RSYaxisInverted=1 then $AnalogsAxisInvertedText=""
	if $LSXaxisInverted=1 then $AnalogsAxisInvertedText&="LSX "
	if $LSYaxisInverted=1 then $AnalogsAxisInvertedText&="LSY "
	if $RSXaxisInverted=1 then $AnalogsAxisInvertedText&="RSX "
	if $RSYaxisInverted=1 then $AnalogsAxisInvertedText&="RSY "

	if $SendKeysType=1 then $sendkeystypetext=" (Game)"
	if $SendKeysType=2 then $sendkeystypetext=" (Desktop)"


endfunc


Func stats()


;for $i=0 to ubound($values)-1
;$assignmentstext&=$values[$i] & @CRLF
for $i=0 to ubound($values,2)-1
$assignmentstext&=$values[$l][$i] & @CRLF
next

local $ltype
if $layertype[$l]=0 then $ltype="Layer"
if $layertype[$l]=1 then $ltype="Set"
if $l=0 then $LayerName[$l]= "Buttons"

			   $textstat = _
			   StringFormat("LSX: %-6s RSX: %-6s LT: %-6s", $LSX, $RSX, $LT) & @CRLF & _
			   StringFormat("LSY: %-6s RSY: %-6s RT: %-6s", $LSY, $RSY, $RT) & @CRLF   _
			   & @CRLF _
			   & "[Mouse]"  & @CRLF _
			   & "AnalogToMouse: " & $AnalogToMouseText & "   | Stick:" & $Stick & @CRLF _
			   & "DeadzoneShape: " & $DeadzoneShapetext & @CRLF _
			   & "DeadzoneType:  " & $MouseDeadzoneTypeText  & @CRLF _
			   & "Deadzone:      " & $Mousedeadzone &  @CRLF _
			   & "AxisInverted:  " & $MouseAxisInvertedText  & @CRLF _
			   &  @CRLF _
			   & "[Analogs]" & "                          " & @CRLF _
			   & "DeadzoneType:  " & $AnalogsDeadzoneTypeText & @CRLF _
			   & "Deadzone:      " & $AnalogsDeadzoneText & @CRLF _
			   & "AxisInverted:  " & $AnalogsAxisInvertedText & @CRLF _
			   &  @CRLF _
			   & "[Other]" & @CRLF _
			   & "SendKeysType:    " & $SendKeysType & $sendkeystypetext & @CRLF _
			   & "TurboRepeatTime: " & $repeatTime & @CRLF _
			   & "ComboAsyncDelay: " & $combotime & @CRLF _
			   & "SequenceTime:    " & $SequenceTime & @CRLF _
			   & "HoldTime:        " & $HoldTime & @CRLF _
			   & "FastPressTime:   " & $FastPressTime & @CRLF _
			   & "ShiftTogKeybVal: " & $ShiftModeToggleKVal & @CRLF _
			   & "KeyboardToggleLayerType: " & $LayerToggleKtype & @CRLF _
			   & "CurLayerN: " & $l & @CRLF _
			   & "CurLayerName: "  & $LayerName[$l] & @CRLF _
			   & "CurLayerType: " & $ltype & @CRLF _ ;& $layertype[$l]
			   & "LayerToCycle: " & "↵" & @CRLF _
			   & $LayerToCycleSS


$textstat3=""
local $pressedText[$asize]


for $i=0 to 24
	if $keys[$i] then $pressedText[$i]=">"
	if not $keys[$i] then $pressedText[$i]=" "
	if $buttonaction[$l][$i]=22 or $buttonaction[$l][$i]=23 then $valuesS[$l][$i]=""

 ;$textstat3 &= $pressedText[$i] & " " & $buttonsname[$i] & ": " & $actionnameS[$i] & "" & stringleft($values[$i],25) & @CRLF
 ;$textstat3 &= $pressedText[$i] & " " & $buttonsname[$i] & ": " & $actionnameS[$l][$i] & "" & stringleft($values[$l][$i],33) & @CRLF
 $textstat3 &= $pressedText[$i] & " " & $buttonsname[$i] & ": " & $actionnameS[$l][$i] & "" & stringleft($valuesS[$l][$i],30) & @CRLF
next


local $textleft[200], $textright[200]

$textLeftN = StringSplit($textstat, @CRLF)
$textRightN = StringSplit($textstat3, @CRLF)


for $i=1 to $textLeftN[0]
$textleft[$i]=$textLeftN[$i]
next

for $i=1 to $textRightN[0]
$textRight[$i]=$textRightN[$i]
next


local $newtextstat=""

;for $i=1 to $textleftN[0] step 2
for $i=1 to _max($textleftN[0], $textrightN[0]) step 2
 ;$newtextstat &= StringFormat("%-35s %-15s", $textleft[$i], $textright[$i]) & @CRLF
 ;$newtextstat &= StringFormat("%-35s %-15s", stringleft($textleft[$i],33), $textright[$i]) & @CRLF
 $newtextstat &= StringFormat("%-40s %-15s", stringleft($textleft[$i],40), $textright[$i]) & @CRLF
next

	;ControlSetText($stats, "", "Static1", $newtextstat)
	    If $newtextstat <> $LastStatsText Then
			$LastStatsText = $newtextstat
			ControlSetText($stats, "", "Static1", $newtextstat)
		EndIf
endfunc

func scrollwheelT($ix,$value)

	if ($Analogscrollrepeat=1 and ($ix>=17 or $ix=6 or $ix=7)) or ($Digitalscrollrepeat=1 and $ix<17 and $ix<>6 and $ix<>7) then
		if $ToggleOn[$l][$ix]=False then $pressed[$ix]=False

		if $alreadytimerscroll[$l][$ix]=False then
		scrollwheel($ix,$value)
		$alreadytimerscroll[$l][$ix]=True
		$timerscroll[$l][$ix]=TimerInit()

		elseif TimerDiff($timerscroll[$l][$ix])>150 then
		scrollwheel($ix,$value)
		$timerscroll[$l][$ix]=TimerInit()
		endif

	Else
	scrollwheel($ix,$value)
	endif


	endfunc

;[-] Stats
#EndRegion

#Region funcs group2()

func executes($ix,$value)
	shellexecute($value)
endfunc

func Toggle($ix,$value,$state,$btype)

	if $toggleOn[$l][$ix]=False and $keys[$ix]=True Then
	$toggleOn[$l][$ix]=True

	sender($ix,$value,0,$btype,$specialkeys[$l][$ix])

	elseif $toggleOn[$l][$ix]=True and $keys[$ix]=True then
	$toggleOn[$l][$ix]=False
	sender($ix,$value,1,$btype,$specialkeys[$l][$ix])
	endif

endfunc


func Turbo($ix,$value,$state,$btype)
	if $alreadyTimer[$l][$ix]=False then
	sender($ix,$value,$state,$btype,$specialkeys[$l][$ix])
	$alreadyTimer[$l][$ix]=True
	$timerT[$l][$ix]=_Timer_Init()
	endif

	if _Timer_Diff($timerT[$l][$ix])>$repeatTime then
	sender($ix,$value,$state,$btype,$specialkeys[$l][$ix])
	$timerT[$l][$ix]=_Timer_Init()
	endif
endfunc


func Turbo3($ix,$value,$state,$btype)
	if $alreadyTimer[$l][$ix]=False then
	sender($ix,$value,0,$btype,$specialkeys[$l][$ix])
	$alreadyTimer[$l][$ix]=True
	$timerT[$l][$ix]=_Timer_Init()
	endif

	if _Timer_Diff($timerT[$l][$ix])>$repeatTime then
	sender($ix,$value,0,$btype,$specialkeys[$l][$ix])
	sender($ix,$value,1,$btype,$specialkeys[$l][$ix])
	$timerT[$l][$ix]=_Timer_Init()
	endif
endfunc



func TurboCombo($ix,$value,$state,$btype)

	if $TurboComboalreadyTimer[$l][$ix]=False then

	;for $k=1 to Ubound($Turbocombokeys,$UBOUND_COLUMNS)-1
	for $k=1 to Ubound($Turbocombokeys,3)-1

			if $Turbocombokeys[$l][$ix][$k] then
				sender($ix,$Turbocombokeys[$l][$ix][$k],$state,$TurbocomboType[$l][$ix][$k],$specialkeys2DCombo[$l][$ix][$k])
				$sentkeys[$ix]=True
			endif
	next

	$TurboComboalreadyTimer[$l][$ix]=True
	$TurboCombotimerT[$l][$ix]=_Timer_Init()
	endif


	if _Timer_Diff($TurboCombotimerT[$l][$ix])>$repeatTime then

	;for $ki=1 to Ubound($Turbocombokeys,$UBOUND_COLUMNS)-1
	for $ki=1 to Ubound($Turbocombokeys,3)-1

			if $Turbocombokeys[$l][$ix][$ki] then
				sender($ix,$Turbocombokeys[$l][$ix][$ki],$state,$TurbocomboType[$l][$ix][$ki],$specialkeys2DCombo[$l][$ix][$ki])  ; bugfix: $specialkeys2DCombo[$l][$ix][$k] -> $specialkeys2DCombo[$l][$ix][$ki]
				$sentkeys[$ix]=True
			endif
	next

	$TurboCombotimerT[$l][$ix]=_Timer_Init()
	;$pressed[$i]=False
	endif

endfunc


func ToggleCombo($ix,$value,$state,$btype)
	if $toggleComboOn[$l][$ix]=False and $keys[$ix]=True Then
	$toggleComboOn[$l][$ix]=True


	;for $k=1 to Ubound($Togglecombokeys,$UBOUND_COLUMNS)-1
	for $k=1 to Ubound($Togglecombokeys,3)-1
		if $Togglecombokeys[$l][$ix][$k] then
			sender($ix,$Togglecombokeys[$l][$ix][$k],0,$TogglecomboType[$l][$ix][$k],$specialkeys2DCombo[$l][$ix][$k])
			$sentkeys[$ix]=True
		endif
	next


	elseif $toggleComboOn[$l][$ix]=True and $keys[$ix]=True then
	$toggleComboOn[$l][$ix]=False

	for $k=1 to Ubound($combokeys,3)-1
			if $Togglecombokeys[$l][$ix][$k] then sender($ix,$Togglecombokeys[$l][$ix][$k],1,$TogglecomboType[$l][$ix][$k],$specialkeys2DCombo[$l][$ix][$k])
	next


	endif

endfunc

func COMBO($ix,$value,$state,$btype)
	for $k=1 to Ubound($combokeys,3)-1
		if $combokeys[$l][$ix][$k]="" then continueloop
			$sentkeys[$ix]=True
			sender($ix,$combokeys[$l][$ix][$k],$state,$combotype[$l][$ix][$k],$specialkeys2DCombo[$l][$ix][$k])
	next
endfunc


func COMBOasync($ix,$value,$state,$btype)
if $state=1 then return

	if $alreadytimerasync[$l][$ix]=False then
	$comboasyncOn[$l][$ix]=True
		if $combokeysasync[$l][$ix][1] then
			sender($ix,$combokeysasync[$l][$ix][1],0,$comboAsyncType[$l][$ix][1],$specialkeys2DCombo[$l][$ix][1])
			$sentkeys[$ix]=True
		endif
	$timerasync[$l][$ix]=TimerInit()
	$alreadytimerasync[$l][$ix]=True
	$combK[$l][$ix]=1
	endif

if $comboasyncOn[$l][$ix]=True then

	if TimerDiff($timerasync[$l][$ix])>$combotime then
			if $combK[$l][$ix]<$comboasyncNum[$l][$ix] then $combK[$l][$ix]+=1
		if $combokeysasync[$l][$ix][$combK[$l][$ix]] then
			sender($ix,$combokeysasync[$l][$ix][$combK[$l][$ix]],0,$comboAsyncType[$l][$ix][$combK[$l][$ix]],$specialkeys2DCombo[$l][$ix][$combK[$l][$ix]])
			$sentkeys[$ix]=True
		endif
	$timerasync[$l][$ix]=TimerInit()
	endif


	if $combK[$l][$ix]>=$comboasyncNum[$l][$ix] then
	for $k=1 to $comboasyncNum[$l][$ix]
		if $combokeysasync[$l][$ix][$k]="" then ContinueLoop
			sender($ix,$combokeysasync[$l][$ix][$k],1,$comboAsyncType[$l][$ix][$k],$specialkeys2DCombo[$l][$ix][$k])
			$sentkeys[$ix]=True
	next
	$comboasyncOn[$l][$ix]=False
	$alreadytimerasync[$l][$ix]=False
	$timerasync[$l][$ix]=0
	endif

endif

endfunc




func Hold($ix,$value,$state,$btype)

switch $HoldNum[$l][$ix]

case 1
		sender($ix,$HoldKeys[$l][$ix][1],3,$btype,$specialkeys2DHold[$l][$ix][1])
		return

case 2

	if $HoldOn[$l][$ix]=False then
		if $state=0 then
		$holdtimer[$l][$ix]=Timerinit()
		$HoldOn[$l][$ix]=True
		endif
	endif

	if $HoldOn[$l][$ix]=True then
		if timerdiff($holdtimer[$l][$ix])<$HoldTime Then
			if $state=1 then
				sender($ix,$HoldKeys[$l][$ix][1],3,$btype,$specialkeys2DHold[$l][$ix][1])
				$HoldOn[$l][$ix]=False
				$holdtimer[$l][$ix]=0
				return
			endif
		endif
		if timerdiff($holdtimer[$l][$ix])>=$HoldTime then
			sender($ix,$HoldKeys[$l][$ix][2],3,$btype,$specialkeys2DHold[$l][$ix][2])
			$holdtimer[$l][$ix]=0
			$HoldOn[$l][$ix]=False
		endif
	endif

case 3

	if $HoldOn[$l][$ix]=False then
		if $state=0 then
		$holdtimer[$l][$ix]=Timerinit()
		$HoldOn[$l][$ix]=True
		endif
	endif

	if $HoldOn[$l][$ix]=True then
		if timerdiff($holdtimer[$l][$ix])<$HoldTime Then

			if $state=1 then
				sender($ix,$HoldKeys[$l][$ix][1],3,$btype,$specialkeys2DHold[$l][$ix][1])
				$HoldOn[$l][$ix]=False
				$holdtimer[$l][$ix]=0
				return
			endif
		endif

	if $state=1 then
		if timerdiff($holdtimer[$l][$ix])>=$HoldTime and timerdiff($holdtimer[$l][$ix])<($HoldTime*2.5) then
			sender($ix,$HoldKeys[$l][$ix][2],3,$btype,$specialkeys2DHold[$l][$ix][2])
			$holdtimer[$l][$ix]=0
			$HoldOn[$l][$ix]=False
			return
		endif
	endif
		if timerdiff($holdtimer[$l][$ix])>=($HoldTime*2.5) then
			sender($ix,$HoldKeys[$l][$ix][3],3,$btype,$specialkeys2DHold[$l][$ix][3])
			$holdtimer[$l][$ix]=0
			$HoldOn[$l][$ix]=False
		endif
	endif

endswitch
endfunc




func Sequence($ix,$value,$state,$btype)

if $state=1 then return

	if $alreadytimerSimplemacro[$l][$ix]=False then
	$simpleMacroOn[$l][$ix]=True
		if $simpleMacrokeys[$l][$ix][1] then
			sender($ix,$simpleMacrokeys[$l][$ix][1],3,$simpleMacroType[$l][$ix][1],$specialkeys2DSequence[$l][$ix][1])
			$sentkeys[$ix]=True
		endif
	$timerSimpleMacro[$l][$ix]=TimerInit()
	$alreadytimerSimplemacro[$l][$ix]=True
	$SmacroK[$l][$ix]=1
	endif


if $simpleMacroOn[$l][$ix]=True then

	if TimerDiff($timerSimpleMacro[$l][$ix])>$SequenceTime then
			if $SmacroK[$l][$ix]<$SequenceNum[$l][$ix] then $SmacroK[$l][$ix]+=1
		if $simpleMacrokeys[$l][$ix][$SmacroK[$l][$ix]] then
			sender($ix,$simpleMacrokeys[$l][$ix][$SmacroK[$l][$ix]],$state,$simpleMacroType[$l][$ix][$SmacroK[$l][$ix]],$specialkeys2DSequence[$l][$ix][$SmacroK[$l][$ix]])
			$sentkeys[$ix]=True
		endif
	$timerSimpleMacro[$l][$ix]=TimerInit()
	endif


	if $SmacroK[$l][$ix]>=$SequenceNum[$l][$ix] then
		$simpleMacroOn[$l][$ix]=False
		$alreadytimerSimplemacro[$l][$ix]=False
		$timerSimpleMacro[$l][$ix]=0
	endif

endif


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
#endregion

#Region Parse()
func parse($cl)
	for $i=0 to Ubound($values,2)-1
		;$valuesS[$cl][$i]=""
	next
for $i=0 to Ubound($values,2)-1

	if (StringInStr($values[$cl][$i], "[Toggle]")) Then
		$toggle[$cl][$i]=True
		$values[$cl][$i]= stringreplace ($values[$cl][$i],"[Toggle]","")
		$values[$cl][$i]= StringStripWS($values[$cl][$i],8)
			$valuesS[$cl][$i]=" " & $values[$cl][$i]
		$buttonaction[$cl][$i]=1
		$actionName[$cl][$i]="TOGGLE"
		$actionNameS[$cl][$i]="[TOGGLE]"
		endif

	if (StringInStr($values[$cl][$i], "[TURBO]")) Then
		$Turbo[$cl][$i]=True
		;$values[$cl][$i]=Stringlower($values[$cl][$i])
		$values[$cl][$i]= stringreplace($values[$cl][$i],"[Turbo]","")
		$values[$cl][$i]= StringStripWS($values[$cl][$i],8)
			$valuesS[$cl][$i]=" " & $values[$cl][$i]
		$buttonaction[$cl][$i]=2
		$actionName[$cl][$i]="TURBO"
		$actionNameS[$cl][$i]="[TURBO]"
	endif

	if (StringInStr($values[$cl][$i], "[TURBOtoggle]")) Then
		$TurboToggle[$cl][$i]=True
		;$values[$cl][$i]=Stringlower($values[$cl][$i])
		$values[$cl][$i]= stringreplace($values[$cl][$i],"[TurboToggle]","")
		$values[$cl][$i]= StringStripWS($values[$cl][$i],8)
			$valuesS[$cl][$i]=" " & $values[$cl][$i]
		$buttonaction[$cl][$i]=3
		$actionName[$cl][$i]="TURBOTOGGLE"
		$actionNameS[$cl][$i]="[TURBOTOGGLE]"
	endif


	if (StringInStr($values[$cl][$i], "[execute]")) Then
	$execute[$cl][$i]=True
	$values[$cl][$i]= stringreplace($values[$cl][$i],"[execute]","")
	$values[$cl][$i]= StringStripWS($values[$cl][$i],3)
		$valuesS[$cl][$i]=" " & $values[$cl][$i]
	$buttonaction[$cl][$i]=4
	$actionName[$cl][$i]="EXECUTE"
	$actionNameS[$cl][$i]="[EXECUTE]"
	endif


		if (StringInStr($values[$cl][$i], "[COMBO]")) Then
			$valuesS[$cl][$i]=""
		$Combo[$cl][$i]=True
		$values[$cl][$i]=stringreplace($values[$cl][$i],"[COMBO]","")
		local $combokeysL=StringSplit($values[$cl][$i],",")
			if $combokeysL[0]>$combosize-1 then $combokeysL[0]=$combosize-1

		for $j=1 to $combokeysL[0]
			$combokeys[$cl][$i][$j]=$combokeysL[$j]
			;$combokeys[$i][$j]=Stringlower($combokeys[$i][$j])
			$combokeys[$cl][$i][$j]=StringStripWS($combokeys[$cl][$i][$j],8)
			$keysfromcombo[$cl][$i]&= "{" & ($combokeys[$cl][$i][$j]) & "}"
			$keysfromcombodown[$cl][$i]&= "{" & ($combokeys[$cl][$i][$j]) & " down} "
			$keysfromcomboup[$cl][$i]&= "{" & ($combokeys[$cl][$i][$j]) & " up} "

				if $j=1 then $valuesS[$cl][$i] = " " & $valuesS[$cl][$i]
				If $j > 1 Then $valuesS[$cl][$i] &= ", "
				$valuesS[$cl][$i] &= $combokeys[$cl][$i][$j]

			local $val=buttontype($combokeys,$combotype,$cl,$i,$j)
			$combokeys[$cl][$i][$j]=$val[0]
			$combotype[$cl][$i][$j]=$val[1]

			if $combokeys[$cl][$i][$j]= "Lctrl" or $combokeys[$cl][$i][$j]="Lalt" or $combokeys[$cl][$i][$j]="Lwin" or $combokeys[$cl][$i][$j]="Rwin" or $combokeys[$cl][$i][$j]="Rctrl" or $combokeys[$cl][$i][$j]="Ralt" then $specialkeys2DCombo[$cl][$i][$j]=True
		next

		$values[$cl][$i]=$keysfromcombo[$cl][$i]




	$buttonaction[$cl][$i]=5
	$actionName[$cl][$i]="COMBO"
	$actionNameS[$cl][$i]="[COMBO]"


	endif



	if (StringInStr($values[$cl][$i], "[COMBOasync]")) Then
			$valuesS[$cl][$i]=""
		$ComboAsync[$cl][$i]=True
		$values[$cl][$i]=stringreplace($values[$cl][$i],"[COMBOasync]","")
				;$valuesS[$cl][$i]=$values[$cl][$i]
		 local $combokeysLasync=StringSplit($values[$cl][$i],",")
			if $combokeysLasync[0]>$combosize-1 then $combokeysLasync[0]=$combosize-1
			;if $combokeysLasync[0]>$combosize-1 then $valuesS[$cl][$i]=$values[$cl][$i]
			$comboasyncNum[$cl][$i]=$combokeysLasync[0]
			;msgbox("","",$i &" "&$comboasyncnum[$i])


		for $j=1 to $combokeysLasync[0]
			$combokeysasync[$cl][$i][$j]=$combokeysLasync[$j]
			$combokeysasync[$cl][$i][$j]=StringStripWS($combokeysasync[$cl][$i][$j],8)
			$keysfromcomboasync[$cl][$i]&= "{" & ($combokeysasync[$cl][$i][$j]) & "}"
			$keysfromcombodownasync[$cl][$i]&= "{" & ($combokeysasync[$cl][$i][$j]) & " down} "
			$keysfromcomboupasync[$cl][$i]&= "{" & ($combokeysasync[$cl][$i][$j]) & " up} "
			$comboasynctype[$cl][$i][$j]=$buttontype[$cl][$i]

				;$valuesS[$cl][$i]&=" " & $combokeysasync[$cl][$i][$j]
				;if $j<>$combokeysLasync[0] and $j>1 then
				;	$valuesS[$cl][$i]&=$combokeysasync[$cl][$i][$j] & ", "
				;Elseif $j=$combokeysLasync[0] then
				;	$valuesS[$cl][$i]&=$combokeysasync[$cl][$i][$j]
				;else
				;	$valuesS[$cl][$i]&=" " & $combokeysasync[$cl][$i][$j] & ", "
				;endif

				if $j=1 then $valuesS[$cl][$i] = " " & $valuesS[$cl][$i]
				If $j > 1 Then $valuesS[$cl][$i] &= ", "
				$valuesS[$cl][$i] &= $combokeysasync[$cl][$i][$j]

			local $val=buttontype($combokeysasync,$comboasynctype,$cl,$i,$j)
			$combokeysasync[$cl][$i][$j]=$val[0]
			$comboasynctype[$cl][$i][$j]=$val[1]

			if $combokeysasync[$cl][$i][$j]= "Lctrl" or $combokeysasync[$cl][$i][$j]="Lalt" or $combokeysasync[$cl][$i][$j]="Lwin" or $combokeysasync[$cl][$i][$j]="Rwin" or $combokeysasync[$cl][$i][$j]="Rctrl" or $combokeysasync[$cl][$i][$j]="Ralt" then $specialkeys2DCombo[$cl][$i][$j]=True
		next

	$values[$cl][$i]=$keysfromcomboasync[$cl][$i]
	$async[$cl][$i] = True

	$buttonaction[$cl][$i]=6
	$actionName[$cl][$i]="COMBOASYNC"
	$actionNameS[$cl][$i]="[COMBOASYNC]"

	endif



	if (StringInStr($values[$cl][$i], "[ToggleCOMBO]")) Then
			$valuesS[$cl][$i]=""
		$ToggleCombo[$cl][$i]=True
		$values[$cl][$i]=stringreplace($values[$cl][$i],"[ToggleCOMBO]","")
		local $TogglecombokeysL=StringSplit($values[$cl][$i],",")
			if $TogglecombokeysL[0]>$combosize-1 then $TogglecombokeysL[0]=$combosize-1

		for $j=1 to $TogglecombokeysL[0]
			$Togglecombokeys[$cl][$i][$j]=$TogglecombokeysL[$j]
			;$Togglecombokeys[$i][$j]=Stringlower($Togglecombokeys[$i][$j])
			$Togglecombokeys[$cl][$i][$j]=StringStripWS($Togglecombokeys[$cl][$i][$j],8)
			$Togglekeysfromcombo[$cl][$i]&= "{" & ($Togglecombokeys[$cl][$i][$j]) & "}"
			$Togglekeysfromcombodown[$cl][$i]&= "{" & ($Togglecombokeys[$cl][$i][$j]) & " down} "
			$Togglekeysfromcomboup[$cl][$i]&= "{" & ($Togglecombokeys[$cl][$i][$j]) & " up} "
			$ToggleComboType[$cl][$i][$j]=$buttontype[$cl][$i]

				if $j=1 then $valuesS[$cl][$i] = " " & $valuesS[$cl][$i]
				If $j > 1 Then $valuesS[$cl][$i] &= ", "
				$valuesS[$cl][$i] &= $Togglecombokeys[$cl][$i][$j]

			local $val=buttontype($Togglecombokeys,$ToggleComboType,$cl,$i,$j)
			$Togglecombokeys[$cl][$i][$j]=$val[0]
			$Togglecombotype[$cl][$i][$j]=$val[1]

			if $Togglecombokeys[$cl][$i][$j]= "Lctrl" or $Togglecombokeys[$cl][$i][$j]="Lalt" or $Togglecombokeys[$cl][$i][$j]="Lwin" or $Togglecombokeys[$cl][$i][$j]="Rwin" or $Togglecombokeys[$cl][$i][$j]="Rctrl" or $Togglecombokeys[$cl][$i][$j]="Ralt" then $specialkeys2DCombo[$cl][$i][$j]=True
		next

		$values[$cl][$i]=$Togglekeysfromcombo[$cl][$i]

	$buttonaction[$cl][$i]=7
	$actionName[$cl][$i]="TOGGLECOMBO"
	$actionNameS[$cl][$i]="[TOGGLECOMBO]"
	endif


		if (StringInStr($values[$cl][$i], "[TurboCOMBO]")) Then
			$valuesS[$cl][$i]=""
		$TurboCombo[$cl][$i]=True
		$values[$cl][$i]=stringreplace($values[$cl][$i],"[TurboCOMBO]","")
		local $TurbocombokeysL=StringSplit($values[$cl][$i],",")
			if $TurbocombokeysL[0]>$combosize-1 then $TurbocombokeysL[0]=$combosize-1

		for $j=1 to $TurbocombokeysL[0]
			$Turbocombokeys[$cl][$i][$j]=$TurbocombokeysL[$j]
			;$Turbocombokeys[$i][$j]=Stringlower($Turbocombokeys[$i][$j])
			$Turbocombokeys[$cl][$i][$j]=StringStripWS($Turbocombokeys[$cl][$i][$j],8)
			$Turbokeysfromcombo[$cl][$i]&= "{" & ($Turbocombokeys[$cl][$i][$j]) & "}"
			$Turbokeysfromcombodown[$cl][$i]&= "{" & ($Turbocombokeys[$cl][$i][$j]) & " down} "
			$Turbokeysfromcomboup[$cl][$i]&= "{" & ($Turbocombokeys[$cl][$i][$j]) & " up} "
			$TurboComboType[$cl][$i][$j]=$buttontype[$cl][$i]

				if $j=1 then $valuesS[$cl][$i] = " " & $valuesS[$cl][$i]
				If $j > 1 Then $valuesS[$cl][$i] &= ", "
				$valuesS[$cl][$i] &= $Turbocombokeys[$cl][$i][$j]

			local $val=buttontype($Turbocombokeys,$Turbocombotype,$cl,$i,$j)
			$Turbocombokeys[$cl][$i][$j]=$val[0]
			$Turbocombotype[$cl][$i][$j]=$val[1]

			if $Turbocombokeys[$cl][$i][$j]= "Lctrl" or $Turbocombokeys[$cl][$i][$j]="Lalt" or $Turbocombokeys[$cl][$i][$j]="Lwin" or $Turbocombokeys[$cl][$i][$j]="Rwin" or $Turbocombokeys[$cl][$i][$j]="Rctrl" or $Turbocombokeys[$cl][$i][$j]="Ralt" then $specialkeys2DCombo[$cl][$i][$j]=True
		next

		$values[$cl][$i]=$Turbokeysfromcombo[$cl][$i]

	$buttonaction[$cl][$i]=8
	$actionname[$cl][$i]="TURBOCOMBO"
	$actionnameS[$cl][$i]="[TURBOCOMBO]"
	endif




		if (StringInStr($values[$cl][$i], "[TurboToggleCOMBO]")) Then
			$valuesS[$cl][$i]=""
		$TurboCombo[$cl][$i]=True
		$values[$cl][$i]=stringreplace($values[$cl][$i],"[TurboToggleCOMBO]","")
		local $TurbocombokeysL=StringSplit($values[$cl][$i],",")

		if $TurbocombokeysL[0]>$combosize-1 then $TurbocombokeysL[0]=$combosize-1

		for $j=1 to $TurbocombokeysL[0]
			$Turbocombokeys[$cl][$i][$j]=$TurbocombokeysL[$j]
			;$Turbocombokeys[$cl][$i][$j]=Stringlower($Turbocombokeys[$cl][$i][$j])
			$Turbocombokeys[$cl][$i][$j]=StringStripWS($Turbocombokeys[$cl][$i][$j],8)
			$Turbokeysfromcombo[$cl][$i]&= "{" & ($Turbocombokeys[$cl][$i][$j]) & "}"
			$Turbokeysfromcombodown[$cl][$i]&= "{" & ($Turbocombokeys[$cl][$i][$j]) & " down} "
			$Turbokeysfromcomboup[$cl][$i]&= "{" & ($Turbocombokeys[$cl][$i][$j]) & " up} "
			$TurboComboType[$cl][$i][$j]=$buttontype[$cl][$i]

				if $j=1 then $valuesS[$cl][$i] = " " & $valuesS[$cl][$i]
				If $j > 1 Then $valuesS[$cl][$i] &= ", "
				$valuesS[$cl][$i] &= $Turbocombokeys[$cl][$i][$j]

			local $val=buttontype($Turbocombokeys,$Turbocombotype,$cl,$i,$j)
			$Turbocombokeys[$cl][$i][$j]=$val[0]
			$Turbocombotype[$cl][$i][$j]=$val[1]

			if $Turbocombokeys[$cl][$i][$j]= "Lctrl" or $Turbocombokeys[$cl][$i][$j]="Lalt" or $Turbocombokeys[$cl][$i][$j]="Lwin" or $Turbocombokeys[$cl][$i][$j]="Rwin" or $Turbocombokeys[$cl][$i][$j]="Rctrl" or $Turbocombokeys[$cl][$i][$j]="Ralt" then $specialkeys2DCombo[$cl][$i][$j]=True
		next

		$values[$cl][$i]=$Turbokeysfromcombo[$cl][$i]
	$buttonaction[$cl][$i]=9
	$actionName[$cl][$i]="TURBOTOGGLECOMBO"
	$actionNameS[$cl][$i]="[T.T.Combo]"
		endif


		if (StringInStr($values[$cl][$i], "[Sequence]")) Then
			$valuesS[$cl][$i]=""
		$SimpleMacro[$cl][$i]=True
		$values[$cl][$i]=stringreplace($values[$cl][$i],"[Sequence]","")
		local $simpleMacrokeysL=StringSplit($values[$cl][$i],",")
			if $simpleMacrokeysL[0]>$SequenceMax-1 then $simpleMacrokeysL[0]=$SequenceMax-1
				$SequenceNum[$cl][$i]=$simpleMacrokeysL[0]

		for $j=1 to $simpleMacrokeysL[0]
			$SimpleMacroKeys[$cl][$i][$j]=$SimpleMacroKeysL[$j]
			;$SimpleMacroKeys[$cl][$i][$j]=Stringlower($SimpleMacroKeys[$cl][$i][$j])
			$SimpleMacroKeys[$cl][$i][$j]=StringStripWS($SimpleMacroKeys[$cl][$i][$j],8)
			$KeysFromSimpleMacro[$cl][$i]&= "{" & ($SimpleMacroKeys[$cl][$i][$j]) & "}"

				if $j=1 then $valuesS[$cl][$i] = " " & $valuesS[$cl][$i]
				If $j > 1 Then $valuesS[$cl][$i] &= ", "
				$valuesS[$cl][$i] &= $SimpleMacroKeys[$cl][$i][$j]

			local $val=buttontype($simpleMacroKeys,$simpleMacrotype,$cl,$i,$j)
			$simpleMacroKeys[$cl][$i][$j]=$val[0]
			$simpleMacrotype[$cl][$i][$j]=$val[1]

			if $simpleMacroKeys[$cl][$i][$j]= "Lctrl" or $simpleMacroKeys[$cl][$i][$j]="Lalt" or $simpleMacroKeys[$cl][$i][$j]="Lwin" or $simpleMacroKeys[$cl][$i][$j]="Rwin" or $simpleMacroKeys[$cl][$i][$j]="Rctrl" or $simpleMacroKeys[$cl][$i][$j]="Ralt" then $specialkeys2DSequence[$cl][$i][$j]=True

		next

		$values[$cl][$i]=$KeysFromSimpleMacro[$cl][$i]

	$buttonaction[$cl][$i]=10
	$actionName[$cl][$i]="SEQUENCE"
	$actionNameS[$cl][$i]="[SEQUENCE]"
		endif



		if (StringInStr($values[$cl][$i], "[TEXT]")) Then
			$valuesS[$cl][$i]=""
		$Text[$cl][$i]=True
		$values[$cl][$i]=stringreplace($values[$cl][$i],"[TEXT]","")
		if stringlen($values[$cl][$i])>=$stringmax then $values[$cl][$i]=Stringleft($values[$cl][$i],$stringmax)
			$valuesS[$cl][$i]=" " & $values[$cl][$i]

		$buttonaction[$cl][$i]=11
		$actionName[$cl][$i]="TEXT"
		$actionNameS[$cl][$i]="[TEXT]"
		endif



		if (StringInStr($values[$cl][$i], "[Hold]")) Then
			$valuesS[$cl][$i]=""
		$Hold[$cl][$i]=True
		$values[$cl][$i]=stringreplace($values[$cl][$i],"[Hold]","")
		local $HoldkeysL=StringSplit($values[$cl][$i],",")
			if $HoldkeysL[0]>$HoldMax-1 then $HoldkeysL[0]=$HoldMax-1
				$HoldNum[$cl][$i]=$HoldkeysL[0]

		for $j=1 to $HoldkeysL[0]
			$HoldKeys[$cl][$i][$j]=$HoldKeysL[$j]
			$HoldKeys[$cl][$i][$j]=StringStripWS($HoldKeys[$cl][$i][$j],8)
			$KeysFromHold[$cl][$i]&= "{" & ($HoldKeys[$cl][$i][$j]) & "}"

				if $j=1 then $valuesS[$cl][$i] = " " & $valuesS[$cl][$i]
				If $j > 1 Then $valuesS[$cl][$i] &= ", "
				$valuesS[$cl][$i] &= $HoldKeys[$cl][$i][$j]


				#cs
				$valuesS[$cl][$i]&=" " & $HoldKeys[$cl][$i][$j]
				if $j<>$HoldKeysL[0] and $j>1 then
					$valuesS[$cl][$i]&=$HoldKeys[$cl][$i][$j] & ", "
				Elseif $j=$HoldKeysL[0] then
					$valuesS[$cl][$i]&=$HoldKeys[$cl][$i][$j]
				else
					$valuesS[$cl][$i]&=" " & $HoldKeys[$cl][$i][$j] & ", "
				endif
				#ce

			local $val=buttontype($HoldKeys,$Holdtype,$cl,$i,$j)
			$HoldKeys[$cl][$i][$j]=$val[0]
			$Holdtype[$cl][$i][$j]=$val[1]

			if $HoldKeys[$cl][$i][$j]= "Lctrl" or $HoldKeys[$cl][$i][$j]="Lalt" or $HoldKeys[$cl][$i][$j]="Lwin" or $HoldKeys[$cl][$i][$j]="Rwin" or $HoldKeys[$cl][$i][$j]="Rctrl" or $HoldKeys[$cl][$i][$j]="Ralt" then $specialkeys2DHold[$cl][$i][$j]=True

		next

		$values[$cl][$i]=$KeysFromHold[$cl][$i]

	$buttonaction[$cl][$i]=12
	$actionname[$cl][$i]="HOLD"
	$actionnameS[$cl][$i]="[HOLD]"
		endif


	if (StringInStr($values[$cl][$i], "[Fastpress]")) Then
			$valuesS[$cl][$i]=""
		$Fastpress[$cl][$i]=True
		$values[$cl][$i]=stringreplace($values[$cl][$i],"[Fastpress]","")
		local $FastpresskeysL=StringSplit($values[$cl][$i],",")
			if $FastpresskeysL[0]>$FastpressMax-1 then $FastpresskeysL[0]=$FastpressMax-1
				$FastpressNum[$cl][$i]=$FastpresskeysL[0]

		for $j=1 to $FastpresskeysL[0]
			$FastpressKeys[$cl][$i][$j]=$FastpressKeysL[$j]
			$FastpressKeys[$cl][$i][$j]=StringStripWS($FastpressKeys[$cl][$i][$j],8)
			$KeysFromFastpress[$cl][$i]&= "{" & ($FastpressKeys[$cl][$i][$j]) & "}"

				if $j=1 then $valuesS[$cl][$i] = " " & $valuesS[$cl][$i]
				If $j > 1 Then $valuesS[$cl][$i] &= ", "
				$valuesS[$cl][$i] &= $FastpressKeys[$cl][$i][$j]

			local $val=buttontype($FastpressKeys,$Fastpresstype,$cl,$i,$j)
			$FastpressKeys[$cl][$i][$j]=$val[0]
			$Fastpresstype[$cl][$i][$j]=$val[1]

			if $FastpressKeys[$cl][$i][$j]= "Lctrl" or $FastpressKeys[$cl][$i][$j]="Lalt" or $FastpressKeys[$cl][$i][$j]="Lwin" or $FastpressKeys[$cl][$i][$j]="Rwin" or $FastpressKeys[$cl][$i][$j]="Rctrl" or $FastpressKeys[$cl][$i][$j]="Ralt" then $specialkeys2DFastPress[$cl][$i][$j]=True

		next

		$values[$cl][$i]=$KeysFromFastpress[$cl][$i]

	$buttonaction[$cl][$i]=13
	$actionname[$cl][$i]="Fastpress"
	$actionnameS[$cl][$i]="[Fastpress]"
		endif


		if (StringInStr($values[$cl][$i], "[ShiftMode]")) Then
			$valuesS[$cl][$i]=""
		$ShiftMode[$cl][$i]=True
	$values[$cl][$i]=stringreplace($values[$cl][$i],"[ShiftMode]","")
	$values[$cl][$i]= StringStripWS($values[$cl][$i],8)
	if $values[$cl][$i]="" then $values[$cl][$i]=2
	if $values[$cl][$i]>$ShiftMax-1 then $values[$cl][$i]=$ShiftMax-1
		$valuesS[$cl][$i]=" " & $values[$cl][$i]


	$buttonaction[$cl][$i]=14
	$actionname[$cl][$i]="Shiftmode"
	$actionnameS[$cl][$i]="[Shiftmode]"
		endif

		if (StringInStr($values[$cl][$i], "[ShiftModeToggle]")) Then
			$valuesS[$cl][$i]=""
		$ShiftModeToggle[$cl][$i]=True
	$values[$cl][$i]=stringreplace($values[$cl][$i],"[ShiftModeToggle]","")
	$values[$cl][$i]= StringStripWS($values[$cl][$i],8)
		$valuesS[$cl][$i]=" " & $values[$cl][$i]

	$buttonaction[$cl][$i]=15
	$actionname[$cl][$i]="ShiftmodeToggle"
	$actionnameS[$cl][$i]="[ShiftmodeToggle]"
		endif

		if (StringInStr($values[$cl][$i], "[ShiftModeCycle-]")) Then
		$ShiftModeCycle[$cl][$i]=True
		$values[$cl][$i]=" "
			$valuesS[$cl][$i]=" "

	$buttonaction[$cl][$i]=16
	$actionname[$cl][$i]="ShiftmodeCycle-"
	$actionnameS[$cl][$i]="[ShiftmodeCycle-]"
		endif


	if (StringInStr($values[$cl][$i], "[ShiftModeCycle+]")) Then
		$ShiftModeCycle[$cl][$i]=True
		$values[$cl][$i]=" "
			$valuesS[$cl][$i]=" "

	$buttonaction[$cl][$i]=17
	$actionname[$cl][$i]="ShiftmodeCycle+"
	$actionnameS[$cl][$i]="[ShiftmodeCycle+]"
	endif

	if (StringInStr($values[$cl][$i], "[ShiftModeCycle]")) Then
		$ShiftModeCycle[$cl][$i]=True
		$values[$cl][$i]=" "
			$valuesS[$cl][$i]=" "

	$buttonaction[$cl][$i]=17
	$actionname[$cl][$i]="ShiftModeCycle"
	$actionnameS[$cl][$i]="[ShiftModeCycle]"
		endif

	if (StringInStr($values[$cl][$i], "[Shift]")) Then
			$valuesS[$cl][$i]=""
		$Shift[$cl][$i]=True
		$values[$cl][$i]=stringreplace($values[$cl][$i],"[Shift]","")
		local $ShiftKeysL=StringSplit($values[$cl][$i],",")
		if $ShiftkeysL[0]>$shiftmax-1 then $ShiftkeysL[0]=$shiftmax-1
		$shiftnum[$cl][$i]=$ShiftkeysL[0]

		for $j=1 to $ShiftkeysL[0]
			$ShiftKeys[$cl][$i][$j]=$ShiftkeysL[$j]
			$ShiftKeys[$cl][$i][$j]=StringStripWS($ShiftKeys[$cl][$i][$j],8)
			$KeysFromShift[$cl][$i]&= "{" & ($ShiftKeys[$cl][$i][$j]) & "}"

				if $j=1 then $valuesS[$cl][$i] = " " & $valuesS[$cl][$i]
				If $j > 1 Then $valuesS[$cl][$i] &= ", "
				$valuesS[$cl][$i] &= $ShiftKeys[$cl][$i][$j]

			local $val=buttontype($ShiftKeys,$ShiftType,$cl,$i,$j)
			$ShiftKeys[$cl][$i][$j]=$val[0]
			$Shifttype[$cl][$i][$j]=$val[1]

			if $ShiftKeys[$cl][$i][$j]= "Lctrl" or $ShiftKeys[$cl][$i][$j]="Lalt" or $ShiftKeys[$cl][$i][$j]="Lwin" or $ShiftKeys[$cl][$i][$j]="Rwin" or $ShiftKeys[$cl][$i][$j]="Rctrl" or $ShiftKeys[$cl][$i][$j]="Ralt" then $specialkeys2DShift[$cl][$i][$j]=True

		next

		$values[$cl][$i]=$KeysFromShift[$cl][$i]

	$buttonaction[$cl][$i]=18
	$actionname[$cl][$i]="Shift"
	$actionnameS[$cl][$i]="[Shift]"
		endif



;If $valuesS[$cl][$i] = "" Then  $valuesS[$cl][$i] = $values[$cl][$i]
If $valuesS[$cl][$i] = "" Then
$valuesS[$cl][$i] = $values[$cl][$i]
$valuesS[$cl][$i]= StringStripWS($valuesS[$cl][$i],8)
endif




;#comments-start

if $buttonaction[$cl][$i]<5 then

if $values[$cl][$i]= "LBmouse" or $values[$cl][$i]= "RBmouse" or $values[$cl][$i]= "MBmouse" Then
$buttontype[$cl][$i]=1
elseif $values[$cl][$i]="WheelUp" or $values[$cl][$i]="WheelDown" Then
$buttontype[$cl][$i]=2
endif

if $values[$cl][$i]="LBmouse" then $values[$cl][$i]="left"
if $values[$cl][$i]="RBmouse" then $values[$cl][$i]="right"
if $values[$cl][$i]="MBmouse" then $values[$cl][$i]="middle"

if $values[$cl][$i]="WheelUp" then $values[$cl][$i]="up"
if $values[$cl][$i]="WheelDown" then $values[$cl][$i]="down"


if $values[$cl][$i]= "Lctrl" or $values[$cl][$i]="Lalt" or $values[$cl][$i]="Lwin" or $values[$cl][$i]="Rwin" or $values[$cl][$i]="Rctrl" or $values[$cl][$i]="Ralt" then $specialkeys[$cl][$i]=True


endif

;#comments-end



next

endfunc




func buttontype($array,$typee,$cl,$i,$j)
if $array[$cl][$i][$j]= "LBmouse" or $array[$cl][$i][$j]= "RBmouse" or $array[$cl][$i][$j]= "MBmouse" Then
$typee[$cl][$i][$j]=1
elseif $array[$cl][$i][$j]="WheelUp" or $array[$cl][$i][$j]="WheelDown" Then
$typee[$cl][$i][$j]=2
Else
$typee[$cl][$i][$j]=0
endif

if $array[$cl][$i][$j]="LBmouse" then $array[$cl][$i][$j]="left"
if $array[$cl][$i][$j]="RBmouse" then $array[$cl][$i][$j]="right"
if $array[$cl][$i][$j]="MBmouse" then $array[$cl][$i][$j]="middle"

if $array[$cl][$i][$j]="WheelUp" then $array[$cl][$i][$j]="up"
if $array[$cl][$i][$j]="WheelDown" then $array[$cl][$i][$j]="down"

local $val[2]
$val[0]=$array[$cl][$i][$j]
$val[1]=$typee[$cl][$i][$j]

return $val

endfunc





func parseL0()
parse(0)

;;;;local $aLayer = InireadSection($inifile, "Layer"), $layertoCycleL=StringSplit($aLayer[1][1],",")

local $temp = Iniread($inifile,"Other","LayerToCycle","")
local $layertoCycle=StringSplit($temp,",")


if $layerToCycle[0]>5 then $layerToCycle[0]=5
$layercount=$layerToCycle[0]

local $allsections=IniReadSectionNames($inifile)
;$allsections=IniReadSectionNames($inifile)
;msgbox("","",IniReadSectionNames($inifile))
;msgbox("","",$allsections)

for $j=1 to $layerToCycle[0]
$sectionname[0][$j]=StringStripWS($layerToCycle[$j],8)
		$LayerToCycleSS&=$layerToCycle[$j]
			$LayerToCycleS[$j]=$sectionname[0][$j]
	for $i=1 to $allsections[0]
		if not stringinstr($sectionname[0][$j],"layer:") and not stringinstr($sectionname[0][$j],"set:") and $sectionname[0][$j] <> $allsections[$i] then
			if ("layer:"& $sectionname[0][$j])= $allsections[$i] then
				$layertype[$j]=0
				$prefix[0][$j]="layer:"
					$layerName[$j]=$sectionname[0][$j]
				$sectionname[0][$j]="layer:" & $sectionname[0][$j]
			endif
			if ("set:" & $sectionname[0][$j]) = $allsections[$i] then
				$layertype[$j]=1
				$prefix[0][$j]="set:"
					$layerName[$j]=$sectionname[0][$j]
				 $sectionname[0][$j]="set:" & $sectionname[0][$j]
			endif
		elseif (stringinstr($sectionname[0][$j],"layer:") or stringinstr($sectionname[0][$j],"set:")) and $sectionname[0][$j] <> $allsections[$i] then
			if $sectionname[0][$j]= "layer:" & $allsections[$i] then
				$layertype[$j]=0
				$prefix[0][$j]="layer:"
				$sectionname[0][$j]=$allsections[$i]
					$layerName[$j]=$sectionname[0][$j]
			endif

			if $sectionname[0][$j]= "set:" & $allsections[$i] then
				$layertype[$j]=1
				$prefix[0][$j]="set:"
				$sectionname[0][$j]=$allsections[$i]
					$layerName[$layercount]=$sectionname[0][$j]
			endif
		elseif not stringinstr($sectionname[0][$j],"layer:") and not stringinstr($sectionname[0][$j],"set:") and $sectionname[0][$j] = $allsections[$i] then
			$layertype[$j]=0
		endif
	next


next



for $i=0 to Ubound($values,2)-1


	if StringInStr($values[0][$i], "[LayerCycle-]") or StringInStr($values[0][$i], "[LayerCycle]") or StringInStr($values[0][$i], "[LayerCycle+]") Then
		;$Mode[$i]=True
		if (StringInStr($values[0][$i], "[LayerCycle-]")) then
	$values[0][$i]=stringreplace($values[0][$i],"[LayerCycle-]","")
	$values[0][$i]= StringStripWS($values[0][$i],8)
	if $values[0][$i]="" then $values[0][$i]="LayerCycle-"
		$valuesS[0][$i]= " "

	$buttonaction[0][$i]=22
	$actionName[0][$i]="LayerCycle-"
	$actionNameS[0][$i]="[LayerCycle-]"
	$layeraccnum+=1
	$layeracc[$layeraccnum]=$i
		endif

		if (StringInStr($values[0][$i], "[LayerCycle]")) then
	$values[0][$i]=stringreplace($values[0][$i],"[LayerCycle]","")
	$values[0][$i]= StringStripWS($values[0][$i],8)
	if $values[0][$i]="" then $values[0][$i]="LayerCycle"
		$valuesS[0][$i]= " "

	$buttonaction[0][$i]=23
	$actionName[0][$i]="LayerCycle"
	$actionNameS[0][$i]="[LayerCycle]"
	$layeraccnum+=1
	$layeracc[$layeraccnum]=$i
		endif

		if (StringInStr($values[0][$i], "[LayerCycle+]")) then
	$values[0][$i]=stringreplace($values[0][$i],"[LayerCycle+]","")
	$values[0][$i]= StringStripWS($values[0][$i],8)
	if $values[0][$i]="" then $values[0][$i]="LayerCycle+"
		$valuesS[0][$i]= " "

	$buttonaction[0][$i]=23
	$actionName[0][$i]="LayerCycle+"
	$actionNameS[0][$i]="[LayerCycle+]"
	$layeraccnum+=1
	$layeracc[$layeraccnum]=$i
		endif



	for $u=1 to $layercount
		;msgbox("","",$u & "  " & $layercount & "  " & $sectionname[0][$u] & "  " &  $layertype[$u])
		;$layerName[$layercount]=$sectionname[0][$i]
		$layerName[$layercount]=stringreplace($sectionname[0][$u],"layer:","")
		$layerName[$layercount]=stringreplace($sectionname[0][$u],"set:","")
	Layer($i,$u,$sectionname[0][$u],$layertype[$u])
	;msgbox("","",$sectionname[0][$u] & " lc: " & $layercount & " layertype: " & $layertype[$u] & " i: " & $i & " u: " & $u)
	parse($u)
	next


	endif
next

	#cs
	for $u=1 to $layercount
		;msgbox("","",$u & "  " & $layercount & "  " & $sectionname[0][$u] & "  " &  $layertype[$u])
	Layer($i,$u,$sectionname[0][$u],$layertype[$u])
	;msgbox("","",$sectionname[0][$u] & " lc: " & $layercount & " layertype: " & $layertype[$u] & " i: " & $i & " u: " & $u)
	parse($u)
	next
	#ce



$CycleLayerCount=$Layercount
$layercount=5
local $allsections=IniReadSectionNames($inifile)
for $i=0 to Ubound($values,2)-1

	if (StringInStr($values[0][$i], "[LayerMode]")) or (StringInStr($values[0][$i], "[SetMode]")) Then
		;$Mode[$i]=True
		if (StringInStr($values[0][$i], "[LayerMode]")) then
	$values[0][$i]=stringreplace($values[0][$i],"[LayerMode]","")
	$values[0][$i]= StringStripWS($values[0][$i],8)
		;$valuesS[0][$i]= $values[0][$i]
		$valuesS[0][$i]= " " & $values[0][$i]
	$sectionname[0][$i]=$values[0][$i]

	$buttonaction[0][$i]=20
	$actionName[0][$i]="LayerMode"
	$actionNameS[0][$i]="[LayerMode]"

	$layercount+=1
	$layertype[$layercount]=0
	$buttonL[0][$i]=$layercount

$sectionname[0][$i]=parsesection2($i,$sectionname[0][$i], $allsections)
		endif

		if (StringInStr($values[0][$i], "[SetMode]")) then
	$values[0][$i]=stringreplace($values[0][$i],"[SetMode]","")
	$values[0][$i]= StringStripWS($values[0][$i],8)
	$sectionname[0][$i]=$values[0][$i]
		;$valuesS[0][$i]= $values[0][$i]
		$valuesS[0][$i]= " " & $values[0][$i]

	$buttonaction[0][$i]=20
	$actionName[0][$i]="SetMode"
	$actionNameS[0][$i]="[SetMode]"

	$layercount+=1
	$layertype[$layercount]=1
	$buttonL[0][$i]=$layercount

	$sectionname[0][$i]=parsesection2($i,$sectionname[0][$i], $allsections)
		endif


		$layerName[$layercount]=stringreplace($sectionname[0][$i],"layer:","")
		$layerName[$layercount]=stringreplace($sectionname[0][$i],"set:","")
	Layer($i,$layercount,$sectionname[0][$i],$layertype[$layercount])
	parse($layercount)
	endif


	if (StringInStr($values[0][$i], "[LayerModeToggle]")) or (StringInStr($values[0][$i], "[SetModeToggle]")) Then
		;$Mode[$i]=True
		if (StringInStr($values[0][$i], "[LayerModeToggle]")) then
	$values[0][$i]=stringreplace($values[0][$i],"[LayerModeToggle]","")
	$values[0][$i]= StringStripWS($values[0][$i],8)
		;$valuesS[0][$i]= $values[0][$i]
		$valuesS[0][$i]= " " & $values[0][$i]
	$sectionname[0][$i]=$values[0][$i]

	$buttonaction[0][$i]=21
	$actionName[0][$i]="LayerModeToggle"
	$actionNameS[0][$i]="[LayerModeToggle]"

	$layercount+=1
	$layertype[$layercount]=0
	$buttonL[0][$i]=$layercount

	$sectionname[0][$i]=parsesection2($i,$sectionname[0][$i], $allsections)
		endif

		if (StringInStr($values[0][$i], "[SetModeToggle]")) then
	$values[0][$i]=stringreplace($values[0][$i],"[SetModeToggle]","")
	$values[0][$i]= StringStripWS($values[0][$i],8)
		;$valuesS[0][$i]= $values[0][$i]
		$valuesS[0][$i]= " " & $values[0][$i]
	$sectionname[0][$i]=$values[0][$i]

	$buttonaction[0][$i]=21
	$actionName[0][$i]="SetModeToggle"
	$actionNameS[0][$i]="[SetModeToggle]"

	$layercount+=1
	$layertype[$layercount]=1
	$buttonL[0][$i]=$layercount

	$sectionname[0][$i]=parsesection2($i,$sectionname[0][$i], $allsections)
		endif

		;$layerName[$layercount]=$sectionname[0][$i]
		$layerName[$layercount]=stringreplace($sectionname[0][$u],"layer:","")
		$layerName[$layercount]=stringreplace($sectionname[0][$u],"set:","")
	Layer($i,$layercount,$sectionname[0][$i],$layertype[$layercount])
	parse($layercount)
	endif


next



	if $LayerToggleKVal<>"" Then
	local $allsections=IniReadSectionNames($inifile)
	for $j=1 to $allsections[0]
	if $LayerToggleKVal=$allsections[$j] and not stringinstr("layer:",$LayerToggleKVal) and not stringinstr("set:",$LayerToggleKVal) Then
			$layercount+=1
			$layertype[$layercount]=0
			;if $LayerToggleKtype=1 Then	$layertype[$layercount]=1
					$layerName[$layercount]=$allsections[$j]
					layerK($i,$layercount,$allsections[$j],$layertype[$layercount])
	elseif 	$LayerToggleKVal="layer:" & $allsections[$j] then
				$layercount+=1
				$layertype[$layercount]=0
						$layerName[$layercount]=$allsections[$j]
					layerK($i,$layercount,$allsections[$j],$layertype[$layercount])
	elseif 	$LayerToggleKVal="set:" & $allsections[$j] then
				$layercount+=1
				$layertype[$layercount]=1
						$layerName[$layercount]=$allsections[$j]
					layerK($i,$layercount,$allsections[$j],$layertype[$layercount])
	elseif 	$allsections[$j]="layer:" & $LayerToggleKVal then
				$layercount+=1
				$layertype[$layercount]=0
						$layerName[$layercount]=stringreplace($allsections[$j],"layer:","")
					layerK($i,$layercount,$allsections[$j],$layertype[$layercount])
				;if $LayerToggleKtype=1 then  $layertype[$layercount]=1
	elseif 	$allsections[$j]="set:" & $LayerToggleKVal then
				$layercount+=1
				$layertype[$layercount]=1
				;if $LayerToggleKtype=0 then  $layertype[$layercount]=0
						$layerName[$layercount]=stringreplace($allsections[$j],"set:","")
					layerK($i,$layercount,$allsections[$j],$layertype[$layercount])
	endif

	next

	endif


endfunc
#Endregion Parse()


func parsesection2($j,$sectionname, $allsections)
	for $i=1 to $allsections[0]
		if not stringinstr($sectionname,"layer:") and not stringinstr($sectionname,"set:") and $sectionname <> $allsections[$i] then
			if ("layer:"& $sectionname)= $allsections[$i] then
				;$layertype[$j]=0
				;$prefix[0][$j]="layer:"
				$sectionname="layer:" & $sectionname
			endif
			if ("set:" & $sectionname) = $allsections[$i] then
				;$layertype[$j]=1
				;$prefix[0][$j]="set:"
				 $sectionname="set:" & $sectionname
			endif
		endif
	next


return $sectionname

endfunc


func parsesection($j,$sectionname, $allsections)
	for $i=1 to $allsections[0]
		if not stringinstr($sectionname,"layer:") and not stringinstr($sectionname,"set:") and $sectionname <> $allsections[$i] then
			if ("layer:"& $sectionname)= $allsections[$i] then
				$layertype[$j]=0
				$prefix[0][$j]="layer:"
				$sectionname="layer:" & $sectionname
			endif
			if ("set:" & $sectionname) = $allsections[$i] then
				$layertype[$j]=1
				$prefix[0][$j]="set:"
				 $sectionname="set:" & $sectionname
			endif
		elseif (stringinstr($sectionname,"layer:") or stringinstr($sectionname,"set:")) and $sectionname <> $allsections[$i] then
			if $sectionname= "layer:" & $allsections[$i] then
				$layertype[$j]=0
				$prefix[0][$j]="layer:"
				$sectionname=$allsections[$i]
			endif

			if $sectionname= "set:" & $allsections[$i] then
				$layertype[$j]=1
				$prefix[0][$j]="set:"
				$sectionname=$allsections[$i]
			endif
		endif
	next

local $val[2]
$val[0]= $sectionname
$val[1]= $layertype[$j]
return $val

endfunc


func LayerpreviousOLD($ix,$cl,$sectionname,$sectiontype)
	;msgbox("","","ee")
for $i=1 to 5
 $buttonaction[$i][$ix] = $buttonaction[0][$ix]
 ;$buttontype[$i][$ix]=0
  ;$buttontype[$i][$ix]=0
 $buttontype[$cl][$ix]=$buttontype[0][$ix]

;$buttonaction[$cl][$ix]=$buttonaction[0][$ix]
;$buttontype[$cl][$ix]=$buttontype[0][$ix]
next
endfunc


func Layerprevious($ix,$cl,$sectionname,$sectiontype)
	;msgbox("","","ee")
for $i=1 to 5
 $buttonaction[$i][$ix] = $buttonaction[0][$ix]
 ;$buttontype[$i][$ix]=0
  ;$buttontype[$i][$ix]=0
 $buttontype[$cl][$ix]=$buttontype[0][$ix]

;$buttonaction[$cl][$ix]=$buttonaction[0][$ix]
;$buttontype[$cl][$ix]=$buttontype[0][$ix]
next
endfunc

func Layer($ix,$cl,$sectionname,$sectiontype)
	if $sectiontype=0 then
 for $i=0 to $asize-1
	 if ($buttonaction[0][$i]<20 or $buttonaction[0][$i]>23) then $values[$cl][$i]=iniRlayer($buttonsname[$i],$sectionname,$i, $cl)
	 ;if ($buttonaction[0][$i]<>22 and $buttonaction[0][$i]<>23) then $values[$cl][$i]=iniRlayer($buttonsname[$i],$sectionname,$i, $cl) ;NO!

if $i<>$ix then

	if StringInStr($values[$cl][$i],"[LayerMode]") _
    or StringInStr($values[$cl][$i],"[LayerModeToggle]") _
    or StringInStr($values[$cl][$i],"[SetMode]") _
    or StringInStr($values[$cl][$i],"[SetModeToggle]") Then

        $buttonaction[$cl][$i]=0
        $actionName[$cl][$i]=""
        $actionNameS[$cl][$i]=""
        $values[$cl][$i]=""
        $valuesS[$cl][$i]=""

    endif

endif

 next

 $buttonaction[$cl][$ix] = $buttonaction[0][$ix]
 ;;$buttontype[$cl][$ix]=0
 $buttontype[$cl][$ix]=$buttontype[0][$ix] ;
 $buttonL[$cl][$ix] = $buttonL[0][$ix]


if $buttonaction[0][$ix]=20 then $values[$cl][$ix]=" "
if $buttonaction[0][$ix]=21 then $values[$cl][$ix]=" "

if $buttonaction[0][$ix]=22 then $values[$cl][$ix]="LayerCycle-"
if $buttonaction[0][$ix]=23 then $values[$cl][$ix]="LayerCycle+"

if $buttonaction[0][$ix]=20 then $actionNameS[$cl][$ix]="[LayerBack]"
if $buttonaction[0][$ix]=21 then $actionNameS[$cl][$ix]="[LayerModeToggle]"

if $buttonaction[0][$ix]=20 then $valuesS[$cl][$ix]= " Buttons"
if $buttonaction[0][$ix]=21 then $valuesS[$cl][$ix]= " Buttons"
if $buttonaction[0][$ix]=22 then $actionNameS[$cl][$ix]="[LayerCycle-]"
if $buttonaction[0][$ix]=23 then $actionNameS[$cl][$ix]="[LayerCycle+]"




;if $cl>5 then Layerprevious($ix,$cl,$sectionname,$sectiontype)
	elseif $sectiontype=1 then
 for $i=0 to $asize-1
	if ($buttonaction[0][$i]<20 or $buttonaction[0][$i]>23)  then $values[$cl][$i]=iniRset($buttonsname[$i],$sectionname,$i, $cl)
 next

 $buttonaction[$cl][$ix] = $buttonaction[0][$ix]
  ;;$buttontype[$cl][$ix]=0
 $buttontype[$cl][$ix]=$buttontype[0][$ix] ;

 $buttonL[$cl][$ix] = $buttonL[0][$ix]

if $buttonaction[0][$ix]=20 then $values[$cl][$ix]=" " & "Buttons"
if $buttonaction[0][$ix]=20 then $valuesS[$cl][$ix]=" " & "Buttons"
;if $buttonaction[0][$ix]=21 then $values[$cl][$ix]="LayerToggle"
if $buttonaction[0][$ix]=21 then $values[$cl][$ix]=" Buttons"
if $buttonaction[0][$ix]=21 then $valuesS[$cl][$ix]=" Buttons"

if $buttonaction[0][$ix]=22 then $values[$cl][$ix]="LayerCycle-"
if $buttonaction[0][$ix]=23 then $values[$cl][$ix]="LayerCycle+"

if $buttonaction[0][$ix]=20 then $actionNameS[$cl][$ix]="[LayerBack]"
if $buttonaction[0][$ix]=21 then $actionNameS[$cl][$ix]="[SetModeToggle]"
if $buttonaction[0][$ix]=22 then $actionNameS[$cl][$ix]="[LayerCycle-]"
if $buttonaction[0][$ix]=23 then $actionNameS[$cl][$ix]="[LayerCycle+]"

;if $cl> 5 then Layerprevious($ix,$cl,$sectionname,$sectiontype)
endif

endfunc


func LayerK($i,$cl,$sectionname,$sectiontype)

	$KeyboardLayerToJump=$cl

	if $sectiontype=0 then
 for $i=0 to $asize-1
	 $values[$cl][$i]=iniRlayer($buttonsname[$i],$sectionname,$i, $cl)



 $buttonaction[$cl][$i] = $buttonaction[0][$i]
  ;$buttontype[$cl][$i]=0
 $buttontype[$cl][$i]=$buttontype[0][$i]
 $buttonL[$cl][$i] = $buttonL[0][$i]


	 if $buttonaction[0][$i]=20 then $values[$cl][$i]="LayerBack"
if $buttonaction[0][$i]=21 then $values[$cl][$i]="LayerToggle"
if $buttonaction[0][$i]=22 then $values[$cl][$i]="LayerCycle-"
if $buttonaction[0][$i]=23 then $values[$cl][$i]="LayerCycle+"

if $buttonaction[0][$i]=20 then $actionNameS[$cl][$i]="[LayerBack]"
if $buttonaction[0][$i]=21 then $actionNameS[$cl][$i]="[LayerToggle]"
if $buttonaction[0][$i]=22 then $actionNameS[$cl][$i]="[LayerCycle-]"
if $buttonaction[0][$i]=23 then $actionNameS[$cl][$i]="[LayerCycle+]"

 next
	elseif $sectiontype=1 then
 for $i=0 to $asize-1
 $values[$cl][$i]=inirset($buttonsname[$i],$sectionname,$i, $cl)

 parse($cl)



 next

	endif

endfunc


func iniRlayer($buttonsname, $sectioname,$i, $cl)
	$temp = IniRead($inifile, $sectioname, $buttonsname, "")
	If $temp = "" Then
		$temp = $values[0][$i]
		copyarray($i, $cl)
	EndIf
	return $temp
endfunc

;func iniRset($buttonsname, $sectioname,$i)
	func iniRset($buttonsname, $sectioname,$ix, $cl)
	$tempS = IniRead($inifile, $sectioname, $buttonsname, "")
	return $tempS
endfunc

func Layerchange($ix,$value,$state,$btype)
if $state=0 then
	$prevLayer=$L
	$l=$buttonL[0][$ix] ;$l=1
endif
if $state=1 then


for $i=0 to $asize-1
	if $keys[$i] then
		if $buttonaction[$l][$i]<>19 and $buttonaction[$l][$i]<>20 then inpt($i,$values[$l][$i],1,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])
	endif
next


$l=$prevLayer
endif
endfunc

func LayerToggle($ix,$value,$state,$btype)
if $state=1 then return

if $layerToggleOn[$ix]=False Then
		$prevLayer=$L
		$layerToggleOn[$ix]=True
		$l=$buttonL[0][$ix]	;$l=1
elseif $layerToggleOn[$ix]=True then

	for $i=0 to $asize-1
		if $keys[$i] then
			;if $buttonaction[$l][$i]<>19 and $buttonaction[$l][$i]<>20 then inpt($i,$values[$l][$i],1,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])
		endif
	next
	$l=$prevLayer 	;$l=0
	$layerToggleOn[$ix]=False
endif

endfunc

func LayerCycleMinus($ix,$value,$state,$btype)

if $state=1 then
 ;$pressed[$ix]=False
	return
endif


	for $i=0 to $asize-1
		if $keys[$i] then
if $buttonaction[$l][$i]<>19 and $buttonaction[$l][$i]<>20 then inpt($i,$values[$l][$i],1,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])
		endif

	layereleasekeys($i)

	next


;$KeyboardPrevLayer=$KeyboardLayerToJump

if $l>5 then
	$l=$CycleLayerCount
elseif $l>=0 then
	$l-=1
endif
if $l<0 then $l=$CycleLayerCount

endfunc

func LayerCyclePlus($ix,$value,$state,$btype)
if $state=1 then return


	for $i=0 to $asize-1
		if $keys[$i] then
if $buttonaction[$l][$i]<>19 and $buttonaction[$l][$i]<>20 then inpt($i,$values[$l][$i],1,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])
		endif

	layereleasekeys($i)

	next

;$KeyboardPrevLayer=$KeyboardLayerToJump

if $l<=$CyclelayerCount then $l+=1
if $l>$CycleLayerCount then $l=0


endfunc

func layereleasekeys($i)
	if $comboasyncOn[$l][$i]=True Then

			for $u=$combK[$l][$i] to 1 step -1
				sender($i,$combokeysasync[$l][$i][$u],1,$comboAsyncType[$l][$i][$u],$specialkeys2DCombo[$l][$i][$u])
			Next

			$comboasyncOn[$l][$i]=False
			$alreadytimerasync[$l][$i]=False
			$timerasync[$l][$i]=0
			$combK[$l][$i]=0

		endif


		if $simpleMacroOn[$l][$i]=True Then

			for $u=$SmacroK[$l][$i] to 1 step -1
				sender($i,$simpleMacrokeys[$l][$i][$u],1,$simpleMacroType[$l][$i][$u],$specialkeys2DSequence[$l][$i][$u])
			next


			$simpleMacroOn[$l][$i]=False
			$alreadytimerSimplemacro[$l][$i]=False
			$timerSimpleMacro[$l][$i]=0
			$SmacroK[$l][$i]=0

		endif


		if $HoldOn[$l][$i]=True then
		$holdtimer[$l][$i]=0
		$HoldOn[$l][$i]=False
		endif


		if $fastpressOnH[$l][$i]=True then
		sender($i,$FastpressKeys[$l][$i][$oldtap[$l][$i]],1,$FastpressType[$l][$i][$oldtap[$l][$i]],$specialkeys2DFastpress[$l][$i][$oldtap[$l][$i]])
		$fastpressOnH[$l][$i]=False
		endif

		if $fastpresson[$l][$i]=True then
		$tap[$l][$i]=0
		$oldtap[$l][$i]=0
		$fastpresstimer[$l][$i]=0
		$fastpressOnH[$l][$i]=False
		$fastpressOn[$l][$i]=False
		endif
endfunc

func copyarray($ix, $cl)
$buttonaction[$cl][$ix]=$buttonaction[0][$ix]
$buttontype[$cl][$ix]=$buttontype[0][$ix]
	$actionname[$cl][$ix]=$actionname[0][$ix]
	$actionnameS[$cl][$ix]=$actionnameS[0][$ix]
	$valuesS[$cl][$ix]=$valuesS[0][$ix]
switch $buttonaction[0][$ix]

case 1
	$Toggle[$cl][$ix]=$Toggle[0][$ix]
case 2
	$Turbo[$cl][$ix]=$Turbo[0][$ix]
case 3
	$TurboToggle[$cl][$ix]=$TurboToggle[0][$ix]
case 4

case 5
for $k=1 to ubound($combokeys,3)-1
$combokeys[$cl][$ix][$k] = $combokeys[0][$ix][$k]
$combotype[$cl][$ix][$k] = $combotype[0][$ix][$k]
next
$Combo[$cl][$ix]=$Combo[0][$ix]
	$valuesS[$cl][$ix]=$valuesS[0][$ix]


case 6
for $k=1 to ubound($combokeysasync,3)-1
$combokeysasync[$cl][$ix][$k] = $combokeysasync[0][$ix][$k]
$comboAsyncType[$cl][$ix][$k] = $comboAsyncType[0][$ix][$k]
next
$comboasync[$cl][$ix]=$comboasync[0][$ix]
$async[$cl][$ix]=$async[0][$ix]
$comboasyncNum[$cl][$ix]=$comboasyncNum[0][$ix]



case 7
for $k=1 to ubound($Togglecombokeys,3)-1
$Togglecombokeys[$cl][$ix][$k] = $Togglecombokeys[0][$ix][$k]
$ToggleComboType[$cl][$ix][$k] = $ToggleComboType[0][$ix][$k]
next
$ToggleCombo[$cl][$ix] = $ToggleCombo[0][$ix]


case 8
for $k=1 to ubound($Turbocombokeys,3)-1
$Turbocombokeys[$cl][$ix][$k] = $Turbocombokeys[0][$ix][$k]
$TurbocomboType[$cl][$ix][$k] = $TurbocomboType[0][$ix][$k]
next
$TurboCombo[$cl][$ix]=$TurboCombo[0][$ix]


case 9 ; TurboToggleCombo
for $k=1 to ubound($TurboCOMBOkeys,3)-1
$TurboCOMBOkeys[$cl][$ix][$k] = $TurboCOMBOkeys[0][$ix][$k]
$Turbocombotype[$cl][$ix][$k] = $Turbocombotype[0][$ix][$k]
next
$TurboCombo[$cl][$ix] = $TurboCombo[0][$ix]

case 10 ; Sequence
for $k=1 to ubound($SimpleMacroKeys,3)-1
$SimpleMacroKeys[$cl][$ix][$k] = $SimpleMacroKeys[0][$ix][$k]
$SimpleMacroType[$cl][$ix][$k] = $SimpleMacroType[0][$ix][$k]
next
$SimpleMacro[$cl][$ix]=$SimpleMacro[0][$ix]
$SequenceNum[$cl][$ix]=$SequenceNum[0][$ix]
$SimpleMacro[$cl][$ix]=$SimpleMacro[0][$ix]


case 12
for $k=1 to ubound($Holdkeys,3)-1
$Holdkeys[$cl][$ix][$k] = $Holdkeys[0][$ix][$k]
next
$HoldNum[$cl][$ix]=$HoldNum[0][$ix]

case 13
for $k=1 to ubound($Fastpresskeys,3)-1
$Fastpresskeys[$cl][$ix][$k] = $Fastpresskeys[0][$ix][$k]
next
$FastpressNum[$cl][$ix]=$FastpressNum[0][$ix]

case 18
for $k=1 to ubound($ShiftKeys,3)-1
$Shiftkeys[$cl][$ix][$k] = $Shiftkeys[0][$ix][$k]
next
$shiftnum[$cl][$ix]=$shiftnum[0][$ix]

endswitch

endfunc

#Region mouse()
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
#Endregion mouse()


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


;$LT=$input[3]
;$RT=$input[4]

If $LT < $TriggerDeadzone Then $LT = 0
If $RT < $TriggerDeadzone Then $RT = 0


for $i=0 to $VibrateBmaxN-1

	$VibrateButton[$i]=execute($VibrateButtonS[$i])
	;if $VibrateButton_Modifier[$i]<>"NAA" then $VibrateButton_Modifier[$i]=execute($VibrateButton_ModifierS[$i])
	if $VibrateButton_Modifier[$i]<>"NAA" then $VibrateButton_Modifier[$i]=string(execute($VibrateButton_ModifierS[$i]))


	if $VibrateProgressiveTrigger = 1 Then
	;if $VibrateProgressiveTrigger = 1 and ($VibrateButton_ModifierS[$i]<>"$LT" and $VibrateButton_ModifierS[$i]<>"$RT") Then

		if $VibrateisTrigger[$i]=True and $VibrateButton[$i] then
		;if $VibrateisTrigger[$i]=True and (($VibrateButton_ModifierS[$i]<>"$LT" and $VibrateButton_ModifierS[$i]<>"$RT") ) and $VibrateButton[$i] then

			if $LT and $RT Then

				if $RT>=$LT then

					if $VibrateButton_Motor[$i]="Right" then
						$VibrateButton_LeftMotorStrength[$i]= 0
						$VibrateButton_RightMotorStrength[$i]= $RT/2.55
					elseif $VibrateButton_Motor[$i]="Left" then
						$VibrateButton_RightMotorStrength[$i]= 0
						$VibrateButton_LeftMotorStrength[$i]= $RT/2.55
					else
						;$VibrateButton_LeftMotorStrength[$i]= $RT/2.55
						;$VibrateButton_RightMotorStrength[$i]= $RT/2.55
					endif

				elseif $LT>$RT then

					if $VibrateButton_Motor[$i]="Left" then
						$VibrateButton_RightMotorStrength[$i]= 0
						$VibrateButton_LeftMotorStrength[$i]= $LT/2.55
					elseif $VibrateButton_Motor[$i]="Right" then
						$VibrateButton_LeftMotorStrength[$i]= 0
						$VibrateButton_RightMotorStrength[$i]= $LT/2.55
					else
						;$VibrateButton_LeftMotorStrength[$i]= $LT/2.55
						;$VibrateButton_RightMotorStrength[$i]= $LT/2.55
					endif

				endif

			else


					if $VibrateButton_Motor[$i]="Right" then
						;$VibrateButton_LeftMotorStrength[$i]= 0
						$VibrateButton_RightMotorStrength[$i]= $VibrateButton[$i]/2.55
					elseif $VibrateButton_Motor[$i]="Left" then
						;$VibrateButton_RightMotorStrength[$i]= 0
						$VibrateButton_LeftMotorStrength[$i]= $VibrateButton[$i]/2.55
					else
					$VibrateButton_LeftMotorStrength[$i]= $VibrateButton[$i]/2.55
					$VibrateButton_RightMotorStrength[$i]= $VibrateButton[$i]/2.55
					;$LeftMotorStrength=Sqrt($VibrateButton[$i]/255)*100
					;$RightMotorStrength=Sqrt($VibrateButton[$i]/255)*100
					endif


			endif

		endif

	endif




next



endfunc

#Region pause
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
#EndRegion

#Region loadini()
func loadini()
#Region Var
global $analogdeadzone=1, $sentKeys[256], $ignoreIndices[4]
global $A=$buttons[12],$B=$buttons[13],$X=$buttons[14],$Y=$buttons[15],$start=$buttons[5],$back=$buttons[6],$LS=$buttons[7],$RS=$buttons[8],$LB=$buttons[9],$RB=$buttons[10],$Home=$buttons[11],$Up=$buttons[1],$Down=$buttons[2],$Left=$buttons[3],$Right=$buttons[4]
global $LT=$input[3],$RT=$input[4],	$LSX=$input[5], $LSY=$input[6], $RSX=$input[7], $RSY=$input[8], $LS=$buttons[7], $RS=$buttons[8]


global $LSleft = $LSX<-3000, $LSright = $LSX>3000, $LSdown = $LSY<-3000, $LSup = $LSY>3000
global $RSleft = $RSX<-3000,$RSright = $RSX>3000, $RSdown = $RSY<-3000, $RSup = $RSY>3000

global $TriggerDeadzone=IniRead($inifile,"Other","TriggerDeadzone",20)

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
global $combotime = IniRead($inifile,"Other","ComboAsyncDelay",50), $SequenceTime= IniRead($inifile,"Other","SequenceTime",50), $HoldTime= IniRead($inifile,"Other","HoldTime",300)
global $fastPressTime = IniRead($inifile,"Other","fastPressTime",150)

If $AnalogToMouse <> "1" and $AnalogToMouse <> "0" Then	$AnalogToMouse=0
if $MouseDeadzoneType<> 1 and $MouseDeadzoneType <>  2 and $MouseDeadzoneType <>  4 then  $MouseDeadzoneType=1
if $AnalogsDeadzoneType<> 1 and $AnalogsDeadzoneType <>  2 and $AnalogsDeadzoneType <>  4 and $AnalogsDeadzoneType <> 8 then $AnalogsDeadzoneType=1

global $VibrateBmaxN=16+8+1, $VibrateButtonS[$VibrateBmaxN], $VibrateButton[$VibrateBmaxN], $VibrateIsTrigger[$VibrateBmaxN], $vibrationEnabled=False, $VibrateEnabled = IniRead($inifile,"Vibration","Enabled",0)
global $VibrateButton_strength[$VibrateBmaxN], $VibrateButton_SingleDuration[$VibrateBmaxN], $VibrateButton_RepeatDuration[$VibrateBmaxN] ,$VibrateButton_RepeatInterval[$VibrateBmaxN], $VibrateButton_Motor[$VibrateBmaxN]
global $VibrateButton_LeftMotorStrength[$VibrateBmaxN], $VibrateButton_RightMotorStrength[$VibrateBmaxN], $VibrateButton_Style[$VibrateBmaxN], $VibrateButton_Style[$VibrateBmaxN]
global $VibrateButton_Modifier[$VibrateBmaxN], $VibrateButton_ModifierS[$VibrateBmaxN]

for $i=0 to $VibrateBmaxN-1
	$VibrateButtonS[$i] = IniRead($inifile,"Vibration", "VibrateButton" & $i+1,"")
	if $VibrateButtonS[$i]<>"" then $vibrationEnabled=True
	if $VibrateButtonS[$i]="LT" or $VibrateButtonS[$i]="RT" then $VibrateisTrigger[$i]=True
next

global $VibrateModifierButton = IniRead($inifile,"Vibration", "ModifierButton",""), $VibrateStyle= IniRead($inifile,"Vibration","Style",1), $VibrateUseSameStrengthVal=IniRead($inifile,"Vibration","UseSameStrengthVal",0)
global $VibrateStrength = IniRead($inifile,"Vibration","Strength",100), $LeftMotorStrength = IniRead($inifile,"Vibration","LeftMotorStrength",100), $RightMotorStrength = IniRead($inifile,"Vibration","RightMotorStrength",100)
global $VibrateSingleDuration = IniRead($inifile,"Vibration","SingleDuration",400), $VibrateRepeatDuration = IniRead($inifile,"Vibration","RepeatDuration",300), $VibrateRepeatInterval = IniRead($inifile,"Vibration","RepeatInterval",100)
global $VibrationWasEnabled = False, $VibrateProgressiveTrigger=IniRead($inifile,"Vibration","ProgressiveTrigger",0), $VibrateMotor=IniRead($inifile,"Vibration","Motor","Both")
global $vibrationValSX, $vibrationValDX


if $VibrateEnabled=1 and $VibrationEnabled = 1 then
$VibrationWasEnabled = True

for $i=0 to $VibrateBmaxN-1
	$VibrateButtonS[$i]="$"&$vibrateButtonS[$i]

	$VibrateButton_LeftMotorStrength[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".LeftMotorStrength","")
	$VibrateButton_RightMotorStrength[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".RightMotorStrength","")
	$VibrateButton_Strength[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".Strength","")
	$VibrateButton_Motor[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".Motor","")
	$VibrateButton_SingleDuration[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".SingleDuration","")
	$VibrateButton_RepeatDuration[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".RepeatDuration","")
	$VibrateButton_RepeatInterval[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".RepeatInterval","")
	$VibrateButton_Style[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".Style","")
	$VibrateButton_ModifierS[$i]=IniRead($inifile,"Vibration","VibrateButton"& $i+1 & ".Modifier","")

	if $VibrateButton_ModifierS[$i]<>"" then
		$VibrateButton_ModifierS[$i]="$" & $VibrateButton_ModifierS[$i]
	Else
		$VibrateButton_Modifier[$i]="NAA"
	endif


	if $VibrateButton_LeftMotorStrength[$i]="" then
		if $VibrateButton_Strength[$i]<>"" Then $VibrateButton_LeftMotorStrength[$i]=$VibrateButton_Strength[$i]
		if $VibrateButton_Strength[$i]="" then
			if $VibrateUseSameStrengthVal="1" then $VibrateButton_LeftMotorStrength[$i]=$VibrateStrength
			if $VibrateUseSameStrengthVal<>"1" then $VibrateButton_LeftMotorStrength[$i]=$LeftMotorStrength
		endif
	endif

	if $VibrateButton_RightMotorStrength[$i]="" then
		if $VibrateButton_Strength[$i]<>"" Then $VibrateButton_RightMotorStrength[$i]=$VibrateButton_Strength[$i]
		if $VibrateButton_Strength[$i]="" then
			if $VibrateUseSameStrengthVal="1" then $VibrateButton_RightMotorStrength[$i]=$VibrateStrength
			if $VibrateUseSameStrengthVal<>"1" then $VibrateButton_RightMotorStrength[$i]=$RightMotorStrength
		endif
	endif


if $VibrateButton_Motor[$i]="Left" then $VibrateButton_RightMotorStrength[$i]=0
if $VibrateButton_Motor[$i]="Right" then $VibrateButton_LeftMotorStrength[$i]=0

	if $VibrateButton_Style[$i]="" then $VibrateButton_Style[$i]= $VibrateStyle
	if $VibrateButton_SingleDuration[$i]="" then $VibrateButton_SingleDuration[$i]=$VibrateSingleDuration
	if $VibrateButton_RepeatDuration[$i]="" then $VibrateButton_RepeatDuration[$i]=$VibrateRepeatDuration
	if $VibrateButton_RepeatInterval[$i]="" then $VibrateButton_RepeatInterval[$i]=$VibrateRepeatInterval


next


AdlibRegister("Vibrate",50)


elseif $VibrationWasEnabled = True then
	AdlibUnRegister("Vibrate")
endif


global $sendkeystype = Iniread($inifile, "Other","SendKeysType",1)

;;;;;;;;;; RELOAD & STATS
global $ReloadHotkeyEnabledWasTrue=False, $StatsHotkeyEnabledWasTrue=False, $KeyboardShiftToggleEnabledWasTrue=False, $KeyboardShiftCycleEnabledWasTrue=False
global $ReloadHotkeyEnabled=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","ReloadHotkeyEnabled","True"), $StatsHotkeyEnabled=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","StatsHotkeyEnabled","True")


if $ReloadHotkeyEnabled="True" then
global $hotkey =Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","ReloadHotkey","^+5") 	  ;default: Ctrl+Shift+5
$hotkey=String($hotkey)
HotKeySet($hotkey, reloadini)
$ReloadHotkeyEnabledWasTrue=True
elseif $ReloadHotkeyEnabledWasTrue=True Then
	HotKeySet($hotkey)
endif

if $StatsHotkeyEnabled="True" then
global $statshotkey =Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","StatsHotkey","^+6") ;default: Ctrl+Shift+6
$statshotkey=String($statshotkey)
HotKeySet($statshotkey, statsstart)
$StatsHotkeyEnabledWasTrue=True
elseif $StatsHotkeyEnabledWasTrue=True Then
	HotKeySet($statshotkey)
endif

;;;;;;;;;;;;; SHIFT (keyboard)
global $KeyboardShiftToggleEnabled=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","KeyboardShiftToggleEnabled","False") , $KeyboardShiftCycleEnabled=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","KeyboardShiftCycleEnabled","False")

if $KeyboardShiftToggleEnabled="True" then
	global $ShiftModeTogglehotkey=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","ShiftModeToggle","^+9")
	hotkeyset(String($ShiftModeTogglehotkey),ShiftModeToggleK)
	$KeyboardShiftToggleEnabledWasTrue=True
elseif $KeyboardShiftToggleEnabledWasTrue=True Then
	HotKeySet($ShiftModeTogglehotkey)
endif

global $ShiftModeToggleKOn=false, $ShiftModeToggleKVal=IniRead($inifile,"Other","ShiftToggleKeyboardValue",3)

if $KeyboardShiftCycleEnabled="True" then
global $ShiftModeCycleMinushotkey=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","ShiftModeCycle-","^+7"), $ShiftModeCyclePlushotkey=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","ShiftModeCycle+","^+8")
hotkeyset(String($ShiftModeCycleMinushotkey),ShiftModeCycleMinusK)
hotkeyset(String($ShiftModeCyclePlushotkey),ShiftModeCyclePlusK)
$KeyboardShiftCycleEnabledWasTrue=True
elseif $KeyboardShiftCycleEnabledWasTrue=True Then
	HotKeySet($ShiftModeCycleMinushotkey)
	HotKeySet($ShiftModeCyclePlushotkey)
endif

;;;;;;;;;;;;; LAYER (keyboard)
global $KeyboardLayerToJump, $KeyboardPrevLayer
global $layerToggleKOn=False, $LayerToggleKtype=IniRead($inifile,"Other","KeyboardTogglelayerType",0), $LayerToggleKVal=IniRead($inifile,"Other","KeyboardToggleLayerName","")
global $KeyboardLayerToggle=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","KeyboardLayerToggleEnabled","False"), $KeyboardLayerCycle=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","KeyboardLayerCycleEnabled","False")

if $KeyboardLayerToggle="True" then
global $LayerTogglehotkey=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","LayerToggle","^+3")
hotkeyset(String($LayerTogglehotkey),LayerToggleK)
$KeyboardLayerToggleEnabledWasTrue=True
elseif $KeyboardLayerToggleEnabledWasTrue=True then
	hotkeyset($LayerTogglehotkey)
endif


if $KeyboardLayerCycle="True" then
global $LayerCycleMinushotkey=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","LayerCycle-","^+1"), $LayerCyclePlushotkey=Iniread(@ScriptDir & "\" & $programName &".config","Hotkey","LayerCycle+","^+2")
hotkeyset(String($LayerCycleMinushotkey),LayerCycleMinusK)
hotkeyset(String($LayerCyclePlushotkey), LayerCyclePlusK)
$KeyboardLayerCycleEnabledWasTrue=True
elseif $KeyboardLayerCycleEnabledWasTrue=True then
	hotkeyset($LayerCycleMinushotkey)
	hotkeyset($LayerCyclePlushotkey)
endif
;;;;;;;;;;;;;;;;;;


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
#Endregion

#Region var2
global $ml=16, $l=0
global $asize=16+1+8
global $ef[$ml][$asize], $ez[$ml][$asize], $ee[$ml][$asize]
global $ef1[$asize]
For $i=0 To $ml-1
    For $j=0 To $asize-1
        $ef[$i][$j]=False
        $ez[$i][$j]=0
        $ee[$i][$j]=""
		$ef1[$j]=False
    Next
Next
global $keys[16+1+8]   		= [$A, $B, $X, $Y, $LB, $RB, $LT, $RT, $back, $start, $LS, $RS, $Up, $Down, $Left, $Right, $Home, $LSup, $LSdown, $LSleft, $LSright, $RSup, $RSdown, $RSleft, $RSright]
global $keystring[16+1+8]   = ["A", "B", "X", "Y", "LB", "RB", "LT", "RT", "Back", "Start", "LS", "RS", "DUp", "Ddown", "Dleft", "Dright", "Home", "LSup", "LSdown", "LSleft", "LSright", "RSup", "RSdown", "RSleft", "RSright"]
global $pressed=$ef
;A, B, X, Y, LB, RB, LT , RT, back, start, LS, RS, UP, DOWN, LEFT, RIGHT, Home,  LSup,  LSdown, LSleft, LSright, RSup, RSdown, RSleft, RSright
;0  1  2  3  4   5   6    7   8     9      10  11  12  13    14    15     16     17	    18	    19	    20	     21	   22	   23	   24


global $values[$ml][$asize], $valuesS[$ml][$asize]

For $i = 0 To $asize-1
    $values[0][$i] = IniR($keystring[$i])
Next

global $curValues=$values

global $buttonsname=["A","B","X","Y","LB","RB","LT","RT","Back","Start","LS","RS","Dup","Ddown","Dleft","Dright","Home","LSup","LSdown","LSleft","LSright","RSup","RSdown","RSleft","RSright"]

global $toggle=$ef, $toggleOn=$ef,	$Turbo=$ef, $TurboToggle=$ef, $TurboToggleOn=$ef, $TurboOn=$ef, $alreadytimer=$ef, $alreadytimer2=$ef,		$TurboComboalreadyTimer=$ef, $TurboToggleComboalreadyTimer=$ef
global $TimerT[$ml][$asize], $TimerT2[$ml][$asize], $Timer[$ml][$asize], $timersplash,		$TurboComboTimerT[$ml][$asize]
global $released=$ef1, $combo=$ef, $Comboasync=$ef,	$toup=$ef,		$comboOn=$ef, $combosize=11,	$SequenceMax=16,		$comboasyncOn=$ef,	$simpleMacroOn=$ef

global $ToggleComboOn=$ef, $ToggleCombo=$ef, $TurboCombo=$ef, $TurboToggleCombo=$ef,	$TurboComboOn=$ef, $TurboToggleOn=$ef, $TurboToggleComboOn=$ef
global $keysfromcombo[$ml][$asize], $combokeys[$ml][$asize][$combosize], $keysfromcomboup[$ml][$asize], $keysfromcombodown[$ml][$asize]
global $keysfromcomboasync[$ml][$asize], $combokeysasync[$ml][$asize][$combosize], $keysfromcomboupasync[$ml][$asize], $keysfromcombodownasync[$ml][$asize], $combK[$ml][$asize]
global $MacroOn=$ef, $macrosize=26, $Macrokeys[$ml][$asize][$macrosize]
global $stringmax=200,  $text=$ef ; $textOn=$ef, $textkeys[$asize][$stringsize]

global $Togglekeysfromcombo[$ml][$asize],$Togglecombokeys[$ml][$asize][$combosize],$Togglekeysfromcomboup[$ml][$asize],$Togglekeysfromcombodown[$ml][$asize]
global $Turbokeysfromcombo[$ml][$asize],$Turbocombokeys[$ml][$asize][$combosize],$Turbokeysfromcomboup[$ml][$asize],$Turbokeysfromcombodown[$ml][$asize]
;global $TurboTogglekeysfromcombo[$asize],$TurboTogglecombokeys[$asize][$combosize],$TurboTogglekeysfromcomboup[$asize],$TurboTogglekeysfromcombodown[$asize],		$TurboToggleComboTimerT[$asize], 	$releasedC=$ef
global $simplemacro[$ml][$asize], $macro[$ml][$asize],	$SmacroK[$ml][$asize], $SimpleMacroKeys[$ml][$asize][$SequenceMax], $keysfromSimpleMacro[$ml][$asize]
global $alreadyTimerSimpleMacro=$ef, $timerSimpleMacro=$ef

global $comboNum[$ml][$asize], $comboasyncNum[$ml][$asize], $sequenceNum[$ml][$asize], 		$ToggleComboNum[$ml][$asize],$turboComboNum[$ml][$asize]
global $ComboType[$ml][$asize][$combosize],	$comboAsyncType[$ml][$asize][$combosize],	$ToggleComboType[$ml][$asize][$combosize],	$TurboComboType[$ml][$asize][$combosize], $SimpleMacroType[$ml][$asize][$SequenceMax]

global $async=$ef, $alreadytimerasync=$ef, $timerasync=$ef;;;$timerasync[$asize]

global $execute=$ef
global $buttonaction=$ez ;0: normal, 1: toggle, 2: turbo, 3: turbotoggle, 4: execute, 5: combo, 6: comboasync
global $buttontype=$ez   ;0: keyboard, 1:mousebutton, 2: scrollupdown


global $mousemovv[2], $LastStatsText
global $alreadytimerscroll=$ef, $timerscroll[$ml][$asize]
Global $hNTDLL = DllOpen("ntdll.dll")
global $fkeys, $DW=@DesktopWidth/15,$DH=@DesktopHeight/18
global $specialkeys=$ef, $specialkeys2DCombo[$ml][$asize][$combosize], $specialkeys2DSequence[$ml][$asize][$SequenceMax]
;global $textstats, $textstats2, $statsOn=False, $stats, $statstime[$ml][$asize], $statstimer, $splashreload=False
global $textstats, $textstats2, $stats, $statstime[$ml][$asize], $statstimer ; $statsOn=False, $splashreload=False
global $holdmax=3+(1), $holdnum[$ml][$asize], $holdtype[$ml][$asize][$Holdmax],$hold=$ef,$holdOn=$ef, $KeysfromHold[$ml][$asize], $HoldKeys[$ml][$asize][$Holdmax], $specialkeys2DHold[$ml][$asize][$holdmax], $holdtimer=$ef
global $shiftmax=5+1, $shiftNum[$ml][$asize], $shift=$ef, $ShiftKeys[$ml][$asize][$shiftmax], $KeysfromShift[$ml][$asize], $ShiftType[$ml][$asize][$shiftmax], $specialkeys2DShift[$ml][$asize][$shiftmax]
global $ShiftMode=$ef, $ShiftModeToggle=$ef, $ShiftmodeCycle=$ef
global $actionName=$ee, $actionNameS=$ee
global $shinum=1, $tempshinum, $shiftModeToggleOn=$ef, $newshinum=1, $shilimit, $previouslimit
global $FastpressMax=3+1, $FastpressNum=$ez, $Fastpress=$ef, $Fastpresstimer[$ml][$asize], $fastpressOn=$ef, $FastpressKeys[$ml][$asize][$FastpressMax], $fastpressOnH=$ef
global $keysfromFastpress[$ml][$asize], $FastpressType[$ml][$asize][$FastpressMax], $specialkeys2DFastPress[$ml][$asize][$FastpressMax], $tap=$ez, $oldtap=$ez, $fastpressSent=$ef
global $statepress=$ee
global $ml=16, $bl=1, $tl=5 , $l=0, $layervalexists=False, $prefix=$ee, $layeracc[$asize], $layeraccnum=0
global $sectionName[$ml][$asize], $layercount=0, $layertype[$ml], $layerToggleOn=$ef1, $layercycle[$ml], $layervalue[$ml], $layerToCycle[$ml], $buttonL=$ee, $curLayer=0, $prevLayer=0, $cycleLayerCount=0, $layerToCycleSS, $layerToCycleS[$ml], $layerName[$ml]
;global $timerVibrate, $TimerInterval, $vibrateOn=False
global $timerVibrate[$VibrateBmaxN], $TimerInterval[$VibrateBmaxN], $vibrateOn[$VibrateBmaxN], $VibratePressed[$asize] ;global $VibratePressed[$VibrateBmaxN]

$hashValues = ObjCreate("Scripting.Dictionary")
$hashValuesx = ObjCreate("Scripting.Dictionary")
$hashVibrate = ObjCreate("Scripting.Dictionary")
global $VibrateIndex[$VibrateBmaxN], $VibrateIndex2[$VibrateBmaxN]

	for $i=0 to $VibrateBmaxN-1
		$vibrateOn[$i]=0
		$hashValues.Add("$"&$buttonsname[$i],$i)
		$hashValuesx.Add($i,"$"&$buttonsname[$i])
		if $VibrateButtonS[$i]<>"$" then $hashVibrate.Add($VibrateButtonS[$i],$i)
	next

	for $i=0 to $VibrateBmaxN-1
		;$VibrateIndex[$i]=$hashVibrate.Item($hashValuesx.Item($i))
		$VibrateIndex[$i]=$hashVibrate.Item($hashValues.Keys[$i]) ;  $VibrateIndex[$i]=$hashVibrate.Item($hashValues.Keys()[$i]) also ok   ;$VibrateIndex[$i]=$hashVibrate.Item($hashValues.Keys()($i)) ;SAME
		$VibrateIndex2[$i]=$hashValues.Item($VibrateButtonS[$i])
	next
#Endregion var2

parseL0()

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

TraySetToolTip($inifile)
statsvar()

if $AnalogTomouse="1" Then
	adlibregister("mouse",1)
elseif $AnalogTomouseWasTrue="1" then
	adlibunregister("mouse")
endif

endfunc
#Endregion

func timeout()
	if timerdiff($timersplash)>750 then
		$splashreload=False
		SplashOff()
		AdlibUnRegister(timeout)
	endif
endfunc

func reloadini()
	loadini()
	if $splash=1 and not $statsOn then
	$splashreload=True
	$ST=SplashTextOn("","Config reloaded!",$DW,$DH,@DesktopWidth-$DW,@DesktopHeight-$DH,1,13*@DesktopWidth/2000,"",400)
	$timersplash=timerinit()
	AdlibRegister("timeout",50)
	endif
endfunc


#Region Keyboard()
;;;;;;;;;;;;;;KEYBOARD
func shiftmodeToggleK()
	if $ShiftModeToggleKOn = False then
$ShiftModeToggleKOn = True
$shinum=$ShiftModeToggleKval
$newshinum=$shinum
	elseif $ShiftModeToggleKOn = True then
		$shinum=1
		$newshinum=$shinum
		$ShiftModeToggleKOn = False
	endif
endfunc

func shiftmodeCycleMinusK()
	if $shinum>=1 then
		$shinum-=1
		$previouslimit=""
	endif

	if $shinum<1 then
		$shinum=$shiftMax-1
		$shiLimit=$shiftMax-1
		Return
	endif
endfunc

func shiftmodeCyclePlusK()
$shinum+=1
	if $shinum>$shiLimit then
		$shinum=1
		$shiLimit=$shiftMax-1
		$previouslimit=""
		Return
	endif
endfunc



func LayerToggleK()

if $layerToggleKOn=False Then
		$layerToggleKOn=True
		$KeyboardPrevLayer=$l
		$l=$KeyboardLayerToJump
elseif $layerToggleKOn=True then

	for $i=0 to $asize-1
		if $keys[$i] then
			;if $buttonaction[$l][$i]<>19 and $buttonaction[$l][$i]<>20 then inpt($i,$values[$l][$i],1,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])
		endif
	next
	$l=$KeyboardPrevLayer
	$layerToggleKOn=False
endif

endfunc

func LayerCycleMinusK()

	for $i=0 to $asize-1
		if $keys[$i] then
if $buttonaction[$l][$i]<>19 and $buttonaction[$l][$i]<>20 then inpt($i,$values[$l][$i],1,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])
		endif

	layereleasekeys($i)

	next

if $l>5 then
	$l=$CycleLayerCount
elseif $l>=0 then
	$l-=1
elseif $l<0 then
	$l=$CycleLayerCount
endif
endfunc

func LayerCyclePlusK()

	for $i=0 to $asize-1
		if $keys[$i] then
if $buttonaction[$l][$i]<>19 and $buttonaction[$l][$i]<>20 then inpt($i,$values[$l][$i],1,$buttontype[$l][$i],$buttonaction[$l][$i],$specialkeys[$l][$i])
		endif

	layereleasekeys($i)

	next


if $l<=$CyclelayerCount then $l+=1
if $l>$CycleLayerCount then $l=0
endfunc


;;;;;;;;;;;;;;;;
#Endregion


#REgion onExit()
func onexit()
	;sleep(1500)
	if $splashEx=1 then
	SplashTextOn("","Quitting",$DW,$DH,@DesktopWidth-$DW,@DesktopHeight-$DH,1,13*@DesktopWidth/2000,"",400)
	$timersplash=timerinit()
	AdlibRegister("timeout",50)
	sleep(1000)
	endif


	For $i = 0 To UBound($sentKeys) - 1
		If Not $sentKeys[$i] Then ContinueLoop
		if $values[$l][$i]="" then continueloop
If ($sendkeystype=1 and $buttonaction[$l][$i] <=4 and $sentkeys[$i]) or ($sentkeys[$i] and $sendkeystype=2 and ($buttonaction[$l][$i]<>5 and $buttonaction[$l][$i]>6 and $buttonaction[$l][$i]<>7 and $buttonaction[$l][$i]<>10)) then
	if $values[$l][$i]="" then continueloop
	if $buttontype[$l][$i]=0 Then Send("{" & $values[$l][$i] & " up}")
	if $buttontype[$l][$i]=1 then mouseup($values[$l][$i])


Elseif ($sendkeystype=1 and $buttonaction[$l][$i]>4) or ($sendkeystype=2 and ($buttonaction[$l][$i]=5 or $buttonaction[$l][$i]=6 or $buttonaction[$l][$i]=7 or $buttonaction[$l][$i]=10)) then


		For $k=1 To UBound($combokeys, 3) - 1
		  If $sentKeys[$i] Then
            If $combokeys[$l][$i][$k] <> "" Then Send("{" & $combokeys[$l][$i][$k] & " up}")
		  endif
        Next

		#cs
		For $k=1 To UBound($combokeysasync, 3) - 1
		  If $sentKeys[$i] Then
            If $combokeysasync[$l][$i][$k] <> "" Then Send("{" & $combokeysasync[$l][$i][$k] & " up}")
		  endif
        Next
		#ce

		For $k=1 To UBound($Togglecombokeys, 3) - 1
		  If $sentKeys[$i] Then
            If $Togglecombokeys[$l][$i][$k] <> "" Then Send("{" & $Togglecombokeys[$l][$i][$k] & " up}")
		  endif
        Next

		For $k=1 To UBound($Turbocombokeys, 3) - 1
		  If $sentKeys[$i] Then
            If $Turbocombokeys[$l][$i][$k] <> "" Then Send("{" & $Turbocombokeys[$l][$i][$k] & " up}")
		  Endif
		Next


		if $simplemacroOn[$l][$i]=True Then
			for $u=$SmacroK[$l][$i] to 1 step -1
				sender($i,$simpleMacrokeys[$l][$i][$u],1,$simpleMacroType[$l][$i][$u],$specialkeys2DSequence[$l][$i][$u])
			next
			$simpleMacroOn[$l][$i]=False
		endif

		if $comboasyncOn[$l][$i]=True Then
			for $u=$combK[$l][$i] to 1 step -1
				sender($i,$combokeysasync[$l][$i][$u],1,$comboAsyncType[$l][$i][$u],$specialkeys2DCombo[$l][$i][$u])
			Next
			$comboasyncOn[$l][$i]=False
		endif



		if $fastpressOnH[$l][$i]=True then
		sender($i,$FastpressKeys[$l][$i][$oldtap[$l][$i]],1,$FastpressType[$l][$i][$oldtap[$l][$i]],$specialkeys2DFastpress[$l][$i][$oldtap[$l][$i]])
		endif

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
#endregion



