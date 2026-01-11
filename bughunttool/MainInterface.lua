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

-- إضافة قائمة لعرض الـ Remotes المكتشفة
local LogSection = Tabs.Main:AddSection("سجل التواصل (Remotes)")

Tabs.Settings:AddToggle("SpyToggle", {
    Title = "تفعيل الرصد",
    Default = true,
    Callback = function(Value)
        _G.BugHunter.Settings.SpyActive = Value
    end
})

return Window