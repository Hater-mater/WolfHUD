
WolfgangHUDMenu = WolfgangHUDMenu or class(BLTMenu)

local function check_enabled_reqs(req, value)
	if type(req) == "table" then
		if req.equal then
			if value ~= req.equal then
				return false
			end
		elseif type(value) == "boolean" then
			local b = req.invert and true or false
			if value == b then
				return false
			end
		elseif type(value) == "number" then
			local min_value = req.min or value
			local max_value = req.max or value
			if value < min_value or value > max_value then
				return false
			end
		end
	elseif type(req) == "boolean" then
		return req
	end
	return true
end

-- Called on setting change
local function change_setting(setting, value, report)
	if report or WolfgangHUD:getSetting(setting, nil) ~= value and WolfgangHUD:setSetting(setting, value) then
		local key = WolfgangHUD:SafeTableConcat(setting, "->")
		WolfgangHUD:print_log(string.format("Change setting: %s = %s", key, tostring(value)), "info")
		local map = WolfgangHUD.enabled_req_maps[key]
		if map ~= nil and type(map) == 'table' then
			for _, m in ipairs(map) do
				m.item:set_enabled(check_enabled_reqs(m.req, value))
			end
		end
		WolfgangHUD.settings_changed = true
		local script = table.remove(setting, 1)
		if WolfgangHUD.apply_settings_clbk[script] then
			WolfgangHUD.apply_settings_clbk[script](setting, value)
		end
	end
end

local function add_enabled_reqs(item, data)
	local reqs = deep_clone(data.enabled_reqs or {})
	table.merge(reqs, deep_clone(data.visible_reqs or {}))
	for _, req in pairs(reqs) do
		local key = WolfgangHUD:SafeTableConcat(req.setting, "->")
		WolfgangHUD.enabled_req_maps[key] = WolfgangHUD.enabled_req_maps[key] or {}
		table.insert(WolfgangHUD.enabled_req_maps[key], {item = item, req = req})
		local value = WolfgangHUD:getSetting(req.setting, nil)
		if value ~= nil then
			item:set_enabled(check_enabled_reqs(req, value))
		end
	end
end

function WolfgangHUDMenu:Init(root, args)

	WolfgangHUD.enabled_req_maps = {} -- reset

	-- item create functions by type
	local create_item_handlers = {
		slider = function(menu_id, offset, data, value)
			--[[
				local id = string.format("%s_%s_slider", menu_id, data.name_id)
				local clbk_id = id .. "_clbk"

				MenuHelper:AddSlider({
					id = id,
					title = data.name_id,
					desc = data.desc_id,
					callback = string.format("%s %s", clbk_id, update_visible_clbks),
					value = value or 0,
					min = data.min_value,
					max = data.max_value,
					step = data.step_size,
					show_value = true,
					menu_id = menu_id,
					priority = offset,
					disabled_color = Color(0.6, 0.6, 0.6),
				})

				--Value changed callback
				MenuCallbackHandler[clbk_id] = function(self, item)
					change_setting(clone(data.value), item:value())
				end

				if data.visible_reqs or data.enabled_reqs then
					add_visible_reqs(menu_id, id, data)
				end
			]]
			WolfgangHUD:print_log(string.format("%s TYPE NOT IMPLEMENTED YET", tostring(data.type), tostring(id), tostring(menu_id)), "error")
		end,
		toggle = function(menu_id, offset, data, value)
			local id = string.format("%s_%s_toggle", menu_id, data.name_id)
			local clbk_id = id .. "_clbk"
			if data.invert_value then
				value = not value
			end
			self[clbk_id] = function(self, value, item)
				if data.invert_value then
					value = not value
				end
				change_setting(clone(data.value), value)
			end
			local item = self:Toggle({
				name = id,
				text = data.name_id,
				localize = true,
				callback = callback(self, self, clbk_id),
				value = value,
			})
			if data.visible_reqs or data.enabled_reqs then
				add_enabled_reqs(item, data)
			end
		end,
		multi_choice = function(menu_id, offset, data, value)
			local id = string.format("%s_%s_multi", menu_id, data.name_id)
			local clbk_id = id .. "_clbk"
			local items = {}
			for value, text_id in pairs(data.options) do
				table.insert(items, {
					text = managers.localization:text(text_id),
					value = value,
				})
			end
			if data.add_color_options then
				for k, v in ipairs(WolfgangHUD:getTweakEntry("color_table", "table") or {}) do
					if data.add_rainbow or v.name ~= "rainbow" then
						local color_name = managers.localization:text("wolfganghud_colors_" .. v.name)
						color_name = not color_name:lower():find("error") and color_name or string.upper(v.name)
						table.insert(items, {
							text = color_name,
							value = v.name,
						})
					end
				end
			end
			if table.size(items) > 0 then
				self[clbk_id] = function(self, value, item)
					change_setting(clone(data.value), value)
				end
				local item = self:MultiChoice({
					name = id,
					text = data.name_id,
					localize = true,
					callback = callback(self, self, clbk_id),
					value = value,
					items = items,
				})
				if data.visible_reqs or data.enabled_reqs then
					add_enabled_reqs(item, data)
				end
			end
		end,
		input = function(menu_id, offset, data)
			--[[
				local id = string.format("%s_%s_input", menu_id, data.name_id)
				local clbk_id = id .. "_clbk"

				MenuHelper:AddInput({
					id = id,
					title = data.name_id,
					desc = data.desc_id,
					value = tostring(data.value),
					callback = clbk_id,
					menu_id = menu_id,
					priority = offset,
					disabled_color = Color(0.6, 0.6, 0.6),
				})

				MenuCallbackHandler[clbk_id] = function(self, item)
					change_setting(clone(data.value), item:value())
				end

				if data.visible_reqs or data.enabled_reqs then
					add_visible_reqs(menu_id, id, data)
				end
			]]
			WolfgangHUD:print_log(string.format("%s TYPE NOT IMPLEMENTED YET", tostring(data.type), tostring(id), tostring(menu_id)), "error")
		end,
		button = function(menu_id, offset, data)
			local id = string.format("%s_%s_button", menu_id, data.name_id)
			local clbk_id = data.clbk or (id .. "_clbk")
			self[clbk_id] = self[clbk_id] or function(self, value, item) end
			local item = self:Button({
				name = id,
				text = data.name_id,
				localize = true,
				callback = callback(self, self, clbk_id),
			})
			if data.visible_reqs or data.enabled_reqs then
				add_enabled_reqs(item, data)
			end
		end,
		keybind = function(menu_id, offset, data)
			--[[
				local id = string.format("%s_%s_keybind", menu_id, data.name_id)
				local clbk_id = data.clbk or (id .. "_clbk")

				MenuHelper:AddKeybinding({
					id = id,
					title = data.name_id,
					desc = data.desc_id,
					connection_name = "",
					binding = "",
					button = "",
					callback = clbk_id,
					menu_id = menu_id,
					priority = offset,
					--disabled_color = Color(0.6, 0.6, 0.6),
				})

				MenuCallbackHandler[clbk_id] = MenuCallbackHandler[clbk_id] or function(self, item)

				end

				if data.visible_reqs or data.enabled_reqs then
					add_visible_reqs(menu_id, id, data)
				end
			]]
			WolfgangHUD:print_log(string.format("%s TYPE NOT IMPLEMENTED YET", tostring(data.type), tostring(id), tostring(menu_id)), "error")
		end,
		divider = function(menu_id, offset, data)
			local id = string.format("%s_divider_%d", menu_id, offset)
			self:Label({
				name = id,
				text = data.text_id,
				localize = data.text_id ~= nil,
				h = data.size or 8,
			})
		end,
	}

	-- Populate menu items
	local item_amount = #args.options
	for i, data in ipairs(args.options) do
		local value = data.value and WolfgangHUD:getSetting(data.value, nil)
		local type = data.type
		local menu_id = data.parent_id or args.menu_id
		if type ~= "menu" then
			create_item_handlers[type](menu_id, item_amount - i, data, value)
		end
	end
