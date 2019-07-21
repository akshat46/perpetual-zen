local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")

local GET_BAT_CAP = 'bash -c "cat /sys/class/power_supply/BAT0/capacity"'
local GET_BAT_CHR = 'bash -c "cat /sys/class/power_supply/ADP1/online"'
local charging = false

local battery_widget = wibox.widget({
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
  local cap = tonumber(stdout)
  local battery_icon
  if not charging then
    if cap < 25 then battery_icon=beautiful.battery_icon_low
    elseif (cap < 60) then battery_icon=beautiful.battery_icon_med
    elseif (cap < 80) then battery_icon=beautiful.battery_icon_high
    elseif (cap <= 100) then battery_icon=beautiful.battery_icon_full
    end
    widget.icon_widget.image = battery_icon
  end
  widget.text_widget.text = cap .. "%"
end

local update_charging = function(widget, stdout, _, _, _)
  if tonumber(stdout) == 1 then
    widget.icon_widget.image = beautiful.battery_icon_charging
    charging = true
  else
    charging = false
  end
end

watch(GET_BAT_CAP, 5, update_graphic, battery_widget)
watch(GET_BAT_CHR, 2, update_charging, battery_widget)

return battery_widget
