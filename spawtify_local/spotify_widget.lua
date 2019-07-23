local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("utils")
local gears = require("gears")
local utils = require("utils")
local naughty = require("naughty")
local spotify = {}
local dir = gears.filesystem.get_configuration_dir ()

local icons = {}
icons.spotify_play_button_icon = dir.."spawtify/icons/play-spotify.png" or beautiful.spotify_play_button_icon
icons.spotify_pause_button_icon = dir.."spawtify/icons/pause-spotify.png" or beautiful.spotify_pause_button_icon
icons.spotify_prev_button_icon = dir.."spawtify/icons/previous-spotify.png" or beautiful.spotify_prev_button_icon
icons.spotify_next_button_icon = dir.."spawtify/icons/next-spotify.png" or beautiful.spotify_next_button_icon
icons.spotify_icon = dir.."spawtify/icons/spotify-spotify.png" or beautiful.spotify_icon
icons.error_icon = dir.."spawtify/icons/ghost.png" or beautiful.spotify_error_icon

local spotify_commands = {}
spotify_commands.status = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus'|egrep -A 1 \"string\"|cut -b 26-|cut -d '\"' -f 1|egrep -v ^$"
spotify_commands.toggle = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
spotify_commands.prev = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous"
spotify_commands.next = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
spotify_commands.song = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 1 \"title\"|egrep -v \"title\"|cut -b 44-|cut -d '\"' -f 1|egrep -v ^$"
spotify_commands.album = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 1 \"album\"|egrep -v \"album\"|cut -b 44-|cut -d '\"' -f 1|egrep -v ^$"
spotify_commands.artist = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 2 \"artist\"|egrep -v \"artist\"|egrep -v \"array\"|cut -b 27-|cut -d '\"' -f 1|egrep -v ^$"
spotify_commands.artwork = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 1 \"artUrl\"|egrep -v \"artUrl\"|cut -b 44-|cut -d '\"' -f 1|egrep -v ^$"

local button_size
local width
local height
local old_title
local changed = false
local playing = false
local art = false
local art_path = dir .."spawtify/.cache/artwork"

local artwork = wibox.widget.imagebox()
artwork.clip_shape = utils.rrect(beautiful.border_radius or 5)

local spotify_icon = wibox.widget.imagebox()
spotify_icon.forced_width = 40
spotify_icon.forced_height = 40

local spotify_icon_onclick = gears.table.join(
    awful.button({ }, 1,
        function()
            check_for_updates()
        end
    )
)
spotify_icon:buttons(spotify_icon_onclick)

local title = wibox.widget.textbox("Title")
title.align = center

local album = wibox.widget.textbox("Album")
album.align =  center

local artist = wibox.widget.textbox("Artist")
artist.align = center

local toggle_button = wibox.widget.imagebox()

function addSongData()
    local song_data = wibox.widget({
        {
            title,
            halign = 'center',
            widget = wibox.container.place,
        },
        --utils.pad_height(2),
        {
            album,
            halign = 'center',
            widget = wibox.container.place,
        },
        {
            artist,
            halign = 'center',
            widget = wibox.container.place,
        },
        layout = wibox.layout.fixed.vertical,
    })
    return song_data
end

function set_toggle_image(toggle)
    playing = not playing
    if playing then
        toggle.image = icons.spotify_pause_button_icon
    else
        toggle.image = icons.spotify_play_button_icon
    end
end
function addButtons()
    -- make the toggle button
    toggle_button.forced_height = button_size
    toggle_button.forced_width = button_size

    -- make the next button
    local next_button = wibox.widget.imagebox(icons.spotify_next_button_icon)
    next_button.forced_height = button_size
    next_button.forced_width = button_size

    -- make the prev button
    local prev_button = wibox.widget.imagebox(icons.spotify_prev_button_icon)
    prev_button.forced_height = button_size
    prev_button.forced_width = button_size

    local toggle_onclick = gears.table.join(
        awful.button({ }, 1,
            function()
                awful.spawn(spotify_commands.toggle)
                set_toggle_image(toggle_button)
            end
        )
    )
    toggle_button:buttons(toggle_onclick)

    local next_onclick = gears.table.join(
        awful.button({ }, 1,
            function()
                awful.spawn(spotify_commands.next)
                check_for_updates()
            end
        )
    )
    next_button:buttons(next_onclick)

    local prev_onclick = gears.table.join(
        awful.button({ }, 1,
            function()
                awful.spawn(spotify_commands.prev)
                check_for_updates()
            end
        )
    )
    prev_button:buttons(prev_onclick)

    local put_buttons_together = wibox.widget({
        {
            prev_button,
            toggle_button,
            next_button,
            layout = wibox.layout.flex.horizontal,
            spacing = button_size,
        },
        halign = 'center',
        widget = wibox.container.place,
    })
    return put_buttons_together
end

--[[-----------------------------------------
Artwork Functions
]]-------------------------------------------
function initArtwork()
    artwork.image = icons.error_icon
    artwork.forced_height = height*0.4
    artwork.forced_width = width*0.6
    artwork.opacity = 0.3
    artwork.resize = true
end

function getArtwork()
    if art then
        return artwork
    else
        return nil
    end
end

