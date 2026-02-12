
	$config = @{}
	Get-Content -Path "$PSScriptRoot\autorun.ini" | ForEach-Object {
	$parts = $_ -split "="
	#$content= $parts[1].Trim()
	$key = $parts[0].Trim()
    $value = $parts[1].Trim()
    $config[$key] = $value
	}
	
	
		if ($config["GamepadToKeyboardActive"] -eq 1){
		$global:ProgramActive=1
		}
	

$global:program_filename="GamepadToKeyboard"




function OnGameStarted()
{
    param($args)
    #$ags.Game.Name | Out-File "RunningGame.txt"
	#if ($args.Game.Name -like "*DOOM 64*") {


	if ($global:ProgramActive -eq 1) {
	

$gamel  = $PlayniteApi.MainView.SelectedGames
$gamed = $gamel.id


	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$ini = $ini -replace("\\","\\")
	$ini = $ini |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' }| ConvertFrom-StringData
	
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	if (($ini."UseCustomIni" -eq "On")){
		$global:initoload=$ini."CustomIniFile"
		$global:initoload=[string]$global:initoload

	start-process "$PSScriptRoot\$global:program_filename.exe" -Argument "$PSScriptRoot\$global:initoload"
	}
	else {
	
	if ($ini.$gamed -eq 1){ 
	start-process "$PSScriptRoot\$global:program_filename.exe" -Argument "$PSScriptRoot\$gamed.ini"
	#start-process "$PSScriptRoot\GamepadToKeyboard.exe" -Argument "$PSScriptRoot\$($args.Game.id).ini"
	
	}
	
}

} #$global:ProgramActive -eq 1

}#endfunc

function OnGameStopped()
{
	param($args)
	
	stop-process -Name "$global:program_filename" -EA 0
	
}

