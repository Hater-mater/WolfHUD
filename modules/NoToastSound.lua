local _animate_present_original = HUDToastNotification._animate_present

function HUDToastNotification:_animate_present(panel, duration, ...)
    if not (WolfgangHUD and WolfgangHUD:getSetting({ "SOUND", "MUTE_TOASTS" }, false)) then
        _animate_present_original(self, panel, duration, ...)
        return
    end

    -- sadly we must copy the entire func, as the sound calls are inline

    local x_travel = 60
    local fade_in_duration = duration * 0.1
    local sustain_duration = duration * 0.6
    local fade_out_duration = duration * 0.1
    local fade_in_distance = x_travel * 0.38
    local sustain_distance = x_travel * 0.24
    local fade_out_distance = x_travel * 0.38
    local t = 0

    self._background:set_alpha(0)
    self._text:set_alpha(0)
    self._object:set_center_x(self._object:parent():w() / 2 + x_travel / 2)
    self._text:set_center_x(self._object:w() / 2 - x_travel / 2)

    while t < fade_in_duration do
        local dt = coroutine.yield()

        t = t + dt

        local current_alpha = Easing.quadratic_in_out(math.clamp(t - 0.2, 0, fade_in_duration * 0.8), 0, 1,
            fade_in_duration * 0.8)

        self._background:set_alpha(current_alpha)
        self._text:set_alpha(current_alpha)

        local current_offset = Easing.quartic_in_out(t, x_travel / 2, -fade_in_distance, fade_in_duration)

        self._object:set_center_x(self._object:parent():w() / 2 + current_offset)
        self._text:set_center_x(self._object:w() / 2 - x_travel / 2 - current_offset * 2)
    end

    self._background:set_alpha(1)
    self._text:set_alpha(1)

    t = 0

    while t < sustain_duration do
        local dt = coroutine.yield()

        t = t + dt

        local current_offset = Easing.linear(t, x_travel / 2 - fade_in_distance, -sustain_distance, sustain_duration)

        self._object:set_center_x(self._object:parent():w() / 2 + current_offset)
        self._text:set_center_x(self._object:w() / 2 - x_travel / 2 - current_offset * 2)
    end

    t = 0

    while t < fade_out_duration do
        local dt = coroutine.yield()

        t = t + dt

        local current_alpha = Easing.quadratic_in_out(t, 1, -1, fade_out_duration * 0.8)

        self._background:set_alpha(current_alpha)
        self._text:set_alpha(current_alpha)

        local current_offset = Easing.quartic_in_out(t, x_travel / 2 - fade_in_distance - sustain_distance,
            -fade_out_distance, fade_out_duration)

        self._object:set_center_x(self._object:parent():w() / 2 + current_offset)
        self._text:set_center_x(self._object:w() / 2 - x_travel / 2 - current_offset * 2)
    end

    self._background:set_alpha(0)
    self._text:set_alpha(0)
    self._object:set_center_x(self._object:parent():w() / 2)
    self._text:set_center_x(self._object:w() / 2)
    self:_present_done()
end
