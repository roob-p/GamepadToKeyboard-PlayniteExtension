<!--[🔙 Back](https://roob-p.github.io)-->  
<!--[![🔙 Back](https://img.shields.io/badge/🔙-Back-blue)](https://roob-p.github.io)-->    
[![🔙 Back](https://img.shields.io/badge/🔙-Back-white?style=flat-square&logoColor=blue&color=blue)](https://roob-p.github.io)  
# 🎮 GamepadToKeyboard-PlayniteExtension  
 ![GitHub Downloads](https://img.shields.io/github/downloads/roob-p/GamepadToKeyboard-PlayniteExtension/total)  
 
🕹️ *Emulate mouse and keyboard input with your gamepad in a quick, easy and highly customizable way.*  

- This extension lets you send mouse and keyboard input with your controller, so you can use it in games without gamepad support, or where some controller buttons (in particular `LT` and `RT`) do not work.  
***Perfect for old games without native controller support or with incomplete Xinput functionality.***  
- The program is very easy to use and configure: just edit the assignments in the `.ini` file and the application will be started automatically after launching the game. 
- A dedicated config can be created per game, or a global config can be used for all games.
- It's also possible to browse the config to use directly from the menu panel, or create a list of favourite configs that can be switched via sub-menu.
- Multiple games can be selected at once, and a config will be created for each of them.
- The program's functionalities can be changed with a click through the menu.
- Clear and intuitive: "LED" icons indicate the state of the program, the active config and much more.
- Config files can be edited and reloaded on-the-fly using a hotkey, without restarting the application.
- **The program allows fine control over several controller aspects: deadzone types (square/rectangular, circular with and without rescale), deadzone values (per stick, axis, or direction), axis inversion, modifiers (`[Toggle], [Turbo], [TurboToggle], [Execute], [Combo], [Sequence]` and others) and more.**
- Supports switchable key assignment groups: `Layer` (with fallback support) and `Set` (without fallback).
- Includes a customizable rumble system with per-button vibration effects.
- Future updates will include `[Chord]` a more advanced `[MACRO]` modifier.


  

##### ⚠️ `GamepadToKeyboard` requires an Xinput controller (native or emulated via tools like DS4Windows, DualSenseX, x360ce, etc.).  
#### 🚀 Standalone version
A standalone version is also available for users who don't use Playnite:
[GamepadToKeyboard standalone](https://github.com/roob-p/GamepadToKeyboard)


## 🧩 How it works (Playnite side)
- Turn `On|Off` the program by clicking the 1st menu item. When `Enabled`, the program is automatically executed after launching the defined (activated) games.
- Activate a game by clicking the 2nd menu item, and the game will be added in `Gamelist.ini` (with its name, id, source and/or platform). An assignment config (gameid.ini) for that game will be created.
- You can open the game config by clicking `Edit game config`.
- Edit `Gamelist.ini` by clicking the 3rd menu item. `Gamelist.ini` contains the games for which `GamepadToKeyboard` will work. When a gameid is set to `1` the game is active; when set to `0` the game is not active and `GamepadToKeyboard` will not be launched.
- Use a personal, external config for all games by setting `UseCustomIni = 1` (editing `Gamelist.ini`, or through the menu panel and specifying the file in `FileIni`).
- You can also explore and select it via `Select custom ini file (all games)`.
- In `QuickIniProfile.ini` you can edit a list of "favourite" configs that can be switched through `Quick ini profiles (all games)` item menu. The sub-menu is dynamically built: its size varies with the number of elements.
- The program can also load a config if passed as parameter via command line, or by drag and drop it to `GamepadToKeyboard.exe`. Make sure that GamepadToKeyboard is disabled in Playnite, or that the target game is deactivated.
- In a multiple selection, if the games are in a mixed state (some games activated, some games deactivated, others not added) the extension automatically adds the new entries in `Gamelist.ini` and activates all of them.


## 📝 Controller configuration
- The program includes several modifiers, which change the button behaviour.  
  **Just add one of these modifiers before the assigned keys:**
 - `[Toggle], [Turbo], [TurboToggle]`
 - `[Combo]`: send multiple keys at once
 - `[Execute]`: run programs (e.g. `notepad`, `calc.exe`, `c:\yourfolder\yourprogram.exe`)
 - `[ComboAsync]`: send multiple keys with a delay (defined with `ComboKeysDelay`)
 - `[ToggleCombo], [TurboCombo], [TurboToggleCombo]`
 - `[Sequence]`: send keys in sequence. Similar to `[ComboAsync]`, but ComboAsync sends and holds the keys, `[Sequence]` sends simple presses.
- Set `AnalogToMouse = 1` (enabled by default) to move the mouse with the analog stick defined in `Stick` (default: `Stick = RS` )
- Mouse wheel input is digital when assigned to buttons, and analog/progressive when assigned to sticks or triggers.


### 🔄 Live config reload

- Configuration files can be edited while the game is running.
- Just press the Hotkey (`Shift`+`Ctrl`+`5` by default) to instantly reload the current `.ini`, without restarting the application.
- The Hotkey can be customized in `GamepadToKeyboard.config`. 


## 🕹️ Button assignments
Values you can assign to the buttons: 
- `A..Z`, `0..9`, `F1..F12`
- common buttons: `Enter`, `Space`, `Esc`, `Lalt`, `Lshift`, `Lctrl`, `Lwin`
- mouse buttons: `LBmouse`, `RBmouse`, `MBmouse`, `WheelUp`, `WheelDown`  
##### Additional assignable keys are listed at the bottom of this page.

### 📘 Syntax
- Just add one modifier to button assignments, placing it before the keys (e.g `A = [Turbo]c`).
- Each key must be separated with `,`. Extra spaces are ignored (e.g `A = [COMBO] c,S, L,Lbmouse`).
- Modifiers are case-insensitive (`[Turbo]`, `[TURBO]` and `[turbo]` are equivalent).
- Spaces after modifiers are optional (`[Turbo]k` and `[Turbo] k` are both valid).
- Combo-based modifiers support up to 10 buttons, while `[Sequence]` supports up to 15. Any additional keys are ignored.


**Example syntax:**

|Button   |Assignment              |      |‎Button   | Assignment          |‎     |Button   |Assignment  |‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎   
|---------|------------------------|------|---------|---------|-----------|-----|---------|------------|
|`A`      |Enter                   |      |`Back`   | F1                  |     |`LSup`   | Up         |           
|`B`      |[Turbo] Space           |      |`Start`  | Esc                 |     |`LSdown` | Down       |
|`X`      |[ComboAsync] S, Space,r |      |`LS`     | [Toggle]LShift      |     |`LSleft` | Left       |                    
|`Y`      |[COMBO]A,x,F,LBmouse    |      |`RS`     | [execute] calc.exe  |     |`LSright`| Right      |
|`LB`     |RBmouse                 |      |`Dup`    | Up                  |     |`RSup`   |            |
|`RB`     |LBmouse                 |      |`Ddown`  | Down                |     |`RSdown` |            |
|`LT`     |Wheelup                 |      |`Dleft`  | Left                |     |`RSleft` |            |
|`RT`     |WheelDown               |      |`Dright` | Right               |     |`RSright`|            |
|`Home`   |Lwin                    |


## ⚙️ Common controller options  

| Section                         | Option                         | Values / Description                                                                                                       |
|---------------------------------|--------------------------------|------------------------------------------------------------------------------------------------------------
|                                 |                                |                                                                                                                            |
|Mouse                            |AnalogToMouse                   |`1/0`    : Turn On/Off the mouse movement via analog sticks.                                                                |
|                                 |Stick 	                         |`RS/LS`  : Analog to use. Button assignments ignored.         
|                                 |Deadzoneshape                   |`1/2/3`  : `Square/Rectangular`,`Circular`,`Circular (with rescale)`.     |
|                                 |DeadzoneType                    |`1/2/4`  : Both axis/ per axis/ per direction.                                                                              |
|                                 |(Stick)AxisInverted             |`1/0`    : Turn On/off axis inversion. 4 options available.                                             | 
|                                 |Sensitivity                     |`Value`  : Mouse movement speed.                                                                                            |
|Analogs                          |DeadzoneType                    |`1/2/4/8`: Both sticks/ per stick/ per axis/ per direction.                                                                |    
|                                 |(Stick)AxisInverted             |`1/0`    : Turn On/off axis inversion. 4 options available.                               
|Other                            |SendKeysTypes                   |`1`: Game mode; `2`: Desktop (with windows-style keypress delay + repeat)   

                                                 

                                                                   

<br>

 ### ⌨️ Hotkeys                                                
The program supports several configurable hotkeys. They can be set in `GamepadToKeyboard.config` and disabled if needed.
- **Configuration reload**: `Shift + Ctrl + 5` (enabled by default). 
- **Stats system**: `Shift + Ctrl + 6` (enabled by default).
- **ShiftMode controls**: `ShiftModeCycle-` *(Shift + Ctrl + 7)*, `ShiftModeCycle+` *(Shift + Ctrl + 8)*, `ShiftModeToggle` *(Shift + Ctrl + 9)*, disabled by default.
- **Layer controls**: `LayerCycle-` *(Shift + Ctrl + 1)*, `LayerCycle+` *(Shift + Ctrl + 2)*, `LayerToggle` *(Shift + Ctrl + 3)*, disabled by default.
- To enable/disable a hotkey, use the corresponding boolean flag in `GamepadToKeyboard.config`:
  e.g. `KeyboardShiftEnabled = False`.  

<br>

## 🖼️ Layers
- GamepadToKeyboard supports multiple switchable slots of key assignments through Layer and Set.
- `Layer` supports fallback (if a key doens't have an assignment, the correspondent value is taken from the Button section), while `Set` does not. 
- You can define a Layer adding a section in the .INI file using square brackets (e.g. `[inventorymenu]`).
- Adding the prefix `layer:` or `set:` to the name section set its initial type (Layer or Set) (e.g. `[set:inventorymenu], [layer:inventorymenu]`). Types can be overridden using the Layer/Set modifiers. If no prefix is added the default type is layer.
- Use `[LayerMode]`, `[SetMode]`, `[LayerModeToggle]`, `[SetModeToggle]` followed by the Layer/Set name in button assignments to load that Layer/Set.
- You can also define up to 5 Layers/Sets using `LayerToCycle` in `Other` section and switch between them using `[LayerCycle+]` and `[LayerCycle-]`. These can reference existing Layers/Sets already used by the mode modifiers, or completely different ones.
- Each Layer/Set assignment uses one available slot, even if it references an already existing Layer/Set.
- The maximum number of active Layer/Set assignments is 15.
- When you assign a Layer/Set modifier to a button, that "activator" key will have the same function in the called layer/set (even if you try to reassign it to a new value). 
- **Please use Layer/Set modifiers only in the Buttons section.**
- Check the `LayerExample.ini` to see how layers/set work.

<br>

## 〰️ Vibration feature
- GamepadToKeyboard lets you create customizable vibration effects for every button.
- Three different vibration modes are available:
   - `Hold`: vibration continues while the button is held down.
   - `Single`: send a single vibration each time the button is pressed (duration can be configured in ms using `SingleDuration` variable).
   - `Repeat`: vibration is repeated while the button is held down with an interval time (RepeatDuration and RepeatInterval are available).
- You can define the buttons to vibrate with VibrateButtonN in the `[Vibration]` section (e.g. `VibrateButton1 = X`, `$VibrateButton2 = LB` etc.) and specify the properties adding a dot and the variable to the name:  
 >   
 > - VibrateButton2                   = Y
 > - VibrateButton2.Style             = 1
 > - VibrateButton2.LeftMotorStrength = 50
 > - VibrateButton2.SingleDuration    = 300
- If a property is not set, the corresponding global value is used.
- You can also define `Modifier` buttons: the vibration only starts when this button is pressed together with a VibrateButton, e.g.:
 >   
 > - VibrateButton3                   = X
 > - VibrateButton3.Modifier          = LB 
- Common properties available:
 >   
 > - VibrateButtonN.Style: (0, 1, 2) 
 > - VibrateButtonN.Motor: (Left, Right, Both)
 > - VibrateButtonN.LeftMotorStrength: (Value), VibrateButtonN.RightMotorStrength: (Value)
 > - VibrateButtonN.SingleDuration, VibrateButtonN.RepeatDuration, VibrateButtonN.RepeatInterval  
- If `VibrateButtonN.LeftMotorStrength` or `VibrateButtonN.RightMotorStrength` are not available, GamepadToKeyboard looks up the global variables `LeftMotorStrength` and `RightMotorStrength`. If `UseSameStrengthVal = 1` then the `Strength` global variable is used.
- You can enable progressive vibration strength with `ProgressiveTrigger = 1` (in this mode, Style is ignored for analog triggers).
- GamepadToKeyboard supports simultaneous vibration effects from multiple buttons by automatically combining the left and right motor strengths.
- **By combining styles, durations, intervals and motor strengths, you can create a wide variety of vibration effects.**


### ⚠️ Notes
- The exe that comes with the extension is 64bit. The reason is that the x64 version of Autoit programs receive minor flags from AV engines. If you need the x86 one you can download it from the main in the repo, or from the attached files in the releases.  
- The program does not contain any malicious behaviour. If your AV engine flags it as malware it's a false positive. If so, please send `GamepadTokeyboard.exe` (or any associated flagged file) to your AV vendor asking for a false positive review request.


<br>  

**If you enjoy GamepadToKeyboard, you can buy me a coffee. It will be very appreciated ;)**  

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/E1E214R1KB)  

<br>

- 🐙 Github repo: [roop-p/GamepadToKeyboard-PlayniteExtension](https://github.com/roob-p/GamepadToKeyboard-PlayniteExtension/)
- 🧩 Install directly:
  [GamepadToKeyboard](https://playnite.link/addons.html#GamepadToKeyboard)
- 📥 Download last version:
[v1.2.7](https://github.com/roob-p/GamepadToKeyboard-PlayniteExtension/releases/download/v1.2.7/GamepadToKeyboard_v1.2.7.pext)


<br>

## ⌨️ List of assignable keys
`SPACE`, `ENTER`, `ALT`, `BACKSPACE`, `BS`, `DELETE`, `DEL`, `UP`, `DOWN`, `LEFT`, `RIGHT`, `HOME`, `END`, `ESCAPE`, `ESC`, `INSERT`, `INS`, `PGUP`, `PGDN`, `F1`, `F2`, `F3`, `F4`, `F5`, `F6`, `F7`, `F8`, `F9`, `F10`, `F11`, `F12`, `TAB`, `PRINTSCREEN`, `LWIN`, `RWIN`, `NUMLOCK on`, `CAPSLOCK off`, `SCROLLLOCK toggle`, `BREAK`, `PAUSE`, `NUMPAD0`, `NUMPAD1`, `NUMPAD2`, `NUMPAD3`, `NUMPAD4`, `NUMPAD5`, `NUMPAD6`, `NUMPAD7`, `NUMPAD8`, `NUMPAD9`, `NUMPADMULT`, `NUMPADADD`, `NUMPADSUB`, `NUMPADDIV`, `NUMPADDOT`, `NUMPADENTER`, `APPSKEY`, `LALT`, `RALT`, `LCTRL`, `RCTRL`, `LSHIFT`, `RSHIFT`, `SLEEP`, `ASC nnnn`, `BROWSER_BACK`, `BROWSER_FORWARD`, `BROWSER_REFRESH`, `BROWSER_STOP`, `BROWSER_SEARCH`, `BROWSER_FAVORITES`, `BROWSER_HOME`, `VOLUME_MUTE`, `VOLUME_DOWN`, `VOLUME_UP`, `MEDIA_NEXT`, `MEDIA_PREV`, `MEDIA_STOP`, `MEDIA_PLAY_PAUSE`, `LAUNCH_MAIL`, `LAUNCH_MEDIA`, `LAUNCH_APP1`, `LAUNCH_APP2`, `OEM_102`   

<br>



### 🎖️ Credits
This gamepad script was written in AutoIt.  
The program makes use of a remodified version of the XInput UDF by Oxin8 (xoninx@gmail.com) to read Xinput states.






 




 
