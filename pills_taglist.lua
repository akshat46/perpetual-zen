-- Custom tags pills
local awful = require("awful")
local wibox = require("wibox")
local utils = require("utils") -- local file with utility functions
local beautiful = require("beautiful")
local cpu_widget = require ("widgets/cpu")
local volume_widget = require ("widgets/volume")
local thermal_widget = require ("widgets/thermal")
local battery_widget = require ("widgets/battery")
local wifi_widget = require ("widgets/wifi")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local naughty = require("naughty")

local banners = {}
collectgarbage("setpause", 100)
collectgarbage("setstepmul", 400)

--- tags banner
banners.init_tags_banner = function(s)
    s.tagsBanner = awful.widget.taglist{
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = {
            bg_focus = beautiful.banner_bg or beautiful.bg_focus,
        },
    }
    screen[1]:connect_signal("tag::history::update", function()
        handle_tag_icons(awful.tag.selected(1))
                            end)

    s.tagsBannerContainer = wibox{
        screen = s,
        x = -20,
        visible = true,
        width = dpi(360), --460
        height = dpi(70), --80
        bg = beautiful.banner_bg or beautiful.bg_normal,
        shape = utils.rrect(beautiful.border_radius),
        ontop = true,
        border_width = beautiful.banner_border_width,
        border_color = beautiful.banner_border_color,
    }
    s.tagsBannerContainer:setup{
        halign = "right",
        layout =  wibox.container.place,
        {
            widget = s.tagsBanner,
            forced_height = dpi(35),
            forced_width = dpi(340),
            --layout = wibox.container.margin(_, _, _, 2)
        }
    }
    utils.relative_position(s.tagsBannerContainer, "bottom", dpi(12))
end

banners.toggle_tags_banner = function()
    for s in screen do
        if s.tagsBannerContainer then
            s.tagsBannerContainer.visible = not s.tagsBannerContainer.visible
        end
    end
end

-- info(right) banner
banners.init_info_banner = function(s)
    s.infoBannerContainer = wibox{
        screen = s,
        visible = true,
        width = dpi(360),
        height = dpi(230),
        bg =  beautiful.banner_bg or beautiful.bg_normal,
        shape = utils.rrect(beautiful.border_radius),
        ontop = true,
        border_width = beautiful.banner_border_width,
        border_color = beautiful.banner_border_color,
    }
    s.layoutBox = awful.widget.layoutbox(s)
    --s.layoutBox.point = awful.placement.top_left
    -- datetime
    local clock = wibox.widget({
        align = 'center',
        font = beautiful.titlefont .." "..dpi(28),
        widget = wibox.widget.textclock('%H:%M'),
    })
    local date = wibox.widget({
        align = 'center',
        font = beautiful.fontname .. " "..dpi(7),
        widget = wibox.widget.textclock('%A, %B, %d')
    })
    local datetime = wibox.widget({
        {
            forced_width = dpi(25),
            forced_height = dpi(25),
            s.layoutBox,
            left = 10,
            top = 10,
            layout = wibox.container.margin,
        },
        {
            widget = clock,
        },
        {
            widget = date,
        },
        layout = wibox.layout.fixed.vertical,

    })

    cpu_widget.setColor(beautiful.fg_normal)
    cpu_widget.widget.point = awful.placement.bottom_left
    volume_widget.widget.text_widget.font = beautiful.fontname .. " "..dpi(7)
    thermal_widget.widget.text_widget.font = beautiful.fontname .. " "..dpi(7)
    battery_widget.widget.text_widget.font = beautiful.fontname .. " "..dpi(7)
    wifi_widget.widget.text_widget.font = beautiful.fontname .. " "..dpi(7)

    s.infoBannerContainer:setup
    { -- Time & date widget
        layout = wibox.layout.fixed.vertical,
        datetime,
        utils.pad_height(dpi(4)),
        {
            {
                volume_widget.widget,
                battery_widget.widget,
                spacing = dpi(80),
                forced_height = dpi(35),
                forced_width = dpi(230),
                layout = wibox.layout.flex.horizontal,
            },
            layout = wibox.container.place,
            halign = true,
        },
        utils.pad_height(dpi(4)),
        {
            {
                thermal_widget.widget,
                wifi_widget.widget,
                spacing = dpi(80),
                forced_height = dpi(35),
                forced_width = dpi(230),
                layout = wibox.layout.flex.horizontal,
            },
            layout = wibox.container.place,
            halign = true,
        },
        -- [[same widgets in grid layout. couldn't get vertical spacing to work]]
        -- {
        --     {
        --         volume_widget.widget,
        --         battery_widget.widget,
        --         thermal_widget.widget,
        --         wifi_widget.widget,
        --         spacing = 25,
        --         vertical_spacing = 40,
        --         forced_num_cols = 2,
        --         min_rows_size = 50,
        --         forced_height = 160,
        --         forced_width = 360,
        --         layout = wibox.layout.grid,
        --     },
        --     layout = wibox.container.place,
        --     halign = true,
        -- },
        -- {
        --     layout = wibox.layout.manual,
        --     cpu_widget.widget,
        -- },
    }
    utils.relative_position(s.infoBannerContainer, "bottom", dpi(12))
    utils.relative_position(s.infoBannerContainer, "right", -10)
    collectgarbage()
end

banners.toggle_info_banner = function()
    local visible = false
    for s in screen do
        if s.infoBannerContainer then
            s.infoBannerContainer.visible = not s.infoBannerContainer.visible
            visible = s.infoBannerContainer.visible
        end
    end
    battery_widget.toggle_checker(visible)
    thermal_widget.toggle_checker(visible)
    volume_widget.toggle_checker(visible)
end

local last_selected_tag
function handle_tag_icons(selected_tag)
    local next = next
    if last_selected_tag ~= nil then
        local clients = last_selected_tag:clients()
        if not next(clients) then
            -- tag is empty
            last_selected_tag.switch_icon(last_selected_tag,false,false)
        else
            --tag has something
            last_selected_tag.switch_icon(last_selected_tag,false, true)
        end
    end
    selected_tag.switch_icon(selected_tag,true, false)
    last_selected_tag = selected_tag
end

return banners
