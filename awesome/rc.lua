local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local vicious       = require("vicious")
require("awful.autofocus")

beautiful.init(awful.util.getdir("config") .. "/themes/obscur/theme.lua")

local terminal   = "urxvt"
local modkey     = "Mod4"
local tags       = { "1", "2", "3", "4", "S", "M", "V", "T", "W" }

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.corner.nw
	-- awful.layout.suit.magnifier,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}

function changeScreen(screen, tag)
	local s = awful.screen.focused()
	s.label.markup = "[ F" .. s.index .. " ]"
	awful.screen.focus(screen)

	s = awful.screen.focused()
	s.label.markup = "<span color='#FF0000'>[ F" .. s.index .. " ]</span>"
	s.tags[tag]:view_only()
end

function openGUIAppAt(app, ts, tt)
	changeScreen(ts, tt)
	awful.util.spawn_with_shell("pgrep -f -u $USER -x " .. app .. " || " .. app)
end

function openTermAppAt(app, ts, tt)
	changeScreen(ts, tt)

	local file = io.popen("pgrep -f -u $USER -x " .. app)
	if file:read('*all') == "" then
		awful.spawn(terminal .. " -e " .. app, { tag = tags[tt], screen = ts })
	end
end

function initMyWorkspace()
	openTermAppAt("newsbeuter", 1, 5)
	openTermAppAt("mutt", 1, 6)
	openGUIAppAt("iceweasel", 1, 9)

	awful.spawn("xscreensaver -no-splash")
end

uptime  = wibox.widget.textbox()
temp    = wibox.widget.textbox()
cpu     = wibox.widget.textbox()
memory  = wibox.widget.textbox()
disk    = wibox.widget.textbox()
up      = wibox.widget.textbox()
down    = wibox.widget.textbox()
wifi    = wibox.widget.textbox()
battery = wibox.widget.textbox()
volume  = wibox.widget.textbox()
clock   = wibox.widget.textclock("[ ⌚ %d/%b :: %I:%M ]", 60)

vicious.register(uptime, vicious.widgets.uptime,
	function(widget, args)
		if args[1] >= 1 or args[2] >= 8 then
			return "<span color='#FF0000'>[ ⌛ " .. args[1] .. ":" .. args[2] .. ":" .. args[3] .. " ]</span>"
		end

		return  "[ ⌛ " .. args[1] .. ":" .. args[2] .. ":" .. args[3] .. " ]"
	end, 60)
vicious.register(memory, vicious.widgets.mem, "[ ⛃ $1% :: $2 MB ]", 60)
vicious.register(volume, vicious.widgets.volume, "[ ♬ $1% ]", 60, "Master")
vicious.register(cpu, vicious.widgets.cpu, "[ ✇ $1% ]", 60)
vicious.register(battery, vicious.widgets.bat,
	function(widget, args)
		if args[1] == "-" and args[2] < 10 then
			naughty.notify({ title = "Battery Warning", text = "Battery level below 10%", timeout = 10, position = "top_right", fg = beautiful.fg_urgent, bg = beautiful.bg_urgent })
			return "<span color='#FF0000'>[ ⚡ " .. args[2] .. "% ]</span>"
		end

		return "[ ⚡ " .. args[2] .. "% ]"
	end, 120, "BAT0")
vicious.register(temp, vicious.widgets.thermal,
	function (widget, args)
		if  args[1] >= 70 then
			return "<span color='#FF0000'>[ ❕  " .. args[1] .. " ºC ]</span>"
		end

		return "[ ❕  " .. args[1] .. " ºC ]"
	end, 120, "thermal_zone0" )
vicious.register(wifi, vicious.widgets.wifi,
	function(widget, args)
		return "[ ✺ " .. args["{linp}"] .. "% ]"
	end, 60, "eth0" )
vicious.register(disk, vicious.widgets.fs,
	function(widget, args)
		local used = args["{/ used_gb}"]
		local avail = args["{/ avail_gb}"]
		local total = math.floor(used * 100 / (avail + used))

		return "[ ⛁ " .. total .. "% :: " .. avail .. " GB ]"
	end, 3600 )
vicious.register(down, vicious.widgets.net, "[ ⇩ ${eth0 down_kb} kbps ]")
vicious.register(up, vicious.widgets.net, "[ ⇧ ${eth0 up_kb} kbps ]")

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
	awful.button({        }, 1,
		function(t)
			t:view_only()
		end
	),
	awful.button({ modkey }, 1,
		function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end
	),
	awful.button({        }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3,
		function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end
	),
	awful.button({ }, 4,
		function(t)
			awful.tag.viewnext(t.screen)
		end
	),
	awful.button({ }, 5,
		function(t)
			awful.tag.viewprev(t.screen)
		end
	)
)

