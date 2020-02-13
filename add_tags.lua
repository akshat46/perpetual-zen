local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")

local tag_function = {}

local function add_tags()
    awful.tag.add("1", {
        index = 1,
        layout      = awful.layout.suit.tile,
        screen      = s_outline,
        icon = beautiful.tag_logo_terminal_outline,
        master_fill_policy = "master_width_factor",
        gap_single_client = true,
        selected = true,
        gap = 15,
        switch_icon = function(self, selected, full)
            full = full or false
            if selected then
                self.icon = beautiful.tag_logo_terminal
            elseif not selected and full then
                self.icon = beautiful.tag_logo_terminal_unfocused
            else
                self.icon = beautiful.tag_logo_terminal_outline
            end
        end,
    })
    awful.tag.add("2", {
        layout      = awful.layout.suit.floating,
        screen      = s,
        resize = true_outline,
        icon = beautiful.tag_logo_firefox_outline,
        master_fill_policy = "master_width_factor",
        gap_single_client = false,
        gap = 5,
        switch_icon = function(self, selected, full)
            full = full or false
            if selected then
                self.icon = beautiful.tag_logo_firefox
            elseif not selected and full then
                self.icon = beautiful.tag_logo_firefox_unfocused
            else
                self.icon = beautiful.tag_logo_firefox_outline
            end
        end,
    })
    awful.tag.add("3", {
        layout      = awful.layout.suit.floating,
        screen      = s,
        icon = beautiful.tag_logo_code_outline,
        master_fill_policy = "master_width_factor",
        gap_single_client = false,
        gap = 5,
        switch_icon = function(self, selected, full)
            full = full or false
            if selected then
                self.icon = beautiful.tag_logo_code
            elseif not selected and full then
                self.icon = beautiful.tag_logo_code_unfocused
            else
                self.icon = beautiful.tag_logo_code_outline
            end
        end
    })
    awful.tag.add("4", {
        layout      = awful.layout.suit.floating,
        screen      = s,
        icon = beautiful.tag_logo_folder_outline,
        master_fill_policy = "master_width_factor",
        gap_single_client = true,
        gap = 10,
        switch_icon = function(self, selected, full)
            full = full or false
            if selected then
                self.icon = beautiful.tag_logo_folder
            elseif not selected and full then
                self.icon = beautiful.tag_logo_folder_unfocused
            else
                self.icon = beautiful.tag_logo_folder_outline
            end
        end
    })
    awful.tag.add("5", {
        layout      = awful.layout.suit.floating,
        screen      = s,
        icon = beautiful.tag_logo_spotify_outline,
        master_fill_policy = "master_width_factor",
        gap = 15,
        switch_icon = function(self, selected, full)
            full = full or false
            if selected then
                self.icon = beautiful.tag_logo_spotify
            elseif not selected and full then
                self.icon = beautiful.tag_logo_spotify_unfocused
            else
                self.icon = beautiful.tag_logo_spotify_outline
            end
        end
    })
    awful.tag.add("6", {
        layout      = awful.layout.suit.tile,
        screen      = s,
        icon = beautiful.tag_logo_circle_outline,
        master_fill_policy = "master_width_factor",
        gap_single_client = true,
        gap = 10,
        switch_icon = function(self, selected, full)
            full = full or false
            if selected then
                self.icon = beautiful.tag_logo_circle
            elseif not selected and full then
                self.icon = beautiful.tag_logo_circle_unfocused
            else
                self.icon = beautiful.tag_logo_circle_outline
            end
        end
    })
    awful.tag.add("7", {
        layout      = awful.layout.suit.floating,
        screen      = s,
        icon = beautiful.tag_logo_circle_outline,
        master_fill_policy = "master_width_factor",
        gap_single_client = true,
        gap = 10,
        switch_icon = function(self, selected, full)
            full = full or false
            if selected then
                self.icon = beautiful.tag_logo_circle
            elseif not selected and full then
                self.icon = beautiful.tag_logo_circle_unfocused
            else
                self.icon = beautiful.tag_logo_circle_outline
            end
        end
    })
end

tag_function.add_tags = add_tags

return tag_function
