
WolfgangHUDMenu = WolfgangHUDMenu or class(BLTMenu)

function WolfgangHUDMenu:Init(root, args)

	local next_menu_button_x = 0
	local next_menu_button_y = 122
	local menu_button_count = 0
	local index = 0

	self.enabled_req_maps = {}

	-- item create functions by type
	local create_item_handlers = {
		menu = function(menu_id, index, data)
			local id = string.format("%s_menubutton", data.menu_id)
			local clbk_id = data.clbk or (id .. "_clbk")
			self[clbk_id] = self[clbk_id] or function(self, value, item)
				managers.raid_menu:open_menu(data.menu_id)
			end
			local item = self:LongRoundedButton({
				index = index,
				name = id,
				text = data.name_id,
				localize = true,
				callback = callback(self, self, clbk_id),
				ignore_align = true,
				x = next_menu_button_x,
				y = next_menu_button_y,
				h = 50,
				w = 275,
			})
			if data.visible_reqs or data.enabled_reqs then
				self:_add_enabled_reqs(item, data)
			end
			next_menu_button_x = next_menu_button_x + item:w() + 10
			menu_button_count = menu_button_count + 1
			if menu_button_count == 6 then
				menu_button_count = 0
				next_menu_button_x = 0
				next_menu_button_y = next_menu_button_y + 70
			end
		end,
		slider = function(menu_id, index, data, value)
			local id = string.format("%s_%s_slider", menu_id, data.name_id)
			local clbk_id = id .. "_clbk"
			self[clbk_id] = function(self, value, item)
				self:_change_setting(clone(data.value), value)
			end
			local item = self:Slider({
				index = index,
				name = id,
				text = data.name_id,
				localize = true,
				callback = callback(self, self, clbk_id),
				value = value or 0,
				min = data.min_value,
				max = data.max_value,
				value_format = (data.value_format ~= nil and data.value_format or ("%." .. (data.decimal_places or 2) .. "f")),
				x_offset = data.x_offset or 0,
				y_offset = data.y_offset or 10,
			})
			if data.visible_reqs or data.enabled_reqs then
				self:_add_enabled_reqs(item, data)
			end
		end,
		toggle = function(menu_id, index, data, value)
			local id = string.format("%s_%s_toggle", menu_id, data.name_id)
			local clbk_id = id .. "_clbk"
			if data.invert_value then
				value = not value
			end
			self[clbk_id] = function(self, value, item)
				if data.invert_value then
					value = not value
				end
				self:_change_setting(clone(data.value), value)
			end
			local item = self:Toggle({
				index = index,
				name = id,
				text = data.name_id,
				localize = true,
				callback = callback(self, self, clbk_id),
				value = value,
				x_offset = data.x_offset or 0,
				y_offset = data.y_offset or 10,
			})
			if data.visible_reqs or data.enabled_reqs then
				self:_add_enabled_reqs(item, data)
			end
		end,
		multi_choice = function(menu_id, index, data, value)
			local id = string.format("%s_%s_multi", menu_id, data.name_id)
			local clbk_id = id .. "_clbk"
			local items = {}
			for value, text_id in pairs(data.options) do
				table.insert(items, {
					text = utf8.to_upper(managers.localization:text(text_id)),
					value = value,
				})
			end
			if data.add_color_options then
				for k, v in ipairs(WolfgangHUD:getTweakEntry("color_table", "table") or {}) do
					if data.add_rainbow or v.name ~= "rainbow" then
						local color_name = utf8.to_upper(managers.localization:text("wolfganghud_colors_" .. v.name))
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
					self:_change_setting(clone(data.value), value.value)
				end
				local item = self:MultiChoice({
					index = index,
					name = id,
					text = data.name_id,
					localize = true,
					callback = callback(self, self, clbk_id),
					value = value,
					items = items,
					x_offset = data.x_offset or 0,
					y_offset = data.y_offset or 10,
				})
				if data.visible_reqs or data.enabled_reqs then
					self:_add_enabled_reqs(item, data)
				end
			end
		end,
		input = function(menu_id, index, data)
			local id = string.format("%s_%s_input", menu_id, data.name_id)
			--[[
				local clbk_id = id .. "_clbk"

				MenuHelper:AddInput({
					id = id,
					title = data.name_id,
					desc = data.desc_id,
					value = tostring(data.value),
					callback = clbk_id,
					menu_id = menu_id,
					priority = index,
					disabled_color = Color(0.6, 0.6, 0.6),
					x_offset = data.x_offset or 0,
					y_offset = data.y_offset or 10,
				})

				MenuCallbackHandler[clbk_id] = function(self, item)
					self:_change_setting(clone(data.value), item:value())
				end

				if data.visible_reqs or data.enabled_reqs then
					self:_add_enabled_reqs(menu_id, id, data)
				end
			]]
			WolfgangHUD:print_log(string.format("%s TYPE NOT IMPLEMENTED YET", tostring(data.type), tostring(id), tostring(menu_id)), "error")
		end,
		button = function(menu_id, index, data)
			local id = string.format("%s_%s_button", menu_id, data.name_id)
			local clbk_id = data.clbk or (id .. "_clbk")
			self[clbk_id] = self[clbk_id] or function(self, value, item) end
			local item = self:MenuButton({
				index = index,
				name = id,
				text = data.name_id,
				localize = true,
				callback = callback(self, self, clbk_id),
				x_offset = data.x_offset or 0,
				y_offset = data.y_offset or 10,
			})
			if data.visible_reqs or data.enabled_reqs then
				self:_add_enabled_reqs(item, data)
			end
		end,
		keybind = function(menu_id, index, data)
			local item = self:KeyBind({
				index = index,
				keybind_id = data.keybind_id,
				text = utf8.to_upper(managers.localization:text(data.name_id)),
				x_offset = data.x_offset or 0,
				y_offset = data.y_offset or 10,
			})
			if data.visible_reqs or data.enabled_reqs then
				self:_add_enabled_reqs(item, data)
			end
		end,
		divider = function(menu_id, index, data)
			local id = string.format("%s_divider_%d", menu_id, index)
			self:Label({
				index = index,
				name = id,
				text = data.text_id,
				localize = data.text_id ~= nil,
				h = data.size or 12,
				x_offset = data.x_offset or 0,
				y_offset = data.y_offset or 10,
			})
		end,
		header = function(menu_id, index, data)
			local id = string.format("%s_header_%d", menu_id, index)
			self:SubTitle({
				index = index,
				name = id,
				text = data.text_id,
				localize = data.text_id ~= nil,
				h = data.size or 24,
				x_offset = data.x_offset or 0,
				y_offset = data.y_offset or 12,
			})
		end,
	}

	-- Populate title
	index = index + 1
	local title = self:Title({
		index = index,
		text = "wolfganghud_options_name",
		localize = true,
		ignore_align = true,
	})
	-- Populate header
	index = index + 1
	self:SubTitle({
		index = index,
		text = args.name_id,
		localize = args.name_id ~= nil,
		ignore_align = true,
		y = title:h()
	})
	-- Populate menu items
	local item_amount = #args.options
	for _, data in ipairs(args.options) do
		index = index + 1
		local value = data.value and WolfgangHUD:getSetting(data.value, nil)
		create_item_handlers[data.type](args.menu_id, index, data, value)
	end
	-- Populate reset button
	if args.is_root then -- only in main menu
		index = index + 1
		self:LongRoundedButton2({
			index = index,
			name = "wolfganghud_reset_options_button",
			text = "wolfganghud_reset_options_title",
			localize = true,
			callback = callback(self, self, "Reset"),
			ignore_align = true,
			y = 832,
			x = 1472,
		})
	end
