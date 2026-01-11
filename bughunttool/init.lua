-- init.lua
_G.BugHunter = {
    Settings = { SpyActive = true },
    AddLog = nil -- سيتم تعريفه داخل الواجهة
}

local function import(file)
    local url = string.format("https://raw.githubusercontent.com/m8lza/BugHuntTool/main/bughunttool/%s.lua", file)
    local success, content = pcall(game.HttpGet, game, url)
    
    if success and content then
        local func, err = loadstring(content)
        if func then
            return func()
        else
            warn("خطأ في قراءة ملف " .. file .. ": " .. tostring(err))
        end
    else
        warn("فشل في تحميل الملف من الرابط: " .. file)
    end
end

-- تحميل الواجهة أولاً لضمان وجود مكان للرصد
import("MainInterface")
import("Sniffer")
