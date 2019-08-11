<p align="center">
  <img src="https://github.com/akshat46/perpetual-zen/blob/master/screenshots/title.png?raw=true"/>
  An awesome-wm theme with different toggleable components.
</p>

<p align="center">
  <img src="https://github.com/akshat46/perpetual-zen/blob/master/screenshots/screenshot_pz.png?raw=true"/>
</p>

## Key Binds

<p align="center">
  <img src="https://raw.githubusercontent.com/akshat46/perpetual-zen/master/screenshots/keybinds.png">
</p>

## Usage
Backup your configurations and clone this repository in your awesomewm config folder (~/.config/awesome/). 

Info and tags, spawtify, quawke, and top banners can all be used independently. For now, venture into the code and try to find configurations. Will document them *soon*. 

## Project Structure

*TODO: separate banners and widgets in distinct folders*

`banners.lua` 
tags banner (left bottom) and info banner (right bottom)

`widgets/` 
info banner components as independent widgets and rest of the banners. 

*`exit_screen.lua` is an unused file taken from [elanapan's dotfiles](https://github.com/elenapan/dotfiles/blob/master/config/awesome/noodle/exit_screen.lua). I am trying to keep awesome as light as possible and this file adds about 25mb of memory usage. Keeping it around for referencing when I work on`exit.lua`* 

`spawtify/`
spawtify repo as a module. See the module's readme for more details.

`startup.lua` 
Consists of all the startup programs. 

`utils.lua` 
Helper functions

*a modified version of [lawsdontapplytopigs's utils.lua](https://github.com/lawsdontapplytopigs/dotfiles/blob/master/awesome/utils.lua)*

