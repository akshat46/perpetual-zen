local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local gears = require("gears")
local notify = require("naughty").notify

local GET_BAT_CAP = 'bash -c "cat /sys/class/power_supply/BAT0/capacity"'
local GET_BAT_CHR = 'bash -c "cat /sys/class/power_supply/ADP1/online"'
local charging = false

local battery_widget = {}

battery_widget.widget = wibox.widget({
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
      awful.spawn.easy_async_with_shell(GET_BAT_CHR, function(out)
        if tonumber(out) == 1 then
          battery_widget.widget.icon_widget.image = beautiful.battery_icon_charging
          charging = true
        else
          charging = false
        end
      end)
    end)
    awful.spawn.easy_async_with_shell(command, function()
      awful.spawn.easy_async_with_shell(GET_BAT_CAP, function(out)
        local cap = tonumber(out)
        local battery_icon
        if not charging then
          if cap < 25 then
              battery_icon = beautiful.battery_icon_low
              notify({
                title = "Low Battery",
                text = "bro charge your shit",
                icon = beautiful.battery_icon_low,
                icon_size = beautiful.notification_size_small.height-10,
                width = beautiful.notification_size_small.width,
                height = beautiful.notification_size_small.height,
              })
          elseif (cap < 60) then battery_icon=beautiful.battery_icon_med
          elseif (cap < 80) then battery_icon=beautiful.battery_icon_high
          elseif (cap <= 100) then battery_icon=beautiful.battery_icon_full
          end
          battery_widget.widget.icon_widget.image = battery_icon
        end
        battery_widget.widget.text_widget.text = cap .. "%"
      end)
    end)
    collectgarbage()
end

local widget_update = gears.timer{
  timeout = 10,
  call_now = false,
  callback = function()
    update()
  end
}

update()
widget_update:start()

collectgarbage("setpause", 100)
collectgarbage("setstepmul", 400)

battery_widget.toggle_checker = function(visible)
  if not visible then
    widget_update:stop()
  else
    update()
    widget_update:start()
  end
end

return battery_widget
