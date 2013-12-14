#!/usr/bin/lua


local socket = require("socket")


local socket = require("socket")
host = "172.64.10.90"
port = 44444
udp = assert(socket.udp())
assert(udp:setsockname(host, port))
assert(udp:settimeout(5))
ip, port = udp:getsockname()
assert(ip, port)
print("Waiting packets on " .. ip .. ":" .. port .. "...")

while 1 do
    dgram, ip, port = udp:receivefrom()
    if dgram then
	print("Echoing '" .. dgram .. "' to " .. ip .. ":" .. port)
    else
	print(ip)
    end
end