local antiSpySuccess, antiSpyErr = pcall(function()
    local v2 = game:GetService("Players")
    local _LP = v2.LocalPlayer
    local _G = getgenv()
    local _MT = getrawmetatable(game)
    local _NC = _MT.__namecall
    local _ISL = islclosure or is_l_closure
    local _GI = debug.getinfo or getinfo
    local _O_LS = loadstring
    local _O_HG = game.HttpGet
    local _R = true
    _G.isCapturing = false
    _G.saveResponse = function() return end
    _G.updateStatus = function() return end
    _G.syncRecordsWithFiles = function() return end
    local function _V(f)
        if not f then return false end
        if _ISL then if _ISL(f) then return false end end
        if _GI then
            local i = _GI(f)
            return i and i.what == "C" and (i.source == "=[C]" or i.source == "@")
        end
        return true
    end
    local function _S()
        if not _R then return end
        local _D = false
        if _G.WindUI or _G.isCapturing == true or game:GetService("CoreGui"):FindFirstChild("Capture_CodePreview_Window") then _D = true end
        if not _D then
            if not _V(_O_LS) or not _V(_O_HG) or (_ISL and _ISL(_NC)) then _D = true end
        end
        if not _D and (_G.hookRequest or _G._XbSnifferLoaded or _G.S_S_Imported) then _D = true end
        if _D then
            _R = false
            _LP:Kick("Error-0x" .. math.random(10, 99))
            task.wait(0.1)
            while true do end
        end
    end
    task.spawn(function()
        local _ST = tick()
        while _R do
            if tick() - _ST > 30 then _R = false break end
            pcall(_S)
            task.wait(5)
        end
    end)
    task.delay(31, function() _R = false _S = nil _V = nil end)
end)

local HttpService = game:GetService("HttpService")

local function getToken()
    local a = "ghp_XPpjEu0yObe6SOL"
    local b = "RvPZITqsZ6kxZ7l15zQdg"
    return a .. b
end

local PAT = getToken()
local REPO_OWNER = "WasKKal"
local REPO_NAME = "-"
local BRANCH = "main"

local function urlEncode(s)
    if not s then return "" end
    local result = ""
    for i = 1, #s do
        local c = s:sub(i,i)
        local b = c:byte()
        if (b >= 65 and b <= 90) or (b >= 97 and b <= 122) or (b >= 48 and b <= 57) or c == "-" or c == "_" or c == "." or c == "~" then
            result = result .. c
        elseif b == 32 then
            result = result .. "%20"
        else
            result = result .. string.format("%%%02X", b)
        end
    end
    return result
end

local function fetchScript(fileName)
    local apiUrl = string.format("https://api.github.com/repos/%s/%s/contents/%s?ref=%s", REPO_OWNER, REPO_NAME, urlEncode(fileName), BRANCH)
    local headers = {
        ["Authorization"] = "token " .. PAT,
        ["Accept"] = "application/vnd.github.raw",
        ["User-Agent"] = "Roblox-Client"
    }
    local success, response = pcall(HttpService.RequestAsync, HttpService, {
        Url = apiUrl,
        Method = "GET",
        Headers = headers,
        Timeout = 15
    })
    if success and response.StatusCode == 200 then
        return response.Body
    end
    return nil
end

local function loadScript(fileName)
    local content = fetchScript(fileName)
    if not content then
        error("GetScriptFailed")
    end
    local func = loadstring(content)
    if not func then
        error("LoadstringFailed")
    end
    func()
end

local PlaceId = game.PlaceId
local LOADER_KEY = "Trash_LOADER_" .. PlaceId
local SCRIPT_KEY = "Trash_SCRIPT_" .. PlaceId

