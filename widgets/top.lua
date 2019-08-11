local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("utils")
local gears = require("gears")
local utils = require("utils")
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local top = {}
local term
local options = {}
local CMD = " -hold -e \'gotop-cjbassi\'"
local visible = false
local pid

collectgarbage("setpause", 100)
collectgarbage("setstepmul", 400)

local properties = {}

top.init = function(terminal, o, fallback)
    fallback = fallback or false
    o = o or {}
    term = terminal or "urxvt"
    TOP_CMD = term .. CMD
    options = o
    local workarea = awful.screen.focused().workarea
    local w = o.width or dpi(720)
    local h = o.height or dpi(950)
    local left_margin = o.left_margin or dpi(-5)
    properties = {
        floating = true,
        sticky = true,
        ontop = true,
        focus = true,
        focusable = false,
        requests_no_titlebar = true,
        width = w,
        x = left_margin,
        y = o.y or 300,
        height = h,
    }
    collectgarbage()
end

top.toggle = function(c)
    if visible then
        awful.spawn("kill "..pid)
    else
        pid = awful.spawn(TOP_CMD, properties)
    end
    visible = not visible
    collectgarbage()
end

return top
