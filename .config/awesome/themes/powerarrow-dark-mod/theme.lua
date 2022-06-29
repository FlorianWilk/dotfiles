--[[

     WILK mod of 
     Powerarrow Dark Awesome WM theme
     github.com/lcpz

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi
local volume_control = require("volume-control")
local layout_indicator = require("keyboard-layout-indicator")
local watch = require("awful.widget.watch")
local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility
local naughty       = require("naughty")
local mainscreen=2

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-dark-mod"
theme.wallpaper                                 = theme.dir .. "/wall.png"
theme.font                                      = "Terminus 9"
theme.font2                                      = "Terminus 9"
theme.fg_normal                                 = "#DDDDDD"
theme.fg_focus                                  = "#00AFFF"
theme.notification_border_color                 = "#00AFFF"
theme.fg_urgent                                 = "#AFFF00"
theme.bg_normal                                 = "#1A1A1A"
theme.bg_focus                                  = "#313131"
theme.bg_urgent                                 = "#1A1A1A"
theme.border_width                              = dpi(1)
theme.border_normal                             = "#313131"
theme.border_focus                              = "#7F7F7F"
theme.border_marked                             = "#CC9393"
theme.tasklist_bg_focus                         = "#1A1A1A"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_focus
theme.titlebar_fg_focus                         = theme.fg_focus
theme.tasklist_fg_focus                         = "#00AFFF"
theme.tasklist_bg_focus                         = "#313131"
theme.border_focus                              = "#1ca7e8"
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery                            = theme.dir .. "/icons/battery.png"
theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
theme.widget_music                              = theme.dir .. "/icons/note.png"
theme.widget_music_on                           = theme.dir .. "/icons/note_on.png"
theme.widget_vol                                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail                               = theme.dir .. "/icons/mail.png"
theme.widget_mail_on                            = theme.dir .. "/icons/mail_on.png"
theme.tasklist_plain_task_name                  = false
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = dpi(0)
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"
theme.notification_bg = "#202020"
theme.notification_fg = "#d0d0d0"
theme.notification_border_color = "#00AFFF"
theme.notification_margin = dpi(30)
theme.hotkeys_border_width = dpi(1)
theme.hotkeys_group_margin = dpi(60)
theme.hotkeys_fg = "#909090"
theme.hotkeys_modifiers_fg = "#00a0ff"
theme.notification_icon_size = dpi(32)

local markup = lain.util.markup
local separators = lain.util.separators

function arrowbar(total, high,col1,highvalue)
    local widget = wibox.widget.base.make_widget()
    widget.col1 = col1
    widget.col2 = "#00a0ff"
    widget.total=total
    widget.high=high
    widget.thickness=3
    widget.margin=2
    widget.h=3
    widget.s=6
    widget.highvalue=100
    widget.value=50
    widget.ph=4

    widget.fit = function(_,  _, _)
        return widget.s*(widget.total)+widget.thickness, separators.height
    end

    widget.setValue = function(value,v)
        --widget.value = value
        --widget.value=value.value
        widget.value=v
        widget:emit_signal("widget::redraw_needed")
    end

    widget.draw = function(_, _, cr, width, height)
            margin=widget.margin
            s=widget.s
            h=widget.h
            ph=widget.ph
            high=widget.total/widget.highvalue*widget.value
            for v=0,widget.total-1 do
                if((widget.total-1)-v>=high) then
                    cr:set_source_rgba(gears.color.parse_color(widget.col1))
                else 
                    cr:set_source_rgba(gears.color.parse_color(widget.col2))
                end
                t=widget.thickness
                cr:new_path()
                local o=0
                cr:move_to(v*s,height/2+o)
                cr:line_to(v*s+ph,height/2-ph+o)
                cr:line_to(v*s+ph+t,height/2-ph+o)
                cr:line_to(v*s+t,height/2+o)                
                cr:line_to(v*s+ph+t,height/2+ph+o)
                cr:line_to(v*s+ph,height/2+ph+o)
                cr:line_to(v*s,height/2+o)


                cr:close_path()
                cr:fill()
            end
   end

   return widget
end

function donut(total, high,col1,highvalue)
    local widget = wibox.widget.base.make_widget()
    widget.col1 = col1
    widget.col2 = "#00a0ff"
    widget.value=0

    widget.fit = function(_,  _, _)
        return 16, 10
    end

    widget.setValue = function(value,v)
        widget.value=v
        widget:emit_signal("widget::redraw_needed")
    end
    local PI = 2*math.asin(1)
    local rad_N = 3*PI/2 -- north in radians
    local rad_E = 0      -- east in radians
    local rad_S = PI/2   -- south in radians
    local rad_W = PI     -- west in radians
    widget.draw = function(_, _, cr, width, height)
        cr:set_source_rgba(gears.color.parse_color("#606060"))
        gears.shape.transform(gears.shape.arc) : translate(0,5) (cr, 10,10, 2, rad_E, 2*rad_W)
        cr:fill()
        cr:set_source_rgba(gears.color.parse_color(widget.col2))
        gears.shape.transform(gears.shape.arc) : translate(0,5) (cr, 10,10, 2, rad_N, rad_N+PI/((90-20)/2)*(widget.value-20))
            cr:fill()
   end
   return widget
end

function tempbar(total, high,col1,col3,highvalue)
    local widget = wibox.widget.base.make_widget()
    widget.col1 = col1
    widget.col2 = "#00a0ff"
    widget.col3=col3
    widget.value=0

    widget.fit = function(_,  _, _)
        return 6, 10
    end

    widget.setValue = function(value,v)
        widget.value=v
        widget:emit_signal("widget::redraw_needed")
    end
    local PI = 2*math.asin(1)
    local rad_N = 3*PI/2 -- north in radians
    local rad_E = 0      -- east in radians
    local rad_S = PI/2   -- south in radians
    local rad_W = PI     -- west in radians
    widget.draw = function(_, _, cr, width, height)
        cr:set_source_rgba(gears.color.parse_color(widget.col1))
        gears.shape.transform(gears.shape.rectangle) : translate(0,5) (cr, 4,10)
        cr:fill()
        local val = 10/70*(widget.value-20)
        if val>6 then
            cr:set_source_rgba(gears.color.parse_color(widget.col2))
        else
            cr:set_source_rgba(gears.color.parse_color(widget.col3))
        end
        gears.shape.transform(gears.shape.rectangle) : translate(0,15-val) (cr, 4,val)
            cr:fill()
   end
   return widget
end



-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    "date +'%a %d %b %R'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { clock },
    followtag=true,
    notification_preset = {
        font = "Terminus 9",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal,
        screen = s
    }
})