function openfolder()
{
		param(
		$getGameMenuItemsArgs
	)
	
	start $PSScriptRoot
	
}#endfunc


	function getGameMenuItems{
	
	param(
		$getGameMenuItemsArgs
	)
	
	
	$gamel  = $PlayniteApi.MainView.SelectedGames	
	if ($gamel.count -eq 1) {
	$gamedl = $gamel.id
	
	
	
	
		$global:gamestatus = ""
	$global:game_icon  =  ""
	
	

	#$global:inic=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |select-object| ConvertFrom-StringData
	#$global:inic=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$global:inic=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$global:inic = $global:inic -replace("\\","\\")
	$global:inic = $global:inic |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
	if ($global:inic.$gamedl -eq 1){ 
	$global:gamestatus = "Activated for this game"
	$global:game_icon  =  "$PSScriptRoot\green.png"
	$global:gamefunc = "GameToggle"
		
		if (!(Test-Path "$PSScriptRoot\$gamedl.ini")){
	$global:gameconfigstate = "Game config not found"	
	$global:gameconficon = "$PSScriptRoot\documentx.png"	
	} else{
	$global:gameconfigstate = "Edit Game config"
	$global:gameconficon = "$PSScriptRoot\document.png"
	}
	
	
	}# 1
		elseif ($global:inic.$gamedl -eq 0){ 
	$global:gamestatus = "Deactivated for this game"
	$global:game_icon  =  "$PSScriptRoot\blue.png"
	$global:gamefunc = "GameToggle"
	
	
			if (!(Test-Path "$PSScriptRoot\$gamedl.ini")){
	$global:gameconfigstate = "Game config not found"	
	$global:gameconficon = "$PSScriptRoot\documentx.png"	
	} else{
	$global:gameconfigstate = "Edit Game config"
	$global:gameconficon = "$PSScriptRoot\document.png"	
	}
	
	
	} #0
	else {    #no entry in gamelist	
	if (Test-Path "$PSScriptRoot\$gamedl.ini" ){	
	$global:gamestatus = "Game config found but no gamelist entry.`nClick to add one."
	$global:gameconfigstate = "Game config found. Click to edit"
	$global:gameconficon = "$PSScriptRoot\document.png"
	$global:game_icon  =  "$PSScriptRoot\blue!.png"
	$global:gamefunc = "GameToggle"
	#$global:gameconfigstate = "No game config found. Click to create one"
	}
	else {	
		$global:gamestatus = "No gamelist entry and no game config found. Click to create both."
		$global:gameconfigstate = "No game config found"
		$global:gameconficon = "$PSScriptRoot\documentX.png"
		$global:game_icon  =  "$PSScriptRoot\Disabled.png"
		$global:gamefunc = "GameToggle"
	}
	}
	
	
		$global:program_name="Gamepad To Keyboard"
		
	
	if ($global:ProgramActive -eq 1){
		$global:program_desc= "$global:program_name" + ": Enabled"
		$global:program_icon= "$PSScriptRoot\Enabled.png"
	} else {
		$global:program_desc = "$global:program_name" + ": Disabled"
		$global:program_icon = "$PSScriptRoot\Disabled.png"

		}	

	
	}#count1
	
	elseif ($gamel.count -gt 1) {					#multiple selection
		
		
	$gamel  = $PlayniteApi.MainView.SelectedGames	
		
		
	#$global:gamestatus=""
	#$global:inic=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |select-object| ConvertFrom-StringData
	#$inics=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$inics=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$inics = $inics -replace("\\","\\")
	$inics = $inics |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData

	
	$global:allconfigok=1
	$global:configfound=0
	$global:allactivated=1
	$global:alldisactivated=1
	$global:gameadded=0
	$global:alladded=1

	foreach ($game in $gamel) {
	
	$gamed=$game.id
	
	if (Test-Path "$PSScriptRoot\$gamed.ini"){	
	$global:configfound=1
	}else{$global:allconfigok=0}
	

	if ($inics.$gamed -eq 1){ 
	#$global:allactivated=$True
	$global:gameadded=1
	}
	else {$global:allactivated=0}
	
	
		if ($inics.$gamed -eq 0){ 
		$global:gameadded=1
	}
	else {$global:alldisactivated=0}
	
	
	
	if ($inics.$gamed) {
	}		
	else {$global:alladded=0
	}
	
	
	
	

		
	}#foreach
		
		
		
	if ($global:allconfigok){
		
	#$global:gameconfigstate = "Edit game configs (all configs found)."
	#$global:gameconficon = "$PSScriptRoot\document.png"	
	}
	else {
	#$global:gameconfigstate = "Edit the game configs found."
	#$global:gameconficon = "$PSScriptRoot\document.png"		
	}
		
	if ($global:allactivated -eq 1)	{
	$global:gamestatus = "Activated for all games. Click to deactivate them."	
	$global:game_icon  =  "$PSScriptRoot\green.png"	
	$global:gamefunc ="Deactivateall"
	if ($global:allconfigok -eq 1) {
	$global:gameconfigstate = "Edit game configs (all configs found)"	#
	$global:gameconficon = "$PSScriptRoot\document.png"	
	}
		else{
		
	if ($global:configfound -eq 1){	
	$global:gameconfigstate = "Edit the game configs found."
	$global:gameconficon = "$PSScriptRoot\document.png"	
	}
	else{
	$global:gameconfigstate = "No game configs found."
	$global:gameconficon = "$PSScriptRoot\documentx.png"		
	}

			}
	}	#allactivated=1
	
					else { # !allactivated=1
	
	if ($global:alldisactivated -eq 1)	{
	$global:gamestatus = "Deactivated for all games. Click to activate them."	
	$global:game_icon  =  "$PSScriptRoot\blue.png"	
	$global:gamefunc ="Activateall"

	}
	
	else {
		
		if ($global:gameadded -eq 0) {
		$global:gamestatus = "No game entries in gamelist. Click to add them."
		$global:game_icon  =  "$PSScriptRoot\Disabled.png"	
		$global:gamefunc ="Activateall"
		} 
		
		elseif ($global:alladded -eq 1){
			$global:gamestatus = "All games have gamelist entries but are in a mixed state. Click to activate all."
			$global:game_icon  =  "$PSScriptRoot\blue.png"
			$global:gamefunc ="ActivateAll"
		}
		
		#elseif ($global:gameadded -eq 1) {
			else{	
	$global:gamestatus = "Games in mixed state. Click to add missing entries and activate all."
	$global:game_icon  =  "$PSScriptRoot\blue!.png"	
	#$global:gamefunc ="Deactivateallandadd"
	$global:gamefunc ="ActivateAllandadd"
		}	
	}	
		
		if ($global:allconfigok -eq 1) {
	$global:gameconfigstate = "Edit game configs (all configs found)"	#
	$global:gameconficon = "$PSScriptRoot\document.png"	
	}
		else{
		
	if ($global:configfound -eq 1){	
	$global:gameconfigstate = "Edit the game configs found."
	$global:gameconficon = "$PSScriptRoot\document.png"	
	}
	else{
	$global:gameconfigstate = "No game configs found."
	$global:gameconficon = "$PSScriptRoot\documentx.png"		
	}
		
		
		
		
		
						}
		
	
	$global:program_name="Gamepad To Keyboard"
	
	if ($global:ProgramActive -eq 1){
		$global:program_desc= $global:program_name + ": Enabled"
		$global:program_icon= "$PSScriptRoot\Enabled.png"
	} else {
		$global:program_desc = $global:program_name + ": Disabled"
		$global:program_icon = "$PSScriptRoot"+"\Disabled.png"

		}	
		
		}#else intermedio
			
		
		
	}#else #count>1


	
	
	
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$ini = $ini -replace("\\","\\")
	$ini = $ini |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
	
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	
	$ini2=get-content "$PSScriptRoot\QuickIniProfiles.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
	$inii2=get-content "$PSScriptRoot\QuickIniProfiles.ini" -EA 0
	
	

	
	$global:quickiniprofilesname = "Quick ini profiles (all games)"
#$menuItems = @( $null ) * 15
$menuItems = @( $null ) * $ini2.count

	
	#for ($m=0; $m -lt 15;$m++){
		for ($m=0; $m -lt $ini2.count;$m++){
	
	$menuItems[$m] = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItems[$m].Description = $ini2."$($m+1)"
    $menuItems[$m].FunctionName = "changeprofile"
	$menuItems[$m].Icon = "$PSScriptRoot\document.png"
	$menuItems[$m].MenuSection = "GamepadToKeyboard|$global:quickiniprofilesname|"	
		
		

		
	}

	
	
	
	
	$global:UseIni=$ini."UseCustomIni"
	$global:fileini=$ini."CustomIniFile"

	
	
	if ($global:UseIni -eq "Off"){
	$global:ini_icon="$PSScriptRoot\blue.png"
	$global:inistate= "OFF"
	}elseif($global:UseIni -eq "On"){
		$global:ini_icon="$PSScriptRoot\green.png"
		$global:inistate= "ON"
	}
	
	$global:quickiniprofilesname = "Quick ini profiles (all games)"
	
	
	
	$menuItem1 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItem1.Description = "$global:program_desc"
    $menuItem1.FunctionName = "ProgramToggle"
	$menuItem1.Icon = "$global:program_icon"
	$menuItem1.MenuSection = "GamepadToKeyboard|"
	
	
	$menuItem2 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItem2.Description = "$global:gamestatus"
    $menuItem2.FunctionName = "$global:gamefunc"
	$menuItem2.Icon = "$global:game_icon"
	$menuItem2.MenuSection = "GamepadToKeyboard|"
	
	
	$menuItem3 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItem3.Description = "$global:gameconfigstate"
    $menuItem3.FunctionName = "gameconfig"
	$menuItem3.Icon = "$global:gameconficon"
	$menuItem3.MenuSection = "GamepadToKeyboard|"
	
	$menuItem4 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItem4.Description = "Edit Gamelist"
    $menuItem4.FunctionName = "gamelist"
	$menuItem4.Icon = "$PSScriptRoot\documentlist.png"
	$menuItem4.MenuSection = "GamepadToKeyboard|"
	
	$menuItemE = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItemE.Description = "-"
	$menuItemE.MenuSection = "GamepadToKeyboard|"
	

	
	
	$menuItem5 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItem5.Description = "Use custom ini (all games): $inistate`nFile: $global:fileini"
    $menuItem5.FunctionName = "CustomIniToggle"
	$menuItem5.Icon = "$ini_icon"
	$menuItem5.MenuSection = "GamepadToKeyboard|"
	
	$menuItem6 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItem6.Description = "Select custom ini file (all games)"
    $menuItem6.FunctionName = "getfileini"
	$menuItem6.Icon = "$PSScriptRoot\folder.png"
	$menuItem6.MenuSection = "GamepadToKeyboard|"
	
	$menuItem7 = New-Object Playnite.SDK.Plugins.ScriptGameMenuItem
	$menuItem7.Description = "Open config folder"
    $menuItem7.FunctionName = "openfolder"
	$menuItem7.Icon = "$PSScriptRoot\folder2.png"
	$menuItem7.MenuSection = "GamepadToKeyboard|"
	
	
	
	
	
	
#return $menuItem1, $menuItem2, $menuItem3, $menuitem4, $menuItem5, $menuItems
return @(
    $menuItem1,
    $menuItem2,
    $menuItem3,
    $menuItem4,
    #$menuItem5,
	#$menuItem6
	#) + $menuItems
$menuItem5, $menuItemE) + $menuItems + @($menuItem6) + @($menuItem7)


	
		} #end getGameMenuItems
	
	

	
	

	
	function ProgramToggle() 
	{
			param(
		$getGameMenuItemsArgs
	)
	
	$ini0=get-content "$PSScriptRoot\autorun.ini"
	
	if ($global:ProgramActive -eq 1) {
		$ini0 = $ini0 -replace("GamepadToKeyboardActive = 1", "GamepadToKeyboardActive = 0")
		set-content $ini0 -Path "$PSScriptRoot\autorun.ini" -Force
				$global:ProgramActive=0
		
	}
	else{
		$ini0 = $ini0 -replace("GamepadToKeyboardActive = 0", "GamepadToKeyboardActive = 1")
		set-content $ini0 -Path "$PSScriptRoot\autorun.ini" -Force
				$global:ProgramActive=1
	}
		#$global:ProgramActive=!$global:ProgramActive
		
	}
	
	
	function changeprofile()
	{
				param(
		$getGameMenuItemsArgs
	)
	
	$valuemenu = $getGameMenuItemsArgs.SourceItem.Description
	
	if ($valuemenu -ne ""){
	
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$ini = $ini -replace("\\","\\")
	$ini = $ini |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
	
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0

	
	
	
	#$inii = $inii.Replace("CustomIniFile = *", "CustomIniFile = $valuemenu")
	$inii = $inii -replace '^(CustomIniFile\s*=\s*).*$', "`$1$valuemenu"
	set-content $inii -Path "$PSScriptRoot\gamelist.ini" -Force

	}
	
	}#endfunc
	
	
	
	function getfileini()
	{
		param(
	$getGameMenuItemsArgs
	)
	
$initialDirectory=""	
	
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.Filter = "ini files (*.ini)|"
#$dialog.InitialDirectory = $game.installdirectory  


if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
	$inifile = $dialog.FileName
	
	
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$ini = $ini -replace("\\","\\")
	$ini = $ini |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
	
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0	
	$inii = $inii -replace '^(CustomIniFile\s*=\s*).*$', "`$1$inifile"
	set-content $inii -Path "$PSScriptRoot\gamelist.ini" -Force

}

	
	
	}#endfunc
	
	function CustomIniToggle()
	{
	param(
	$getGameMenuItemsArgs
	)	
	
	if ($global:UseIni -eq "Off"){
	$global:UseIni="On"
	#$global:inistate="ON"
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$inii = $inii.Replace("UseCustomIni = Off", "UseCustomIni = On")
	set-content $inii -Path "$PSScriptRoot\gamelist.ini" -Force
	
	} elseif($global:UseIni -eq "On"){
	$global:UseIni="Off"
	#$global:inistate="OFF"
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$inii = $inii.Replace("UseCustomIni = On", "UseCustomIni = Off")
	set-content $inii -Path "$PSScriptRoot\gamelist.ini" -Force
	}
	
	}#endfunc
	
	
	
	
	
	function gameToggle() 
	{
			param(
		$getGameMenuItemsArgs
	)



	$game = $PlayniteApi.MainView.SelectedGames	
	$gamed = $game.id
	
	
	
	
	
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |select-object| ConvertFrom-StringData
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$ini = $ini -replace("\\","\\")
	$ini = $ini |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
	
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	
	if ($ini.$gamed -eq 1){ 
	$inii = $inii.Replace("$($gamed) = 1", "$($gamed) = 0")
	set-content $inii -Path "$PSScriptRoot\gamelist.ini" -Force
	
	
		if (!(Test-Path "$PSScriptRoot\$gamed.ini")){	
	#createini }
			   }
	}
	elseif ($ini.$gamed -eq 0){ 
	$inii = $inii.Replace("$($gamed) = 0", "$($gamed) = 1")
	set-content $inii -Path "$PSScriptRoot\gamelist.ini" -Force
	
		if (!(Test-Path "$PSScriptRoot\$gamed.ini")){	
	createini }
	
	}
	#elseif ( ($ini.$gamed -eq "") -or !($ini.$gamed) ){	
	elseif ( !($ini.$gamed) ){
	#$inii+="$($game.id) = 1`n"
	##$inii+="$($game.id) = 1" + [Environment]::NewLine
	if (!(Test-Path "$PSScriptRoot\$gamed.ini")){	
	createini }
	platformsource
		#add-content -Path "$PSScriptRoot\gamelist.ini" "$($game.id) = 1"
		add-content -Path "$PSScriptRoot\gamelist.ini" "$($game.id) = 1 	# Title: $game | $global:platformsource"
	
	}



		}# end gameToggle
	
	
	function getini{
		param(
	$getGameMenuItemsArgs
	)	
	
	
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$ini = $ini -replace("\\","\\")
	$ini = $ini |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
	
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	
	
	
	}
	
	
	function platformsource{
				param(
	$getGameMenuItemsArgs
	)
	#if ( ($($game.source) -ne '') -and ($($game.platforms)) -ne '' ) {
if ( ($($game.source)) -and ($($game.platforms)) ) {
	$global:platformsource = "$($game.source), $($game.platforms)"
}
elseif ( ($($game.source)) ) {
$global:platformsource	= "($($game.source))"
} elseif ( ($($game.platforms)) ){
$global:platformsource = "($($game.platforms))"
}		
	}
	