end

function WolfgangHUDMenu:Reset(value, item)
	QuickMenu:new(
		managers.localization:text("wolfganghud_reset_options_title"),
		managers.localization:text("wolfganghud_reset_options_confirm"),
		{
			[1] = {
				text = managers.localization:text("dialog_no"),
				is_cancel_button = true,
			},
			[2] = {
				text = managers.localization:text("dialog_yes"),
				callback = function()
					local old_settings = deep_clone(WolfgangHUD.settings)
					WolfgangHUD:Reset()
					local function report_settings_changed(old_settings, setting)
						setting = setting or {}
						for key, old_value in pairs(old_settings or {}) do
							table.insert(setting, key)
							if type(old_value) == "table" then
								report_settings_changed(old_value, setting)
							else
								local value = WolfgangHUD:getSetting(setting, nil)
								if value ~= nil and value ~= old_value then
									change_setting(deep_clone(setting), value, true)
								end
							end
							table.remove(setting, #setting)
						end
					end
					report_settings_changed(old_settings)
					self:ReloadMenu()
					managers.viewport:resolution_changed()
					WolfgangHUD:print_log("Settings reset!", "info")
				end,
			},
		},
		true
	)
end

function WolfgangHUDMenu:Close()
	if WolfgangHUD.settings_changed then
		WolfgangHUD.settings_changed = nil
		WolfgangHUD:Save()
		WolfgangHUD:print_log("Settings saved!", "info")
	end
end

Hooks:Add("MenuComponentManagerInitialize", "MenuComponentManagerInitialize_WolfgangHUD", function(menu_manager)
	local function create_menu(menu_table, parent_id)
		for i, data in ipairs(menu_table) do
			if data.type == "menu" then
				-- Raid BLT needs unique classes for each menu, so lets create them using inheritance. without this, all menus would appear in all menus.
				local menu_class = "WolfgangHUDMenu_" .. data.menu_id
				_G[menu_class] = _G[menu_class] or class(WolfgangHUDMenu)
				-- create menu
				RaidMenuHelper:CreateMenu({
					name = data.menu_id,
					name_id = data.name_id,
					inject_menu = parent_id,
					class = _G[menu_class],
					args = data,
				})
				-- create sub-menus
				create_menu(data.options, data.menu_id)
			end
		end
	end
	-- create menus recursively
	create_menu({WolfgangHUD.options_menu_data}, "blt_options")
end)