end

function WolfgangHUDMenu:_check_enabled_reqs(req, value)
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

function WolfgangHUDMenu:_change_setting(setting, value, report)
	if report or WolfgangHUD:getSetting(setting, nil) ~= value and WolfgangHUD:setSetting(setting, value) then
		local key = WolfgangHUD:SafeTableConcat(setting, "->")
		WolfgangHUD:print_log(string.format("Change setting: %s = %s", key, tostring(value)), "info")
		local map = self.enabled_req_maps[key]
		if map ~= nil and type(map) == 'table' then
			for _, m in ipairs(map) do
				m.item:set_enabled(self:_check_enabled_reqs(m.req, value))
			end
		end
		WolfgangHUD.settings_changed = true
		local script = table.remove(setting, 1)
		if WolfgangHUD.apply_settings_clbk[script] then
			WolfgangHUD.apply_settings_clbk[script](setting, value)
		end
	end
end

function WolfgangHUDMenu:_add_enabled_reqs(item, data)
	local reqs = deep_clone(data.enabled_reqs or {})
	table.merge(reqs, deep_clone(data.visible_reqs or {}))
	for _, req in pairs(reqs) do
		local key = WolfgangHUD:SafeTableConcat(req.setting, "->")
		self.enabled_req_maps[key] = self.enabled_req_maps[key] or {}
		table.insert(self.enabled_req_maps[key], {item = item, req = req})
		local value = WolfgangHUD:getSetting(req.setting, nil)
		if value ~= nil then
			item:set_enabled(self:_check_enabled_reqs(req, value))
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
									self:_change_setting(deep_clone(setting), value, true)
								end
							end
							table.remove(setting, #setting)
						end
					end
					report_settings_changed(old_settings)
					self:ReloadMenu()
					--managers.viewport:resolution_changed() -- FIXME: causes crash when going back to main menu (raid-blt bug on every res change)
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
	local function create_menu(menu_table)
		for i, data in ipairs(menu_table) do
			if data.type == "menu" then
				-- Raid BLT needs unique classes for each menu, so lets create them using inheritance. without this, all menus would appear in all menus.
				local menu_class = "WolfgangHUDMenu_" .. data.menu_id
				_G[menu_class] = _G[menu_class] or class(WolfgangHUDMenu)
				-- create menu
				RaidMenuHelper:CreateMenu({
					name = data.menu_id,
					name_id = data.name_id,
					inject_menu = data.is_root and "blt_options" or nil,
					class = _G[menu_class],
					args = data,
				})
				-- create sub-menus
				create_menu(data.options)
			end
		end
	end
	-- create menus
	create_menu({WolfgangHUD.options_menu_data})
end)
