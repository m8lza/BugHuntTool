-- Sniffer.lua
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- رصد كافة أنواع التواصل (Events & Functions)
    if _G.BugHunter.Settings.SpyActive and (method:lower():find("server")) then
        local data = ""
        for i, v in pairs(args) do
            data = data .. string.format("[%d]: %s (%s)  ", i, tostring(v), typeof(v))
        end

        -- إرسال البيانات فوراً للواجهة
        if _G.BugHunter.LogSection then
            _G.BugHunter.LogSection:AddParagraph({
                Title = "📡 رصد: " .. self.Name,
                Content = "📍 المسار: " .. self:GetFullName() .. "\n📝 البيانات: " .. (data ~= "" and data or "لا يوجد")
            })
        end
        print("Captured: " .. self.Name) -- تظهر في F9 للتأكيد
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