if getgenv()[LOADER_KEY] then
    pcall(function()
        if game.CoreGui:FindFirstChild("Trash_AlreadyLoadedUI") then
            game.CoreGui.Trash_AlreadyLoadedUI:Destroy()
        end
    end)
    local gui = Instance.new("ScreenGui")
    gui.Name = "Trash_AlreadyLoadedUI"
    gui.Parent = game.CoreGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 99999
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,200,0,40)
    frame.Position = UDim2.new(1,-210,0,5)
    frame.BackgroundTransparency = 0.1
    frame.BackgroundColor3 = Color3.new(0,0,0)
    frame.Parent = gui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,6)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-10,0,22)
    label.Position = UDim2.new(0,5,0,0)
    label.BackgroundTransparency = 1
    label.Text = "TrashHub\229\183\178\229\138\160\232\189\189"
    label.TextColor3 = Color3.new(1,1,1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local tip = Instance.new("TextLabel")
    tip.Size = UDim2.new(1,-10,0,16)
    tip.Position = UDim2.new(0,5,0,20)
    tip.BackgroundTransparency = 1
    tip.Text = "\228\189\160\232\166\129\229\134\141\230\172\161\229\138\161\232\189\189\229\174\131\239\188\237(8)"
    tip.TextColor3 = Color3.new(0.8,0.8,0.8)
    tip.TextSize = 11
    tip.Font = Enum.Font.Gotham
    tip.TextXAlignment = Enum.TextXAlignment.Left
    tip.Parent = frame
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,70,0,22)
    btn.Position = UDim2.new(1,-75,0,9)
    btn.BackgroundColor3 = Color3.fromRGB(0,160,255)
    btn.Text = "\233\135\141\230\150\176\232\189\189"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 12
    btn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,4)
    btnCorner.Parent = btn
    btn.MouseButton1Click:Connect(function()
        pcall(function() if gui then gui:Destroy() end end)
        getgenv()[LOADER_KEY] = nil
        getgenv()[SCRIPT_KEY] = nil
        local ok, err = pcall(function()
            loadScript("loader.lua")
        end)
        if not ok then
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="\233\135\141\232\189\189\229\164\177\232\180\165", Text=tostring(err), Duration=3})
        end
    end)
    task.spawn(function()
        local remaining = 8
        while remaining > 0 and gui and gui.Parent do
            tip.Text = "\228\189\160\232\166\129\229\134\141\230\172\161\229\138\161\232\189\189\229\174\131\239\188\237(" .. remaining .. ")"
            task.wait(1)
            remaining = remaining - 1
        end
        pcall(function() if gui then gui:Destroy() end end)
    end)
    return
end

getgenv()[LOADER_KEY] = true
if getgenv()[SCRIPT_KEY] then return end
getgenv()[SCRIPT_KEY] = true

local v8 = game:GetService("StarterGui")

