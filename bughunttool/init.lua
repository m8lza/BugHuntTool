-- init.lua
_G.BugHunter = {
    Settings = { SpyActive = true },
    LogSection = nil
}

local owner = "m8lza"
local repo = "BugHuntTool"
local path = "bughunttool"

local function import(file)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/main/%s/%s.lua", owner, repo, path, file)
    local success, content = pcall(function() return game:HttpGet(url) end)
    
    if success and content then
        local func, err = loadstring(content)
        if func then
            return func()
        else
            warn("Error parsing " .. file .. ": " .. tostring(err))
        end
    else
        warn("Failed to download " .. file)
    end
end

import("MainInterface")
import("Sniffer")
