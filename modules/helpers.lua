
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local gears = require('gears')
local cairo = require('lgi').cairo

function log(text)
    print(string.format("|%s| %s", os.date(), text))
end
