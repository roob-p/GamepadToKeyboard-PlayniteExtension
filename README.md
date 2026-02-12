 # 🎮 GamepadToKeyboard-PlayniteExtension
🕹️ *Emulate keyboard and mouse input with your gamepad in a quick, easy and very customizable manner.*

- This extension lets use send mouse and keyboard inputs so you can use the controller in games without pad support, or where some controller buttons (in particular LT and RT) does not work (for example `Legacy of Kain: Defiance` and `Assassin's Creed`).   
***This can be very usel in old games without xinput support.***
- The program is very easy to use and configure: just edit the button assignments in the associated game ini file and the application will be started automatically after launching the game. 
- You can create a config per game or use a global config for all games.
- Add the config to use in `gamelist.ini` or change it via menu panels.
- You can Explore and choose the file trough `Select custom ini file (all games)`
- Or edit a list (`QuickIniProfile.ini`) adding your "favorite" configs that you'll can switch via `Quick ini profiles (all gamea)` quick a click.


## ⚙️ How it works 
- Activate a game with the 2nd menu voice, and it be will be added in `Gamelist.ini` (with it's name, id, platform and/or source). An assignment config (gameid.ini) for that game will be created.
- You can open the created game config by clicking `Edit game config`
- Edit `Gamelist.ini` by clicking the 3rd menu voice.
- `Gamelist.ini` contains the games for which GamepadToKeyboard will work. When an idgame is setted to `1` the game is active; when setted to `0` the game is not active and GamepadToKeyboard will not be launched. 





The extension include the .exe in 64bit. The reason is that the x64 version of Autoit programs receive minor flag from av engines. If you need the x86 one you can dowload from the main in the repo, of from the attached file in release.