function gameconfig
{
	param(
	$getGameMenuItemsArgs
	)
	
	
	
	
	
	$gamesel = $PlayniteApi.MainView.SelectedGames	
	
	foreach($game in $gamesel){
		$gamed = $game.id
	
	if (Test-Path "$PSScriptRoot\$gamed.ini" ){
	start "$PSScriptRoot\$gamed.ini"
	}
	}
	
	}#endfunc

function gamelist
{
	
		param(
	$getGameMenuItemsArgs
	)
	
start "$PSScriptRoot\gamelist.ini"
}	
	
	
	function loadini {
	
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$ini = $ini -replace("\\","\\")
	$ini = $ini |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
	
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	
	}
	
	
	
	function ActivateAll() 
	{
			param(
		$getGameMenuItemsArgs
	)



	$gamesel = $PlayniteApi.MainView.SelectedGames
	foreach ($game in $gamesel) {
		
		
	$gamed = $game.id
	
	
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |select-object| ConvertFrom-StringData
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$ini = $ini -replace("\\","\\")
	$ini = $ini |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
	
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	
if ($ini.$gamed -eq 0){ 
	$inii = $inii.Replace("$($gamed) = 0", "$($gamed) = 1")
	set-content $inii -Path "$PSScriptRoot\gamelist.ini" -Force
	
	if (!(Test-Path "$PSScriptRoot\$gamed.ini")){	
	createini }
	
	}
	elseif ( !($ini.$gamed) ){	
	#elseif ( ($ini.$gamed -eq "") -or !($ini.$gamed) ){	
	#$inii+="$($game.id) = 1`n"
	##$inii+="$($game.id) = 1" + [Environment]::NewLine
	if (!(Test-Path "$PSScriptRoot\$gamed.ini")){	
	createini }
	platformsource
		#add-content -Path "$PSScriptRoot\gamelist.ini" "$($game.id) = 1"
		add-content -Path "$PSScriptRoot\gamelist.ini" "$($game.id) = 1 	# Title: $game | $global:platformsource"
	
	}

	}

		}# end ActivateAll
	
	
	
	
	
		function DeactivateAll() 
	{
			param(
		$getGameMenuItemsArgs
	)



	$gamesel = $PlayniteApi.MainView.SelectedGames
	foreach ($game in $gamesel) {
		
		

	$gamed = $game.id
	
	
	
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |select-object| ConvertFrom-StringData
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$ini = $ini -replace("\\","\\")
	$ini = $ini |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
	
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	
	if ($ini.$gamed -eq 1){ 
	$inii = $inii.Replace("$($gamed) = 1", "$($gamed) = 0")
	set-content $inii -Path "$PSScriptRoot\gamelist.ini" -Force
	}

	}

		}# end ActivateAll
	
	
	
	
	