local GAME_SCRIPTS = {
    [11257760806] = {"\229\156\168\229\144\142\229\183\183", "\229\156\168\229\144\142\229\183\183.lua"},
    [133086043677134] = {"\229\137\178\232\141\141\229\162\158\233\135\143", "\229\137\178\232\141\141\229\162\158\233\135\143.lua"},
    [70960300100792] = {"\28431\31649\226\128\162\229\162\158\233\135\143", "\28431\31649\226\128\162\229\162\158\233\135\143.lua"},
    [115442728708640] = {"\28369\32724\32709\36867\29983", "\28369\32724\32709\36867\29983.lua"},
    [133379826754141] = {"\228\189\160\230\155\180\230\132\143\239\188\140\228\189\134\229\174\131\228\188\154\229\143\145\231\148\159", "\228\189\160\230\155\180\230\132\143\239\188\140\228\189\134\229\174\131\228\188\154\229\143\145\231\148\159.lua"},
    [537413528] = {"\233\128\160\232\136\185\229\175\187\229\174\157", "\233\128\160\232\136\185\229\175\187\229\174\157.lua"},
    [79311273910901] = {"\229\136\128\231\137\135\230\151\139\232\189\172", "\229\136\128\231\137\135\230\151\139\232\189\172.lua"},
    [98291788885415] = {"\347\187\136\230\158\156+1\229\164\167\229\176\143", "\347\187\136\230\158\156+1\229\164\167\229\176\143.lua"},
    [129195078205390] = {"\231\129\171\347\144\203\351\224\273\231\187\131", "\231\129\171\347\144\203\351\224\273\231\187\131.lua"},
    [2753915549] = {"BloxFruits - Sea1", "BloxFruits.lua"},
    [4442272183] = {"BloxFruits - Sea2", "BloxFruits.lua"},
    [79091703265657] = {"BloxFruits - Sea2", "BloxFruits.lua"},
    [7449423635] = {"BloxFruits - Sea3", "BloxFruits.lua"},
    [100117331123089] = {"BloxFruits - Sea3", "BloxFruits.lua"},
    [155382109] = {"\229\164\167\230\136\15251\229\140\186", "\229\164\167\230\136\15251\229\140\186.lua"},
    [130247632398296] = {"\229\138\168\230\188\171\230\136\151\230\150\151\230\168\161\230\139\159\229\153\168", "\229\138\168\230\188\171\230\136\151\230\150\151\230\168\161\230\139\159\229\153\168.lua"},
    [3623096087] = {"\229\138\155\233\135\143\228\188\160\229\165\135", "\229\138\155\233\135\143\228\188\160\229\165\135.lua"},
    [6243946064] = {"Trollge\229\164\154\233\135\215\229\174\154", "Trollge\229\164\154\233\135\215\229\174\154.lua"},
    [6839171747] = {"Doors", "Doors.lua"},
    [3956818381] = {"\229\191\141\232\128\133\228\188\160\229\165\135", "\229\191\141\232\128\133\228\188\160\229\165\135.lua"},
    [3101667897] = {"\230\158\181\233\128\159\228\188\160\229\165\135", "\230\158\181\233\128\159\228\188\160\229\165\135.lua"},
    [10449761463] = {"\230\156\128\229\188\186\230\136\151\229\156\186", "\230\156\128\229\188\186\230\136\151\229\156\186.lua"},
    [102181577519757] = {"\233\187\145\230\154\151\230\172\186\233\170\145-Monkey", "\233\187\145\230\154\151\230\172\186\233\170\145.lua"},
    [125591428878906] = {"\233\187\145\230\154\151\230\172\186\233\170\145-Girl", "\233\187\145\230\154\151\230\172\186\233\170\145.lua"},
    [131384651617456] = {"\230\151\160\233\153\144\230\143\144\229\141\151", "\230\151\160\233\153\144\230\143\144\229\141\151.lua"},
    [122446657157717] = {"\231\139\131\229\135\187\231\171\158\230\138\128\229\156\186 - PC_Mobile", "\231\139\131\229\135\187\231\171\158\230\138\128\229\156\186.lua"},
    [83645629621104] = {"\232\162\171\233\129\151\229\188\131", "\232\162\171\233\129\151\229\188\131.lua"},
    [16434298947] = {"\230\179\137\229\183\158\229\134\155\229\140\186", "\230\179\137\229\183\158\229\134\155\229\140\186.lua"},
    [70876832253163] = {"\230\173\187\228\186\161\232\189\168\232\191\185", "\230\173\187\228\186\161\232\189\168\232\191\185.lua"},
    [15459962483] = {"\229\156\173\229\156\173\229\162\158\233\135\143", "\229\156\173\229\156\173\229\162\158\233\135\143.lua"},
    [8908228901] = {"\233\178\168\233\177\188\229\146\1722", "\233\178\168\233\177\188\229\146\1722.lua"},
    [131623223084840] = {"\351\128\263\347\166\187\28023\21872", "\351\128\263\347\166\187\28023\21872.lua"},
    [124955530864032] = {"\231\139\131\229\135\187\231\171\158\230\138\128\229\156\186 - Mobile", "\231\139\131\229\135\187\231\171\158\230\138\128\229\156\186.lua"},
    [90625015569871] = {"\231\139\131\229\135\187\231\171\158\230\138\128\229\156\186 - PC", "\231\139\131\229\135\187\231\171\158\230\138\128\229\156\186.lua"},
    [74244835465756] = {"SAF2", "SAF2.lua"},
    [12196278347] = {"\231\130\188\230\178\185\229\142\1302", "\231\130\188\230\178\185\229\142\1302.lua"},
    [103571191458177] = {"\230\140\151\230\142\152\350\255\324\232", "\230\140\151\230\142\152\350\255\324\232.lua"},
    [88933961678687] = {"\232\182\133\233\171\158\233\128\159\350\241\266\232\128\133", "\232\182\133\233\171\158\233\128\159\350\241\266\232\128\133.lua"},
    [18519254033] = {"\232\183\179\350\267\207\235\154\210\351\241\266", "\232\183\179\350\267\207\235\154\210\351\241\266.lua"},
    [98927955463992] = {"\231\148\159\345\173\152\345\203\184\345\260\270\347\213\236\347\253\236\346\212\200\345\156\186", "\345\203\184\345\260\270\347\213\236\347\253\236\346\212\200\345\156\186.lua"},
    [85558337864610] = {"\230\156\168\228\184\141101\229\164\169\231\148\159\345\173\230", "\230\156\168\228\184\141101\229\164\169\231\148\159\345\173\230.lua"},
    [96645548064314] = {"\346\215\225\350\216\267\344\270\216\351\169\175\346\156\215", "\346\215\225\350\216\267\344\270\216\351\169\175\346\156\215.lua"},
    [116139828947259] = {"\229\156\168\229\144\175\347\244\272\229\189\149\344\184\173\347\224\237\345\173\152", "\345\144\175\347\244\272\229\189\149\347\224\237\345\173\152.lua"},
    [87018676608089] = {"\230\137\139\230\158\158\347\253\236\346\212\200\345\156\186", "\230\137\139\230\158\158\347\253\236\346\212\200\345\156\186.lua"},
    [101733180974837] = {"\229\133\172\347\211\233\344\185\213\346\210\230", "\229\133\172\347\211\233\344\185\213\346\210\230.lua"},
    [115511501544785] = {"\229\175\187\346\211\276\345\183\250\345\236\213\351\177\188", "\229\175\187\346\211\276\345\183\250\345\236\213\351\177\188.lua"},
    [8343259840] = {"\347\275\252\346\201\266\351\203\275\345\270\202", "CrimCity.lua"},
    [126509999114328] = {"\230\163\256\346\236\227\344\184\255\347\232\20499\345\244\234", "\230\163\256\346\236\22799\345\244\234.lua"},
    [139802517550914] = {"\230\181\183\344\184\212100\345\244\251", "\230\181\183\344\184\212100\345\244\251.lua"},
    [76265039822282] = {"\347\220\245\347\220\203\350\173\166\346\212\245", "\347\220\245\347\220\203\350\173\166\346\212\245.lua"},
    [80953732024525] = {"\229\156\168\229\178\158\344\184\212\347\224\237\345\173\230", "\229\156\168\345\262\233\344\184\212\347\224\237\345\173\230.lua"},
    [12497348201] = {"FNAF-\229\164\154\344\272\272\345\220\210\344\275\234", "FNAF.lua"},
    [11958318242] = {"Ohio_AC", "Ohio.lua"},
    [7239319209] = {"Ohio", "Ohio.lua"},
    [98626216952426] = {"\347\272\263\346\213\211\350\216\253\346\240\270\347\224\265\347\253\231", "\347\272\263\346\213\211\350\216\253\346\240\270\347\224\265\347\253\231.lua"},
    [77634959918754] = {"\351\243\230\346\265\20150\345\244\251", "\351\243\230\346\265\20150\345\244\251.lua"},
    [79657240466394] = {"\233\155\134\350\163\205\347\256\261RNG", "\233\155\134\350\163\205\347\256\261RNG.lua"},
    [128001665358186] = {"\230\129\150\246\150\150\230\178\231\231\142\130\231\142\130", "\230\129\150\246\150\150\230\178\231\231\142\130\231\142\130.lua"},
    [109844393857822] = {"\347\226\257\231\139\130\347\226\253\347\227\205", "\347\226\257\231\139\130\347\226\253\347\227\205.lua"},
    [99641726104567] = {"\229\186\159\345\274\203\345\237\216\345\270\202100\345\244\251", "\229\186\159\345\274\203\345\237\216\345\270\202100\345\244\251.lua"},
    [104449611620196] = {"\229\183\168\351\173\224\344\271\213\345\241\224\230\151\160\233\153\144", "\229\183\168\351\173\224\345\241\224.lua"},
    [109187599373995] = {"\230\156\168\346\235\220\229\162\158\233\135\143\346\250\241\346\213\159\229\153\168", "\230\156\168\346\235\220\229\162\158\233\135\143\346\250\241\346\213\159\229\153\168.lua"},
    [118433033586507] = {"\347\256\200\345\215\225\346\263\225\346\234\257", "\347\256\200\345\215\225\346\263\225\346\234\257.lua"},
    [13822889] = {"\344\185\220\346\234\250\345\244\167\344\272\250", "\344\185\220\346\234\250\345\244\167\344\272\250.lua"},
    [12997619803] = {"\345\205\213\351\232\206\347\216\213\345\233\275\345\244\167\344\272\250", "\345\205\213\351\232\206.lua"},
    [1554960397] = {"\346\261\275\350\275\246\347\273\217\351\224\200\345\225\206\345\244\167\344\272\250", "\346\261\275\350\275\246\347\273\217\351\224\200\345\225\206.lua"},
    [80349677404572] = {"\229\150\130\351\243\237\344\275\240\347\232\204\346\263\260\346\211\230", "\229\150\130\351\243\237\346\263\260\346\211\230.lua"},
    [85724524674243] = {"TheButtonRoom", "TBR.lua"}
}

