-- 
--
-- Geert M. Eikelboom, 2020
--

obs = obslua
config = {}
path = ""
local_settings = nil

function on_event(event)
	obs.script_log(obs.LOG_INFO, "info: Event " .. event);


	local scenes = obs.obs_frontend_get_scenes()
	-- Clear configuration table
	config = {}
	
	-- (Originally part of script_update) Add one configuration item per scene
	if scenes ~= nil then
		for _, scene in ipairs(scenes) do
			local name = obs.obs_source_get_name(scene)
			
			local s = {}
			s.name = "scene_" .. name
			s.value = obs.obs_data_get_int(local_settings, s.name)
			
			table.insert(config, s)
			
			obs.script_log(obs.LOG_INFO, "info: Added scene '" .. s.name .. "' (preset " .. s.value .. ")")
		end
	end
	obs.source_list_release(scenes)


	if event == obs.OBS_FRONTEND_EVENT_SCENE_CHANGED then
		local scene = obs.obs_frontend_get_current_scene()
		local scene_name = obs.obs_source_get_name(scene)
		
		if config ~= nil then
			for _, conf in ipairs(config) do
				if conf.name == "scene_" .. scene_name then
					-- Send command to camera
					obs.script_log(obs.LOG_INFO, "info: Detected switch to '" .. conf.name .. "' (preset " .. conf.value .. ")")
					
					obs.script_log(obs.LOG_INFO, path .. conf.value)
					
					result = os.execute(path .. conf.value)
				end
			end
		end

		obs.obs_source_release(scene);
	end
end

-- Defines the properties that the user
-- can change for the entire script module itself
function script_properties()
	local props = obs.obs_properties_create()

	obs.obs_properties_add_text(props, "path", "Command", obs.OBS_TEXT_DEFAULT)
	
	local scenes = obs.obs_frontend_get_scenes()
	
	if scenes ~= nil then
		for _, scene in ipairs(scenes) do
			local name = obs.obs_source_get_name(scene)
			
			local p = obs.obs_properties_add_int(props, "scene_" .. name, name, 0, 139, 1) -- Presets range from 0x00 - 0X8B
		end
	end
	
	obs.source_list_release(scenes)
	
	return props
end

-- The description shown to the user
function script_description()
	return "Configure camera zoom/focus preset numbers for each scene"
end

-- Will be called when settings are changed
function script_update(settings)
	
	path = obs.obs_data_get_string(settings, "path")
	obs.script_log(obs.LOG_INFO, "info: Path set to '" .. path .. "'")
	
	-- Moved settings processing to on_event, because list of scenes is not available on loading the plugin
	local_settings = settings
end

function script_load(settings)
	obs.obs_frontend_add_event_callback(on_event)
end
