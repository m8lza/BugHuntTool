-- init.lua
local owner = "m8lza" -- تأكد من مطابقة اسم حسابك
local repo = "BugHuntTool"
local path = "bughunttool"

local function import(file)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/main/%s/%s.lua", owner, repo, path, file)
    local success, content = pcall(game.HttpGet, game, url)
    if success then
        return loadstring(content)()
    else
        warn("خطأ في تحميل الموديل: " .. file)
    end
end

-- إعداد الجدول العالمي للبيانات
_G.BugHunter = {
    Settings = { SpyActive = true },
    Logs = {}
}

import("MainInterface")
import("Sniffer")
