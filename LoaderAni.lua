local v1, v2 = pcall(function()
    local v3 = game:GetService("Players")
    local v4 = v3.LocalPlayer
    local v5 = getgenv()
    local v6 = getrawmetatable(game)
    local v7 = v6.__namecall
    local v8 = islclosure or is_l_closure
    local v9 = debug.getinfo or getinfo
    local v10 = loadstring
    local v11 = game.HttpGet
    local v12 = true
    v5.isCapturing = false
    v5.saveResponse = function() end
    v5.updateStatus = function() end
    v5.syncRecordsWithFiles = function() end
    local function v13(v14)
        if not v14 then return false end
        if v8 then if v8(v14) then return false end end
        if v9 then
            local v15 = v9(v14)
            return v15 and v15.what == "C" and (v15.source == "=[C]" or v15.source == "@")
        end
        return true
    end
    local function v16()
        if not v12 then return end
        local v17 = false
        if v5.WindUI or v5.isCapturing == true or game:GetService("CoreGui"):FindFirstChild("Capture_CodePreview_Window") then v17 = true end
        if not v17 then
            if not v13(v10) or not v13(v11) or (v8 and v8(v7)) then v17 = true end
        end
        if not v17 and (v5.hookRequest or v5._XbSnifferLoaded or v5.S_S_Imported) then v17 = true end
        if v17 then
            v12 = false
            v4:Kick("Error-0x" .. math.random(10, 99))
            task.wait(0.1)
            while true do end
        end
    end
    task.spawn(function()
        local v18 = tick()
        while v12 do
            if tick() - v18 > 30 then v12 = false break end
            pcall(v16)
            task.wait(5)
        end
    end)
    task.delay(31, function() v12 = false v16 = nil v13 = nil end)
end)

local v19 = game:GetService("HttpService")
local function v20()
    local v21 = {113,97,111,102,103,115,99,118,100,101,114,98,116,110,109,117,104,105,106,107,108,112,119,120,121,122}
    local v22 = {18,3,25,21,17,4,22,19,0,7,12,20,16,11,14,9,23,8,13,24,1,15,10,5,6,2}
    local v23 = {}
    for v24 = 1, #v22 do
        v23[v22[v24] + 1] = v21[v24]
    end
    local v25 = {}
    for v26 = 1, 40 do
        v25[v26] = 0
    end
    v25[1] = v23[7] + v23[13] - 20
    v25[2] = v23[19] + 12
    v25[3] = v23[24] - 15
    v25[4] = v23[3] + 18
    v25[5] = v23[17] - 9
    v25[6] = v23[11] + 5
    v25[7] = v23[26] - 22
    v25[8] = v23[9] + 11
    v25[9] = v23[22] - 17
    v25[10] = v23[5] + 14
    v25[11] = v23[14] - 8
    v25[12] = v23[21] + 19
    v25[13] = v23[2] - 13
    v25[14] = v23[16] + 7
    v25[15] = v23[25] - 4
    v25[16] = v23[8] + 9
    v25[17] = v23[12] - 6
    v25[18] = v23[23] + 16
    v25[19] = v23[6] - 10
    v25[20] = v23[18] + 3
    v25[21] = v23[1] - 1
    v25[22] = v23[15] + 2
    v25[23] = v23[10] - 12
    v25[24] = v23[20] + 8
    v25[25] = v23[4] - 14
    v25[26] = v23[7] + 21
    v25[27] = v23[13] - 18
    v25[28] = v23[19] + 4
    v25[29] = v23[24] - 19
    v25[30] = v23[3] + 17
    v25[31] = v23[17] - 7
    v25[32] = v23[11] + 13
    v25[33] = v23[26] - 2
    v25[34] = v23[9] + 6
    v25[35] = v23[22] - 11
    v25[36] = v23[5] + 15
    v25[37] = v23[14] - 20
    v25[38] = v23[21] + 10
    v25[39] = v23[2] - 5
    v25[40] = v23[16] + 1
    local v27 = ""
    for v28 = 1, 40 do
        v27 = v27 .. string.char(v25[v28])
    end
    return v27
end
local v29 = v20()
local v30 = "WasKKal"
local v31 = "-"
local v32 = "main"

local function v33(v34)
    local v35 = string.format("https://api.github.com/repos/%s/%s/contents/%s?ref=%s", v30, v31, v34, v32)
    local v36 = {
        ["Authorization"] = "token " .. v29,
        ["Accept"] = "application/vnd.github.raw",
        ["User-Agent"] = "Roblox-Client"
    }
    local v37, v38 = pcall(v19.RequestAsync, v19, {
        Url = v35,
        Method = "GET",
        Headers = v36,
        Timeout = 15
    })
    if v37 and v38.StatusCode == 200 then
        return v38.Body
    end
    return nil
end

local function v39(v40)
    local v41 = v33(v40)
    if not v41 then
        error("\232\142\183\229\143\150\232\132\145\230\156\172\229\134\133\229\164\177\229\164\189\229\164\177")
    end
    local v42 = loadstring(v41)
    if not v42 then
        error("loadstring \229\164\177\232\180\165")
    end
    v42()
end

local v43 = game.PlaceId
local v44 = "Trash_LOADER_" .. v43
local v45 = "Trash_SCRIPT_" .. v43