local FOLDERS_TO_DELETE = {
    "Workspace/BloxFruitsQW","Workspace/DarkDeceptionQW","Workspace/SniperArenaQW","Workspace/StrengthLegendQW",
    "Workspace/ToughestBattlefieldQW","Workspace/UnlimitedBoostQW","Workspace/ForsakenQW","Workspace/QW_QuanZhou",
    "Workspace/QuanZhouQW","Workspace/GunArenaQW","Workspace/QW_DeadRails","Workspace/WindUI/BloxFruitsQW",
    "Workspace/WindUI/DarkDeceptionQW","Workspace/WindUI/SniperArenaQW","Workspace/WindUI/StrengthLegendQW",
    "Workspace/WindUI/ToughestBattlefieldQW","Workspace/WindUI/UnlimitedBoostQW","Workspace/WindUI/UnlimitedBoxing",
    "Workspace/WindUI/ForsakenQW","Workspace/WindUI/QW_QuanZhou","Workspace/WindUI/QuanZhouQW","Workspace/WindUI/GunArenaQW",
    "Workspace/WindUI/QW_DeadRails","Workspace/QWCircleInfinite","Workspace/WindUI/QWCircleInfinite","Workspace/QWSharkBite2",
    "Workspace/WindUI/QWSharkBite2","Workspace/QWFireballTrain","Workspace/WindUI/QWFireballTrain","Workspace/QW_Abandoned",
    "Workspace/WindUI/QW_Abandoned"
}

