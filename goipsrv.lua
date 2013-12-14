#!/usr/bin/lua

local syslog = require "lsyslog"

syslog.open("goipsrv", syslog.FACILITY_USER)

for line in io.stdin:lines() do
    syslog.log(syslog.LOG_INFO, line)
end

syslog.close()
