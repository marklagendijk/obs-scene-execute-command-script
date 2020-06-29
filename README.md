# obs-scene-execute-command-script
OBS script for executing any CLI command whenever whenever a scene is activated. Useful for:
- Loading a preset of any PTZ camera when an OBS scene is activated/
- Executing any command that does anything when an OBS scene is activated.

## Installation
1. Download the zip file or targz file [from Releases](https://github.com/marklagendijk/obs-scene-execute-command-script/releases/tag/1.0.0)
2. Extract the archive at a location where it can remain.
3. In OBS open `Tools` => `Scripts`.
4. Click `+` and select the `scene_execute_command.lua` file at the location where you extracted it.
5. The script appears under `Loaded scripts`. Click it.
6. You will see the script's description and settings.

## Usage
1. Test the command you want to execute, by executing it on the command line.
2. See which part of the command would be different when you would execute it for the different scenes. 
3. Replace this variable part with `SCENE_VALUE` and enter the command in the `Command` setting.
4. Enable the checkboxes for all the scenes for which you want to execute a command when they are activated.
5. Enter the variable part for each scene.
