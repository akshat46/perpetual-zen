local custom_themes_path = require("gears.filesystem").get_configuration_dir()

local autostart = {
compton = "compton --experimental-backends --config ".. os.getenv("HOME") .. "/.config/compton/compton.conf",
xresources = "xrdb ".. os.getenv("HOME") .. "/.Xresources",
brightness = "sudo br 150",
flux = "fluxgui",
feh_background = "feh --bg-scale "..custom_themes_path.."/wallpapers/main.png", --wallpaper
}
return autostart
