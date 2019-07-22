local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local button_size = 50

local spotify_widget = {}

spotify_widget.toggle_button = wibox.widget({
    image = beautiful.play_button_icon,
    widget = wibox.widget.imagebox,
    forced_height = button_size,
    forced_width = button_size,
})

spotify_widget.prev_button = wibox.widget({
    image = beautiful.prev_button_icon,
    widget = wibox.widget.imagebox,
    forced_height = button_size,
    forced_width = button_size,
})

-- local spotify_widget = ({
--     -- {
--     --     prev_button,
--     --     toggle_button,
--     --     --next_button,
--     --     layout = wibox.layout.fixed.horizontal,
--     -- },
--     -- halign = "center",
--     -- layout = wibox.container.place,
--     prev_button,
--     toggle_button,
--     -- --next_button,
--     layout = wibox.layout.fixed.horizontal,
-- })

return spotify_widget
