local owner = "m8lzas"
local branch = "main"

local function import(file)
    local url = string.format("https://raw.githubusercontent.com/%s/BugHuntTool/%s/%s.lua", owner, branch, file)
    local success, result = pcall(function() return game:HttpGet(url) end)
    if success then
        return loadstring(result)()
    else
        warn("فشل تحميل الملف: " .. file)
    end
end

-- تعريف جدول عالمي لتخزين البيانات
_G.BugHunter = {
    Logs = {},
    Settings = { SpyActive = true }
}

-- تحميل المكونات بترتيب
import("UI/MainInterface")
import("Classes/Sniffer")

print("BugHuntTool تم التحميل بنجاح!")