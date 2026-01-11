-- MainInterface.lua V2
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BugHuntTool Pro V2",
    SubTitle = "بواسطة [m8lza]",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 500),
    Acrylic = true
})

local Tabs = {
    Main = Window:AddTab({ Title = "الرصد المباشر", Icon = "list" }),
    Settings = Window:AddTab({ Title = "الإعدادات", Icon = "settings" })
}

-- وظيفة إضافة السجلات المتطورة
_G.BugHunter.AddLog = function(name, path, argsTable)
    local section = Tabs.Main:AddSection("Captured: " .. name)
    
    local formattedArgs = ""
    for i, v in pairs(argsTable) do
        formattedArgs = formattedArgs .. string.format("[%d]: %s (%s)\n", i, tostring(v), typeof(v))
    end
    
    section:AddParagraph({
        Title = "المسار الكامل",
        Content = path
    })

    section:AddParagraph({
        Title = "البيانات المرسلة",
        Content = formattedArgs ~= "" and formattedArgs or "لا توجد بيانات"
    })

    -- زر نسخ الكود (مثل Hydroxide)
    section:AddButton({
        Title = "نسخ السكربت (Copy)",
        Callback = function()
            local argString = ""
            for i, v in pairs(argsTable) do
                local val = type(v) == "string" and '"'..v..'"' or tostring(v)
                argString = argString .. val .. (i < #argsTable and ", " or "")
            end
            setclipboard(string.format('game:GetService("ReplicatedStorage").%s:FireServer(%s)', name, argString))
            Fluent:Notify({ Title = "نجاح", Content = "تم نسخ كود التشغيل!", Duration = 2 })
        end
    })

    -- زر التشغيل الفوري
    section:AddButton({
        Title = "تشغيل (Run)",
        Callback = function()
            pcall(function()
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild(name, true) or game:FindFirstChild(name, true)
                if remote then remote:FireServer(unpack(argsTable)) end
            end)
            Fluent:Notify({ Title = "تم", Content = "تم إعادة إرسال الطلب للسيرفر", Duration = 2 })
        end
    })
end

Tabs.Settings:AddToggle("SpyToggle", {
    Title = "تفعيل الرصد",
    Default = true,
    Callback = function(Value) _G.BugHunter.Settings.SpyActive = Value end
})

return Window
