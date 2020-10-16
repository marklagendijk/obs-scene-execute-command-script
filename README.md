# obs-scene-execute-command-script [![GitHub license](https://img.shields.io/github/license/marklagendijk/obs-scene-execute-command-script)](https://github.com/marklagendijk/obs-scene-execute-command-script/blob/master/LICENSE)
OBS script for executing any CLI command whenever whenever a scene is activated. Useful for:
- Loading a preset of any PTZ camera when an OBS scene is activated.
- Executing any command that does anything when an OBS scene is activated.

## Installation
1. Download the zip file or targz file [from Releases](https://github.com/marklagendijk/obs-scene-execute-command-script/releases/tag/1.0.0)
2. Extract the archive at a location where it can remain.
3. In OBS open `Tools` => `Scripts`.
4. Click `+` and select the `scene_execute_command.lua` file at the location where you extracted it.
5. The script appears under `Loaded scripts`. Click it.
6. You will see the script's description and settings.
7. Whenever you add / rename a scene, you will have to press the `Reload Scripts` button, before the script settings will show the settings for this new scene.

## Usage
1. Test the command you want to execute, by executing it on the command line.
2. See which part of the command would be different when you would execute it for the different scenes. 
3. Replace this variable part with `SCENE_VALUE` and enter the command in the `Command` setting.
4. Enable the checkboxes for all the scenes for which you want to execute a command when they are activated.
5. Enter the variable part for each scene.

## Quick examples
### Loading PTZ presets of a Lumens camera using curl
* `Command`: `curl http://192.168.178.61/cgi-bin/lums_configuration.cgi -H "Cookie: userName=admin; passWord=admin;" --data-raw "{\"cmd\":\"campresetrecall\",\"memnum\":\"SCENE_VALUE\"}"`
* `Scene1 value`: `1`
* `Scene2 value`: `2`

### Loading PTZ presets of a Sony camera using curl with Digest Authentication
* `Command`: `curl  http://192.168.1.160/command/presetposition.cgi?PresetCall=SCENE_VALUE --digest -u admin:password123`
* `Scene1 value`: `1`
* `Scene2 value`: `2`

### Loading PTZ presets of a camera with ONVIF support using onvif-ptz-cli
* `Command`: [onvif-ptz goto-preset --baseUrl=http://192.168.0.123 -u=admin -p=admin --preset=SCENE_VALUE`](https://github.com/marklagendijk/node-onvif-ptz-cli)
* `Scene1 value`: `1`
* `Scene2 value`: `2`

### Executing very different commands per scene
If you have very different commands for the different scenes you can use the following approach:
* `Command`: `SCENE_VALUE`
* `Scene1 value`: `do-something --arg=1`
* `Scene2 value`: `something-entirely-different --cow=horse`

## Guides
### Loading PTZ presets using curl
curl is a well-known cli-tool for executing any HTTP command. It is available for Linux, Windows and OSX.

Most PTZ cameras come with a web-application. In this web-application you can configure the camera, and often also control the PTZ features of the camera, like setting and loading presets.

1. Open the web-application of the camera with Firefox or Chrome.
2. Open the Developer Tools of the browser (right-click -> Inspect element).
3. Open the `Network` tab of the Developer Tools.
4. Load a preset via the web-application. 
5. You will see a new request appear in the list. Right-click on this new request and choose 'Copy as curl'
6. Move the camera to a different preset.
7. Open the command line and paste the command, and execute it. The camera should now move to the original preset.
8. If it works, paste the command in the `Command` setting of the script in OBS.
9. Find where it sets the preset. Replace the preset with `SCENE_VALUE`.
10. Enter the preset value for every scene, and enable the checkboxes.
11. Test it. When you have issues you can open the `Script Log`. The script will tell what commands it is executing.
12. ...
13. Profit!

### Loading PTZ presets of a camera with ONVIF support using onvif-ptz-cli
Many PTZ cameras have support for the ONVIF protocol. Since this is an old SOAP protocol you can't easily execute these commands with curl.

[onvif-ptz-cli](https://github.com/marklagendijk/node-onvif-ptz-cli) is a CLI tool that I created to be able to easily execute ONVIF commands from the command line. Together with the OBS Scene Execute Command you can easily execute ONVIF commands when an OBS scene is activated.

1. Install [onvif-ptz-cli](https://github.com/marklagendijk/node-onvif-ptz-cli).
2. On the command line, move the camera to a diferent preset using `onvif-ptz`. Something like: `onvif-ptz goto-preset --baseUrl=http://192.168.0.123 -u=admin -p=admin --preset=1`.
3. Copy the command and paste it in the `Command` setting of the script in OBS, and replace the preset with `SCENE_VALUE`. Something like: `onvif-ptz goto-preset --baseUrl=http://192.168.0.123 -u=admin -p=admin --preset=SCENE_VALUE`.
4. Enter the preset value for every scene, and enable the checkboxes.
5. Test it. When you have issues you can open the `Script Log`. The script will tell what commands it is executing.
6. ...
7. Profit!


## Contributors
* Geert Eikelboom (my brother-in-law)
  * Wrote the original script
  * Told me about OBS Scripts
  * Gave me the script to publish on GitHub
* [Mark Lagendijk](https://github.com/marklagendijk)
  * Generalized and improved the script
  * Wrote documenation
  * Published it [on GitHub](https://github.com/marklagendijk/obs-scene-execute-command-scrip) and [OBS Forums](https://obsproject.com/forum/resources/scene-execute-command.1028/)
