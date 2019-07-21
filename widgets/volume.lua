-- reference: https://github.com/streetturtle/awesome-wm-widgets/tree/master/volume-widget

local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")

local GET_VOLUME_CMD = 'amixer -D pulse sget Master'
local INC_VOLUME_CMD = 'amixer -D pulse sset Master 5%+'
local DEC_VOLUME_CMD = 'amixer -D pulse sset Master 5%-'
local TOG_VOLUME_CMD = 'amixer -D pulse sset Master toggle'

local volume_widget = wibox.widget({
    {
        id = "icon_widget",
        {
            id = "icon",
            image = beautiful.volume_icon_mute,
            resize = true,
            widget = wibox.widget.imagebox,
            forced_height = 40,
        },
        layout = wibox.container.margin,
        set_image = function(self, path)
            self.icon.image = path
        end,
    },
    {
        id = "text_widget",
        {
            id = "value",
            text = "**",
            widget = wibox.widget.textbox,
        },
        layout = wibox.container.margin,
        set_text = function(self, text)
            self.value.text = text
        end,
        set_font = function(self, font)
            self.value.font = font
        end
    },
    layout = wibox.layout.fixed.horizontal,
})

local update_graphic = function(widget, stdout, _, _, _)
    local mute = string.match(stdout, "%[(o%D%D?)%]")
    local volume = string.match(stdout, "(%d?%d?%d)%%")
    volume = tonumber(string.format("% 3d", volume))
    local volume_icon_name
    if mute == "off" then volume_icon_name=beautiful.volume_icon_off
    elseif (volume >= 0 and volume < 5) then volume_icon_name=beautiful.volume_icon_mute
    elseif (volume < 20) then volume_icon_name=beautiful.volume_icon_low
    elseif (volume < 50) then volume_icon_name=beautiful.volume_icon_medium
    elseif (volume <= 100) then volume_icon_name=beautiful.volume_icon_high
    end
    widget.icon_widget.image = volume_icon_name
    widget.text_widget.text = volume .."dB"
end

--[[ allows control volume level by:
- clicking on the widget to mute/unmute
- scrolling when cursor is over the widget
]]
volume_widget:connect_signal("button::press", function(_,_,_,button)
    if (button == 4)     then awful.spawn(INC_VOLUME_CMD, false)
    elseif (button == 5) then awful.spawn(DEC_VOLUME_CMD, false)
    elseif (button == 1) then awful.spawn(TOG_VOLUME_CMD, false)
    end

    spawn.easy_async(GET_VOLUME_CMD, function(stdout, stderr, exitreason, exitcode)
        update_graphic(volume_widget, stdout, stderr, exitreason, exitcode)
    end)
end)

watch(GET_VOLUME_CMD, 5, update_graphic, volume_widget)

return volume_widget
