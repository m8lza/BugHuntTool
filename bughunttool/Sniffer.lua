-- [[ BugHuntTool V2 - Professional Remote Spy ]] --

-- 1. تعريف الجدول العالمي للبيانات لضمان الربط بين المحرك والواجهة
_G.BugHunter = {
    Settings = { SpyActive = true },
    AddLog = nil
}

-- 2. تحميل مكتبة الواجهات Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 3. بناء الواجهة الاحترافية
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

-- وظيفة إضافة السجلات المتطورة مع أزرار النسخ والتشغيل
_G.BugHunter.AddLog = function(name, path, argsTable)
    local section = Tabs.Main:AddSection("تم رصد: " .. name)
    
    local formattedArgs = ""
    for i, v in pairs(argsTable) do
        formattedArgs = formattedArgs .. string.format("[%d]: %s (%s)\n", i, tostring(v), typeof(v))
    end
    
    section:AddParagraph({
        Title = "تفاصيل المسار",
        Content = path
    })

    section:AddParagraph({
        Title = "البيانات (Arguments)",
        Content = formattedArgs ~= "" and formattedArgs or "لا توجد بيانات"
    })

    -- زر نسخ الكود الجاهز
    section:AddButton({
        Title = "نسخ السكربت (Copy Code)",
        Callback = function()
            local argString = ""
            for i, v in pairs(argsTable) do
                local val = type(v) == "string" and '"'..v..'"' or tostring(v)
                argString = argString .. val .. (i < #argsTable and ", " or "")
            end
            setclipboard(string.format('game:GetService("ReplicatedStorage").%s:FireServer(%s)', name, argString))
            Fluent:Notify({ Title = "نجاح", Content = "تم نسخ الكود!", Duration = 2 })
        end
    })

    -- زر التشغيل الفوري
    section:AddButton({
        Title = "تشغيل الآن (Run)",
        Callback = function()
            pcall(function()
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild(name, true) or game:FindFirstChild(name, true)
                if remote then remote:FireServer(unpack(argsTable)) end
            end)
            Fluent:Notify({ Title = "إرسال", Content = "تم إعادة إرسال الطلب", Duration = 2 })
        end
    })
end

-- 4. محرك الرصد (Sniffer) المطور
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.BugHunter.Settings.SpyActive and (method:lower():find("server")) then
        if _G.BugHunter.AddLog then
            _G.BugHunter.AddLog(self.Name, self:GetFullName(), args)
        end
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- إعدادات التشغيل
Tabs.Settings:AddToggle("SpyToggle", {
    Title = "تفعيل الرصد",
    Default = true,
    Callback = function(Value) _G.BugHunter.Settings.SpyActive = Value end
})

Fluent:Notify({ Title = "BugHuntTool", Content = "السكربت جاهز للرصد!", Duration = 5 })
