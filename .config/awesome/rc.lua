--[[
    my Awesome 4.3 Setup
    originally from
     Awesome WM configuration template powerarrow-dark
     github.com/lcpz
--]] 

local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears = require("gears")
local awful = require("awful")
local _ = require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local lain = require("lain")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local _ = require("awful.hotkeys_popup.keys")
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi = require("beautiful.xresources").apply_dpi

local chosen_theme = "powerarrow-dark-mod"
local modkey = "Mod4"
local altkey = "Mod1"
local terminal = "x-terminal-emulator"
local vi_focus = false -- vi-like client focus - https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev = false -- cycle trough all previous client or just the first -- https://github.com/lcpz/awesome-copycats/issues/274
local editor = os.getenv("EDITOR") or "vim"
local gui_editor = os.getenv("GUI_EDITOR") or "code"
local browser = os.getenv("BROWSER") or "google-chrome"
local scrlocker = "slock"
local scrlocker_suspend = "systemctl suspend"

-- Notification Presets
naughty.config.defaults.timeout = 3
naughty.config.presets.low.timeout = 3
naughty.config.presets.normal.timeout = 3
naughty.config.presets.critical.timeout = 10
naughty.config.padding = dpi(20)
naughty.config.icon_size = dpi(32)

-- fix slow menubar - no need for icons
menubar.menu_gen.lookup_category_icons = function() end

-- include Snapd and FlatPak in menu
menubar.menu_gen.all_menu_dirs = {'/usr/share/applications/','/var/lib/snapd/desktop/applications/', "~/.local/share/flatpak/exports/share/applications", "/var/lib/flatpak/exports/share/applications"}

-- {{{ Error handling
if awesome.startup_errors then naughty.notify({preset = naughty.config.presets.critical, title = "Awesome Startup Errors!", text = awesome.startup_errors}) end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    if in_error then return end
    in_error = true
    naughty.notify({preset = naughty.config.presets.critical, title = "Oops, an error happened!", text = tostring(err)})
    in_error = false
  end)
end
-- }}}

-- {{{ Autostart windowless processes / daemons
-- This function will run once every time Awesome is started - i use .xprofile instead
-- local function run_once(cmd_arr) for _, cmd in ipairs(cmd_arr) do awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd)) end end
-- run_once({ "urxvtd", "unclutter -root" }) 
-- run_once({"xset +dpms s 180 180"})

-- This function implements the XDG autostart specification
-- list each of your autostart commands, followed by ; inside single quotes, followed by ..
-- 'dex --environment Awesome --autostart --search-paths "~/.config/autostart' -- https://github.com/jceb/dex

if true then
  awful.spawn.with_shell('if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' .. 'xrdb -merge <<< "awesome.started:true";' ..
                           'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"')
end


awesome.connect_signal("startup", function()
  -- spawn_once("firefox","Firefox33",3,3)
  -- cmd = { awful.util.shell, '-c', "firefox www.microsoft.com" }
  -- awful.spawn.once("google-chrome www.microsoft.com", { floating = true, screen = 3, tag = "2" })
  -- awful.spawn.once(cmd, { floating = false, screen = 4, tag = "1" })

  -- didn't work for terminals. long story short: put it in .xprofile and use awesome rules later on
  -- awful.spawn.once(terminal .. "  -plogs -T 'sys:logs' -e \"zsh -c 'source ~/.zshrc && slogs'\"", { maximized=true, screen = 3, tag = "3" })
end)

awful.util.terminal = terminal
awful.util.tagnames = {"1", "2", "3", "4", "5"}

awful.layout.layouts = {
  awful.layout.suit.tile, awful.layout.suit.tile.left, awful.layout.suit.tile.bottom, awful.layout.suit.tile.top, awful.layout.suit.floating
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
  -- lain.layout.cascade,
  -- lain.layout.cascade.tile,
  -- lain.layout.centerwork,
  -- lain.layout.centerwork.horizontal,
  -- lain.layout.termfair,
  -- lain.layout.termfair.center,
}

-- TagList Mouse
awful.util.taglist_buttons = my_table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({modkey}, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end), 
  awful.button({modkey}, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end), 
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end))

