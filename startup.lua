local autostart = {
"compton --experimental-backends --config ".. os.getenv("HOME") .. "/.config/Compton/compton.conf",
"xrdb ".. os.getenv("HOME") .. "/.Xresources",
"sudo br 150",
"feh --bg-scale /home/akshat/Pictures/Wallpapers/owu50m6mg4a31.jpg", --wallpaper
--"fluxgui",
}
return autostart
