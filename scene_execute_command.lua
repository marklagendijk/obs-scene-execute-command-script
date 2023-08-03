-- MIT License
--
-- Copyright (c) Geert Eikelboom, Mark Lagendijk
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--
-- Original script by Geert Eikelboom
-- Generalized and released on GitHub (with permission of Geert) by Mark Lagendijk

obs = obslua
settings = {}

-- Script hook for defining the script description
function script_description()
	return [[
Execute a CLI command whenever a scene is activated.

When specifying the command 'SCENE_VALUE' can be used to denote the 'value' that was entered for the scene.

Example:
When command is
    curl -X POST http://192.168.1.123/load-preset -d "preset=SCENE_VALUE"

And Scene 1 value is
    5

Activating Scene 1 would execute:
    curl -X POST http://192.168.1.123/load-preset -d "preset=5"

See https://github.com/marklagendijk/obs-scene-execute-command-script/ for further documentation and examples.
]]
end

-- Script hook for defining the settings that can be configured for the script
function script_properties()
	local props = obs.obs_properties_create()

	obs.obs_properties_add_bool(props, "log_command_output", "Log the command output in script log")
	obs.obs_properties_add_text(props, "command", "Command", obs.OBS_TEXT_DEFAULT)
	
	local scenes = obs.obs_frontend_get_scenes()
	
	if scenes ~= nil then
		for _, scene in ipairs(scenes) do
			local scene_name = obs.obs_source_get_name(scene)
			obs.obs_properties_add_bool(props, "scene_enabled_" .. scene_name, "Execute when '" .. scene_name .. "' is activated")
			obs.obs_properties_add_text(props, "scene_value_" .. scene_name, scene_name .. " value", obs.OBS_TEXT_DEFAULT)
		end
	end
	
	obs.source_list_release(scenes)
	
	return props
end

-- Script hook that is called whenver the script settings change
function script_update(_settings)	
	settings = _settings
end

-- Script hook that is called when the script is loaded
function script_load(settings)
	obs.obs_frontend_add_event_callback(handle_event)
end

function handle_event(event)
	if event == obs.OBS_FRONTEND_EVENT_SCENE_CHANGED then
		handle_scene_change()	
	end
end

function handle_scene_change()
	local scene = obs.obs_frontend_get_current_scene()
	local scene_name = obs.obs_source_get_name(scene)
	local scene_enabled = obs.obs_data_get_bool(settings, "scene_enabled_" .. scene_name)
	local log_command_output = obs.obs_data_get_bool(settings, "log_command_output")

	if scene_enabled then
		local command = obs.obs_data_get_string(settings, "command")
		local scene_value = obs.obs_data_get_string(settings, "scene_value_" .. scene_name)
		local scene_command = string.gsub(command, "SCENE_VALUE", scene_value)
		obs.script_log(obs.LOG_INFO, "Activating " .. scene_name .. ". Executing command:\n  " .. scene_command)

  local command_output = execute_command(scene_command)
		
		if log_command_output then
			obs.script_log(obs.LOG_INFO, "Command output: " .. command_output)
		end
	else
		obs.script_log(obs.LOG_INFO, "Activating " .. scene_name .. ". Command execution is disabled for this scene.")
	end
	obs.obs_source_release(scene);
end

function execute_command(command)
	local handle = io.popen(command, 'r')
	local command_output = handle:read('*all')
	handle:close()

	return command_output
end
