local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local popup_control = {}

popup_control.layout_popup_init = function(s)
    s.layoutPopup = awful.popup {
        widget = wibox.widget {
            id = "icon",
            image = beautiful.battery_icon_low,
            resize = true,
            widget = wibox.widget.imagebox,
            forced_height = 40,
        },
        border_color = '#777777',
        border_width = 2,
        ontop        = true,
        placement    = awful.placement.centered,
        shape        = gears.shape.rounded_rect
    }
    s.layoutPopup:setup{}
end

return popup_control
