-- Sniffer.lua
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.BugHunter.Settings.SpyActive and (method == "FireServer" or method == "InvokeServer") then
        -- تنسيق البيانات للعرض
        local argString = ""
        for i, v in pairs(args) do
            argString = argString .. string.format("[%d]: %s ", i, tostring(v))
        end
        
        local info = string.format("Path: %s\nArgs: %s", self:GetFullName(), argString)
        
        -- إرسال البيانات للواجهة
        if _G.BugHunter.AddLog then
            _G.BugHunter.AddLog(self.Name, info)
        end
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
