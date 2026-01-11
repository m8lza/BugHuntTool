-- Sniffer.lua (Pro Version)
local Sniffer = {}
local LogSection = _G.BugHunter.LogSection

-- دالة لتنسيق البيانات بشكل جميل مثل Hydroxide
local function formatArgs(args)
    local out = ""
    for i, v in pairs(args) do
        out = out .. string.format("[%d] %s (%s)\n", i, tostring(v), typeof(v))
    end
    return out == "" and "No Arguments" or out
end

-- رصد RemoteEvents (FireServer)
local oldFireServer
oldFireServer = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.BugHunter.Settings.SpyActive and (method == "FireServer" or method == "fireServer") then
        local remoteName = self.Name
        local remotePath = self:GetFullName()
        local formattedData = formatArgs(args)

        -- إرسال للواجهة
        if _G.BugHunter.LogSection then
            _G.BugHunter.LogSection:AddParagraph({
                Title = "📡 Event: " .. remoteName,
                Content = "📍 Path: " .. remotePath .. "\n📝 Args:\n" .. formattedData
            })
        end
        print("Captured Event: " .. remoteName) -- للتأكد في F9
    end
    return oldNamecall(self, ...) -- تأكد من تعريف oldNamecall عالمياً أو استخدم hookfunction
end))

-- رصد RemoteFunctions (InvokeServer)
local oldInvokeServer
oldInvokeServer = hookfunction(Instance.new("RemoteFunction").InvokeServer, newcclosure(function(self, ...)
    if _G.BugHunter.Settings.SpyActive then
        local args = {...}
        _G.BugHunter.LogSection:AddParagraph({
            Title = "📞 Function: " .. self.Name,
            Content = "📍 Path: " .. self:GetFullName() .. "\n📝 Args:\n" .. formatArgs(args)
        })
    end
    return oldInvokeServer(self, ...)
end))

return Sniffer
