-- reference: https://github.com/streetturtle/awesome-wm-widgets/tree/master/volume-widget

local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

local GET_VOLUME_CMD = 'amixer -D pulse sget Master'

local volume_widget = {}

collectgarbage("setpause", 100)
collectgarbage("setstepmul", 400)

volume_widget.widget = wibox.widget({
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

local update = function()
    awful.spawn.easy_async_with_shell(command, function()
        awful.spawn.easy_async_with_shell(GET_VOLUME_CMD, function(out)
            local mute = string.match(out, "%[(o%D%D?)%]")
            local volume = string.match(out, "(%d?%d?%d)%%")
            volume = tonumber(string.format("% 3d", volume))
            local volume_icon_name
            if mute == "off" then volume_icon_name=beautiful.volume_icon_off
            elseif (volume >= 0 and volume < 5) then volume_icon_name=beautiful.volume_icon_mute
            elseif (volume < 20) then volume_icon_name=beautiful.volume_icon_low
            elseif (volume < 50) then volume_icon_name=beautiful.volume_icon_medium
            elseif (volume <= 100) then volume_icon_name=beautiful.volume_icon_high
            end
            volume_widget.widget.icon_widget.image = volume_icon_name
            volume_widget.widget.text_widget.text = volume .."dB"
            collectgarbage()
        end)
    end)
end

local widget_update = gears.timer{
    timeout = 5,
    call_now = false,
    callback = function()
        update()
    end
}

update()
widget_update:start()

volume_widget.toggle_checker = function(visible)
  if not visible then
    widget_update:stop()
  else
    update()
    widget_update:start()
  end
end

return volume_widget
