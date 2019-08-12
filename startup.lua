local custom_themes_path = require("gears.filesystem").get_configuration_dir()

local autostart = {
"compton --config ".. os.getenv("HOME") .. "/.config/compton/compton.conf",
"xrdb ".. os.getenv("HOME") .. "/.Xresources",
"sudo br 200",
--"fluxgui",
"feh --bg-scale "..custom_themes_path.."/wallpapers/main.png", --wallpaper
}
return autostart
