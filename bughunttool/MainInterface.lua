-- MainInterface.lua
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BugHuntTool V1",
    SubTitle = "بواسطة [m8lza]",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true
})

local Tabs = {
    Main = Window:AddTab({ Title = "الرصد", Icon = "list" }),
    Settings = Window:AddTab({ Title = "الإعدادات", Icon = "settings" })
}

-- قسم عرض النتائج
local LogSection = Tabs.Main:AddSection("سجل التواصل (Remotes)")

-- وظيفة لإضافة النتائج للواجهة
_G.BugHunter.AddLog = function(name, info)
    Tabs.Main:AddParagraph({
        Title = "Captured: " .. name,
        Content = info
    })
end

Tabs.Settings:AddToggle("SpyToggle", {
    Title = "تفعيل الرصد المباشر",
    Default = true,
    Callback = function(Value)
        _G.BugHunter.Settings.SpyActive = Value
    end
})

return Window
