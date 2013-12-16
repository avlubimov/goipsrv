#!/usr/bin/lua

--comment this line if you don't have local C libs
LOCAL_CPATH="./clibs/?.so;"
--comment this line if you don't have local lua libs
--LOCAL_PATH="./clibs/?.so;"

DEBUG=true

if LOCAL_CPATH then package.cpath=LOCAL_CPATH..package.cpath end
if LOCAL_PATH then package.path=LOCAL_PATH..package.path end

print (package.cpath)

local socket = require("socket")
local syslog = require "lsyslog"


host = "172.64.10.90"
port = 44444


--init

function init_service ()

    syslog.open("goipsrv", syslog.FACILITY_USER)

    --bind
    netsock = assert(socket.udp())
    assert(netsock:setsockname(host, port))
    assert(netsock:settimeout(2))
    local ip, port = netsock:getsockname()
    assert(ip, port)

    if DEBUG then syslog.log(syslog.LOG_INFO,("Waiting packets on %s:%s"):format(ip, port)) end
end 


function close_service ()
    syslog.close()
end

function process_request (request)
    if request["req"] then
	for key,value in pairs(request) do
	    print (key,value)
	end
    end
end




init_service()

while 1 do
    dgram, ip, port = netsock:receivefrom()
    if dgram then
	print("Echoing '" .. dgram .. "' to " .. ip .. ":" .. port)
	local request={}
	for key,value in dgram:gfind("([^:;]+):([^:;]+);") do
	    request[key]=value
	end
	process_request(request)
    else
	print ("else")
    end
end

