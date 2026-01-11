-- Sniffer.lua V2
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- رصد كل ما ينتهي بـ "Server" (مثل FireServer و InvokeServer)
    if _G.BugHunter.Settings.SpyActive and (method:lower():find("server")) then
        if _G.BugHunter.AddLog then
            -- نرسل البيانات للواجهة المتطورة
            _G.BugHunter.AddLog(self.Name, self:GetFullName(), args)
        end
        print("BugHunter Captured: " .. self.Name) -- للتأكد من F9
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