-- MPD
local musicplr = awful.util.terminal .. " -title Music -g 130x34-320+16 -e ncmpcpp"
local mpdicon = wibox.widget.imagebox(theme.widget_music)
mpdicon:buttons(my_table.join(
    awful.button({ modkey }, 1, function () awful.spawn.with_shell(musicplr) end),
    awful.button({ }, 1, function ()
        os.execute("mpc prev")
        theme.mpd.update()
    end),
    awful.button({ }, 2, function ()
        os.execute("mpc toggle")
        theme.mpd.update()
    end),
    awful.button({ }, 3, function ()
        os.execute("mpc next")
        theme.mpd.update()
    end)))
theme.mpd = lain.widget.mpd({
    settings = function()
        if mpd_now.state == "play" then
            artist = " " .. mpd_now.artist .. " "
            title  = mpd_now.title  .. " "
            mpdicon:set_image(theme.widget_music_on)
        elseif mpd_now.state == "pause" then
            artist = " mpd "
            title  = "paused "
        else
            artist = ""
            title  = ""
            mpdicon:set_image(theme.widget_music)
        end

        widget:set_markup(markup.font(theme.font, markup("#EA6F81", artist) .. title))
    end
})

--MICUSE
local micusetext=wibox.widget.textbox()
local micuseresult=""
micusetext:connect_signal('mouse::enter', function()
    if micuseresult~="" then
    naughty.notify({
        preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = "Monospace 10" },
        title = "MIC is used by",
        text = micuseresult,
        timeout= 10
    })
end
end)
watch(
    'bash -c "cat /proc/asound/Audio/pcm0c/sub0/status | grep owner_pid"', 5,
    function(widget, stdout, stderr, exitreason, exitcode)
    if(exitcode == 0) then
        if(stdout=="closed\n") then
            widget:set_markup("<span color='#909090'> MIC </span>")
            micuseresult=""
        else
            micuseresult=stdout
            widget:set_markup("<span color='#FF00FF'> MIC </span>")
        end
    else
        micuseresult=""
        widget:set_markup("<span color='#606060'> MIC </span>")
    end
end,
micusetext
)

