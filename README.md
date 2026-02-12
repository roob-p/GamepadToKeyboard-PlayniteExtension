 # 🎮 GamepadToKeyboard-PlayniteExtension
🕹️ *Emulate keyboard and mouse with your gamepad in a quick and customizable manner.*

- This extension lets use send mouse and keyboard input with the controller, so you can use it in games without pad support, or where some controller buttons (in particular `LT` and `RT`) does not work (for example in `Legacy of Kain: Defiance` and `Assassin's Creed`).   
***Useful for old games without proper xinput support.***
- The program is very easy to use and configure: just edit the assignments in the .ini file and the application will be started automatically after launching the game. 
- You can create a config per game or use a global config for all games.
- Super clear: the "Led" icons indicate the state of the program, the active config and much more.
- You can change the state of the program and its functionalities with a click through the menu panel.
- Possibility to explore the config file to use or edit a list of favourite configs that can be switched via menu panel, with a click.
- You can select multiple games at once. Every new config will be created.
- The program permits to adjust several aspects of the controller: deadzones (per stick, axis, or direction) axis inversions and more.


## ⚙️ How it works 
- Turn `On|Off` the program by clicking the 1st menu voice. When `Enabled`, the program is automatically executed after launching the defined (activated) games.
- Activate a game by clicking the 2nd menu voice, and the game will be added in `Gamelist.ini` (with it's name, id, source and/or platform). An assignment config (gameid.ini) for that game will be created.
- You can open the game config by clicking `Edit game config`
- Edit `Gamelist.ini` by clicking the 3rd menu voice. `Gamelist.ini` contains the games for which `GamepadToKeyboard` will work. When an idgame is setted to `1` the game is active; when setted to `0` the game is not active and `GamepadToKeyboard` will not be launched.
- Use a personal, external config for all games by setting `UseCustomIni = 1` (editing `Gamelist.ini`, or through the menu panel) and specifying the file in `FileIni`).
- You can also explore and select it via `Select custom ini file (all games)`.
- In `QuickIniProfile.ini` you can edit a list of "favourite" configs that can be switched through `Quick ini profiles (all games)` voice menu. The sub-menu is dinamically built: its size varies with the number of elements.
- In a multiple selection, if the games are in a mixed state (some games activated, some games disactivated, others not added) the extension automatically add the new entries in `Gamelist.ini` and activate all of them.



## 🕹️ Button assignments
Values you can assign to the buttons: 
- `A..Z`, `0..9`, `F1..F12`
- common buttons: `Enter`, `Space`, `Esc`, `Lalt`, `Lshift`, `Lctrl`, `Lwin`
- mouse buttons: `LBmouse`, `RBmouse`, `MBmouse`, `WheelUp`, `WheelDown`  

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


## Common controller options  

 Section                          | Option                         | Values / Description                                                                                                       |
| --------------------------------| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
|                                 |                                                                                                                                            
|[Mouse]                          |AnalogToMouse                   |`1/0`    : Turn On/Off the mouse movement via analog sticks.          |
|                                 |Stick 	                         |`RS/LS`  : Analog to use. Button assignments ignored.                 |
|                                 |DeadzoneType                    |`1/2/4`  : Both axis/ per axis/ per direction.*                       |
|                                 |(Stickdir)AxisInverted          |`1/0`    : Turn On/off axis inversion                                 | 
|[Analogs]                        |DeadzoneType                    |`1/2/4/8`: Both sticks/ per stick/ per axis/ per direction.**         |    
|                                 |(Stickdir)AxisInverted          |`1/0`    : Turn On/off axis inversion.                                |   
|[Other]                          |WheelAnalogvalues               |`1/0`    : Progressive/Digital values when wheel is assigned to stick.| 
|                                 |                                |                                                                      |
|                                 |                                |*Assign the value to `Deadzone` / `XDeadzone, YDeadzone` / `XleftDeadzone, XrightDeadzone, YleftDeadzone, YrightDeadzone`    |
|                                 |                                |**Assign the value to `Deadzone` / `LSDeadzone, RSDeadzone` / `LSXDeadzone, LSYDeadzone, RSXDeadzone, RSYDeadzone` /  `LSleftDeadzone, LSrightDeadzone, LSupDeadzone, LSdownDeadzone, RSleftDeadzone, RSrightDeadzone, RSupDeadzone, RSdownDeadzone`     |
                                                                   








## ⚠️ Notes
- The exe that comes with the extension is 64bit. The reason is that the x64 version of Autoit programs receive minor flags from AV engines. If you need the x86 one you can dowload it from the main in the repo, of from the attached files in the releases.  
- The program does not contain any malicious behaviour. If your AV engine flags it as malware it's a false positive. If so, please send `GamepadTokeyboard.exe` (or any associated flagged file) to your AV vendor asking for a false positive review request.

## ⌨️ List of assignable keys:
`SPACE`, `ENTER`, `ALT`, `BACKSPACE`, `BS`, `DELETE`, `DEL`, `UP`, `DOWN`, `LEFT`, `RIGHT`, `HOME`, `END`, `ESCAPE`, `ESC`, `INSERT`, `INS`, `PGUP`, `PGDN`, `F1`, `F2`, `F3`, `F4`, `F5`, `F6`, `F7`, `F8`, `F9`, `F10`, `F11`, `F12`, `TAB`, `PRINTSCREEN`, `LWIN`, `RWIN`, `NUMLOCK on`, `CAPSLOCK off`, `SCROLLLOCK toggle`, `BREAK`, `PAUSE`, `NUMPAD0`, `NUMPAD1`, `NUMPAD2`, `NUMPAD3`, `NUMPAD4`, `NUMPAD5`, `NUMPAD6`, `NUMPAD7`, `NUMPAD8`, `NUMPAD9`, `NUMPADMULT`, `NUMPADADD`, `NUMPADSUB`, `NUMPADDIV`, `NUMPADDOT`, `NUMPADENTER`, `APPSKEY`, `LALT`, `RALT`, `LCTRL`, `RCTRL`, `LSHIFT`, `RSHIFT`, `SLEEP`, `ALTDOWN`, `ALTUP`, `SHIFTDOWN`, `SHIFTUP`, `CTRLDOWN`, `CTRLUP`, `LWINDOWN`, `LWINUP`, `RWINDOWN`, `RWINUP`, `ASC nnnn`, `BROWSER_BACK`, `BROWSER_FORWARD`, `BROWSER_REFRESH`, `BROWSER_STOP`, `BROWSER_SEARCH`, `BROWSER_FAVORITES`, `BROWSER_HOME`, `VOLUME_MUTE`, `VOLUME_DOWN`, `VOLUME_UP`, `MEDIA_NEXT`, `MEDIA_PREV`, `MEDIA_STOP`, `MEDIA_PLAY_PAUSE`, `LAUNCH_MAIL`, `LAUNCH_MEDIA`, `LAUNCH_APP1`, `LAUNCH_APP2`, `OEM_102`

 
