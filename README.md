 # 🎮 GamepadToKeyboard-PlayniteExtension    
 ![GitHub Downloads](https://img.shields.io/github/downloads/roob-p/GamepadToKeyboard-PlayniteExtension/total)   
 
🕹️ *Emulate mouse and keyboard input with your gamepad in a quick, easy and highly customizable manner.*  

- This extension lets you send mouse and keyboard input with your controller, so you can use it in games without gamepad support, or where some controller buttons (in particular `LT` and `RT`) do not work.  
***Perfect for old games without native controller support or with incomplete Xinput functionality.***  
- The program is very easy to use and configure: just edit the assignments in the `.ini` file and the application will be started automatically after launching the game. 
- A dedicated config can be created per game, or a global config can be used for all games.
- It's also possible to browse the config to use directly from the menu panel, or create a list of favourite configs that can be switched via sub-menu.
- Multiple games can be selected at once. Every new config will be created.
- The program's functionalities can be changed with a click through the menu.
- Clear and intuitive: "LED" icons indicate the state of the program, the active config and much more.
- Config files can be edited and reloaded on-the-fly using a hotkey, without restarting the application.
- **The program allows fine control over several controller aspects: deadzone types (square/rectangular, circular with and without rescale), deadzone values (per stick, axis, or direction), axis inversion, modifiers (`[Toggle], [Turbo], [TurboToggle], [Execute], [Combo], [ComboAsync], [Sequence]` and others) and more.**
- Future updates will include `[MACRO]` and `[TEXT]` modifiers.

##### ⚠️ `GamepadToKeyboard` requires an Xinput controller (native or emulated via tools like DS4Windows, DualSenseX, x360ce, etc.). 
#### 🚀 A Standalone version is also available for users who don't use Playnite: https://github.com/roob-p/GamepadToKeyboard  
 
<br>

## 🧩 How it works (Playnite side)
- Turn `On|Off` the program by clicking the 1st menu item. When `Enabled`, the program is automatically executed after launching the defined (activated) games.
- Activate a game by clicking the 2nd menu item, and the game will be added in `Gamelist.ini` (with its name, id, source and/or platform). An assignment config (gameid.ini) for that game will be created.
- You can open the game config by clicking `Edit game config`.
- Edit `Gamelist.ini` by clicking the 3rd menu item. `Gamelist.ini` contains the games for which `GamepadToKeyboard` will work. When a gameid is set to `1` the game is active; when set to `0` the game is not active and `GamepadToKeyboard` will not be launched.
- Use a personal, external config for all games by setting `UseCustomIni = 1` (editing `Gamelist.ini`, or through the menu panel) and specifying the file in `FileIni`).
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

### 🧪 Technical Notes
- Please don't assign `[Turbo]` and other Turbo-based modifiers to Wheel, since it has dedicated repetition variables.
- `[ComboAsync]` and `[Sequence]` timing can be customized through their dedicated delay variables (expressed in ms).
- Add only one modifier per assignment (e.g `[Turbo][Combo]` NOT supported).
- **The Windows key may not behave exactly like a physical key due to Windows focus-handling limitations.**
- Please don't use `CTRLDOWN`, `ALTDOWN`, `SHIFTDOWN`, `LWINDOWN`, `RWINDOWN` in the assignments. These special keys are handled through `LAlt`, `LCtrl`, `RAlt`, `RCtrl`, `LWin`, and `RWin`.


### ⚠️ Notes
- The exe that comes with the extension is 64bit. The reason is that the x64 version of Autoit programs receive minor flags from AV engines. If you need the x86 one you can download it from the main in the repo, or from the attached files in the releases.  
- The program does not contain any malicious behaviour. If your AV engine flags it as malware it's a false positive. If so, please send `GamepadTokeyboard.exe` (or any associated flagged file) to your AV vendor asking for a false positive review request.


<br>  

**If you enjoy GamepadToKeyboard, you can buy me a coffee. It will be very appreciated ;)**  

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/E1E214R1KB)  

<br>


- Install directly:
  [GamepadToKeyboard](https://playnite.link/addons.html#GamepadToKeyboard)
- Download last version:
[v1.2.2](https://github.com/roob-p/GamepadToKeyboard-PlayniteExtension/releases/download/v1.2.2/GamepadToKeyboard_v1.2.2.pext)


<br>

## ⌨️ List of assignable keys
`SPACE`, `ENTER`, `ALT`, `BACKSPACE`, `BS`, `DELETE`, `DEL`, `UP`, `DOWN`, `LEFT`, `RIGHT`, `HOME`, `END`, `ESCAPE`, `ESC`, `INSERT`, `INS`, `PGUP`, `PGDN`, `F1`, `F2`, `F3`, `F4`, `F5`, `F6`, `F7`, `F8`, `F9`, `F10`, `F11`, `F12`, `TAB`, `PRINTSCREEN`, `LWIN`, `RWIN`, `NUMLOCK on`, `CAPSLOCK off`, `SCROLLLOCK toggle`, `BREAK`, `PAUSE`, `NUMPAD0`, `NUMPAD1`, `NUMPAD2`, `NUMPAD3`, `NUMPAD4`, `NUMPAD5`, `NUMPAD6`, `NUMPAD7`, `NUMPAD8`, `NUMPAD9`, `NUMPADMULT`, `NUMPADADD`, `NUMPADSUB`, `NUMPADDIV`, `NUMPADDOT`, `NUMPADENTER`, `APPSKEY`, `LALT`, `RALT`, `LCTRL`, `RCTRL`, `LSHIFT`, `RSHIFT`, `SLEEP`, `ASC nnnn`, `BROWSER_BACK`, `BROWSER_FORWARD`, `BROWSER_REFRESH`, `BROWSER_STOP`, `BROWSER_SEARCH`, `BROWSER_FAVORITES`, `BROWSER_HOME`, `VOLUME_MUTE`, `VOLUME_DOWN`, `VOLUME_UP`, `MEDIA_NEXT`, `MEDIA_PREV`, `MEDIA_STOP`, `MEDIA_PLAY_PAUSE`, `LAUNCH_MAIL`, `LAUNCH_MEDIA`, `LAUNCH_APP1`, `LAUNCH_APP2`, `OEM_102`  

<br>



### 🎖️ Credits
This gamepad script was written in AutoIt.  
The program makes use of a remodified version of the XInput UDF by Oxin8 (xoninx@gmail.com) to read Xinput states.






 
