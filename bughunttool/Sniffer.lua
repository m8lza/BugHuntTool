-- Sniffer.lua (المطور)
local LogSection = _G.BugHunter.LogSection
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

-- دالة لتنظيف وعرض البيانات بشكل احترافي
local function logRemote(self, method, args)
    if not _G.BugHunter.Settings.SpyActive then return end
    
    local name = self.Name
    local path = self:GetFullName()
    local data = ""
    
    for i, v in pairs(args) do
        data = data .. string.format("[%d]: %s (%s)\n", i, tostring(v), typeof(v))
    end

    if _G.BugHunter.LogSection then
        _G.BugHunter.LogSection:AddParagraph({
            Title = "📡 " .. method .. ": " .. name,
            Content = "📍 Path: " .. path .. "\n📝 Args:\n" .. (data ~= "" and data or "No Data")
        })
    end
    print("Captured: " .. name) -- للتأكد من العمل في F9
end

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- رصد FireServer و InvokeServer (بكل حالات الأحرف)
    if method:lower() == "fireserver" or method:lower() == "invokeserver" then
        logRemote(self, method, args)
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
