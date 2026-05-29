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
    local p1 = "ghp_XPpjEu0yObe6SOL"
    local p2 = "RvPZITqsZ6kxZ7l15zQdg"
    return p1 .. p2
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
    label.Text = "TrashHubLoaded"
    label.TextColor3 = Color3.new(1,1,1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local tip = Instance.new("TextLabel")
    tip.Size = UDim2.new(1,-10,0,16)
    tip.Position = UDim2.new(0,5,0,20)
    tip.BackgroundTransparency = 1
    tip.Text = "Reload?(8)"
    tip.TextColor3 = Color3.new(0.8,0.8,0.8)
    tip.TextSize = 11
    tip.Font = Enum.Font.Gotham
    tip.TextXAlignment = Enum.TextXAlignment.Left
    tip.Parent = frame
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,70,0,22)
    btn.Position = UDim2.new(1,-75,0,9)
    btn.BackgroundColor3 = Color3.fromRGB(0,160,255)
    btn.Text = "Reload"
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
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="ReloadFailed", Text=tostring(err), Duration=3})
        end
    end)
    task.spawn(function()
        local remaining = 8
        while remaining > 0 and gui and gui.Parent do
            tip.Text = "Reload?(" .. remaining .. ")"
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
    [11257760806] = {"InBackAlley", "在后巷.lua"},
    [133086043677134] = {"GrassIncrement", "割草增量.lua"},
    [70960300100792] = {"DropperIncrement", "滴管增量.lua"},
    [115442728708640] = {"GlideEscape", "滑翔翼逃生.lua"},
    [133379826754141] = {"WouldYouRather", "你更愿意,但它会发生.lua"},
    [537413528] = {"BuildBoatTreasure", "造船寻宝.lua"},
    [79311273910901] = {"BladeSpin", "刀片旋转.lua"},
    [98291788885415] = {"UltimatePlusOneSize", "终极+1大小.lua"},
    [129195078205390] = {"FireballTrain", "火球训练.lua"},
    [2753915549] = {"BloxFruits-Sea1", "BloxFruits.lua"},
    [4442272183] = {"BloxFruits-Sea2", "BloxFruits.lua"},
    [79091703265657] = {"BloxFruits-Sea2", "BloxFruits.lua"},
    [7449423635] = {"BloxFruits-Sea3", "BloxFruits.lua"},
    [100117331123089] = {"BloxFruits-Sea3", "BloxFruits.lua"},
    [155382109] = {"Area51War", "大战51区.lua"},
    [130247632398296] = {"AnimeBattleSim", "动漫战斗模拟器.lua"},
    [3623096087] = {"StrengthLegend", "力量传奇.lua"},
    [6243946064] = {"TrollgeMultiverse", "Trollge多重宇宙.lua"},
    [6839171747] = {"Doors", "Doors.lua"},
    [3956818381] = {"NinjaLegend", "忍者传奇.lua"},
    [3101667897] = {"SpeedLegend", "极速传奇.lua"},
    [10449761463] = {"StrongestBattlefield", "最强战场.lua"},
    [102181577519757] = {"DarkDeception", "黑暗欺骗.lua"},
    [125591428878906] = {"DarkDeception", "黑暗欺骗.lua"},
    [131384651617456] = {"UnlimitedBoost", "无限提升.lua"},
    [122446657157717] = {"SniperArena", "狙击竞技场.lua"},
    [83645629621104] = {"Abandoned", "被遗弃.lua"},
    [16434298947] = {"QuanzhouArea", "泉州军区.lua"},
    [70876832253163] = {"DeathTrail", "死亡轨迹.lua"},
    [15459962483] = {"CircleIncrement", "圆圈增量.lua"},
    [8908228901] = {"SharkBite2", "鲨鱼咬2.lua"},
    [131623223084840] = {"TsunamiEscape", "逃离海啸.lua"},
    [124955530864032] = {"SniperArena", "狙击竞技场.lua"},
    [90625015569871] = {"SniperArena", "狙击竞技场.lua"},
    [74244835465756] = {"SAF2", "SAF2.lua"},
    [12196278347] = {"Refinery2", "炼油厂2.lua"},
    [103571191458177] = {"DigTrain", "挖掘训练.lua"},
    [88933961678687] = {"HyperRunner", "超高速跑者.lua"},
    [18519254033] = {"JumpDuel", "跳跃对决.lua"},
    [98927955463992] = {"ZombieSurvivalArena", "僵尸生存竞技场.lua"},
    [85558337864610] = {"Raft101Days", "木筏101天生存.lua"},
    [96645548064314] = {"CaptureTame", "捕捉与驯服.lua"},
    [116139828947259] = {"ApocalypseSurvival", "启示录生存.lua"},
    [87018676608089] = {"PistolArena", "手枪竞技场.lua"},
    [101733180974837] = {"BullBattle", "公牛之战.lua"},
    [115511501544785] = {"FindGiantFish", "寻找巨型鱼.lua"},
    [8343259840] = {"CrimCity", "CrimCity.lua"},
    [126509999114328] = {"Forest99Nights", "森林99夜.lua"},
    [139802517550914] = {"Sea100Days", "海上100天.lua"},
    [76265039822282] = {"AmberAlert", "琥珀警报.lua"},
    [80953732024525] = {"IslandSurvival", "在岛上生存.lua"},
    [12497348201] = {"FNAFCoop", "FNAF.lua"},
    [11958318242] = {"OhioAC", "Ohio.lua"},
    [7239319209] = {"Ohio", "Ohio.lua"},
    [98626216952426] = {"NaramoNPP", "纳拉莫核电站.lua"},
    [77634959918754] = {"Drift50Days", "飘流50天.lua"},
    [79657240466394] = {"ContainerRNG", "集装箱RNG.lua"},
    [128001665358186] = {"HorrorShawarma", "恐怖沙威玛.lua"},
    [109844393857822] = {"MadPlague", "疯狂瘟疫.lua"},
    [99641726104567] = {"AbandonedCity100Days", "废弃城市100天.lua"},
    [104449611620196] = {"TrollTowerInf", "巨魔塔.lua"},
    [109187599373995] = {"WoodIncrementSim", "木材增量模拟器.lua"},
    [118433033586507] = {"SimpleSpell", "简单法术.lua"},
    [13822889] = {"LumberTycoon", "伐木大亨.lua"},
    [12997619803] = {"CloneKingdomTycoon", "克隆.lua"},
    [1554960397] = {"CarDealerTycoon", "汽车经销商.lua"},
    [80349677404572] = {"FeedYourTeto", "喂食泰托.lua"},
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
    ["Abandoned"] = true,
    ["ZombieSurvivalArena"] = true,
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
        v8:SetCore("SendNotification", {Title="TrashHub", Text=currentGameName .. " ScriptLoaded", Duration=2})
        UI.createSimpleTopUI(PlaceId, GAME_SCRIPTS, function(file) loadScript(file) end)
    else
        v8:SetCore("SendNotification", {Title="LoadFailed", Text=tostring(err), Duration=3})
        UI.createManualSearchUI(PlaceId, GAME_SCRIPTS, function(file) loadScript(file) end)
    end
    return
end

task.spawn(function()
    local anim = UI.LoadingAnimation.new()
    anim:updateProgress(10, "Cleaning old files...", "", true)
    for i, path in ipairs(FOLDERS_TO_DELETE) do
        anim:updateProgress(10 + (i / #FOLDERS_TO_DELETE) * 20, "Cleaning...", path, true)
        deleteFolder(path)
        task.wait(0.05)
    end
    anim:fadeOutDeleteUI()
    anim:updateProgress(40, "Checking server...", "Getting game info", false)
    task.wait(0.5)
    local scriptData = GAME_SCRIPTS[PlaceId]
    if scriptData then
        anim:updateProgress(60, "Loading script...", scriptData[1], false)
        task.wait(0.5)
        local success, err = pcall(function() loadScript(scriptData[2]) end)
        if success then
            anim:updateProgress(100, "Load complete!", "Injected: " .. scriptData[1], false)
        else
            anim:forceCleanupRainbow()
            anim:updateProgress(85, "Execution failed", tostring(err), false)
            v8:SetCore("SendNotification", {Title="Load failed", Text=tostring(err), Duration=3})
        end
        task.wait(0.8)
        anim:fadeOutAndDestroy()
        UI.createSimpleTopUI(PlaceId, GAME_SCRIPTS, function(file) loadScript(file) end)
    else
        anim:forceCleanupRainbow()
        anim:updateProgress(80, "Game not adapted", "Opening manual search", false)
        task.wait(1)
        anim:fadeOutAndDestroy()
        UI.createManualSearchUI(PlaceId, GAME_SCRIPTS, function(file) loadScript(file) end)
    end
end)