--CAMUSE
local camusetext=wibox.widget.textbox()
local fuserresult=""
camusetext:connect_signal('mouse::enter', function()
    if(fuserresult~="") then
    naughty.notify({
        preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = "Monospace 10" },
        title = "CAM is used by",
        text = fuserresult,
        timeout= 2
    })
end
end)
watch(
    'fuser /dev/video0', 5,
    function(widget, stdout, stderr, exitreason, exitcode)
    if(exitcode == 0) then
        fuserresult=stdout
        widget:set_markup("<span color='#FF00FF'> CAM </span>")
    else
        fuserresult=""
        widget:set_markup("<span color='#606060'> CAM </span>")
    end
end,
camusetext
)

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local membar = arrowbar(5,3,"#606060",100)
local mem = lain.widget.mem({
    settings = function()
        membar:setValue(mem_now.perc)
        widget:set_markup(markup.font(theme.font, " " .. string.format("%.0f", (mem_now.perc))  .. "% "))
        --widget:set_markup(markup.svg(""))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpubar = arrowbar(5,3,"#606060",100)
local cpu = lain.widget.cpu({
    settings = function()
        cpubar:setValue(cpu_now[0].usage)
        widget:set_markup(markup.font(theme.font, " " .. cpu_now[0].usage  .. "% "))
    end
})

-- GPUTemps
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local tempa=tempbar(5,3,theme.bg_focus,"#606060",100)
local tempb=tempbar(5,3,theme.bg_focus,"#606060",100)
local temps = wibox.widget {
    tempa,
    tempb,
    wibox.widget.textbox(' '),
    layout  = wibox.layout.align.horizontal
}
watch(
    "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader", 5,
    function(widget, stdout, stderr, exitreason, exitcode)
    if(exitcode == 0) then
        local time=string.match(stdout,"(%d+)\n")
        local time2=string.match(stdout,"\n(%d+)")
        tempa:setValue(tonumber(time))
        tempb:setValue(tonumber(time2))
    end
end,
temps
)


local ctempa=tempbar(5,3,"#606060","#909090",100)
local ctempn=tempbar(5,3,theme.bg_focus,"#606060",100)
local ctemps = wibox.widget {
    ctempa,
    --ctempb,
    wibox.widget.textbox(' '),
    layout  = wibox.layout.align.horizontal
}
watch(
    "sensors -u", 5,
    function(widget, stdout, stderr, exitreason, exitcode)
    if(exitcode == 0) then
        local time=string.match(stdout,"Package id 0:\n%s+temp1_input:%s+(%d+)")
        local time2=string.match(stdout,"pci.0500\n.*\n%s+temp1_input:%s+(%d+)")
        ctempa:setValue(tonumber(time))
--        tempb:setValue(tonumber(time2))
        ctempn:setValue(tonumber(time2))
    end
end,
ctemps
)


local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. coretemp_now .. "° "))
    end
})

-- / fs
local fsicon = wibox.widget.imagebox(theme.widget_hdd)
theme.fs = lain.widget.fs({followtag=true, partition="/", threshold=80,
    notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = "Monospace 10" },
    settings = function()
        widget:set_markup(markup.font(theme.font, " " ..string.format("%.0f",  fs_now["/"].free ).. fs_now["/"].units .. " "))
    end
})
--[[ commented because it needs Gio/Glib >= 2.54
--]]

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                baticon:set_image(theme.widget_ac)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(theme.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(theme.widget_battery_low)
            else
                baticon:set_image(theme.widget_battery)
            end
            widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup(markup.font(theme.font, " AC "))
            baticon:set_image(theme.widget_ac)
        end
    end
})


-- LUKs
local lukswidget = wibox.widget.textbox()
watch(
    'bash -c "/usr/bin/lsblk -a | grep crypt"', 5,
    function(widget, stdout, stderr, exitreason, exitcode)

    if(exitcode == 0) then
        widget:set_markup(markup.font(theme.font, "<span color='#00AFFF'> LUKS </span>"))
    else
        widget:set_markup(markup.font(theme.font, "<span color='#606060'> LUKS </span>"))
    end
end,
lukswidget
)


-- SSHs
local sshswidget = wibox.widget.textbox()
watch(
    "service ssh status | grep running", 5,
    function(widget, stdout, stderr, exitreason, exitcode)
    if(exitcode == 0) then
        widget:set_markup("<span color='#00AFFF'> SSH </span>")
    else
        widget:set_markup("<span color='#606060'> SSH </span>")
    end
end,
sshswidget
)

