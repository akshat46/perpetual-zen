---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local custom_themes_path = gfs.get_configuration_dir()

local theme = {}

theme.font          = "Atlas Grotesk 11"
theme.fontname      = "Atlas Grotesk"
theme.titlefont     = "Atlas Grotesk Web"
theme.padding_font  = "hack 2"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(0)
theme.rounded_corners = false
theme.border_radius = 8
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- taglist
theme.taglist_spacing = dpi(2)
theme.taglist_font = "sans 0"

-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Tag Icons
theme.tag_logo_terminal = custom_themes_path.."icons/terminal.png"
theme.tag_logo_firefox = custom_themes_path.."icons/firefox.png"
theme.tag_logo_code = custom_themes_path.."icons/code.png"
theme.tag_logo_folder = custom_themes_path.."icons/folder.png"
theme.tag_logo_spotify = custom_themes_path.."icons/spotify.png"
theme.tag_logo_circle = custom_themes_path.."icons/circle.png"
--
theme.tag_logo_terminal_outline = custom_themes_path.."icons/terminal_outline.png"
theme.tag_logo_firefox_outline = custom_themes_path.."icons/firefox_outline.png"
theme.tag_logo_code_outline = custom_themes_path.."icons/code_outline.png"
theme.tag_logo_folder_outline = custom_themes_path.."icons/folder_outline.png"
theme.tag_logo_spotify_outline = custom_themes_path.."icons/spotify_outline.png"
theme.tag_logo_circle_outline = custom_themes_path.."icons/circle_outline.png"

-- Volume Icons
theme.volume_icon_high = custom_themes_path.."icons/volume-high.png"
theme.volume_icon_medium = custom_themes_path.."icons/volume-medium.png"
theme.volume_icon_low = custom_themes_path.."icons/volume-low.png"
theme.volume_icon_mute = custom_themes_path.."icons/volume-mute.png"
theme.volume_icon_off = custom_themes_path.."icons/volume-off.png"

-- Thermal icons
theme.thermal_icon = custom_themes_path.."icons/thermometer.png"
theme.thermal_icon_alert = custom_themes_path.."icons/thermometer_alert.png"

-- Battery Icons
theme.battery_icon_charging = custom_themes_path.."icons/battery-charging.png"
theme.battery_icon_low = custom_themes_path.."icons/battery-low.png"
theme.battery_icon_med = custom_themes_path.."icons/battery-med.png"
theme.battery_icon_high = custom_themes_path.."icons/battery-high.png"
theme.battery_icon_full = custom_themes_path.."icons/battery-full.png"

-- WiFi Icons
theme.wifi_icon_disconnected = custom_themes_path.."icons/wifi-disconnected.png"
theme.wifi_icon_low = custom_themes_path.."icons/wifi-low.png"
theme.wifi_icon_med = custom_themes_path.."icons/wifi-med.png"
theme.wifi_icon_high = custom_themes_path.."icons/wifi-high.png"

-- Media Icons
theme.play_button_icon = custom_themes_path.."icons/play.png"
theme.pause_button_icon = custom_themes_path.."icons/pause.png"
theme.prev_button_icon = custom_themes_path.."icons/previous.png"
theme.next_button_icon = custom_themes_path.."icons/next.png"
-- spotify variants
theme.spotify_play_button_icon = custom_themes_path.."spawtify/icons/play-spotify.png"
theme.spotify_pause_button_icon = custom_themes_path.."spawtify/icons/pause-spotify.png"
theme.spotify_prev_button_icon = custom_themes_path.."spawtify/icons/previous-spotify.png"
theme.spotify_next_button_icon = custom_themes_path.."spawtify/icons/next-spotify.png"
theme.spotify_icon = custom_themes_path.."spawtify/icons/spotify-spotify.png"
theme.error_icon = custom_themes_path.."spawtify/icons/ghost.png"


-- Define the image to load
-- theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
-- theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"
--
-- theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
-- theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"
--
-- theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
-- theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
-- theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
-- theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"
--
-- theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
-- theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
-- theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
-- theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"
--
-- theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
-- theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"
--
-- theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
-- theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
-- theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
-- theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

-- theme.wallpaper = "/home/akshat/Pictures/Wallpapers/wallhaven-mdwxjy.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
