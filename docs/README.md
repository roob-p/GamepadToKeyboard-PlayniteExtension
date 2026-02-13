<!--[🔙 Back](https://roob-p.github.io)-->   
<!--[![🔙 Back](https://img.shields.io/badge/🔙-Back-blue)](https://roob-p.github.io)-->  
[![🔙 Back](https://img.shields.io/badge/🔙-Back-white?style=flat-square&logoColor=blue&color=blue)](https://roob-p.github.io)  
  
# 🎮 GamepadToKeyboard-PlayniteExtension  
🕹️ *Emulate keyboard and mouse with your gamepad in a quick, easy and really customizable manner.*  

- This extension lets you send mouse and keyboard input with your controller, so you can use it in games without gamepad support, or where some controller buttons (in particular `LT` and `RT`) do not work (for example in `Legacy of Kain: Defiance` and `Assassin's Creed`).   
***Useful for old games without proper Xinput support.***
- The program is very easy to use and configure: just edit the assignments in the `.ini` file and the application will be started automatically after launching the game. 
- A dedicated config can be created per game, or a global config can be used for all games.
- Also possible to browse the config to use directly from the menu panel, or create a list of favourite configs that can be switched via sub-menu.
- Multiple games can be selected at once. Every new config will be created.
- The program's functionalities can be changed with a click through the menu.
- Clear and intuitive: "LED" icons indicate the state of the program, the active config and much more.
- The program also allows fine control over several controller aspects: deadzones (per stick, axis, or direction), axis inversion and more.
- Config files can be edited and reloaded on-the-fly using a hotkey, without restarting the application.
- **In future I'll add MACRO, COMBO and TURBO functionalities. Stay tuned.**


## ⚙️ How it works 
- Turn `On|Off` the program by clicking the 1st menu item. When `Enabled`, the program is automatically executed after launching the defined (activated) games.
- Activate a game by clicking the 2nd menu item, and the game will be added in `Gamelist.ini` (with its name, id, source and/or platform). An assignment config (gameid.ini) for that game will be created.
- You can open the game config by clicking `Edit game config`.
- Edit `Gamelist.ini` by clicking the 3rd menu item. `Gamelist.ini` contains the games for which `GamepadToKeyboard` will work. When a gameid is set to `1` the game is active; when set to `0` the game is not active and `GamepadToKeyboard` will not be launched.
- Use a personal, external config for all games by setting `UseCustomIni = 1` (editing `Gamelist.ini`, or through the menu panel) and specifying the file in `FileIni`).
- You can also explore and select it via `Select custom ini file (all games)`.
- In `QuickIniProfile.ini` you can edit a list of "favourite" configs that can be switched through `Quick ini profiles (all games)` item menu. The sub-menu is dynamically built: its size varies with the number of elements.
- The program can also load a config if passed as parameter via command line, or by drag and drop it to `GamepadToKeyboard.exe`. Make sure that GamepadToKeyboard is disabled in Playnite, or that the target game is deactivated.
- In a multiple selection, if the games are in a mixed state (some games activated, some games deactivated, others not added) the extension automatically adds the new entries in `Gamelist.ini` and activates all of them.

### 🔄 Live config reload

- Configuration files can be edited while the game is running.
- Just press the Hotkey (`Shift`+`Ctrl`+`5` by default) to instantly reload the current `.ini`, without restarting the application.
- The Hotkey can be customized in `GamepadToKeyboard.config`. 
<br>  


## 🕹️ Button assignments
Values you can assign to the buttons: 
- `A..Z`, `0..9`, `F1..F12`
- common buttons: `Enter`, `Space`, `Esc`, `Lalt`, `Lshift`, `Lctrl`, `Lwin`
- mouse buttons: `LBmouse`, `RBmouse`, `MBmouse`, `WheelUp`, `WheelDown`  
- Please check the bottom of this page to find the possible key assignments.

`default.ini` example:

|Button       |Keys         |‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ |Button  | Keys    |‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ |Button       |Keys        |‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ |Button       |Keys         |  
|-------------|-------------|-----------|--------|---------|-----------|-------------|------------|-----------|-------------|-------------|
|`A`          |Enter        |           |`Back`  | F1      |           |`LSup`       | W          |           |`Home`       |Esc          | 
|`B`          |Space        |           |`Start` | Esc     |           |`LSdown`     | S          |
|`X`          |Lshift       |           |`LS`    | LShift  |           |`LSleft`     | A          |            
|`Y`          |LCtrl        |           |`RS`    | MBmouse |           |`LSright`    | D          |
|`LB`         |Q            |           |`Dup`   | Up      |           |`RSup`       |            |
|`RB`         |E            |           |`Ddown` | Down    |           |`RSdown`     |            |
|`LT`         |RBmouse      |           |`Dleft` | Left    |           |`RSleft`     |            |
|`RT`         |LBmouse      |           |`Dright`| Right   |           |`RSright`    |            |


## ⚙️ Common controller options  

 Section                          | Option                         | Values / Description                                                                                                       |
| --------------------------------| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
|                                 |                                |                                                                      |                                                                                                                         
|Mouse                            |AnalogToMouse                   |`1/0`    : Turn On/Off the mouse movement via analog sticks.          |
|                                 |Stick 	                         |`RS/LS`  : Analog to use. Button assignments ignored.                 |
|                                 |DeadzoneType                    |`1/2/4`  : Both axis/ per axis/ per direction.*                       |
|                                 |(Stick)AxisInverted             |`1/0`    : Turn On/off axis inversion.                                | 
|                                 |Sensitivity                     |`value`  : Mouse movement speed.                                      |
|Analogs                          |DeadzoneType                    |`1/2/4/8`: Both sticks/ per stick/ per axis/ per direction.*          |    
|                                 |(Stick)AxisInverted             |`1/0`    : Turn On/off axis inversion.                                |   
|Other                            |WheelAnalogvalues               |`1/0`    : Progressive/Digital values when wheel is assigned to stick.|   
|                                 |SendTypes                       |`1`: default; `2`: alternate; `3`: desktop mode (keyboard-style delay and repeat).*| 
                                                                   

<br>



## ⚠️ Notes
- The exe that comes with the extension is 64bit. The reason is that the x64 version of Autoit programs receive minor flags from AV engines. If you need the x86 one you can download it from the main in the repo, or from the attached files in the releases.  
- The program does not contain any malicious behaviour. If your AV engine flags it as malware it's a false positive. If so, please send `GamepadTokeyboard.exe` (or any associated flagged file) to your AV vendor asking for a false positive review request.


<br>  

**If you enjoy GamepadToKeyboard, you can buy me a coffee. It will be very appreciated ;)**  

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/E1E214R1KB)  

<br>

## ⌨️ List of assignable keys
`SPACE`, `ENTER`, `ALT`, `BACKSPACE`, `BS`, `DELETE`, `DEL`, `UP`, `DOWN`, `LEFT`, `RIGHT`, `HOME`, `END`, `ESCAPE`, `ESC`, `INSERT`, `INS`, `PGUP`, `PGDN`, `F1`, `F2`, `F3`, `F4`, `F5`, `F6`, `F7`, `F8`, `F9`, `F10`, `F11`, `F12`, `TAB`, `PRINTSCREEN`, `LWIN`, `RWIN`, `NUMLOCK on`, `CAPSLOCK off`, `SCROLLLOCK toggle`, `BREAK`, `PAUSE`, `NUMPAD0`, `NUMPAD1`, `NUMPAD2`, `NUMPAD3`, `NUMPAD4`, `NUMPAD5`, `NUMPAD6`, `NUMPAD7`, `NUMPAD8`, `NUMPAD9`, `NUMPADMULT`, `NUMPADADD`, `NUMPADSUB`, `NUMPADDIV`, `NUMPADDOT`, `NUMPADENTER`, `APPSKEY`, `LALT`, `RALT`, `LCTRL`, `RCTRL`, `LSHIFT`, `RSHIFT`, `SLEEP`, `ALTDOWN`, `ALTUP`, `SHIFTDOWN`, `SHIFTUP`, `CTRLDOWN`, `CTRLUP`, `LWINDOWN`, `LWINUP`, `RWINDOWN`, `RWINUP`, `ASC nnnn`, `BROWSER_BACK`, `BROWSER_FORWARD`, `BROWSER_REFRESH`, `BROWSER_STOP`, `BROWSER_SEARCH`, `BROWSER_FAVORITES`, `BROWSER_HOME`, `VOLUME_MUTE`, `VOLUME_DOWN`, `VOLUME_UP`, `MEDIA_NEXT`, `MEDIA_PREV`, `MEDIA_STOP`, `MEDIA_PLAY_PAUSE`, `LAUNCH_MAIL`, `LAUNCH_MEDIA`, `LAUNCH_APP1`, `LAUNCH_APP2`, `OEM_102`  

<br>



### 📝 *Option notes and other settings    
|     |     |     |     |     |    
|:---:|:---:|:---:|:---:|:---:|    
|**Mouse**‎  |`Deadzone`|`XDeadzone` `YDeadzone`  |`XleftDeadzone` `XrightDeadzone` `YleftDeadzone` `YrightDeadzone` |                                                                                                                                     |    
|**Analogs**‎|`Deadzone`|`LSDeadzone` `RSDeadzone`|`LSXDeadzone` `LSYDeadzone` `RSXDeadzone` `RSYDeadzone`           |`LSleftDeadzone` `LSrightDeadzone` `LSupDeadzone` `LSdownDeadzone` `RSleftDeadzone` `RSrightDeadzone` `RSupDeadzone` `RSdownDeadzone`|  

|   |   |   |   |
|  -|-  |-  |-  |
|**Other**|`Sendtypes`:|`1` Simple press (desktop single press, works well in games)                                    |`2` Continuous press on desktop, same as type 1 in games|
|         |            |`3` Desktop-like behavior (keyboard-style delay and repeat). Same as the previous types in games|`4` Desktop-alt experimental (not recommended). In-game behavior as previous types|

|     |     |     |     |     | 
|:---:|:---:|:---:|:---:|:---:|
| `UseSameWheelSpeedLimiter`: `1\|0` -->  Use same value for WheelUp and WheelDown|`WheelSpeedLimiter`: limit scroll speed|`WheelSpeedLimiterUp`: WheelUp limiter | `WheelSpeedLimiterDown`: WheelDown limiter       | |

| | | |
|-|-|-|
|**Mouse**|`SmoothFactor`:|How smooth the movement should be (1 = no smoothing, near 0 = very smooth, values below 0.1 may make the cursor too slow. 0 blocks the cursor, be cautious)|


 
