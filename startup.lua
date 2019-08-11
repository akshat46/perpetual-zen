local autostart = {
"compton --experimental-backends --config ".. os.getenv("HOME") .. "/.config/Compton/compton.conf",
"xrdb ".. os.getenv("HOME") .. "/.Xresources",
"sudo br 200",
"feh --bg-scale /home/akshat/Pictures/Wallpapers/recolored/spiderman_depth_of_field_recolored.png", --wallpaper
--"fluxgui",
}
return autostart
