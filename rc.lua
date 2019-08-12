-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local declutter = require("add_tags")
local utils = require("utils")
local banners = require("banners")
local spotify = require("spawtify/spotify_widget")
local quawke = require("widgets/quawke")
local top = require("widgets/top")
-- local exit = require("widgets/exit")
local layout_popup = require("layout_popup")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

--temporary spotify notification fix (TODO)
-- Changing spotify notifications.
naughty.config.presets.spotify = {
    -- if you want to disable Spotify notifications completely, return false
    callback = function(args)
        return true
    end,

    -- Adjust the size of the notification
    height = 100,
    width  = 340,
    -- Guessing the value, find a way to fit it to the proper size later
    icon_size = 90
}
table.insert(naughty.dbus.config.mapping, {{appname = "Spotify"}, naughty.config.presets.spotify})

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- autostart programs
local startup_programs = require("startup")
for _, v in pairs(startup_programs) do
    awful.util.spawn(v)
end

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
quawke.init(terminal, terminal)
top.init(terminal)
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- rounded corners
if beautiful.rounded_corners then
  client.connect_signal("property::geometry", function (c)
    if not c.fullscreen then
        gears.timer.delayed_call(function()
          gears.surface.apply_shape_bounding(c, gears.shape.rounded_rect, 10)
        end)
    end
  end)
end

local ll = awful.widget.layoutlist {
    source      = awful.widget.layoutlist.source.default_layouts, --DOC_HIDE
    spacing = dpi(24),
    base_layout = wibox.widget {
        spacing         = dpi(24),
        forced_num_cols = 4,
        layout          = wibox.layout.grid.vertical,
    },
    widget_template = {
        {
            {
                id            = 'icon_role',
                forced_height = dpi(68),
                forced_width  = dpi(68),
                widget        = wibox.widget.imagebox,
            },
            margins = dpi(24),
            widget  = wibox.container.margin,
        },
        id              = 'background_role',
        forced_width    = dpi(68),
        forced_height   = dpi(68),
        shape           = gears.shape.rounded_rect,
        widget          = wibox.container.background,
    },
}

local layout_popup = awful.popup {
    widget = wibox.widget {
        ll,
        margins = dpi(24),
        widget  = wibox.container.margin,
    },
    border_color = beautiful.border_color,
    border_width = beautiful.border_width,
    placement    = awful.placement.centered,
    shape = utils.rrect(beautiful.border_radius),
    ontop        = true,
    visible      = false,
    bg           = beautiful.bg_normal,
}

--DOC_NEWLINE

-- Make sure you remove the default `Mod4+Space` and `Mod4+Shift+Space`
-- keybindings before adding this.