function setArtwork(empty)
    if empty then
        artwork.opacity = 0.3
        artwork.resize = true
        artwork.image = icons.error_icon
    else
        artwork.opacity = 1
        artwork.resize = false
        artwork.image = art_path
    end
end
--[[-----------------------------------------]]

spotify.widget = function(o)
    local s = o.screen
    width  = 460 or o.width
    height = 600 or o.height
    button_size = width * 0.1
    art = o.artwork or false

    if art then
        initArtwork()
    end
    local song_data = addSongData()
    local buttons = addButtons()

    title.font = beautiful.titlefont.." Black 16" or beautiful.font
    title.forced_height = 50
    --title.ellipsize = "end"
    album.font = beautiful.fontname.." 9" or beautiful.font
    artist.font = beautiful.fontname.." 11" or beautiful.font

    spotify_icon.image = icons.spotify_icon

    s.spotify_widget = wibox({
        screen = s,
        visible = true,
        width = width,
        height = height,
        bg = "#000000" or o.bg,
        shape = utils.rrect(beautiful.border_radius),
        ontop = true,
    })

    s.spotify_widget:setup({
        {
            spotify_icon,
            left = 20,
            top = 20,
            bottom = 5,
            layout = wibox.container.margin,
        },
        --utils.pad_height(8),
        {
            getArtwork(),
            halign = 'center',
            widget = wibox.container.place,
        },
        utils.pad_height(4),
        song_data,
        utils.pad_height(4),
        buttons,
        layout =  wibox.layout.fixed.vertical,
    })

    local bottom_margin = o.bottom_margin or 225
    utils.relative_position(s.spotify_widget, "bottom", bottom_margin)
    utils.relative_position(s.spotify_widget, "right", -10)
    -- init_status()
    force_update_widget()
end

-- check continously every 'artwork_callback_count' seconds for 'artwork_callback_count' * 'artwork_callback_timer' seconds
local artwork_callback_timer = 1
local artwork_callback_count = 3

--local artwork_timer = gears.timer.start_new(2.5, artworkCallback)

-- check pauseplay status has changed, and change icon accordingly.
function pause_play_check()
    awful.spawn.easy_async_with_shell(command, function()
        awful.spawn.easy_async_with_shell(spotify_commands.status, function(out)
            if string.match(out, "Playing") then
                playing = true
                toggle_button.image = icons.spotify_pause_button_icon
            elseif string.match(out, "Paused") then
                playing = false
                toggle_button.image = icons.spotify_play_button_icon
            else
                playing = -1
                return
            end
        end)
    end)
end

-- force update
function force_update_widget()
    pause_play_check()

    -- spotify not running/dbus error
    if playing==-1 then return end

    awful.spawn.easy_async_with_shell(command, function()
        awful.spawn.easy_async_with_shell(spotify_commands.song, function(out)
            old_title = out
            title:set_markup (utils.colorize_text(out,"#ffffff"))
        end)
    end)
    data_changed()
end

--update if changes
function check_for_updates()
    pause_play_check()

    -- spotify not running/dbus error
    if playing==-1 then return end

    -- function called before widget was completely initialized.
    -- the assumption is that force_update_widget MUST be called at least once before this function can be called
    if not old_title then return end

    awful.spawn.easy_async_with_shell(command, function()
        awful.spawn.easy_async_with_shell(spotify_commands.song, function(out)
            -- if previously saved title is not same as output, then song has changed.
            if old_title ~= out then
                old_title = out
                title:set_markup (utils.colorize_text(out,"#ffffff"))
                setArtwork(true)
                data_changed()
            end
        end)
    end)
end

function data_changed()
    awful.spawn.easy_async_with_shell(command, function()
        awful.spawn.easy_async_with_shell(spotify_commands.album, function(out)
            album:set_markup ("<span foreground='#ffffffAA'><i>" .. out .. "</i></span>")
        end)
    end)

    awful.spawn.easy_async_with_shell(command, function()
        awful.spawn.easy_async_with_shell(spotify_commands.artist, function(out)
            artist:set_markup ("<span foreground='#ffffff'>by  <b>" .. out .. "</b></span>")
        end)
    end)

    awful.spawn.easy_async_with_shell(command, function()
        awful.spawn.easy_async_with_shell(spotify_commands.artwork, function(out)
            local cmd = "wget -O "..dir.."spawtify/.cache/artwork "..out
            awful.spawn(cmd)
            --gears.timer.weak_start_new(artwork_callback_timer, artworkCallback):stop()
            gears.timer.weak_start_new(artwork_callback_timer, artworkCallback):start()
        end)
    end)
    collectgarbage()
end

function artworkCallback()
    artwork_callback_count = artwork_callback_count-1
    if artwork_callback_count > 0 then
        setArtwork(false)
        return true
    else
        artwork_callback_count = 3
        collectgarbage()
        return false
    end
end


--watch(spotify_commands.song, 5, check_for_updates, artwork)
local widget_update = gears.timer{
    timeout = 5,
    call_now = false,
    callback = function()
        check_for_updates()
    end
}

widget_update:start()

spotify.toggle = function()
    for s in screen do
        if s.spotify_widget then
            s.spotify_widget.visible = not s.spotify_widget.visible
        end
        if s.spotify_widget.visible then
            force_update_widget()
            widget_update:start()
        else
            widget_update:stop()
        end
    end
end

return spotify
