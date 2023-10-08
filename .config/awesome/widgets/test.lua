local awful = require("awful")
local wibox = require("wibox")

local my_widget = wibox.widget {
    {
        text = "Hello, Awesome!",
        widget = wibox.widget.textbox
    },
}

return my_widget
