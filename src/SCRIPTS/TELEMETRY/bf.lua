SCRIPT_HOME = "/SCRIPTS/BF"

SetupPages = {}
protocol = {}
radio = {}

supportedRadios = 
{
    ["x9d"] =     
    {
        templateHome    = SCRIPT_HOME.."/X9/",
        preLoad         = SCRIPT_HOME.."/X9/x9pre.lua"
    },
    ["x9d+"] =
    {
        templateHome    = SCRIPT_HOME.."/X9/",
        preLoad         = SCRIPT_HOME.."/X9/x9pre.lua"
    }
}

supportedProtocols =
{
    smartPort =
    {
        transport       = SCRIPT_HOME.."/MSP/sp.lua",
        rssi            = function() return getValue("RSSI") end,
        exitFunc        = function() return 0 end,
        push            = sportTelemetryPush,
        maxTxBufferSize = 8,
        maxRxBufferSize = 8
    },
    crsf =
    {
        transport       = SCRIPT_HOME.."/MSP/crsf.lua",
        rssi            = function() return getValue("TQly") end,
        exitFunc        = function() return "/CROSSFIRE/crossfire.lua" end,
        push            = crossfireTelemetryPush,
        maxTxBufferSize = 8,
        maxRxBufferSize = 58
    }
}

function getProtocol()
    if supportedProtocols.smartPort.push() then
        return supportedProtocols.smartPort
    elseif supportedProtocols.crsf.push() then
        return supportedProtocols.crsf
    end
end

protocol = getProtocol()
local ver, rad, maj, min, rev = getVersion()
radio = supportedRadios[rad]

if not protocol then
    error("Telemetry protocol not supported!")
elseif not radio then
    error("Radio not supported: "..rad)
end

assert(loadScript(radio.preLoad))()
assert(loadScript(protocol.transport))()
assert(loadScript(SCRIPT_HOME.."/MSP/common.lua"))()

local run = assert(loadScript(SCRIPT_HOME.."/ui.lua"))()

return { run=run }
