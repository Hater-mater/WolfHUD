if string.lower(RequiredScript) == "lib/managers/menumanager" then

    local create_controller_original = MenuManager.create_controller
    function MenuManager:create_controller(...)
        create_controller_original(self, ...)
        if self._is_start_menu then
            self:register_menu_new({
                input = "MenuInput",
                name = "mission_join_menu",
                renderer = "MenuRenderer",
                id = "mission_join_menu",
                content_file = "gamedata/raid/menus/mission_join_menu",
                callback_handler = MenuCallbackHandler:new(),
                config = {{
                    _meta = "menu",
                    id = "mission_join_menu",
                    {
                        _meta = "default_node",
                        name = "mission_join"
                    },
                    {
                        _meta = "node",
                        gui_class = "MenuNodeGuiRaid",
                        name = "mission_join",
                        topic_id = "menu_mission_join",
                        menu_components = "raid_menu_header raid_menu_footer raid_menu_mission_join",
                        node_background_width = 0.4,
                        node_padding = 30,
                        no_item_parent = false
                    }
                }}
            })
        end
    end

elseif string.lower(RequiredScript) == "lib/managers/menu/raid_menu/raidmainmenugui" then

    local _list_menu_data_source_original = RaidMainMenuGui._list_menu_data_source
    function RaidMainMenuGui:_list_menu_data_source(...)
        local _list_items = _list_menu_data_source_original(self, ...)
        if WolfgangHUD:getSetting({"MENU", "ADD_JOIN_MENU"}, true) then
            table.insert(_list_items, 5, {
                callback = "on_multiplayer_clicked",
                -- item_h = 72,
                -- item_font_size = 60,
                availability_flags = {RaidGUIItemAvailabilityFlag.IS_IN_MAIN_MENU,
                                      RaidGUIItemAvailabilityFlag.SHOULD_NOT_SHOW_TUTORIAL},
                text = utf8.to_upper(managers.localization:text("menu_servers"))
            })
        end
        if WolfgangHUD:getSetting({"MENU", "STREAMLINE"}, true) then
            for _, item in ipairs(_list_items) do
                item.item_font_size = nil
                item.item_h = nil
            end
        end
        return _list_items
    end

end
