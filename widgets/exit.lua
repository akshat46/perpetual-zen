
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("utils")
local pad = utils.pad_height
local keygrabber = require("awful.keygrabber")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local custom_themes_path = require("gears.filesystem").get_configuration_dir()

-- Appearance
local icon_size = beautiful.exit_screen_icon_size or dpi(80)
local text_font = beautiful.font or "sans 14"

local exit = {}

-- Commands
local poweroff_command = function()
  awful.spawn.with_shell("poweroff")
end
local reboot_command = function()
  awful.spawn.with_shell("reboot")
end
local suspend_command = function()
  awful.spawn.with_shell("systemctl suspend")
  -- awful.spawn.with_shell("i3lock & systemctl suspend")
  exit_screen_hide()
end
local exit_command = function()
  awesome.quit()
end
local lock_command = function()
  awful.spawn.with_shell("i3lock")
  exit_screen_hide()
end

local button_size = dpi(80)

local poweroff_button = wibox.widget({
    forced_width = button_size,
    forced_height = button_size,
    visible = true,
    resize = true,
    widget = wibox.widget.imagebox,

})

exit.init_exit_banner = function(s)
    local workarea = awful.screen.focused().workarea
    local size = dpi(500)
    s.exitScreenBanner = wibox{
        screen = s,
        visible = true,
        width = size,
        height = size/2,
        bg = beautiful.normal,
        shape = utils.rrect(beautiful.border_radius),
        ontop = true,
        -- x = (workarea.width-size)/2,
        -- y = (workarea.height-size)/2,
    }

    -- s.exitScreenBanner:setup{
    -- }
end

return exit
