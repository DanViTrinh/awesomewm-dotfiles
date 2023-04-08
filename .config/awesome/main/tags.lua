-- Standard awesome library
local awful = require("awful")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
    local tags = {}

    local tagpairs = {
        names  = {
            "❶", "❷", "❸",
            "❹", "❺",
            "❻", "break ❼", "chat ❽", "music ❾" },
        layout = {
            RC.layouts[2], RC.layouts[2], RC.layouts[2],
            RC.layouts[2], RC.layouts[2], RC.layouts[2],
            RC.layouts[2], RC.layouts[2], RC.layouts[2]
        }
    }

    awful.screen.connect_for_each_screen(function(s)
        -- Each screen has its own tag table.
        tags[s] = awful.tag(tagpairs.names, s, tagpairs.layout)
    end)

    return tags
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable(
    {},
    { __call = function(_, ...) return _M.get(...) end }
)
