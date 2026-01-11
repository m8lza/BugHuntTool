-- [[ BugHunt Pro - Final Solara Optimized Init ]] --
local environment = getgenv()

-- التأكد من أن oh غير معرف مسبقاً لمنع التداخل عند إعادة التشغيل
if oh then
    pcall(oh.Exit)
end

local web = true
local user = "m8lza" -- حسابك في GitHub
local repo = "BugHuntTool" -- اسم المستودع
local branch = "main"
local importCache = {}

-- 1. تعريف الدوال الأساسية وتجنب أخطاء الدعم (Solara Compatibility)
local globalMethods = {
    checkCaller = checkcaller or function() return false end,
    newCClosure = newcclosure or function(f) return f end,
    hookFunction = hookfunction or detour_function,
    getGc = getgc or get_gc_objects or function() return {} end,
    getInfo = debug.getinfo or getinfo,
    getSenv = getsenv or function() return {} end,
    getMenv = getmenv or getsenv,
    getConnections = get_signal_cons or getconnections,
    getScriptClosure = getscriptclosure or get_script_function,
    getNamecallMethod = getnamecallmethod or get_namecall_method,
    getConstants = debug.getconstants or getconstants,
    getUpvalues = debug.getupvalues or getupvalues,
    getProtos = debug.getprotos or getprotos,
    getConstant = debug.getconstant or getconstant,
    getUpvalue = debug.getupvalue or getupvalue,
    getMetatable = getrawmetatable or debug.getmetatable,
    setClipboard = setclipboard or writeclipboard,
    setReadOnly = setreadonly or function(t, b) 
        local mt = getrawmetatable(t)
        if mt then mt.__readonly = b end
    end,
    isLClosure = islclosure or function(f) return type(f) == "function" end,
}

-- دمج الدوال في البيئة العالمية
for name, method in pairs(globalMethods) do
    environment[name] = method
end

-- 2. دالة الاستيراد (Import) من روابطك مباشرة
function environment.import(asset)
    if importCache[asset] then
        return unpack(importCache[asset])
    end

    -- تعديل الرابط ليشير إلى مجلدك في GitHub (تأكد من وجود مجلد bughunttool)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/bughunttool/%s.lua", user, repo, branch, asset)
    
    local success, content = pcall(game.HttpGet, game, url)
    
    if success and content and not content:find("404") then
        local func, err = loadstring(content, asset .. ".lua")
        if func then
            local result = { func() }
            importCache[asset] = result
            return unpack(result)
        else
            warn("<BugHunt> Error in " .. asset .. ": " .. tostring(err))
        end
    else
        warn("<BugHunt> Failed to download: " .. asset)
    end
end

-- 3. إعداد كائن OH الأساسي (نظام BugHunt)
environment.oh = {
    Events = {},
    Hooks = {},
    Cache = importCache,
    Methods = globalMethods,
    Constants = {
        Types = { ["nil"] = "rbxassetid://4800232219", table = "rbxassetid://4666594276" },
        Syntax = { string = Color3.fromRGB(225, 150, 85), number = Color3.fromRGB(170, 225, 127) }
    },
    Exit = function()
        for _, event in pairs(environment.oh.Events) do 
            pcall(function() event:Disconnect() end) 
        end
        print("BugHunt System Exited.")
    end
}

-- 4. تحميل المكتبات المساعدة (تأكد من رفعها في مجلد bughunttool/methods/)
pcall(function()
    environment.import("methods/string")
    environment.import("methods/table")
    environment.import("methods/environment")
end)

print("--------------------------------------")
print("BugHunt Pro V6 Loaded Successfully!")
print("GitHub User: " .. user)
print("--------------------------------------")

-- 5. تشغيل الواجهة الرئيسية (قم بإلغاء التعليق عندما ترفع ملف الواجهة)
-- pcall(function() environment.import("ui/main") end)