local function set_wallpaper(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
	function(s)
		set_wallpaper(s)
		awful.tag(tags, s, awful.layout.layouts[2])

		s.promptbox = awful.widget.prompt()
		s.layoutbox = awful.widget.layoutbox(s)
		s.layoutbox:buttons(
			awful.util.table.join(
				awful.button({ }, 1, function () awful.layout.inc( 1) end),
				awful.button({ }, 3, function () awful.layout.inc(-1) end),
				awful.button({ }, 4, function () awful.layout.inc( 1) end),
				awful.button({ }, 5, function () awful.layout.inc(-1) end)
			)
		)

		s.label   = wibox.widget.textbox("[ F" .. s.index .. " ]")
		s.taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
		s.wibox   = awful.wibar({ position = "top", screen = s })
		s.wibox:setup {
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				s.taglist,
			},
			s.promptbox,
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				s.label,
				uptime,
				temp,
				cpu,
				memory,
				disk,
				up,
				down,
				wifi,
				battery,
				volume,
				clock,
				s.layoutbox,
			},
		}
	end
)

-- Key bindings
globalkeys = awful.util.table.join(
	awful.key({ modkey,           }, "Left", awful.tag.viewprev),
	awful.key({ modkey,           }, "Right", awful.tag.viewnext),
	awful.key({ modkey,           }, "u", awful.tag.history.restore),
	awful.key({ modkey,           }, "j",
		function ()
			awful.client.focus.byidx( 1)
		end),
	awful.key({ modkey,           }, "k",
		function ()
			awful.client.focus.byidx(-1)
		end),
	awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
	awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
	awful.key({ modkey,           }, "p",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end),
	awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end),
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit),
	awful.key({ modkey,           }, "l",      function () awful.tag.incmwfact( 0.05)          end),
	awful.key({ modkey,           }, "h",      function () awful.tag.incmwfact(-0.05)          end),
	awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1, nil, true) end),
	awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1, nil, true) end),
	awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1, nil, true)    end),
	awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1, nil, true)    end),
	awful.key({ modkey,           }, "space",  function () awful.layout.inc( 1)                end),
	awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(-1)                end),
	awful.key({ modkey, "Control" }, "n",
		function ()
			local c = awful.client.restore()
			if c then
				client.focus = c
				c:raise()
			end
		end),
	awful.key({ modkey,           }, "r",      function () awful.screen.focused().promptbox:run() end),
	awful.key({                   }, "Print",  function () awful.util.spawn_with_shell("DATE=`date +%d.%m.%Y_%H:%M:%S`; scrot -q 90 $HOME/$DATE.jpg") end),
	awful.key({ modkey,           }, "Tab",
		function ()
			if mouse.screen.index == 1 then
				changeScreen(2)
			else
				changeScreen(1)
			end
		end),
	awful.key({ modkey,           }, "F1",  function () changeScreen(1) end),
	awful.key({ modkey,           }, "F2",  function () changeScreen(2) end),
	awful.key({ modkey,           }, "F9" , function () awful.util.spawn_with_shell("amixer -q sset Master 5%-") end),
	awful.key({ modkey,           }, "F10", function () awful.util.spawn_with_shell("amixer -q sset Master 5%+") end),
	awful.key({ modkey,           }, "F11", function () awful.util.spawn_with_shell("amixer -q sset Master toggle") end),
	awful.key({ modkey,           }, "F12", function () awful.util.spawn("xscreensaver-command -lock") end),
	awful.key({ modkey,           }, "a"  , function () awful.util.spawn_with_shell(terminal .. " -e alsamixer") end),
	awful.key({ modkey,           }, "w"  , function () openGUIAppAt("iceweasel",1,9) end),
	awful.key({ modkey,           }, "t"  , function () openGUIAppAt("transmission-gtk",1,8) end),
	awful.key({ modkey,           }, "v"  , function () openGUIAppAt("vlc",1,7) end),
	awful.key({ modkey,           }, "m"  , function () openTermAppAt("mutt",1, 6) end),
	awful.key({ modkey,           }, "s"  , function () openTermAppAt("newsbeuter",1, 5) end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end),
	awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end),
	awful.key({ modkey,           }, "n",
		function (c)
			c.minimized = true
		end),
	awful.key({ modkey,           }, "m",
		function (c)
			c.maximized = not c.maximized
			c:raise()
		end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
	awful.key({ modkey }, "#" .. i + 9,
		function ()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end),
	awful.key({ modkey, "Control" }, "#" .. i + 9,
		function ()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end),
	awful.key({ modkey, "Shift" }, "#" .. i + 9,
		function ()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end),
	awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
		function ()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end))
end

clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			titlebars_enabled = false,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen,
		}
	},
	{ rule = { instance = terminal }, properties = { size_hints_honor = false } },
	{ rule = { instance = "Navigator" }, properties = { screen = 1, tag = "W" } },
	{ rule = { instance = "transmission-gtk" }, properties = { screen = 1, tag = "T" } },
	{ rule = { instance = "vlc" }, properties = { screen = 1, tag = "V" } }
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and
	not c.size_hints.user_position
	and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
		and awful.client.focus.filter(c) then
		client.focus = c
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

initMyWorkspace();
