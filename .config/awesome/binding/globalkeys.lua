-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- local hotkeys_popup = require("awful.hotkeys_popup").widget
local hotkeys_popup = require("awful.hotkeys_popup")
-- Menubar library
local menubar = require("menubar")

-- Resource Configuration
local modkey = RC.vars.modkey
local altkey = "Mod1"

-- define moudule table
local keys = {}

local terminal = RC.vars.terminal

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local _M = {}

-- reading
-- https://awesomewm.org/wiki/Global_Keybindings

-- Move given client to given direction
local function move_client(c, direction)
    -- If client is floating, move to edge
    if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
        local workarea = awful.screen.focused().workarea
        if direction == "up" then
            c:geometry({ nil, y = workarea.y + beautiful.useless_gap * 2, nil, nil })
        elseif direction == "down" then
            c:geometry({
                nil,
                y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 2 -
                    beautiful.border_width * 2,
                nil,
                nil
            })
        elseif direction == "left" then
            c:geometry({ x = workarea.x + beautiful.useless_gap * 2, nil, nil, nil })
        elseif direction == "right" then
            c:geometry({
                x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 2 -
                    beautiful.border_width * 2,
                nil,
                nil,
                nil
            })
        end
        -- Otherwise swap the client in the tiled layout
    elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
        if direction == "up" or direction == "left" then
            awful.client.swap.byidx(-1, c)
        elseif direction == "down" or direction == "right" then
            awful.client.swap.byidx(1, c)
        end
    else
        awful.client.swap.bydirection(direction, c, nil)
    end
end

-- Resize client in given direction
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating or (c and c.floating) then
        if direction == "up" then
            c:relative_move(0, 0, 0, -floating_resize_amount)
        elseif direction == "down" then
            c:relative_move(0, 0, 0, floating_resize_amount)
        elseif direction == "left" then
            c:relative_move(0, 0, -floating_resize_amount, 0)
        elseif direction == "right" then
            c:relative_move(0, 0, floating_resize_amount, 0)
        end
    else
        if direction == "up" then
            awful.client.incwfact(-tiling_resize_factor)
        elseif direction == "down" then
            awful.client.incwfact(tiling_resize_factor)
        elseif direction == "left" then
            awful.tag.incmwfact(-tiling_resize_factor)
        elseif direction == "right" then
            awful.tag.incmwfact(tiling_resize_factor)
        end
    end
end


-- raise focused client
local function raise_client()
    if client.focus then
        client.focus:raise()
    end
end



function _M.get()
    local globalkeys = gears.table.join(
        awful.key({ modkey, }, "s", hotkeys_popup.show_help,
            { description = "show help", group = "awesome" }),
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- Tag browsing
        awful.key({ modkey, }, "Left", awful.tag.viewprev,
            { description = "view previous", group = "tag" }),
        awful.key({ modkey, }, "Right", awful.tag.viewnext,
            { description = "view next", group = "tag" }),
        awful.key({ modkey, }, "Escape", awful.tag.history.restore,
            { description = "go back", group = "tag" }),

        awful.key({ modkey, }, "w", function() RC.mainmenu:show() end,
            { description = "show main menu", group = "awesome" }),

        -- Layout manipulation
        awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
            { description = "swap with next client by index", group = "client" }),
        awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
            { description = "swap with previous client by index", group = "client" }),
        awful.key({ modkey  }, "o", function() awful.screen.focus_relative(1) end,
            { description = "focus the next screen", group = "screen" }),
        awful.key({ modkey, altkey }, "o", function() awful.screen.focus_relative(-1) end,
            { description = "focus the previous screen", group = "screen" }),
        awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
            { description = "jump to urgent client", group = "client" }),
        awful.key({ modkey, }, "Tab",
            function()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end,
            { description = "go back", group = "client" }),

        -- Client focusing
        -- Focus client by direction (hjkl keys)
        awful.key({ modkey }, "j",
            function()
                awful.client.focus.bydirection("down")
                raise_client()
            end,
            { description = "focus down", group = "client" }
        ),
        awful.key({ modkey }, "k",
            function()
                awful.client.focus.bydirection("up")
                raise_client()
            end,
            { description = "focus up", group = "client" }
        ),
        awful.key({ modkey }, "h",
            function()
                awful.client.focus.bydirection("left")
                raise_client()
            end,
            { description = "focus left", group = "client" }
        ),
        awful.key({ modkey }, "l",
            function()
                awful.client.focus.bydirection("right")
                raise_client()
            end,
            { description = "focus right", group = "client" }
        ),

        -- Focus client by index (cycle through clients)
        awful.key({ modkey }, "z",
            function()
                awful.client.focus.byidx(1)
            end,
            { description = "focus next by index", group = "client" }
        ),
        awful.key({ modkey, "Shift" }, "z",
            function()
                awful.client.focus.byidx(-1)
            end,
            { description = "focus previous by index", group = "client" }
        ),


        -- Standard program
        awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
            { description = "open a terminal", group = "launcher" }),
        awful.key({ modkey, "Control" }, "r", awesome.restart,
            { description = "reload awesome", group = "awesome" }),
        awful.key({ modkey, "Shift" }, "q", awesome.quit,
            { description = "quit awesome", group = "awesome" }),

        -- Layout manipulation
        -- awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        --     { description = "increase master width factor", group = "layout" }),
        -- awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        -- { description = "decrease master width factor", group = "layout" }),
        awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
            { description = "increase the number of master clients", group = "layout" }),
        awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
            { description = "decrease the number of master clients", group = "layout" }),
        awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
            { description = "increase the number of columns", group = "layout" }),
        awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
            { description = "decrease the number of columns", group = "layout" }),
        awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
            { description = "select next", group = "layout" }),
        awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
            { description = "select previous", group = "layout" }),

        awful.key({ modkey, "Control" }, "n",
            function()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", { raise = true }
                    )
                end
            end,
            { description = "restore minimized", group = "client" }),

        -- Prompt
        -- dmenu
        awful.key({ modkey }, "r", function() awful.util.spawn("dmenu_run") end,
            { description = "run dmenu", group = "launcher" }),

        awful.key({ modkey }, "x",
            function()
                awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            end,
            { description = "lua execute prompt", group = "awesome" }),
        -- Menubar
        awful.key({ modkey }, "p", function() menubar.show() end,
            { description = "show the menubar", group = "launcher" }),

        -- Firefox
        awful.key({ modkey }, "ø", function() awful.util.spawn("firefox") end,
            { description = "firefox", group = "launcher" }),

        -- Flameshot screenshot
        awful.key({ modkey, "Shift" }, "s", function() awful.util.spawn("flameshot gui") end,
            { description = "flameshot screenshot", group = "launcher" }),

        -- Music player
        awful.key({ modkey }, "æ",
            function() awful.util.spawn("/home/Dan/.local/share/spotify-launcher/install/usr/share/spotify/spotify") end,
            { description = "music player", group = "launcher" }),

        -- vscode
        awful.key({ modkey }, ".", function() awful.util.spawn("code") end,
            { description = "vscode", group = "launcher" })

    )
    return globalkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
