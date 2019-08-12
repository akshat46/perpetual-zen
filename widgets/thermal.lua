local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

local GET_TEMP_CMD = 'bash -c "cat /sys/class/hwmon/hwmon1/temp1_input"'

local thermal_widget = {}

thermal_widget.widget = wibox.widget({
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
          return text
        end,
        set_font = function(self, font)
            self.value.font = font
        end
    },
    layout = wibox.layout.fixed.horizontal,
    force_height = 20,
})

local init = true
local update = function()
    awful.spawn.easy_async_with_shell(command, function()
      awful.spawn.easy_async_with_shell(GET_TEMP_CMD, function(out)
          local temp = tonumber(out)
          if temp then
          temp = temp/1000
          thermal_widget.widget.text_widget.text = math.floor(temp).."°C"
          if init then
            thermal_widget.widget.icon_widget.image = beautiful.thermal_icon
            init = false
          end
        end
      end)
    end)
    collectgarbage()
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

thermal_widget.toggle_checker = function(visible)
  if not visible then
    widget_update:stop()
  else
    update()
    widget_update:start()
  end
end

return thermal_widget
