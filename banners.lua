-- Custom tags banner
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

local banners = {}

--- tags banner
banners.init_tags_banner = function(s)
    s.tagsBanner = awful.widget.taglist(s, awful.widget.taglist.filter.all)
    screen[1]:connect_signal("tag::history::update", function()
        handle_tag_icons(awful.tag.selected(1))
    end)
    s.tagsBannerContainer = wibox{
        screen = s,
        x = -20,
        visible = true,
        width = dpi(360), --460
        height = dpi(70), --80
        bg = beautiful.bg_normal,
        shape = utils.rrect(beautiful.border_radius),
        ontop = true,
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
        bg = beautiful.bg_normal,
        shape = utils.rrect(beautiful.border_radius),
        ontop = true,
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
    volume_widget.text_widget.font = beautiful.fontname .. " "..dpi(7)
    thermal_widget.text_widget.font = beautiful.fontname .. " "..dpi(7)
    battery_widget.text_widget.font = beautiful.fontname .. " "..dpi(7)
    wifi_widget.text_widget.font = beautiful.fontname .. " "..dpi(7)

    s.infoBannerContainer:setup
    { -- Time & date widget
        layout = wibox.layout.fixed.vertical,
        datetime,
        utils.pad_height(dpi(4)),
        {
            {
                volume_widget,
                battery_widget,
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
                thermal_widget,
                wifi_widget,
                spacing = dpi(80),
                forced_height = dpi(40),
                forced_width = dpi(230),
                layout = wibox.layout.flex.horizontal,
            },
            layout = wibox.container.place,
            halign = true,
        },
        -- [[same widgets in grid layout. couldn't get vertical spacing to work]]
        -- {
        --     {
        --         volume_widget,
        --         battery_widget,
        --         thermal_widget,
        --         wifi_widget,
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
end

banners.toggle_info_banner = function()
    for s in screen do
        if s.infoBannerContainer then
            s.infoBannerContainer.visible = not s.infoBannerContainer.visible
        end
    end
end

local last_selected_tag
function handle_tag_icons(selected_tag)
    local next = next
    if last_selected_tag ~= nil then
        local clients = last_selected_tag:clients()
        if not next(clients) then
            last_selected_tag.switch_icon(last_selected_tag,false)
        end
    end
    selected_tag.switch_icon(selected_tag,true)
    last_selected_tag = selected_tag
end

return banners