function DeactivateAllandadd() 
	{
			param(
		$getGameMenuItemsArgs
	)



	$gamesel = $PlayniteApi.MainView.SelectedGames
	foreach ($game in $gamesel) {
		
		

	$gamed = $game.id
	
	
	
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |select-object| ConvertFrom-StringData
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$ini = $ini -replace("\\","\\")
	$ini = $ini |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
	
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	
	if ($ini.$gamed -eq 1){ 
	$inii = $inii.Replace("$($gamed) = 1", "$($gamed) = 0")
	set-content $inii -Path "$PSScriptRoot\gamelist.ini" -Force
	}
	
	
	
	
		if (!(Test-Path "$PSScriptRoot\$gamed.ini")){	
	createini }
	
	#$gamed = [string]$gamed
	##$gamed = "$gamed "
	##$gamed = $gamed.Trim()
	

	#if (-not($ini.keys.contains($gamed))) {
	if (-not($ini.keys -contains $gamed)){

	platformsource
	
		add-content -Path "$PSScriptRoot\gamelist.ini" "$gamed = 0 	# Title: $game | $global:platformsource"
		
	}
	
	

	}#foreach
	
	


		}# end deactivateAllandadd
		
		
	
		
		
		
		
			
	
function ActivateAllandadd() 
	{
			param(
		$getGameMenuItemsArgs
	)



	$gamesel = $PlayniteApi.MainView.SelectedGames
	foreach ($game in $gamesel) {
		
		

	$gamed = $game.id
	
	
	
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |select-object| ConvertFrom-StringData
	#$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0 |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
		$ini=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	$ini = $ini -replace("\\","\\")
	$ini = $ini |ForEach-Object { ($_ -replace '\s*#.*$','').Trim() } | Where-Object { $_ -match '=' } | ConvertFrom-StringData
	
	$inii=get-content "$PSScriptRoot\gamelist.ini" -EA 0
	
	if ($ini.$gamed -eq 0){ 
	$inii = $inii.Replace("$($gamed) = 0", "$($gamed) = 1")
	set-content $inii -Path "$PSScriptRoot\gamelist.ini" -Force
	}
	
	
	
	
		if (!(Test-Path "$PSScriptRoot\$gamed.ini")){	
	createini }
	
	##$gamed = [string]$gamed
	##$gamed = "$gamed "
	##$gamed = $gamed.Trim()
	
	#if (-not($ini.keys.contains($gamed))) { #no, problems
	if (-not($ini.keys -contains $gamed)){

	platformsource
	
		add-content -Path "$PSScriptRoot\gamelist.ini" "$gamed = 1 	# Title: $game | $global:platformsource"
		
	}
		
	}#foreach
	
	
		}# end deactivateAllandadd
	
	
	
	
	
	