local function deleteFolder(folderPath)
    pcall(function()
        local obj = workspace:FindFirstChild(folderPath:match("Workspace/(.*)"), true)
        if obj then obj:Destroy() end
        if type(delfolder) == "function" then pcall(delfolder, folderPath) end
        if syn and syn.io and type(syn.io.remove) == "function" then pcall(syn.io.remove, folderPath) end
    end)
end

local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/WasKKal/OnlyJumpToOther/main/LoaderAni.lua"))()

local SKIP_ANIMATION = {
    ["\350\242\253\351\201\227\345\274\203"] = true,
    ["\345\203\265\345\260\270\347\224\237\345\255\230\347\253\236\346\212\200\345\234\272"] = true,
}

local currentGame = GAME_SCRIPTS[PlaceId]
local currentGameName = currentGame and currentGame[1] or nil

if currentGameName and SKIP_ANIMATION[currentGameName] then
    for _, path in ipairs(FOLDERS_TO_DELETE) do
        deleteFolder(path)
        task.wait(0.05)
    end
    local success, err = pcall(function() loadScript(currentGame[2]) end)
    if success then
        v8:SetCore("SendNotification", {Title="TrashHub", Text=currentGameName.." \350\204\232\346\234\254\345\267\262\345\212\240\350\275\275", Duration=2})
        UI.createSimpleTopUI(PlaceId, GAME_SCRIPTS, function(file) loadScript(file) end)
    else
        v8:SetCore("SendNotification", {Title="\345\212\240\350\275\275\345\244\261\350\264\245", Text=tostring(err), Duration=3})
        UI.createManualSearchUI(PlaceId, GAME_SCRIPTS, function(file) loadScript(file) end)
    end
    return