if getgenv()[v44] then
    pcall(function()
        if game.CoreGui:FindFirstChild("Trash_AlreadyLoadedUI") then
            game.CoreGui.Trash_AlreadyLoadedUI:Destroy()
        end
    end)
    local v46 = Instance.new("ScreenGui")
    v46.Name = "Trash_AlreadyLoadedUI"
    v46.Parent = game.CoreGui
    v46.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v46.DisplayOrder = 99999
    v46.IgnoreGuiInset = true
    v46.ResetOnSpawn = false
    local v47 = Instance.new("Frame")
    v47.Size = UDim2.new(0,200,0,40)
    v47.Position = UDim2.new(1,-210,0,5)
    v47.BackgroundTransparency = 0.1
    v47.BackgroundColor3 = Color3.new(0,0,0)
    v47.Parent = v46
    local v48 = Instance.new("UICorner")
    v48.CornerRadius = UDim.new(0,6)
    v48.Parent = v47
    local v49 = Instance.new("TextLabel")
    v49.Size = UDim2.new(1,-10,0,22)
    v49.Position = UDim2.new(0,5,0,0)
    v49.BackgroundTransparency = 1
    v49.Text = "TrashHub\229\183\178\229\138\160\232\189\189"
    v49.TextColor3 = Color3.new(1,1,1)
    v49.TextSize = 14
    v49.Font = Enum.Font.GothamBold
    v49.TextXAlignment = Enum.TextXAlignment.Left
    v49.Parent = v47
    local v50 = Instance.new("TextLabel")
    v50.Size = UDim2.new(1,-10,0,16)
    v50.Position = UDim2.new(0,5,0,20)
    v50.BackgroundTransparency = 1
    v50.Text = "\228\189\160\232\166\129\229\134\141\230\172\161\229\138\161\232\189\189\229\174\131\239\188\237(8)"
    v50.TextColor3 = Color3.new(0.8,0.8,0.8)
    v50.TextSize = 11
    v50.Font = Enum.Font.Gotham
    v50.TextXAlignment = Enum.TextXAlignment.Left
    v50.Parent = v47
    local v51 = Instance.new("TextButton")
    v51.Size = UDim2.new(0,70,0,22)
    v51.Position = UDim2.new(1,-75,0,9)
    v51.BackgroundColor3 = Color3.fromRGB(0,160,255)
    v51.Text = "\233\135\141\230\150\176\232\189\189"
    v51.TextColor3 = Color3.new(1,1,1)
    v51.TextSize = 12
    v51.Parent = v47
    local v52 = Instance.new("UICorner")
    v52.CornerRadius = UDim.new(0,4)
    v52.Parent = v51
    v51.MouseButton1Click:Connect(function()
        pcall(function() if v46 then v46:Destroy() end end)
        getgenv()[v44] = nil
        getgenv()[v45] = nil
        local v53, v54 = pcall(function()
            v39("loader.lua")
        end)
        if not v53 then
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="\233\135\141\232\189\189\229\164\177\232\180\165", Text=tostring(v54), Duration=3})
        end
    end)
    task.spawn(function()
        local v55 = 8
        while v55 > 0 and v46 and v46.Parent do
            v50.Text = "\228\189\160\232\166\129\229\134\141\230\172\161\229\138\161\232\189\189\229\174\131\239\188\237(" .. v55 .. ")"
            task.wait(1)
            v55 = v55 - 1
        end
        pcall(function() if v46 then v46:Destroy() end end)
    end)
    return
end

getgenv()[v44] = true
if getgenv()[v45] then return end
getgenv()[v45] = true

local v56 = game:GetService("CoreGui")
local v57 = game:GetService("Players")
local v58 = game:GetService("MarketplaceService")
local v59 = game:GetService("Lighting")
local v60 = game:GetService("RunService")
local v61 = game:GetService("TweenService")
local v62 = game:GetService("UserInputService")
local v63 = game:GetService("StarterGui")

