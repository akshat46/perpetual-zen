local autostart = {
"compton --config ".. os.getenv("HOME") .. "/.config/compton/compton.conf",
"xrdb ".. os.getenv("HOME") .. "/.Xresources",
"sudo br 200",
"feh --bg-scale /home/akshat/Pictures/Wallpapers/recolored/spiderman_depth_of_field_recolored.png", --wallpaper
--"fluxgui",
}
return autostart