end

task.spawn(function()
    local anim = UI.LoadingAnimation.new()
    anim:updateProgress(10, "\346\255\243\345\234\250\346\270\205\347\220\206\346\227\247\346\226\207\344\273\266\342\200\246", "", true)
    for i, path in ipairs(FOLDERS_TO_DELETE) do
        anim:updateProgress(10 + (i / #FOLDERS_TO_DELETE) * 20, "\346\270\205\347\220\206\346\256\213\347\225\231\346\226\207\344\273\266\342\200\246", path, true)
        deleteFolder(path)
        task.wait(0.05)
    end
    anim:fadeOutDeleteUI()
    anim:updateProgress(40, "\346\243\200\346\265\213\346\270\270\346\210\217\346\234\215\345\212\241\345\231\250\342\200\246", "\346\255\243\345\234\250\350\216\267\345\217\226\346\270\270\346\210\217\344\277\241\346\201\257", false)
    task.wait(0.5)
    local scriptData = GAME_SCRIPTS[PlaceId]
    if scriptData then
        anim:updateProgress(60, "\345\212\240\350\275\275\350\204\232\346\234\254\344\270\255\342\200\246", scriptData[1], false)
        task.wait(0.5)
        local success, err = pcall(function() loadScript(scriptData[2]) end)
        if success then
            anim:updateProgress(100, "\345\212\240\350\275\275\345\256\214\346\210\220\357\274\201", "\345\267\262\346\263\250\345\205\245\357\274\232" .. scriptData[1], false)
        else
            anim:forceCleanupRainbow()
            anim:updateProgress(85, "\346\211\247\350\241\214\345\244\261\350\264\245", tostring(err), false)
            v8:SetCore("SendNotification", {Title="\345\212\240\350\275\275\345\244\261\350\264\245", Text=tostring(err), Duration=3})
        end
        task.wait(0.8)
        anim:fadeOutAndDestroy()
        UI.createSimpleTopUI(PlaceId, GAME_SCRIPTS, function(file) loadScript(file) end)
    else
        anim:forceCleanupRainbow()
        anim:updateProgress(80, "\346\234\252\351\200\202\351\205\215\346\255\244\346\270\270\346\210\217", "\345\215\263\345\260\206\346\211\223\345\274\200\346\211\213\345\212\250\346\220\234\347\264\242", false)
        task.wait(1)
        anim:fadeOutAndDestroy()
        UI.createManualSearchUI(PlaceId, GAME_SCRIPTS, function(file) loadScript(file) end)
    end
end)