-- VPN
local vpnwidget = wibox.widget.textbox()
watch(
    "ip addr show tun0", 5,
    function(widget, stdout, stderr, exitreason, exitcode)
    if(stdout == '' or stdout==nil or stdout=='Device "tun0" does not exist.') then
        widget:set_markup("<span color='#606060'> VPN </span>")
    else
        widget:set_markup(" <span color='#00FF00'> VPN </span>")
    end
end,
vpnwidget
)

-- Sound/Audio
local volicon = wibox.widget.imagebox(theme.widget_vol)

theme.volumecfg = volume_control({
   device="pulse",
    widget = arrowbar(4,3,"#606060",100), 
    callback = function(self, setting)
        if(setting.state=="off") then
            volicon:set_image(theme.widget_vol_mute)
        else
            if(setting.volume==0) then
                volicon:set_image(theme.widget_vol_no)
            elseif(setting.volume<=50) then
                volicon:set_image(theme.widget_vol_low)
            else
                volicon:set_image(theme.widget_vol)
            end
        end

        
        self.widget:setValue(setting.volume)
--        self.widget:set_image(
  --          get_image(setting.volume, setting.state))
    end
})

theme.kbdcfg = layout_indicator({
    layouts = {
        {name="us",  layout="us",  variant=nil},  
        {name="de",  layout="de",  variant=nil}
    },
-- optionally, specify commands to be executed after changing layout:ßß
--    post_set_hooks = {
 --       "xmodmap ~/.Xmodmap",
 --       "setxkbmap -option caps:escape"
 --   }
})

--GFX UTIL
local gfxwidget = wibox.widget.textbox()
local gfxa=arrowbar(5,3,theme.bg_focus,100)
local gfxb=arrowbar(5,3,theme.bg_focus,100)
local gfx2 = wibox.widget {
    temps,
    gfxa,
    gfxb,
    layout  = wibox.layout.align.horizontal
}
watch(
    "bash -c 'nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits'", 6,
    function(widget, stdout, stderr, exitreason, exitcode)
    if(exitcode == 0) then
        local time=string.match(stdout,"(%d+)\n")
        local time2=string.match(stdout,"\n(%d+)")
        gfxa:setValue(tonumber(time))
        gfxb:setValue(tonumber(time2))
    end
end,
gfx2
)


-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
if(false) then
local net = lain.widget.net({
    screen=2,
    wifi_state="on",
    eth_state="on",
    units=1024*1024,
    settings = function()
        io.stderr:write(string.format("%s \n",net_now.devices))
        for k, v in pairs(net_now.devices ) do
            io.stderr:write(string.format("%s %s\n",k,v))
        end
        local wlan0 = net_now.devices.wlp6s0
        if wlan0 then
            for k, v in pairs(wlan0 ) do
                io.stderr:write(string.format("%s %s\n",k,v))
            end
           local signal = wlan0.signal
           if signal then
            widget:set_markup("#7AC82E", " " .. string.format("s%d", signal))
           end
--        else
        end
      --  widget:set_markup(markup.font(theme.font,
      --                    string.format("%.1f", net_now.received)
      --                    .. "R " ..
      --                    string.format("%.1f", net_now.sent) .. "S "))
    end
})
end

local pingwidget = wibox.widget.textbox()
watch(
    "bash -c 'ping www.google.de -c 1 | grep time'", 5,
    function(widget, stdout, stderr, exitreason, exitcode)
    if(exitcode == 0) then
        local time=string.match(stdout,"time=(%d+).* ms")
        if time ~= nil then
        widget:set_markup(markup.font(theme.font, string.format("<span color='#00AFFF'>%d</span>",time)).." ")
        end
    else
        widget:set_markup(markup.font(theme.font, string.format("<span color='#FF0000'>NO PING</span>")))
    end
end,
pingwidget
)


local netswidget = wibox.widget.textbox()
watch(
    "bash -c 'nmcli -c no -g IN-USE,SIGNAL,SSID -w 1 dev wifi | grep \\*'", 7,
    function(widget, stdout, stderr, exitreason, exitcode)
    if(exitcode == 0) then
        local ss=string.match(stdout,"(%d+)")
        local ssid=string.match(stdout,"*:%d+:([%d%w]+)")
        widget:set_markup(markup.font(theme.font, string.format("<span color='#00AFFF'>%s</span> <span color='#d0d0d0'>%s</span>",ss,ssid)).." ")
    else
        widget:set_markup(markup.font(theme.font, string.format("<span color='#FF0000'>NO NET</span>")))
    end
end,
netswidget
)

