local Sniffer = {}

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.BugHunter.Settings.SpyActive and (method == "FireServer" or method == "InvokeServer") then
        -- إرسال البيانات للواجهة (نستخدم Events أو نحدث جدولاً)
        table.insert(_G.BugHunter.Logs, {
            Name = self.Name,
            Path = self:GetFullName(),
            Args = args,
            Time = os.date("%X")
        })
        
        -- إشعار (اختياري)
        print("Captured: " .. self.Name)
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
return Sniffer