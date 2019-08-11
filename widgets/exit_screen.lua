-- reference: https://github.com/elenapan/dotfiles/blob/master/config/awesome/noodle/exit_screen.lua

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


collectgarbage("setpause", 100)
collectgarbage("setstepmul", 400)

local poweroff_icon = wibox.widget.imagebox(custom_themes_path.."icons/poweroff.png")
poweroff_icon.resize = true
poweroff_icon.forced_width = icon_size
poweroff_icon.forced_height = icon_size
local poweroff_text = wibox.widget.textbox("Poweroff")
poweroff_text.font = text_font

local poweroff = wibox.widget{
  {
    nil,
    poweroff_icon,
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  {
    pad(1),
    poweroff_text,
    pad(1),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  -- forced_width = 100,
  layout = wibox.layout.fixed.vertical
}
poweroff:buttons(gears.table.join(
                 awful.button({ }, 1, function ()
                     poweroff_command()
                 end)
))

local reboot_icon = wibox.widget.imagebox(custom_themes_path.."icons/restart.png")
reboot_icon.resize = true
reboot_icon.forced_width = icon_size
reboot_icon.forced_height = icon_size
local reboot_text = wibox.widget.textbox("Reboot")
reboot_text.font = text_font

local reboot = wibox.widget{
  {
    nil,
    reboot_icon,
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  {
    nil,
    reboot_text,
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  -- forced_width = 100,
  layout = wibox.layout.fixed.vertical
}
reboot:buttons(gears.table.join(
                   awful.button({ }, 1, function ()
                       reboot_command()
                   end)
))

-- local suspend_icon = wibox.widget.imagebox(beautiful.suspend_icon)
-- suspend_icon.resize = true
-- suspend_icon.forced_width = icon_size
-- suspend_icon.forced_height = icon_size
-- local suspend_text = wibox.widget.textbox("Suspend")
-- suspend_text.font = text_font
--
-- local suspend = wibox.widget{
--   {
--     nil,
--     suspend_icon,
--     nil,
--     expand = "none",
--     layout = wibox.layout.align.horizontal
--   },
--   {
--     nil,
--     suspend_text,
--     nil,
--     expand = "none",
--     layout = wibox.layout.align.horizontal
--   },
--   -- forced_width = 100,
--   layout = wibox.layout.fixed.vertical
-- }
-- suspend:buttons(gears.table.join(
--                  awful.button({ }, 1, function ()
--                      suspend_command()
--                  end)
-- ))


local exit_icon = wibox.widget.imagebox(custom_themes_path.."icons/logout.png")
exit_icon.resize = true
exit_icon.forced_width = icon_size
exit_icon.forced_height = icon_size
local exit_text = wibox.widget.textbox("Log Out")
exit_text.font = text_font

local exit = wibox.widget{
  {
    nil,
    exit_icon,
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  {
    nil,
    exit_text,
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  -- forced_width = 100,
  layout = wibox.layout.fixed.vertical
}
exit:buttons(gears.table.join(
                  awful.button({ }, 1, function ()
                      exit_command()
                  end)
))

-- local lock_icon = wibox.widget.imagebox(beautiful.exit_lock)
-- lock_icon.resize = true
-- lock_icon.forced_width = icon_size
-- lock_icon.forced_height = icon_size
-- local lock_text = wibox.widget.textbox("Lock")
-- lock_text.font = text_font
--
-- local lock = wibox.widget{
--   {
--     nil,
--     lock_icon,
--     nil,
--     expand = "none",
--     layout = wibox.layout.align.horizontal
--   },
--   {
--     pad(1),
--     lock_text,
--     pad(1),
--     expand = "none",
--     layout = wibox.layout.align.horizontal
--   },
--   -- forced_width = 100,
--   layout = wibox.layout.fixed.vertical
-- }
-- lock:buttons(gears.table.join(
--                    awful.button({ }, 1, function ()
--                        lock_command()
--                    end)
-- ))

-- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- Create the widget
exit_screen = wibox({x = 0, y = 0, visible = false, ontop = true, type = "dock", height = screen_height, width = screen_width})

exit_screen.bg = "#00000000"
exit_screen.fg = beautiful.exit_screen_fg or beautiful.wibar_fg or "#FEFEFE"

-- Create an container box
-- local exit_screen_box = wibox.container.background()
-- exit_screen_box.bg = exit_screen.bg
-- exit_screen_box.shape = gears.shape.rounded_rect
-- exit_screen_box.shape_border_radius = 20


function exit_screen_hide()
  exit_screen.visible = false
end
function exit_screen_show()
  exit_screen.visible = true
  collectgarbage()
end

exit_screen:buttons(gears.table.join(
                 -- Middle click - Hide exit_screen
                 awful.button({ }, 2, function ()
                     exit_screen_hide()
                 end),
                 -- Right click - Hide exit_screen
                 awful.button({ }, 3, function ()
                     exit_screen_hide()
                 end)
))

local background = wibox.widget({
  forced_width = screen_width,
  forced_height = screen_height,
  visible = true,
  resize= true,
  widget = wibox.widget.imagebox,
  image = "/home/akshat/Pictures/Wallpapers/blurred-exit-screen.jpg",
})
background.point = awful.placement.centered

-- Item placement
exit_screen:setup {
  {
    background,
    layout = wibox.layout.manual
  },
  {
    nil,
    {
      nil,
      {
        -- {
        poweroff,
        utils.pad_width(dpi(16)),
        reboot,
        utils.pad_width(dpi(16)),
        exit,
        layout = wibox.layout.fixed.horizontal
        -- },
        -- widget = exit_screen_box
      },
      nil,
      expand = "none",
      layout = wibox.layout.align.horizontal
      -- layout = wibox.layout.fixed.horizontal
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
  },
  layout = wibox.layout.stack,
}

collectgarbage()
