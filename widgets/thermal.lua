local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")

local GET_TEMP_CMD = 'bash -c "cat /sys/class/hwmon/hwmon1/temp1_input"'

local thermal_widget = wibox.widget({
    {
        id = "icon_widget",
        {
            id = "icon",
            image = beautiful.thermal_icon,
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
  local temp = stdout
  temp = temp/1000
  widget.text_widget.text = math.floor(temp).."°C"
  if temp > 60 then
    widget.icon_widget.image = beautiful.thermal_icon_alert
  else
    widget.icon_widget.image = beautiful.thermal_icon
  end
end

watch(GET_TEMP_CMD, 60, update_graphic, thermal_widget)

return thermal_widget
