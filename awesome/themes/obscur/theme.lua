local awful = require("awful")
local theme = {}

themedir    = awful.util.getdir("config") .. "/themes/obscur/"
theme.font          = "sans 7"

theme.bg_normal     = "#000000"
theme.bg_focus      = "#FF2222"
theme.bg_urgent     = "#FF2222"
theme.bg_minimize   = "#444444"
theme.bg_widget     = "#000000"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#AAAAAA"
theme.fg_focus      = "#FFFFFF"
theme.fg_urgent     = "#FFFFFF"
theme.fg_minimize   = "#FFFFFF"

theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#FF2222"
theme.border_marked = "#222222"

theme.useless_gap   = 0

theme.taglist_squares_sel    = themedir .. "/icons/squarew.png"
theme.taglist_squares_unsel  = themedir .. "/icons/squarefw.png"

theme.layout_floating        = themedir .. "/icons/floating.png"
theme.layout_tile            = themedir .. "/icons/tile.png"
theme.layout_tileleft        = themedir .. "/icons/tileleft.png"
theme.layout_tilebottom      = themedir .. "/icons/tilebottom.png"
theme.layout_tiletop         = themedir .. "/icons/tiletop.png"
theme.layout_fairv           = themedir .. "/icons/fairv.png"
theme.layout_fairh           = themedir .. "/icons/fairh.png"
theme.layout_spiral          = themedir .. "/icons/spiral.png"
theme.layout_dwindle         = themedir .. "/icons/dwindle.png"
theme.layout_max             = themedir .. "/icons/max.png"
theme.layout_fullscreen      = themedir .. "/icons/max.png"
theme.layout_cornernw        = themedir .. "/icons/cornernw.png"
theme.layout_magnifier       = themedir .. "/icons/magnifier.png"
theme.layout_cornerne        = themedir .. "/icons/magnifier.png"
theme.layout_cornersw        = themedir .. "/icons/magnifier.png"
theme.layout_cornerse        = themedir .. "/icons/magnifier.png"

theme.wallpaper              = themedir .. "background.jpg"

theme.icon_theme = nil

return theme
