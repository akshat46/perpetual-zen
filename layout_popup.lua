local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local popup_control = {}

popup_control.layout_popup_init = function(s)
    s.layoutPopup = awful.popup {
    widget = {
        {
            {
                text   = 'foobar',
                widget = wibox.widget.textbox
            },
            {
                {
                    text   = 'foobar',
                    widget = wibox.widget.textbox
                },
                bg     = '#ff00ff',
                clip   = true,
                shape  = gears.shape.rounded_bar,
                widget = wibox.widget.background
            },
            {
                value         = 0.5,
                forced_height = 30,
                forced_width  = 100,
                widget        = wibox.widget.progressbar
            },
            layout = wibox.layout.fixed.vertical,
        },
        margins = 10,
        widget  = wibox.container.margin
    },
    border_color = '#00ff00',
    border_width = 5,
    placement    = awful.placement.top_left,
    shape        = gears.shape.rounded_rect,
    visible      = true,
    }
    --s.layoutPopup:setup{}
end

return popup_control
