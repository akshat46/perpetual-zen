local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local naughty = require("naughty")

local GET_NET_LVL = "awk 'NR==3 {printf \"%3.0f\" ,($3/70)*100}' /proc/net/wireless"

local wifi_widget = wibox.widget({
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

local update_graphic = function(widget,stdout, _, _, _)
  local level = tonumber(stdout)
  local wifi_icon
  if not level ~= nil then
    if level < 15 then wifi_icon=beautiful.wifi_icon_low
    elseif (level < 60) then wifi_icon=beautiful.wifi_icon_med
    elseif (level <= 100) then wifi_icon=beautiful.wifi_icon_high
    end
    widget.icon_widget.image = wifi_icon
  else
    widget.icon_widget.image = beautiful.wifi_icon_disconnected
  end
  widget.text_widget.text = level .. "%"
end

watch(GET_NET_LVL, 30, update_graphic, wifi_widget)

return wifi_widget