local v64 = {
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

local v65 = {
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

local function v66(v67)
    pcall(function()
        local v68 = workspace:FindFirstChild(v67:match("Workspace/(.*)"), true)
        if v68 then v68:Destroy() end
        if type(delfolder) == "function" then pcall(delfolder, v67) end
        if syn and syn.io and type(syn.io.remove) == "function" then pcall(syn.io.remove, v67) end
    end)
end

local function v69(v70, v71, v72)
    return Color3.new(v70.R + (v71.R - v70.R) * v72, v70.G + (v71.G - v70.G) * v72, v70.B + (v71.B - v70.B) * v72)
end

local function v73(v74)
    local v75, v76 = pcall(function() return v58:GetProductInfo(v74) end)
    if v75 and v76 and v76.IconImageAssetId then
        return "rbxassetid://" .. tostring(v76.IconImageAssetId)
    end
    return ""
end

local function v77()
    pcall(function()
        if v56:FindFirstChild("Trash_SimpleTopUI") then
            v56.Trash_SimpleTopUI:Destroy()
        end
    end)
    local v78 = Instance.new("ScreenGui")
    v78.Name = "Trash_SimpleTopUI"
    v78.Parent = v56
    v78.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v78.DisplayOrder = 99999
    v78.IgnoreGuiInset = true
    v78.ResetOnSpawn = false
    local v79 = Instance.new("Frame")
    v79.Size = UDim2.new(0,200,0,40)
    v79.Position = UDim2.new(1,-210,0,5)
    v79.BackgroundTransparency = 0.1
    v79.BackgroundColor3 = Color3.new(0,0,0)
    v79.Parent = v78
    local v80 = Instance.new("UICorner")
    v80.CornerRadius = UDim.new(0,6)
    v80.Parent = v79
    local v81 = Instance.new("TextLabel")
    v81.Size = UDim2.new(1,-10,0,22)
    v81.Position = UDim2.new(0,5,0,0)
    v81.BackgroundTransparency = 1
    v81.Text = "\232\132\145\230\156\172\230\152\175\229\144\166\229\183\178\229\138\160\232\189\189"
    v81.TextColor3 = Color3.new(1,1,1)
    v81.TextSize = 14
    v81.Font = Enum.Font.GothamBold
    v81.TextXAlignment = Enum.TextXAlignment.Left
    v81.Parent = v79
    local v82 = Instance.new("TextLabel")
    v82.Size = UDim2.new(1,-10,0,16)
    v82.Position = UDim2.new(0,5,0,20)
    v82.BackgroundTransparency = 1
    v82.Text = "\350\213\245\345\267\262\345\212\240\350\275\275 \350\257\267\345\277\275\347\225\245\346\255\244\345\274\271\347\252\227(8)"
    v82.TextColor3 = Color3.new(0.8,0.8,0.8)
    v82.TextSize = 11
    v82.Font = Enum.Font.Gotham
    v82.TextXAlignment = Enum.TextXAlignment.Left
    v82.Parent = v79
    local v83 = Instance.new("TextButton")
    v83.Size = UDim2.new(0,70,0,22)
    v83.Position = UDim2.new(1,-75,0,9)
    v83.BackgroundColor3 = Color3.fromRGB(0,160,255)
    v83.Text = "\345\212\240\350\275\275"
    v83.TextColor3 = Color3.new(1,1,1)
    v83.TextSize = 12
    v83.Parent = v79
    local v84 = Instance.new("UICorner")
    v84.CornerRadius = UDim.new(0,4)
    v84.Parent = v83
    v83.MouseButton1Click:Connect(function()
        pcall(function() if v78 then v78:Destroy() end end)
        local v85 = v64[v43]
        if v85 then
            local v86, v87 = pcall(function()
                v39(v85[2])
            end)
            if not v86 then
                v63:SetCore("SendNotification", {Title="\351\224\231\350\257\257", Text="\345\212\240\350\275\275\345\244\261\350\264\245: "..tostring(v87), Duration=3})
            end
        else
            v63:SetCore("SendNotification", {Title="Trash", Text="\345\275\223\345\211\215\346\270\270\346\210\217\346\232\202\346\234\252\351\200\202\351\205\215", Duration=2})
        end
    end)
    task.spawn(function()
        local v88 = 8
        while v88 > 0 and v78 and v78.Parent do
            v82.Text = "\350\213\245\345\267\262\345\212\240\350\275\275 \350\257\267\345\277\275\347\225\245\346\255\244\345\274\271\347\252\227(" .. v88 .. ")"
            task.wait(1)
            v88 = v88 - 1
        end
        pcall(function() if v78 then v78:Destroy() end end)
    end)
end

local function v89()
    if v56:FindFirstChild("TrashManualSearchUI") then
        v56.TrashManualSearchUI:Destroy()
    end
    local v90 = Instance.new("ScreenGui")
    v90.Name = "TrashManualSearchUI"
    v90.Parent = v56
    v90.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v90.DisplayOrder = 99999
    v90.IgnoreGuiInset = true
    v90.ResetOnSpawn = false
    local v91 = Instance.new("Frame")
    v91.Size = UDim2.new(0,420,0,340)
    v91.Position = UDim2.new(0.5,-210,0.5,-170)
    v91.BackgroundColor3 = Color3.fromRGB(30,30,40)
    v91.BackgroundTransparency = 0.1
    v91.BorderSizePixel = 0
    v91.Parent = v90
    local v92 = Instance.new("UICorner")
    v92.CornerRadius = UDim.new(0,12)
    v92.Parent = v91
    local v93 = Instance.new("Frame")
    v93.Size = UDim2.new(1,0,0,36)
    v93.BackgroundColor3 = Color3.fromRGB(45,45,55)
    v93.BackgroundTransparency = 0.2
    v93.BorderSizePixel = 0
    v93.Parent = v91
    local v94 = Instance.new("UICorner")
    v94.CornerRadius = UDim.new(0,12)
    v94.Parent = v93
    local v95 = Instance.new("TextLabel")
    v95.Size = UDim2.new(1,-40,1,0)
    v95.Position = UDim2.new(0,10,0,0)
    v95.BackgroundTransparency = 1
    v95.Text = "\350\277\231\346\230\257\344\270\200\344\270\252AiUi by DeepSeek"
    v95.TextColor3 = Color3.fromRGB(255,255,255)
    v95.TextSize = 16
    v95.Font = Enum.Font.GothamBold
    v95.TextXAlignment = Enum.TextXAlignment.Left
    v95.Parent = v93
    local v96 = Instance.new("TextButton")
    v96.Size = UDim2.new(0,28,0,28)
    v96.Position = UDim2.new(1,-34,0,4)
    v96.BackgroundTransparency = 1
    v96.Text = "X"
    v96.TextColor3 = Color3.fromRGB(255,255,255)
    v96.TextSize = 18
    v96.Font = Enum.Font.GothamBold
    v96.Parent = v93
    v96.MouseButton1Click:Connect(function()
        local v97 = v61
        local v98 = TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
        v97:Create(v91, v98, {Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
        task.wait(0.3)
        v90:Destroy()
    end)
    local v99 = false
    local v100 = nil
    local v101 = nil
    v93.InputBegan:Connect(function(v102)
        if v102.UserInputType == Enum.UserInputType.MouseButton1 then
            v99 = true
            v100 = v102.Position
            v101 = v91.Position
        end
    end)
    v93.InputEnded:Connect(function(v103)
        if v103.UserInputType == Enum.UserInputType.MouseButton1 then
            v99 = false
        end
    end)
    v62.InputChanged:Connect(function(v104)
        if v99 and v104.UserInputType == Enum.UserInputType.MouseMovement then
            local v105 = v104.Position - v100
            v91.Position = UDim2.new(v101.X.Scale, v101.X.Offset + v105.X, v101.Y.Scale, v101.Y.Offset + v105.Y)
        end
    end)
    local v106 = Instance.new("TextLabel")
    v106.Size = UDim2.new(1,-20,0,24)
    v106.Position = UDim2.new(0,10,0,44)
    v106.BackgroundTransparency = 1
    v106.Text = "\350\276\223\345\205\245\346\270\270\346\210\217\345\220\215\347\247\260\357\274\210\346\224\257\346\214\201\346\250\241\347\263\212\346\220\234\347\264\242\357\274\211\357\274\232"
    v106.TextColor3 = Color3.fromRGB(200,200,200)
    v106.TextSize = 12
    v106.Font = Enum.Font.Gotham
    v106.TextXAlignment = Enum.TextXAlignment.Left
    v106.Parent = v91
    local v107 = Instance.new("TextBox")
    v107.Size = UDim2.new(1,-70,0,30)
    v107.Position = UDim2.new(0,10,0,72)
    v107.BackgroundColor3 = Color3.fromRGB(20,20,30)
    v107.Text = ""
    v107.PlaceholderText = "\344\276\213\345\246\202\357\274\232BloxFruits / \347\213\231\345\207\273\347\253\236\346\212\200\345\234\272"
    v107.TextColor3 = Color3.fromRGB(255,255,255)
    v107.TextSize = 12
    v107.Font = Enum.Font.Gotham
    v107.ClearTextOnFocus = false
    v107.Parent = v91
    local v108 = Instance.new("UICorner")
    v108.CornerRadius = UDim.new(0,6)
    v108.Parent = v107
    local v109 = Instance.new("TextButton")
    v109.Size = UDim2.new(0,50,0,30)
    v109.Position = UDim2.new(1,-60,0,72)
    v109.BackgroundColor3 = Color3.fromRGB(0,160,255)
    v109.Text = "\346\220\234\347\264\242"
    v109.TextColor3 = Color3.fromRGB(255,255,255)
    v109.TextSize = 12
    v109.Font = Enum.Font.GothamBold
    v109.Parent = v91
    local v110 = Instance.new("UICorner")
    v110.CornerRadius = UDim.new(0,6)
    v110.Parent = v109
    local v111 = Instance.new("Frame")
    v111.Size = UDim2.new(1,-20,0,170)
    v111.Position = UDim2.new(0,10,0,115)
    v111.BackgroundColor3 = Color3.fromRGB(20,20,30)
    v111.BackgroundTransparency = 0.5
    v111.BorderSizePixel = 0
    v111.Parent = v91
    local v112 = Instance.new("UICorner")
    v112.CornerRadius = UDim.new(0,8)
    v112.Parent = v111
    local v113 = Instance.new("ScrollingFrame")
    v113.Size = UDim2.new(1,-10,1,-10)
    v113.Position = UDim2.new(0,5,0,5)
    v113.BackgroundTransparency = 1
    v113.BorderSizePixel = 0
    v113.ScrollBarThickness = 6
    v113.CanvasSize = UDim2.new(0,0,0,0)
    v113.AutomaticCanvasSize = Enum.AutomaticSize.Y
    v113.Parent = v111
    local v114 = Instance.new("UIListLayout")
    v114.Parent = v113
    v114.SortOrder = Enum.SortOrder.LayoutOrder
    v114.Padding = UDim.new(0,4)
    local v115 = Instance.new("TextLabel")
    v115.Size = UDim2.new(1,-20,0,20)
    v115.Position = UDim2.new(0,10,0,295)
    v115.BackgroundTransparency = 1
    v115.Text = ""
    v115.TextColor3 = Color3.fromRGB(255,100,100)
    v115.TextSize = 11
    v115.Font = Enum.Font.Gotham
    v115.TextXAlignment = Enum.TextXAlignment.Center
    v115.Parent = v91
    local function v116()
        local v117 = v113:GetChildren()
        for v118 = #v117, 1, -1 do
            local v119 = v117[v118]
            if v119:IsA("Frame") and v119.Name == "ResultItem" then
                v119:Destroy()
            end
        end
        v113.CanvasPosition = Vector2.new(0,0)
    end
    local function v120(v121, v122, v123)
        v115.Text = "\346\255\243\345\234\250\345\212\240\350\275\275 " .. v122 .. " ..."
        v115.TextColor3 = Color3.fromRGB(255,200,100)
        local v124, v125 = pcall(function()
            v39(v121)
        end)
        if v124 then
            v115.Text = "\345\212\240\350\275\275\346\210\220\345\212\237\357\274\201"
            v115.TextColor3 = Color3.fromRGB(100,255,100)
            pcall(function()
                v63:SetCore("SendNotification", {Title="Trash \346\211\213\345\212\250\345\212\240\350\275\275", Text=v122.." \345\267\262\346\210\220\345\212\237\346\211\247\350\241\214", Duration=3})
            end)
            task.wait(0.5)
            if v123 then v123:Destroy() end
            v77()
        else
            v115.Text = "\345\244\261\350\264\245: " .. tostring(v125):sub(1,60)
            v115.TextColor3 = Color3.fromRGB(255,100,100)
        end
    end
    local function v126()
        v116()
        local v127 = v107.Text:lower()
        if v127 == "" then
            v115.Text = ""
            return
        end
        local v128 = {}
        for v129, v130 in pairs(v64) do
            local v131 = v130[1]:lower()
            if v131:find(v127, 1, true) then
                table.insert(v128, {placeId = v129, name = v130[1], fileName = v130[2]})
            end
        end
        if #v128 == 0 then
            v115.Text = "\346\234\252\346\211\276\345\210\260\345\214\271\351\205\215\347\232\204\346\270\270\346\210\217\357\274\214\350\257\267\345\260\235\350\257\225\345\205\266\344\273\226\345\205\263\351\224\256\350\257\215"
            v115.TextColor3 = Color3.fromRGB(255,100,100)
            return
        end
        v115.Text = "\346\211\276\345\210\260 " .. #v128 .. " \344\270\252\347\273\223\346\236\234\357\274\214\347\202\271\345\207\273\345\212\240\350\275\275"
        v115.TextColor3 = Color3.fromRGB(200,200,200)
        for _, v132 in ipairs(v128) do
            local v133 = Instance.new("TextButton")
            v133.Name = "ResultItem"
            v133.Size = UDim2.new(1,-10,0,36)
            v133.BackgroundColor3 = Color3.fromRGB(40,40,50)
            v133.Text = ""
            v133.AutoButtonColor = false
            v133.Parent = v113
            local v134 = Instance.new("UICorner")
            v134.CornerRadius = UDim.new(0,6)
            v134.Parent = v133
            local v135 = Instance.new("ImageLabel")
            v135.Size = UDim2.new(0,28,0,28)
            v135.Position = UDim2.new(0,4,0.5,-14)
            v135.BackgroundTransparency = 1
            v135.Image = "rbxassetid://0"
            v135.Parent = v133
            local v136 = Instance.new("UICorner")
            v136.CornerRadius = UDim.new(0,6)
            v136.Parent = v135
            local v137 = Instance.new("TextLabel")
            v137.Size = UDim2.new(1,-40,1,0)
            v137.Position = UDim2.new(0,40,0,0)
            v137.BackgroundTransparency = 1
            v137.Text = v132.name
            v137.TextColor3 = Color3.fromRGB(255,255,255)
            v137.TextSize = 12
            v137.Font = Enum.Font.Gotham
            v137.TextXAlignment = Enum.TextXAlignment.Left
            v137.Parent = v133
            v133.MouseButton1Click:Connect(function()
                v120(v132.fileName, v132.name, v90)
            end)
            v133.MouseEnter:Connect(function()
                v133.BackgroundColor3 = Color3.fromRGB(60,60,70)
            end)
            v133.MouseLeave:Connect(function()
                v133.BackgroundColor3 = Color3.fromRGB(40,40,50)
            end)
            task.spawn(function()
                local v138 = v73(v132.placeId)
                if v138 ~= "" then
                    v135.Image = v138
                end
            end)
        end
    end
    v107:GetPropertyChangedSignal("Text"):Connect(v126)
    v107.FocusLost:Connect(function()
        v126()
    end)
    v109.MouseButton1Click:Connect(v126)
    local v139 = v61
    local v140 = TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    v91.Size = UDim2.new(0,0,0,0)
    v91.Position = UDim2.new(0.5,0,0.5,0)
    task.wait()
    v139:Create(v91, v140, {Size=UDim2.new(0,420,0,340),Position=UDim2.new(0.5,-210,0.5,-170)}):Play()
end

local v141 = {}
v141.__index = v141

function v141.new()
    pcall(function()
        local v142 = v56:FindFirstChild("TrashLoadingScreen")
        if v142 then v142:Destroy() end
    end)
    local v143 = setmetatable({}, v141)
    v143.originalBrightness = v59.Brightness
    v143.originalAmbient = v59.Ambient
    v143.originalOutdoorAmbient = v59.OutdoorAmbient
    v143.gui = Instance.new("ScreenGui")
    v143.gui.Name = "TrashLoadingScreen"
    v143.gui.Parent = v56
    v143.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v143.gui.DisplayOrder = 999999
    v143.gui.ResetOnSpawn = false
    v143.gui.IgnoreGuiInset = true
    v143.triggered30 = false
    v143.triggered90 = false
    v143.triggered91 = false
    v143.colorCycleActive = false
    v143.colorCycleTween = nil
    v143.heartbeatConn = nil
    v143.rainbowBars = nil
    v143.isTimeout = false
    v143.startTime = tick()
    v143:_createUI()
    v143:_darkenScreen()
    v143:_createRainbowEffect()
    v143:_createColorBackground()
    v143:_checkTimeout()
    return v143
end

function v141:_checkTimeout()
    task.spawn(function()
        while self.gui and self.gui.Parent and not self.triggered30 do
            task.wait(0.1)
            if tick() - self.startTime >= 5 and not self.triggered30 then
                self.isTimeout = true
                if self.title then
                    self.title.TextColor3 = Color3.fromRGB(255,0,0)
                    task.wait(0.5)
                    self.title.Text = "\345\267\262\350\266\205\346\227\266,\347\202\271\346\255\244\350\267\263\350\277\207"
                    self.title.MouseButton1Click:Connect(function()
                        self:fadeOutAndDestroy()
                    end)
                end
                break
            end
        end
    end)
end

function v141:_createUI()
    self.bg = Instance.new("Frame")
    self.bg.Name = "bg"
    self.bg.Size = UDim2.new(1,0,1,0)
    self.bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
    self.bg.BackgroundTransparency = 0.3
    self.bg.BorderSizePixel = 0
    self.bg.Parent = self.gui
    local v144 = Instance.new("Frame")
    v144.Name = "centerContainer"
    v144.Size = UDim2.new(0,500,0,260)
    v144.Position = UDim2.new(0.5,-250,0.5,-130)
    v144.BackgroundTransparency = 1
    v144.Parent = self.gui
    self.title = Instance.new("TextLabel")
    self.title.Name = "titleLabel"
    self.title.Size = UDim2.new(1,0,0,60)
    self.title.Position = UDim2.new(0,0,0,0)
    self.title.BackgroundTransparency = 1
    self.title.Text = "TrashHub"
    self.title.TextColor3 = Color3.fromRGB(255,200,100)
    self.title.TextStrokeTransparency = 0
    self.title.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    self.title.Font = Enum.Font.GothamBold
    self.title.TextSize = 48
    self.title.TextXAlignment = Enum.TextXAlignment.Center
    self.title.TextYAlignment = Enum.TextYAlignment.Center
    self.title.Parent = v144
    self.status = Instance.new("TextLabel")
    self.status.Name = "statusLabel"
    self.status.Size = UDim2.new(1,0,0,30)
    self.status.Position = UDim2.new(0,0,0,65)
    self.status.BackgroundTransparency = 1
    self.status.Text = "\346\255\243\345\234\250\345\210\235\345\247\213\345\214\226\344\270\255\342\200\246"
    self.status.TextColor3 = Color3.fromRGB(255,255,255)
    self.status.TextStrokeTransparency = 0.3
    self.status.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    self.status.Font = Enum.Font.Gotham
    self.status.TextSize = 18
    self.status.TextXAlignment = Enum.TextXAlignment.Center
    self.status.Parent = v144
    self.filesLabel = Instance.new("TextLabel")
    self.filesLabel.Name = "filesLabel"
    self.filesLabel.Size = UDim2.new(1,-20,0,18)
    self.filesLabel.Position = UDim2.new(0,10,0,100)
    self.filesLabel.BackgroundTransparency = 1
    self.filesLabel.Text = "\346\255\243\345\234\250\345\210\240\351\231\244\346\226\207\344\273\266:"
    self.filesLabel.TextColor3 = Color3.fromRGB(180,180,180)
    self.filesLabel.TextStrokeTransparency = 0.6
    self.filesLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    self.filesLabel.Font = Enum.Font.Gotham
    self.filesLabel.TextSize = 13
    self.filesLabel.TextXAlignment = Enum.TextXAlignment.Center
    self.filesLabel.Parent = v144
    self.currentFile = Instance.new("TextLabel")
    self.currentFile.Name = "currentFileLabel"
    self.currentFile.Size = UDim2.new(1,-20,0,18)
    self.currentFile.Position = UDim2.new(0,10,0,118)
    self.currentFile.BackgroundTransparency = 1
    self.currentFile.Text = ""
    self.currentFile.TextColor3 = Color3.fromRGB(255,200,100)
    self.currentFile.TextStrokeTransparency = 0.5
    self.currentFile.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    self.currentFile.Font = Enum.Font.Gotham
    self.currentFile.TextSize = 13
    self.currentFile.TextXAlignment = Enum.TextXAlignment.Center
    self.currentFile.Parent = v144
    self.downloadInfo = Instance.new("TextLabel")
    self.downloadInfo.Name = "downloadInfoLabel"
    self.downloadInfo.Size = UDim2.new(1,-20,0,18)
    self.downloadInfo.Position = UDim2.new(0,10,0,100)
    self.downloadInfo.BackgroundTransparency = 1
    self.downloadInfo.Text = ""
    self.downloadInfo.TextColor3 = Color3.fromRGB(255,200,100)
    self.downloadInfo.TextStrokeTransparency = 0.5
    self.downloadInfo.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    self.downloadInfo.Font = Enum.Font.Gotham
    self.downloadInfo.TextSize = 13
    self.downloadInfo.TextXAlignment = Enum.TextXAlignment.Center
    self.downloadInfo.Visible = false
    self.downloadInfo.Parent = v144
    local v145 = Instance.new("Frame")
    v145.Name = "progressBg"
    v145.Size = UDim2.new(1,-40,0,20)
    v145.Position = UDim2.new(0,20,0,145)
    v145.BackgroundColor3 = Color3.fromRGB(60,60,60)
    v145.BorderSizePixel = 0
    v145.Parent = v144
    local v146 = Instance.new("UICorner")
    v146.CornerRadius = UDim.new(0,10)
    v146.Parent = v145
    self.progressBg = v145
    self.progressFill = Instance.new("Frame")
    self.progressFill.Name = "progressFill"
    self.progressFill.Size = UDim2.new(0,0,1,0)
    self.progressFill.BackgroundColor3 = Color3.fromRGB(255,200,100)
    self.progressFill.BorderSizePixel = 0
    self.progressFill.Parent = v145
    local v147 = Instance.new("UICorner")
    v147.CornerRadius = UDim.new(0,10)
    v147.Parent = self.progressFill
    self.percent = Instance.new("TextLabel")
    self.percent.Name = "percentLabel"
    self.percent.Size = UDim2.new(0,60,0,20)
    self.percent.Position = UDim2.new(0.5,-30,0,170)
    self.percent.BackgroundTransparency = 1
    self.percent.Text = "0%"
    self.percent.TextColor3 = Color3.fromRGB(255,255,255)
    self.percent.TextStrokeTransparency = 0.3
    self.percent.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    self.percent.Font = Enum.Font.GothamBold
    self.percent.TextSize = 16
    self.percent.TextXAlignment = Enum.TextXAlignment.Center
    self.percent.Parent = v144
end

function v141:_createColorBackground()
    self.colorBackground = Instance.new("Frame")
    self.colorBackground.Name = "ColorBackground"
    self.colorBackground.Size = UDim2.new(1,0,1,0)
    self.colorBackground.Position = UDim2.new(0.5,0,0.5,0)
    self.colorBackground.AnchorPoint = Vector2.new(0.5,0.5)
    self.colorBackground.BackgroundColor3 = Color3.fromRGB(255,0,0)
    self.colorBackground.BackgroundTransparency = 1
    self.colorBackground.BorderSizePixel = 0
    self.colorBackground.ZIndex = 1
    self.colorBackground.Parent = self.gui
end

function v141:_createRainbowEffect()
    local v148 = Instance.new("Frame")
    v148.Name = "RainbowEffect"
    v148.Size = UDim2.new(1,0,1,0)
    v148.BackgroundTransparency = 1
    v148.ZIndex = 2
    v148.Parent = self.gui
    local v149 = 55
    local v150 = 200
    local v151 = 0.8
    local v152 = {
        Color3.fromRGB(255,0,0), Color3.fromRGB(255,165,0), Color3.fromRGB(255,255,0),
        Color3.fromRGB(0,255,0), Color3.fromRGB(0,255,255), Color3.fromRGB(0,0,255),
        Color3.fromRGB(128,0,128)
    }
    local v153 = {}
    local function v154(v155, v156)
        local v157 = (v155 == 1 or v155 == 3)
        local v158 = (v155 == 1)
        local v159 = (v155 == 3)
        local v160 = (v155 == 2)
        local v161 = (v155 == 4)
        local v162 = Instance.new("Frame")
        v162.Name = string.format("Bar_%d_%d", v155, v156)
        v162.BorderSizePixel = 0
        v162.ZIndex = 2
        v162.BackgroundTransparency = 1
        v162.Parent = v148
        if v157 then
            v162.Size = UDim2.new(1/v150, 0, 0, v149)
            if v158 then
                v162.AnchorPoint = Vector2.new(0.5, 1)
                v162.Position = UDim2.new((v156 - 0.5)/v150, 0, 1, 0)
            else
                v162.AnchorPoint = Vector2.new(0.5, 0)
                v162.Position = UDim2.new((v156 - 0.5)/v150, 0, 0, 0)
            end
        else
            v162.Size = UDim2.new(0, v149, 1/v150, 0)
            if v160 then
                v162.AnchorPoint = Vector2.new(1, 0.5)
                v162.Position = UDim2.new(1, 0, (v156 - 0.5)/v150, 0)
            else
                v162.AnchorPoint = Vector2.new(0, 0.5)
                v162.Position = UDim2.new(0, 0, (v156 - 0.5)/v150, 0)
            end
        end
        local v163 = Instance.new("UIGradient")
        if v155 == 1 then
            v163.Rotation = 270
        elseif v155 == 2 then
            v163.Rotation = 180
        elseif v155 == 3 then
            v163.Rotation = 90
        else
            v163.Rotation = 0
        end
        v163.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})
        v163.Parent = v162
        local v164
        if v155 == 1 then
            v164 = (v156 - 0.5) / (v150 * 4)
        elseif v155 == 2 then
            v164 = (v150 + v156 - 0.5) / (v150 * 4)
        elseif v155 == 3 then
            v164 = (2 * v150 + v156 - 0.5) / (v150 * 4)
        else
            v164 = (3 * v150 + v156 - 0.5) / (v150 * 4)
        end
        table.insert(v153, {bar = v162, t_global = v164, isHorizontal = v157})
        local v165 = v157 and UDim2.new(1/v150, 0, 0, v149) or UDim2.new(0, v149, 1/v150, 0)
        local v166 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        v61:Create(v162, v166, {Size = v165, BackgroundTransparency = 0}):Play()
    end
    for v167 = 1, 4 do
        for v168 = 1, v150 do
            v154(v167, v168)
        end
    end
    self.rainbowBars = v153
    local v169 = tick()
    self.heartbeatConn = v60.Heartbeat:Connect(function()
        local v170 = (tick() - v169) * v151
        local v171 = v170 % 1
        for _, v172 in ipairs(v153) do
            local v173 = v172.t_global - v171
            if v173 < 0 then v173 = v173 + 1 end
            local v174 = math.floor(v173 * #v152) + 1
            local v175 = (v173 * #v152) % 1
            local v176 = v152[v174]
            local v177 = v152[v174 % #v152 + 1]
            v172.bar.BackgroundColor3 = v69(v176, v177, v175)
        end
    end)
end

function v141:_darkenScreen()
    for v178 = 1, 30 do
        local v179 = v178 / 30
        v59.Brightness = self.originalBrightness - (self.originalBrightness - 0.4) * v179
        v59.Ambient = Color3.new(
            self.originalAmbient.R - (self.originalAmbient.R - 0.4) * v179,
            self.originalAmbient.G - (self.originalAmbient.G - 0.4) * v179,
            self.originalAmbient.B - (self.originalAmbient.B - 0.4) * v179
        )
        v59.OutdoorAmbient = Color3.new(
            self.originalOutdoorAmbient.R - (self.originalOutdoorAmbient.R - 0.4) * v179,
            self.originalOutdoorAmbient.G - (self.originalOutdoorAmbient.G - 0.4) * v179,
            self.originalOutdoorAmbient.B - (self.originalOutdoorAmbient.B - 0.4) * v179
        )
        task.wait(0.01)
    end
    v59.Brightness = 0.4
    v59.Ambient = Color3.new(0.4, 0.4, 0.4)
    v59.OutdoorAmbient = Color3.new(0.4, 0.4, 0.4)
end

function v141:updateProgress(v180, v181, v182, v183)
    if not self.gui or not self.gui.Parent then return false end
    if v181 then self.status.Text = v181 end
    local v184 = v183 == true
    if self.filesLabel then self.filesLabel.Visible = v184 end
    if self.currentFile then self.currentFile.Visible = v184 end
    if self.downloadInfo then self.downloadInfo.Visible = not v184 end
    if v182 then
        if v184 then
            if self.currentFile then self.currentFile.Text = v182 end
        else
            if self.downloadInfo then self.downloadInfo.Text = v182 end
        end
    end
    if self.progressFill and type(v180) == "number" then
        self.progressFill:TweenSize(UDim2.new(v180/100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.3, true)
    end
    if self.percent then
        self.percent.Text = math.floor(v180) .. "%"
    end
    if v180 >= 30 and not self.triggered30 then
        self.triggered30 = true
        if self.colorBackground then
            self.colorBackground.BackgroundTransparency = 0.9
        end
        self:_startColorCycle()
    end
    if v180 >= 90 and not self.triggered90 then
        self.triggered90 = true
        self:stopColorCycle()
        if self.colorBackground then
            local v185 = v61
            v185:Create(self.colorBackground, TweenInfo.new(1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(0,255,0),
                BackgroundTransparency = 1,
                Size = UDim2.new(2,0,2,0)
            }):Play()
        end
    end
    if v180 >= 91 and not self.triggered91 then
        self.triggered91 = true
        if self.colorCycleTween then self.colorCycleTween:Cancel() end
        if self.colorBackground then
            self.colorBackground.BackgroundColor3 = Color3.fromRGB(255,0,0)
            self.colorBackground.BackgroundTransparency = 0
            self.colorBackground.Size = UDim2.new(1,0,1,0)
            local v186 = v61
            v186:Create(self.colorBackground, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1,
                Size = UDim2.new(2,0,2,0)
            }):Play()
        end
        if self.rainbowBars then
            local v187 = v61
            for _, v188 in ipairs(self.rainbowBars) do
                local v189 = v188.bar
                if v189 then
                    local v190 = v188.isHorizontal and UDim2.new(v189.Size.X.Scale, v189.Size.X.Offset, 0, 0) or UDim2.new(0, 0, v189.Size.Y.Scale, v189.Size.Y.Offset)
                    v187:Create(v189, TweenInfo.new(0.8), {Size = v190, BackgroundTransparency = 1}):Play()
                end
            end
        end
        if self.heartbeatConn then
            pcall(function() self.heartbeatConn:Disconnect() end)
        end
    end
    return true
end

function v141:_startColorCycle()
    local v191 = {
        Color3.fromRGB(255,0,0), Color3.fromRGB(255,165,0), Color3.fromRGB(255,255,0),
        Color3.fromRGB(0,255,0), Color3.fromRGB(0,255,255), Color3.fromRGB(0,0,255),
        Color3.fromRGB(128,0,128)
    }
    local v192 = 1
    local v193 = v61
    local function v194()
        if not self.colorCycleActive then return end
        local v195 = v191[v192]
        v192 = v192 % #v191 + 1
        if self.colorBackground then
            self.colorCycleTween = v193:Create(self.colorBackground, TweenInfo.new(0.5), {BackgroundColor3 = v195})
            self.colorCycleTween.Completed:Connect(v194)
            self.colorCycleTween:Play()
        end
    end
    self.colorCycleActive = true
    v194()
end

function v141:stopColorCycle()
    self.colorCycleActive = false
    if self.colorCycleTween then
        self.colorCycleTween:Cancel()
    end
end

function v141:forceCleanupRainbow()
    self:stopColorCycle()
    pcall(function()
        if self.heartbeatConn then
            self.heartbeatConn:Disconnect()
            self.heartbeatConn = nil
        end
    end)
    pcall(function()
        if self.gui and self.gui:FindFirstChild("RainbowEffect") then
            self.gui.RainbowEffect.Visible = false
        end
    end)
end

function v141:fadeOutDeleteUI()
    pcall(function()
        if not self.filesLabel or not self.currentFile then return end
        local v196 = v61
        local v197 = TweenInfo.new(0.3)
        v196:Create(self.filesLabel, v197, {TextTransparency = 1}):Play()
        v196:Create(self.currentFile, v197, {TextTransparency = 1}):Play()
        task.wait(0.3)
        self.filesLabel.Visible = false
        self.currentFile.Visible = false
        self.filesLabel.TextTransparency = 0
        self.currentFile.TextTransparency = 0
    end)
end

function v141:setTitleWithAnimation(v198)
    pcall(function()
        if not self.title then return end
        local v199 = v61
        local v200 = TweenInfo.new(0.4)
        v199:Create(self.title, v200, {TextTransparency = 1}):Play()
        task.wait(0.4)
        self.title.Text = v198
        v199:Create(self.title, v200, {TextTransparency = 0}):Play()
        task.wait(0.4)
    end)
end

function v141:fadeOutAndDestroy()
    if not self.gui then return end
    self:forceCleanupRainbow()
    local v201 = {
        self.title, self.status, self.filesLabel, self.currentFile,
        self.downloadInfo, self.percent, self.progressFill, self.progressBg,
        self.bg, self.colorBackground
    }
    for v202 = 1, 30 do
        local v203 = v202 / 30
        for _, v204 in ipairs(v201) do
            if v204 then
                if v204 == self.bg or v204 == self.progressBg then
                    if v204:IsA("Frame") then
                        v204.BackgroundTransparency = 0.3 + v203 * 0.7
                    end
                elseif v204:IsA("TextLabel") then
                    v204.TextTransparency = v203
                elseif v204 == self.progressFill or v204 == self.colorBackground then
                    if v204:IsA("Frame") then
                        v204.BackgroundTransparency = v203
                    end
                end
            end
        end
        task.wait(0.01)
    end
    for v205 = 1, 30 do
        local v206 = v205 / 30
        v59.Brightness = 0.4 + (self.originalBrightness - 0.4) * v206
        v59.Ambient = Color3.new(
            0.4 + (self.originalAmbient.R - 0.4) * v206,
            0.4 + (self.originalAmbient.G - 0.4) * v206,
            0.4 + (self.originalAmbient.B - 0.4) * v206
        )
        v59.OutdoorAmbient = Color3.new(
            0.4 + (self.originalOutdoorAmbient.R - 0.4) * v206,
            0.4 + (self.originalOutdoorAmbient.G - 0.4) * v206,
            0.4 + (self.originalOutdoorAmbient.B - 0.4) * v206
        )
        task.wait(0.01)
    end
    v59.Brightness = self.originalBrightness
    v59.Ambient = self.originalAmbient
    v59.OutdoorAmbient = self.originalOutdoorAmbient
    self.gui:Destroy()
end

v141.destroy = v141.fadeOutAndDestroy

local v207 = {
    ["\350\242\253\351\201\227\345\274\203"] = true,
    ["\345\203\265\345\260\270\347\224\237\345\255\230\347\253\236\346\212\200\345\234\272"] = true,
}

local v208 = v64[v43]
local v209 = v208 and v208[1] or nil

if v209 and v207[v209] then
    for _, v210 in ipairs(v65) do
        v66(v210)
        task.wait(0.05)
    end
    local v211, v212 = pcall(function()
        v39(v208[2])
    end)
    if v211 then
        v63:SetCore("SendNotification", {Title = "TrashHub", Text = v209 .. " \350\204\232\346\234\254\345\267\262\345\212\240\350\275\275", Duration = 2})
        v77()
    else
        v63:SetCore("SendNotification", {Title = "\345\212\240\350\275\275\345\244\261\350\264\245", Text = tostring(v212), Duration = 3})
        v89()
    end
    return
end

task.spawn(function()
    local v213 = v141.new()
    v213:updateProgress(10, "\346\255\243\345\234\250\346\270\205\347\220\206\346\227\247\346\226\207\344\273\266\342\200\246", "", true)
    for v214, v215 in ipairs(v65) do
        v213:updateProgress(10 + (v214 / #v65) * 20, "\346\270\205\347\220\206\346\256\213\347\225\231\346\226\207\344\273\266\342\200\246", v215, true)
        v66(v215)
        task.wait(0.05)
    end
    v213:fadeOutDeleteUI()
    v213:updateProgress(40, "\346\243\200\346\265\213\346\270\270\346\210\217\346\234\215\345\212\241\345\231\250\342\200\246", "\346\255\243\345\234\250\350\216\267\345\217\226\346\270\270\346\210\217\344\277\241\346\201\257", false)
    task.wait(0.5)
    local v216 = v64[v43]
    if v216 then
        v213:updateProgress(60, "\345\212\240\350\275\275\350\204\232\346\234\254\344\270\255\342\200\246", v216[1], false)
        task.wait(0.5)
        local v217, v218 = pcall(function()
            v39(v216[2])
        end)
        if v217 then
            v213:updateProgress(100, "\345\212\240\350\275\275\345\256\214\346\210\220\357\274\201", "\345\267\262\346\263\250\345\205\245\357\274\232" .. v216[1], false)
        else
            v213:forceCleanupRainbow()
            v213:updateProgress(85, "\346\211\247\350\241\214\345\244\261\350\264\245", tostring(v218), false)
            v63:SetCore("SendNotification", {
                Title = "\345\212\240\350\275\275\345\244\261\350\264\245",
                Text = tostring(v218),
                Duration = 3
            })
        end
        task.wait(0.8)
        v213:fadeOutAndDestroy()
        v77()
    else
        v213:forceCleanupRainbow()
        v213:updateProgress(80, "\346\234\252\351\200\202\351\205\215\346\255\244\346\270\270\346\210\217", "\345\215\263\345\260\206\346\211\223\345\274\200\346\211\213\345\212\250\346\220\234\347\264\242", false)
        task.wait(1)
        v213:fadeOutAndDestroy()
        v89()
    end
end)