-- TaskList Mouse
awful.util.tasklist_buttons = my_table.join(awful.button({}, 1, function(c)
  if c == client.focus then
    c.minimized = true
  else
    -- c:emit_signal("request::activate", "tasklist", {raise = true})<Paste>

    -- Without this, the following
    -- :isvisible() makes no sense
    c.minimized = false
    if not c:isvisible() and c.first_tag then c.first_tag:view_only() end
    -- This will also un-minimize
    -- the client, if needed
    client.focus = c
    c:raise()
  end
end), awful.button({}, 2, function(c) c:kill() end), awful.button({}, 3, function()
  local instance = nil

  return function()
    if instance and instance.wibox.visible then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({theme = {width = dpi(250)}})
    end
  end
end), awful.button({}, 4, function() awful.client.focus.byidx(1) end), awful.button({}, 5, function() awful.client.focus.byidx(-1) end))

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = dpi(2)
lain.layout.cascade.tile.offset_y = dpi(32)
lain.layout.cascade.tile.extra_padding = dpi(5)
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))

-- {{{ Menu
local myawesomemenu = {
  {"hotkeys", function() return false, hotkeys_popup.show_help end}, {"manual", terminal .. " -e man awesome"},
  {"edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile)}, {"restart", awesome.restart}, {"quit", function() awesome.quit() end}
}

-- menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it

-- {{{ Screen
screen.connect_signal("property::geometry", function(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function(s)
  local only_one = #s.tiled_clients == 1
  for _, c in pairs(s.clients) do
    if only_one and not c.floating or c.maximized then
      c.border_width = 0
    else
      c.border_width = beautiful.border_width
    end
  end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) 
  beautiful.at_screen_connect(s) 
  awful.screen.focus(2)

end)

-- {{{ Spotify
function sendToSpotify(command)
  return function ()
    awful.util.spawn_with_shell("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player." .. command)
  end
end

function sendSpotifyVolume(vol)
  return function()
    awful.util.spawn_with_shell("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Set string:'org.mpris.MediaPlayer2.Player' string:'Volume' variant:double:"..vol)
  end
end

-- }}}


-- {{{ Mouse bindings for root - disabled
--root.buttons(my_table.join( --    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),awful.button({}, 4, awful.tag.viewnext),
--  awful.button({}, 5, awful.tag.viewprev)))
-- }}}

local screenFocus = { modkey,altkey } -- {"Control", altkey}
local screenMove = { modkey , altkey, "Shift"} -- {"Control", altkey, "Shift"}
local tagFocus = { "Control",modkey }
local tagMove = { "Control",modkey,"Shift" }

-- use for Notebooks
if(false) then
  local globalNotebookKeys =my_table.join(
  awful.key({}, "XF86MonBrightnessUp", function() os.execute("xbacklight -inc 10") end, {description = "+10%", group = "hotkeys"}),
  awful.key({}, "XF86MonBrightnessDown", function() os.execute("xbacklight -dec 10") end, {description = "-10%", group = "hotkeys"})
  )
end

globalScreenKeys = my_table.join(
  -- Screen 
  awful.key({altkey}, "Tab", function() awful.screen.focus_relative(1) end, {description = "focus the next screen", group = "screen"}),
  awful.key({altkey, "Shift"}, "Tab", function() awful.screen.focus_relative(-1) end, {description = "focus the previous screen", group = "screen"})
)

globalNumpadKeys=my_table.join(
  awful.key({modkey, }, "#86", function() lain.util.useless_gaps_resize(15) end, {description = "increment useless gaps", group = "layout"}),
  awful.key({modkey, }, "#82", function() lain.util.useless_gaps_resize(-15) end, {description = "decrement useless gaps", group = "layout"}), 
  awful.key({modkey }, "#83", function() awful.tag.incmwfact(0.05) end, {description = "increase main-window width factor", group = "layout"}),
  awful.key({modkey}, "#85", function() awful.tag.incmwfact(-0.05) end, {description = "decrease main-window width factor", group = "layout"})
)

-- {{{ Key bindings
globalkeys = my_table.join( 
  globalNotebookKeys,
  globalScreenKeys,
  globalNumpadKeys,

  -- Media
  awful.key({ }, "XF86AudioNext", sendToSpotify("Next")), 
  awful.key({ }, "XF86AudioPrev", sendToSpotify("Previous")), 
  awful.key({ }, "XF86AudioPlay", sendToSpotify("PlayPause")), 
  awful.key({ }, "XF86AudioStop", sendToSpotify("Stop")), 
--  awful.key({ }, "XF86AudioMute", beautiful.volumecfg:toggle()), 

  -- Lock
  awful.key({altkey, "Control"}, "l", function() os.execute(scrlocker_suspend) end, {description = "lock and suspend", group = "hotkeys"}),
  awful.key({altkey, "Control", "Shift"}, "l", function() os.execute(scrlocker) end, {description = "lock", group = "hotkeys"}), 
  
  -- Screenshot and Video
  awful.key({modkey}, "Print", function() awful.util.spawn_with_shell("gnome-screenshot --interactive") end, {description = "screenshot", group = "hotkeys"}), 
  awful.key({modkey,"Shift"}, "Print", function() awful.util.spawn_with_shell("kazam") end, {description = "screenshot", group = "hotkeys"}), 

  awful.key({"Shift", "Control"}, "Home", function() beautiful.kbdcfg:next() end, {description = "Next Keyboard layout", group = "hotkeys"}), 

  -- Awesome
  awful.key({modkey, "Control"}, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
  awful.key({modkey, "Shift"}, "q", awesome.quit, {description = "quit awesome", group = "awesome"}),  
  awful.key({modkey}, "s", hotkeys_popup.show_help, {description = "show help", group = "awesome"}),
  awful.key({modkey}, "b", function()
    for s in screen do
      s.mywibox.visible = not s.mywibox.visible
      if s.mybottomwibox then s.mybottomwibox.visible = not s.mybottomwibox.visible end
    end
  end, {description = "toggle wibox", group = "awesome"}), 

  -- Tag browsing
  awful.key(tagFocus, "Left", awful.tag.viewprev, {description = "view previous", group = "tag"}), 
  awful.key(tagFocus, "Right", awful.tag.viewnext, {description = "view next", group = "tag"}),
  awful.key({modkey}, "Escape", awful.tag.history.restore, {description = "go back", group = "tag"}), 

  -- Dynamic tagging
  awful.key({modkey, "Shift"}, "n", function() lain.util.add_tag() end, {description = "add new tag", group = "tag"}),
  awful.key({modkey, "Shift"}, "r", function() lain.util.rename_tag() end, {description = "rename tag", group = "tag"}),
  awful.key({modkey, "Shift"}, "d", function() lain.util.delete_tag() end, {description = "delete tag", group = "tag"}), 

  -- Window/Client navigation
  awful.key({modkey}, "u", awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}), 
  awful.key({modkey}, "Tab", function()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end, {description = "next window", group = "client"}), 
  awful.key({modkey, "Shift"}, "Tab", function()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end, {description = "previous window", group = "client"}), 
  
  -- Layout manipulation
  awful.key({modkey, "Shift"}, "j", function() awful.client.swap.byidx(1) end, {description = "swap with next client by index", group = "client"}),
  awful.key({modkey, "Shift"}, "k", function() awful.client.swap.byidx(-1) end, {description = "swap with previous client by index", group = "client"}),
  
  -- main window Width
  awful.key({modkey, altkey, "Control"}, "Right", function() awful.tag.incmwfact(0.05) end, {description = "increase main-window width factor", group = "layout"}),
  awful.key({modkey, altkey, "Control"}, "Left", function() awful.tag.incmwfact(-0.05) end, {description = "decrease main-window width factor", group = "layout"}), 
  
  -- On the fly useless gaps change
  awful.key({modkey, "Control"}, "=", function() lain.util.useless_gaps_resize(15) end, {description = "increment useless gaps", group = "layout"}),
  awful.key({modkey, "Control"}, "-", function() lain.util.useless_gaps_resize(-15) end, {description = "decrement useless gaps", group = "layout"}), 

  -- Layout
  awful.key({altkey, "Shift"}, "l", function() awful.tag.incmwfact(0.05) end, {description = "increase master width factor", group = "layout"}),
  awful.key({altkey, "Shift"}, "h", function() awful.tag.incmwfact(-0.05) end, {description = "decrease master width factor", group = "layout"}),
  awful.key({modkey, "Shift"}, "h", function() awful.tag.incnmaster(1, nil, true) end, {description = "increase the number of master clients", group = "layout"}),
  awful.key({modkey, "Shift"}, "l", function() awful.tag.incnmaster(-1, nil, true) end, {description = "decrease the number of master clients", group = "layout"}),
  awful.key({modkey, "Control"}, "h", function() awful.tag.incncol(1, nil, true) end, {description = "increase the number of columns", group = "layout"}),
  awful.key({modkey, "Control"}, "l", function() awful.tag.incncol(-1, nil, true) end, {description = "decrease the number of columns", group = "layout"}),
  awful.key({modkey}, "space", function() awful.layout.inc(1) end, {description = "next layout", group = "layout"}),
  awful.key({modkey, "Shift"}, "space", function() awful.layout.inc(-1) end, {description = "previous layout", group = "layout"}), 
  
  -- ALSA volume control
  awful.key({modkey}, "Page_Up", function() beautiful.volumecfg:up() end, {description = "volume up", group = "sound"}), 
  awful.key({modkey}, "Page_Down", function()   beautiful.volumecfg:down() end, {description = "volume down", group = "sound"}),
  awful.key({modkey}, "Home", function() beautiful.volumecfg:unmute() end, {description = "unmute", group = "sound"}), 
  awful.key({modkey}, "End", function() beautiful.volumecfg:mute() end, {description = "mute", group = "sound"}), 

  -- Copy primary to clipboard (terminals to gtk) -- Copy clipboard to primary (gtk to terminals)
  awful.key({modkey}, "c", function() awful.spawn.with_shell("xsel | xsel -i -b") end, {description = "copy terminal to gtk", group = "hotkeys"}),
  awful.key({modkey}, "v", function() awful.spawn.with_shell("xsel -b | xsel") end, {description = "copy gtk to terminal", group = "hotkeys"}), 

  -- Launcher
  -- Dropdown application - QUAKE not used currently
  --awful.key({modkey}, "z", function() awful.screen.focused().quake:toggle() end, {description = "dropdown application", group = "launcher"}),
  awful.key({modkey}, "p", function() menubar.show() end, {description = "show the menubar", group = "launcher"}), -- Brightness
      
    -- User programs
  awful.key({modkey, "Shift"}, "Return", function() awful.spawn(browser) end, {description = "run browser", group = "launcher"}),
  awful.key({modkey}, "d", function() awful.spawn("nautilus") end, {description = "run files", group = "launcher"}),
  awful.key({modkey}, "j", function() awful.spawn("qalculate-gtk") end, {description = "run files", group = "launcher"}),
  awful.key({modkey}, "a", function() awful.spawn(gui_editor) end, {description = "run gui editor", group = "launcher"}),
  awful.key({modkey}, "Return", function() awful.spawn(terminal) end, {description = "open a terminal", group = "launcher"}), 
  
   -- Screen
  awful.key(screenFocus, "Down", function(c) awful.screen.focus(2) end, {description = "focus to main screen", group = "screen"}),
  awful.key(screenFocus, "Left", function(c) awful.screen.focus(3) end, {description = "focus to left screen", group = "screen"}),
  awful.key(screenFocus, "Right", function(c) awful.screen.focus(1) end, {description = "focus to right screen", group = "screen"}),

  -- Default Prompt
  awful.key({modkey}, "r", function() awful.screen.focused().mypromptbox:run() end, {description = "run prompt", group = "launcher"}), awful.key({modkey}, "x", function()
    awful.prompt.run {
      prompt = "Run Lua code: ",
      textbox = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval"
    }
  end, {description = "lua execute prompt", group = "awesome"}) -- ]]
)

clientkeys = my_table.join(

  -- Client
  awful.key({modkey}, "q", function(c) c:kill() end, {description = "close", group = "client"}),

  -- Layout
  awful.key({modkey}, "t", function(c) c.ontop = not c.ontop end, {description = "toggle keep on top", group = "client"}), 
  awful.key({modkey}, "m", function(c) c.minimized = true end, {description = "minimize", group = "client"}), 
  awful.key({modkey, "Control"}, "m", function()
    local c = awful.client.restore()
    if c then
      client.focus = c
      c:raise()
    end
  end, {description = "restore minimized", group = "client"}), 
  awful.key({altkey, "Shift"}, "m", lain.util.magnify_client, {description = "magnify client", group = "client"}),
  awful.key({modkey}, "k", awful.titlebar.toggle, {description = "Show/Hide Titlebars", group = "client"}), 


  awful.key({modkey}, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, {description = "toggle fullscreen", group = "client"}), 
  awful.key({modkey, "Control"}, "space", awful.client.floating.toggle, {description = "toggle floating", group = "client"}),
  awful.key({modkey, "Control"}, "Return", function(c) c:swap(awful.client.getmaster()) end, {description = "move to master", group = "client"}), 
  
  -- Screen Navigation
  awful.key({modkey}, "o", function(c) c:move_to_screen() end, {description = "move to screen", group = "screen"}),

   -- Screen
  awful.key(screenMove, "Down", function(c) c:move_to_screen(2) end, {description = "move to main screen", group = "screen"}),
  awful.key(screenMove, "Left", function(c) c:move_to_screen(3) end, {description = "move to left screen", group = "screen"}),
  awful.key(screenMove, "Right", function(c) c:move_to_screen(1) end, {description = "move to right screen", group = "screen"}),

  -- Tag Navigation
  awful.key(tagMove, "Left", function()
    local t = client.focus and client.focus.first_tag or nil
    if t == nil then return end
    local tag = client.focus.screen.tags[(t.index - 2) % 5 + 1]
    awful.client.movetotag(tag)
    awful.tag.viewprev()
  end, {description = "move client to previous tag", group = "layout"}), 
  
  awful.key(tagMove, "Right", function()
    local t = client.focus and client.focus.first_tag or nil
    if t == nil then return end
    local tag = client.focus.screen.tags[(t.index % 5) + 1]
    awful.client.movetotag(tag)
    awful.tag.viewnext()
  end, {description = "move client to next tag", group = "layout"}), 

  -- Maximize
  awful.key({modkey}, "Down", function(c)
    c.maximized = false
    c:raise()
  end, {description = "unmaximize", group = "client"}), 
  
  awful.key({modkey}, "Up", function(c)
    c.maximized = true -- not c.maximized
    c:raise()
  end, {description = "maximize", group = "client"}))

 --[[ dmenu
    awful.key({ modkey,"Shift" }, "x", function ()
            os.execute(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "launcher"}),
    --]] -- alternatively use rofi, a dmenu-like application with more features
  -- check https://github.com/DaveDavenport/rofi for more details
  --[[ rofi
    awful.key({ modkey }, "x", function ()
            os.execute(string.format("rofi -show %s -theme %s",
            'run', 'dmenu'))
        end,
        {description = "show rofi", group = "launcher"}),
    --]]

-- Bind all key numbers to tags.
for i = 1, 9 do
  -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
  local descr_view, descr_toggle, descr_move, descr_toggle_focus
  if i == 1 or i == 9 then
    descr_view = {description = "view tag #", group = "tag"}
    descr_toggle = {description = "toggle tag #", group = "tag"}
    descr_move = {description = "move focused client to tag #", group = "tag"}
    descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
  end
  globalkeys = my_table.join(globalkeys, -- View tag only.
  awful.key({modkey}, "#" .. i + 9, function()
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then tag:view_only() end
  end, descr_view), 
  -- Toggle tag display.
  awful.key({modkey, "Control"}, "#" .. i + 9, function()
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then awful.tag.viewtoggle(tag) end
  end, descr_toggle), 
  -- Move client to tag.
  awful.key({modkey, "Shift"}, "#" .. i + 9, function()
    if client.focus then
      local tag = client.focus.screen.tags[i]
      if tag then client.focus:move_to_tag(tag) end
    end
  end, descr_move), 
  -- Toggle tag on focused client.
  awful.key({modkey, "Control", "Shift"}, "#" .. i + 9, function()
    if client.focus then
      local tag = client.focus.screen.tags[i]
      if tag then client.focus:toggle_tag(tag) end
    end
  end, descr_toggle_focus))
end

clientbuttons = gears.table.join(
 awful.button({}, 1, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}) end), 
 awful.button({modkey}, 1, function(c)
  c:emit_signal("request::activate", "mouse_click", {raise = true})
  awful.mouse.client.move(c)
end), 
awful.button({modkey}, 3, function(c)
  c:emit_signal("request::activate", "mouse_click", {raise = true})
  awful.mouse.client.resize(c)
end))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      size_hints_honor = false
    }
  }, 
  -- Titlebars

    -- Floating clients.
    { rule_any = {
      instance = {
        "qalculate-gtk",  -- Firefox addon DownThemAll.
      },
      class = {
        "qalculate-gtk",
      },
      name = {
        "Qalculate!",  -- xev.
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      }
    }, properties = { floating = true }},

  {rule_any = {type = {"dialog", "normal"}}, properties = {titlebars_enabled = true}}, 
  {rule = {name = "sys:logs"}, properties = {screen = 3, tag = "1", titlebars_enabled = false}},
  {rule = {class = "Gimp", role = "gimp-image-window"}, properties = {maximized = true}}
}
-- }}}

-- {{{ Signals
client.connect_signal("manage", function(c)
  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- {{ Personal keybindings
client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings({
    -- show/hide titlebar
    awful.key({modkey}, "k", awful.titlebar.toggle, {description = "Show/Hide Titlebars", group = "client"})
  })
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- Custom
  if beautiful.titlebar_fun then
    beautiful.titlebar_fun(c)
    return
  end

  -- Default
  -- buttons for the titlebar
  local buttons = my_table.join(
    awful.button({}, 1, function()
    c:emit_signal("request::activate", "titlebar", {raise = true})
    awful.mouse.client.move(c)
  end),
   awful.button({}, 2, function() c:kill() end), 
   awful.button({}, 3, function()
    c:emit_signal("request::activate", "titlebar", {raise = true})
    awful.mouse.client.resize(c)
  end))

  awful.titlebar(c, {size = dpi(16)}):setup{
    { -- Left
      --          awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal
    },
    { -- Middle
      { -- Title
        align = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal
    },
    { -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--   c:emit_signal("request::activate", "mouse_enter", {raise = vi_focus})
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- possible workaround for tag preservation when switching back to default screen:
-- https://github.com/lcpz/awesome-copycats/issues/251
-- }}}

--
