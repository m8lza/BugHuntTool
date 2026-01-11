-- init.lua
_G.BugHunter = {
    Settings = { SpyActive = true },
    LogSection = nil
}

local function import(file)
    local url = string.format("https://raw.githubusercontent.com/m8lza/BugHuntTool/main/bughunttool/%s.lua", file)
    local success, content = pcall(game.HttpGet, game, url)
    
    if success and content then
        local func = loadstring(content)
        if func then
            return func()
        end
    end
    warn("فشل تحميل الملف: " .. file)
end

import("MainInterface")
import("Sniffer")