function gears.table.iterate_value(t, value, step_size, filter, start_at)
    local k = gears.table.hasitem(t, value, true, start_at)
    if not k then return end

    step_size = step_size or 1
    local new_key = gears.math.cycle(#t, k + step_size)

    if filter and not filter(t[new_key]) then
        for i=1, #t do
            local k2 = gears.math.cycle(#t, new_key + i)
            if filter(t[k2]) then
                return t[k2], k2
            end
        end
        return
    end

    return t[new_key], new_key
end

awful.keygrabber {
    start_callback = function() layout_popup.visible = true  end,
    stop_callback  = function() layout_popup.visible = false end,
    export_keybindings = true,
    stop_event = "release",
    stop_key = {"Escape", "Super_L", "Super_R", "Mod4"},
    keybindings = {
        {{ modkey          } , " " , function()
             awful.layout.set(gears.table.iterate_value(ll.layouts, ll.current_layout, 1), nil)
        end},
        {{ modkey, "Shift" } , " " , function()
             awful.layout.set(gears.table.iterate_value(ll.layouts, ll.current_layout, -1), nil)
        end},
    }
}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

collectgarbage("setpause", 100)
collectgarbage("setstepmul", 400)

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()


local gfs = require("gears.filesystem")
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- set_wallpaper(s)

    declutter.add_tags()

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- TODO: no popup in 4.2
    --layout_popup.layout_popup_init(s)
    -- Custom banners
    banners.init_tags_banner(s)
    banners.init_info_banner(s)
    -- exit.init_exit_banner(s)

    spotify.widget({
        screen = s,
        artwork = true,
    })
    spotify.toggle()
end)

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- toggle custom banners
    awful.key({ modkey,           }, "z", banners.toggle_tags_banner,
        {description = "toggle taglist banner", group = "awesome"}),
    awful.key({ modkey,           }, ".", banners.toggle_info_banner,
        {description = "toggle info banner", group = "awesome"}),

    -- toggle spotify widget
    awful.key({ modkey, "Shift"   }, "s",      spotify.toggle,
        {description="toggle spawtify", group="awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    -- Edit gap
    awful.key({ modkey, "Shift"   }, "=", function () awful.screen.focused().selected_tag.useless_gap = awful.screen.focused().selected_tag.useless_gap + 5    end,
              {description = "incremenet tag gap by 5", group = "client"}),
    awful.key({ modkey, "Shift"   }, "-", function ()  awful.screen.focused().selected_tag.useless_gap = awful.screen.focused().selected_tag.useless_gap - 5    end,
              {description = "decrement tag gap by 5", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift", "Control"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    -- awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    --           {description = "select next", group = "layout"}),
    -- awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    --           {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- -- Prompt
    -- awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
    --           {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),

    -- JGmenu
    awful.key({ modkey }, "d", function() awful.spawn("jgmenu_run") end,
              {description = "display menu", group = "launcher"}),

    --flameshot
    awful.key({ modkey, "Shift" }, "d", function() awful.spawn("flameshot gui") end,
        {description = "flameshot: initialize", group = "launcher"}),
    awful.key({ modkey, "Control" }, "d", function() awful.spawn("flameshot screen -c") end,
        {description = "flameshot: screen to clipboard", group = "launcher"}),
    --Emacs
    awful.key({ modkey, }, "e", function() awful.spawn("emacs") end,
        {description = "Emacs", group = "launcher"}),

    --Firefox
    awful.key({ modkey, "Shift" }, "f", function() awful.spawn("firefox") end,
            {description = "Firefox", group = "launcher"}),
    --quawke
    awful.key({ modkey }, "`", function() quawke.toggle(client) end,
        {description = "toggle quawke", group = "launcher"}),
    --top
    awful.key({ modkey, "Shift" }, "t", function() top.toggle(client) end,
        {description = "show go top", group = "launcher"}),
    -- media control volume
    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("pactl set-sink-volume 0 +5%") end),
    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("pactl set-sink-volume 0 -5%") end),
    awful.key({}, "XF86AudioMute", function() awful.spawn("pactl set-sink-mute 0 toggle") end),

    -- media control playpause (spotify)
    awful.key({ }, "XF86AudioPlay", function () awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause") end),

    -- brightness controls
    -- xbacklight wont work. for now changing brightness with my own script
    awful.key({ }, "XF86MonBrightnessDown", function () awful.spawn("sudo br down") end),
    awful.key({ }, "XF86MonBrightnessUp", function () awful.spawn("sudo br up") end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = false }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
}, properties = { titlebars_enabled = false }
    },
    -- tag specific apps
    { rule = { class = "URxvt" },
      properties = { screen = 1, tag = "1" } },
    { rule = { class = "Firefox" },
      properties = { screen = 1, tag = "2" } },
    { rule = { class = "Google-chrome" },
      properties = { screen = 1, tag = "2" } },
    { rule = { class = "Atom" },
      properties = { screen = 1, tag = "3" } },
    { rule = { class = "Nautilus" },
      properties = { screen = 1, tag = "4" } },
    { rule = { class = "Spotify" },
      properties = { screen = 1, tag = "5" } },
    { rule = { class = "GLava" },
      callback = function(c) spotify.setVisualizer(c) end
      },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--         and awful.client.focus.filter(c) then
--         client.focus = c
--     end
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