-- Separators
local spr     = wibox.widget.textbox(' ')
local arrl_dl = separators.arrow_left(theme.bg_focus, "alpha")
local arrl_ld = separators.arrow_left("alpha", theme.bg_focus)

-- Background
function theme.at_screen_connect(s)

    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })
    --global_wallpaper.screens = s
    -- If wallpaper is a function, call it with the screen
    --local wallpaper = theme.wallpaper
    --if type(wallpaper) == "function" then
    --    wallpaper = wallpaper(s)
    --end

    gears.wallpaper.set("#313131")
    
    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))

                           s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)
    s.mytasklist = awful.widget.tasklist ({screen=s,filter=awful.widget.tasklist.filter.currenttags,buttons=awful.util.tasklist_buttons,style={disable_task_name = false, align="left",   shape_border_width = 0,
    bg_normal = '#202020',
    bg_selected = '#303030',
    spacing=-9, -- muhahahah, works
    shape  = gears.shape.powerline,
    font = theme.font2,
},
    layout   = {
        spacing = 0,
        margin=0,
        layout  = wibox.layout.fixed.horizontal -- show it without dots
    },    
    widget_template = {
        {
            
            {
                {
                    {
                        id     = 'icon_role',
                        widget = wibox.widget.imagebox,
                    },
                    margins = 0,
                    widget  = wibox.container.margin,
                },
                {
                    id     = 'text_role',
                    widget = wibox.widget.textbox,
                },
                
                layout = wibox.layout.fixed.horizontal,
            },
            left  = 18,
            right = 18,
            widget = wibox.container.margin
        },
        id     = 'background_role',
        widget = wibox.container.background,
    },})

    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(18), bg = theme.bg_normal, fg = theme.fg_normal })


    local staticWidgets={
        arrl_ld,
        wibox.container.background(clock, theme.bg_focus),
        wibox.container.background(spr,theme.bg_focus),
        arrl_dl,
        s.mylayoutbox, 
        spr,
        arrl_ld,
        wibox.container.background(theme.kbdcfg.widget,theme.bg_focus),
        wibox.container.background(spr,theme.bg_focus)
    }

    if s.index == mainscreen then
        local tray=wibox.widget.systray()
        tray:set_screen(s)
        tray:set_base_size(16)
        s.mywibox:setup {
            --expand = "inside",
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                --spr,
                s.mytaglist,
                s.mypromptbox,
                spr,
            },
            {
                layout = wibox.layout.fixed.horizontal,
                s.mytasklist, -- Middle widget
            },
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                wibox.container.margin(tray,1,1,4,4),
                micusetext,
                camusetext,
                lukswidget,
                sshswidget,
                vpnwidget,
                spr,

                arrl_ld,
                --wibox.container.background(tempicon, theme.bg_focus),
                --wibox.container.background(temp.widget, theme.bg_focus),
                wibox.container.background(memicon,theme.bg_focus),
                wibox.container.background(membar,theme.bg_focus),
                wibox.container.background(mem.widget,theme.bg_focus),
                arrl_dl,
                --arrl_ld,
                --wibox.container.background(mpdicon, theme.bg_focus),
                --wibox.container.background(theme.mpd.widget, theme.bg_focus),
                spr,
                gfx2,
                arrl_ld,
                wibox.container.background(cpuicon, theme.bg_focus),
                wibox.container.background(ctemps,theme.bg_focus),
                wibox.container.background(cpubar, theme.bg_focus),
                wibox.container.background(cpu.widget, theme.bg_focus),
                arrl_dl,
                fsicon,
                ctempn,
                theme.fs.widget,
                arrl_ld,
                wibox.container.background(volicon, theme.bg_focus),
                wibox.container.background(theme.volumecfg.widget, theme.bg_focus),
                arrl_dl,


                neticon,
                netswidget,
                pingwidget,
                table.unpack(staticWidgets)
            },
        }
    else
        s.mywibox:setup {
            --expand = "inside",
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                --spr,
                s.mytaglist,
                s.mypromptbox,
                spr,
            },
            {
                layout = wibox.layout.fixed.horizontal,
                s.mytasklist, -- Middle widget
            },

            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
--                tray,
 --               tray,
                spr,

                micusetext,
                camusetext,
                lukswidget,
                sshswidget,
                vpnwidget,

                table.unpack(staticWidgets)
            },
        }
    end
end

-- wibox.widget.systray():set_screen(1)

return theme
