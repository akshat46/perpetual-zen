-- https://github.com/streetturtle/awesome-wm-widgets/blob/master/cpu-widget/cpu-widget.lua

local watch = require("awful.widget.watch")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local color
local cpu_widget = {}

local cpugraph_widget = wibox.widget {
    max_value = 150,
    background_color = "#00000000",
    forced_width = dpi(360),
    height = dpi(30),
    step_width = 4,
    step_spacing = 0,
    widget = wibox.widget.graph,
    color = "linear:0,0:0,22:0,#FF0000:0.3,#FFFF00:0.5,#FFFFFF"
}

--- By default graph widget goes from left to right, so we mirror it and push up a bit
cpu_widget.widget = wibox.container.margin(wibox.container.mirror(cpugraph_widget, { horizontal = true }), 0, 0, 0, 2)

local total_prev = 0
local idle_prev = 0

watch([[bash -c "cat /proc/stat | grep '^cpu '"]], 1,
    function(widget, stdout)
        local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
        stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

        local total = user + nice + system + idle + iowait + irq + softirq + steal

        local diff_idle = idle - idle_prev
        local diff_total = total - total_prev
        local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

        widget:add_value(diff_usage)

        total_prev = total
        idle_prev = idle
    end,
    cpugraph_widget
)

cpu_widget.setColor = function(c)
    color = c
end

return cpu_widget
