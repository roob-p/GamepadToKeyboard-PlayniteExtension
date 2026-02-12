 # 🎮 GamepadToKeyboard-PlayniteExtension
🕹️ *Emulate keyboard and mouse input with your gamepad in a quick, easy and very customizable manner.*

- This extension lets use send mouse and keyboard inputs so you can use the controller in games without pad support, or where some controller buttons (in particular LT and RT) does not work (for example `Legacy of Kain: Defiance` and `Assassin's Creed`).   
***This can be very usel in old games without xinput support.***
- The program is very easy to use and configure: just edit the button assignments in the associated game ini file and the application will be started automatically after launching the game. 
- You can create a config per game or use a global config for all games.
- Super Clean: the "Led" icon indicates the state of the program, the active config and much more.
- Change the state of fucntionality with a click through the menu panel.
- Possibility to explore the config file to use or edit a list of favourite config that can be switch via menu panel with a click 


## ⚙️ How it works 
- Turn On/Off the program clicking the first menu voice. When turned on, the program is executed by launching the "activated" games.
- Activate a game clicking the 2nd menu voice, and it be will be added in `Gamelist.ini` (with it's name, id, platform and/or source). An assignment config (gameid.ini) for that game will be created.
- You can open the created game config by clicking `Edit game config`
- Edit `Gamelist.ini` by clicking the 3rd menu voice.
- `Gamelist.ini` contains the games for which GamepadToKeyboard will work. When an idgame is setted to `1` the game is active; when setted to `0` the game is not active and GamepadToKeyboard will not be launched.
- You can also decide to use a personal, external file ini by setting `UseCustomIni = 1` (manually in `Gamelist.ini`, or through the menu panel) and specifying  the config in `FileIni`
- In `QuickIniProfile.ini` you can edit a list of "favourite" configs that can be switched via `Quick ini profiles (all games)` voice menu with a click.

## Button assignments and controller info






The extension include the .exe in 64bit. The reason is that the x64 version of Autoit programs receive minor flag from av engines. If you need the x86 one you can dowload from the main in the repo, of from the attached file in release.
