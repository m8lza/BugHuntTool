-- MainInterface.lua V2
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BugHuntTool Pro V2",
    SubTitle = "بواسطة [m8lza]",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 500), -- تكبير الواجهة قليلاً
    Acrylic = true
})

local Tabs = {
    Main = Window:AddTab({ Title = "الرصد المباشر", Icon = "list" }),
    Settings = Window:AddTab({ Title = "الإعدادات", Icon = "settings" })
}

-- وظيفة ذكية لإضافة سجل متطور يحتوي على أزرار تفاعلية
_G.BugHunter.AddLog = function(name, path, argsTable)
    local section = Tabs.Main:AddSection("تم رصد: " .. name)
    
    -- تحويل الجدول إلى نص منسق
    local formattedArgs = ""
    for i, v in pairs(argsTable) do
        formattedArgs = formattedArgs .. string.format("[%d]: %s (%s)\n", i, tostring(v), typeof(v))
    end
    
    section:AddParagraph({
        Title = "تفاصيل المسار",
        Content = path
    })

    section:AddParagraph({
        Title = "البيانات المرسلة (Arguments)",
        Content = formattedArgs ~= "" and formattedArgs or "لا توجد بيانات"
    })

    -- زر لنسخ الكود الجاهز (مثل Hydroxide)
    section:AddButton({
        Title = "نسخ السكربت (Copy Code)",
        Description = "نسخ الكود لاستدعاء هذا الـ Remote بنفس البيانات",
        Callback = function()
            local argString = ""
            for i, v in pairs(argsTable) do
                argString = argString .. (type(v) == "string" and '"'..v..'"' or tostring(v)) .. (i < #argsTable and ", " or "")
            end
            local code = string.format('game:GetService("%s").%s:FireServer(%s)', 
                game:GetService("ReplicatedStorage"):IsAncestorOf(path) and "ReplicatedStorage" or "Workspace", 
                name, argString)
            
            setclipboard(code)
            Fluent:Notify({ Title = "نجاح", Content = "تم نسخ الكود للحافظة!", Duration = 3 })
        end
    })

    -- زر لإعادة إرسال الطلب فوراً (Execute)
    section:AddButton({
        Title = "تشغيل الآن (Run)",
        Description = "إرسال نفس البيانات للسيرفر مرة أخرى",
        Callback = function()
            local remote = nil
            -- محاولة العثور على الـ Remote من المسار
            pcall(function()
                local splitPath = string.split(path, ".")
                remote = game
                for i = 2, #splitPath do
                    remote = remote[splitPath[i]]
                end
            end)

            if remote then
                remote:FireServer(unpack(argsTable))
                Fluent:Notify({ Title = "تم الإرسال", Content = "تم إعادة إرسال الطلب بنجاح", Duration = 2 })
            end
        end
    })
end

Tabs.Settings:AddToggle("SpyToggle", {
    Title = "تفعيل الرصد",
    Default = true,
    Callback = function(Value)
        _G.BugHunter.Settings.SpyActive = Value
    end
})

return Window
