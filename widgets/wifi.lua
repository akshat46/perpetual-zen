local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")

local GET_NET_LVL = "awk 'NR==3 {printf \"%3.0f\" ,($3/70)*100}' /proc/net/wireless"

local wifi_widget = {}

wifi_widget.widget = wibox.widget({
    {
        id = "icon_widget",
        {
            id = "icon",
            image = beautiful.battery_icon_low,
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
    force_height = 20,
})


local update = function()
  awful.spawn.easy_async_with_shell(command, function()
    awful.spawn.easy_async_with_shell(GET_NET_LVL, function(out)
      local level = tonumber(out)
      local wifi_icon
      if level ~= nil then
        if level < 15 then wifi_icon=beautiful.wifi_icon_low
        elseif (level < 60) then wifi_icon=beautiful.wifi_icon_med
        elseif (level <= 100) then wifi_icon=beautiful.wifi_icon_high
        end
        wifi_widget.widget.icon_widget.image = wifi_icon
      else
        wifi_widget.widget.icon_widget.image = beautiful.wifi_icon_disconnected
      end
      wifi_widget.widget.text_widget.text = level .. "%"
      collectgarbage()
    end)
  end)
end

local widget_update = gears.timer{
    timeout = 30,
    call_now = false,
    callback = function()
      update()
    end
}

update()
widget_update:start()

collectgarbage("setpause", 100)
collectgarbage("setstepmul", 400)

wifi_widget.toggle_checker = function(visible)
  if not visible then
    widget_update:stop()
  else
    update()
    widget_update:start()
  end
end

return wifi_widget
