local autostart = {
"compton --experimental-backends --config ".. os.getenv("HOME") .. "/.config/Compton/compton.conf",
"xrdb ".. os.getenv("HOME") .. "/.Xresources",
"sudo br 150",
"feh --bg-scale /home/akshat/Pictures/Wallpapers/ZJCYke1.png", --wallpaper
--"fluxgui",
}
return autostart