function createini {


platformsource

$gameinicontent = "Title: $game | Id: $gamed | $global:platformsource
[Buttons]
A       =  Enter
B       =  Space
X       =  LShift
Y       =  LCtrl
LB      =  Q
RB      =  E
LT      =  RBmouse
RT      =  LBmouse
Back    =  F1
Start   =  Esc
LS      =  LShift
RS      =  MBmouse
Dup     =  Up
Ddown   =  Down
Dleft   =  Left
Dright  =  Right
LSup    =  W
LSdown  =  S
LSleft  =  A
LSright =  D
RSup	=  
RSdown  =  
RSleft  =  
RSright = 
Home	=


[Other]
 ; SendKeysType:
; 1 = Simple press (desktop single press, works well in games)
; 2 = Continuous press on desktop, same as type 1 in games
; 3 = Desktop-like behavior (keyboard-style delay and repeat). Same as the previous types in games.
; 4 = Desktop-alt: experimental/alternative desktop mode. In-game behavior same as previous types.

SendKeysType   = 1

 ; WheelAnalogMode = 1  Enables progressive behavior when the wheel is assigned to an analog axis. Digital inputs always use step values.
WheelAnalogMode = 1

UseSameWheelSpeedLimiter  = 1
WheelSpeedLimiter	      = 8500

WheelSpeedLimiterUp 	  = 8500
WheelSpeedLimiterDown 	  = 8500

 ;  Wheel step amount when scrolling
WheelStepUp    = 5
WheelStepDown  = 5

[Mouse]
 ; Activating AnalogToMOuse will ignore the buttons assignments in Buttons section and the deadzone values used in the Analogs section for the selected stick.
AnalogToMouse = 1
Stick 	      = RS

Sensitivity   = 50
SmoothFactor  = 0.2

LSXaxisInverted	= 0
LSYaxisInverted = 0
RSXaxisInverted = 0
RSYaxisInverted = 0

   ; DeadzoneType: 1 = one value for both axes, 2 = one value per axis, 4 = one value per direction
DeadzoneType 	= 1

XleftDeadzone   = 2000
XrightDeadzone  = 2000
YleftDeadzone   = 2000
YrightDeadzone  = 2000

Xdeadzone       = 2000
Ydeadzone       = 2000

Deadzone        = 2000


[Analogs]
   ; DeadzoneType: 1 = Global (one value for both sticks and both axes), 2 = PerStick (LS and RS have different deadzones), 4 = PerAxis (X and Y Deadzones per stick), 8 = PerDirection (left/right/up/down deadzones per stick)
DeadzoneType      =  1

   ; Used when DeadzoneType = 1 (Global)
Deadzone          = 1000

   ; Used when DeadzoneType = 2 (PerStick)
LSDeadzone        = 0
RSDeadzone        = 0

   ; Used when DeadzoneType = 4 (PerAxis)
LSXdeadzone       = 0
LSYdeadzone       = 0
RSXdeadzone       = 0
RSYdeadzone       = 0

   ; Used when DeadzoneType = 8 (PerDirection)
LSleftDeadzone    = 0
LSrightDeadzone   = 0
LSupDeadzone      = 0
LSdownDeadzone    = 0
RSleftDeadzone    = 0
RSrightDeadzone   = 0
RSupDeadzone      = 0
RSdownDeadzone    = 0

LSXaxisInverted	  = 0
LSYaxisInverted   = 0
RSXaxisInverted   = 0
RSYaxisInverted   = 0
"


set-content $gameinicontent -Path "$PSScriptRoot\$gamed.ini" -Force

}#endfunc