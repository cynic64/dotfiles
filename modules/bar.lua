local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local gears = require('gears')
local cairo = require('lgi').cairo

require("modules/helpers")

-- set up socket
local socket = require('socket')

local SOCKET_PATH = "/tmp/awesome-clients.sock"
local socket_connected = false

-- helpers (why can't i forward reference easily? grrrr)
local function try_connect_server()
    if not socket_connected or server:send("TEST\n") == nil then
        server = assert(require 'socket.unix' ())

        if server:connect(SOCKET_PATH) == nil then
            log(string.format("[Bar] Couldn't connect to socket (%s), retry in 10s...", SOCKET_PATH))
            socket_connected = false
        else
            log("[Bar] Successfully connected to socket")
            socket_connected = true
        end
    end
end

-- called on manage/unmanage and sends info on the number of clients on each tag
-- to the socket
local function update_window_counts()
    if socket_connected then
        local client_counts = {}
        local idx = 1

        for idx, tag in ipairs(awful.screen.focused().tags) do
            -- format for the information transferred in the socket: the # of
            -- clients of each tag, in order, separated by spaces
            if server:send(#tag:clients() .. " ") == nil then
                log("[Bar] couldn't send new tag info")
                socket_connected = false
                return
            end
        end

        server:send("\n")
    else
        log("[Bar] Socket not connected")
    end
end

-- connect clients being added or removed to updating the window counts
client.connect_signal("manage", function (c)
                          update_window_counts()
end)

client.connect_signal("unmanage", function (c)
                          update_window_counts()
end)

-- call try_connect every 10 seconds
-- if the server is already initialized, try_connect_server won't do anything
watch("echo", 10, try_connect_server)
