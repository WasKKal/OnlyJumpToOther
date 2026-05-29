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
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local PAT = nil
local TOKEN_FILE = "TrashHub_token.json"

local function hasFileSupport()
    return (syn and syn.io and syn.io.writeFile) or (writefile and readfile) or (Krnln and Krnln.writefile) or (secure_load and secure_load.writefile)
end

local function writeFile(path, content)
    if syn and syn.io and syn.io.writeFile then
        syn.io.writeFile(path, content)
        return true
    elseif writefile then
        writefile(path, content)
        return true
    elseif Krnln and Krnln.writefile then
        Krnln.writefile(path, content)
        return true
    elseif secure_load and secure_load.writefile then
        secure_load.writefile(path, content)
        return true
    end
    return false
end

local function readFile(path)
    if syn and syn.io and syn.io.readFile then
        return syn.io.readFile(path)
    elseif readfile then
        return readfile(path)
    elseif Krnln and Krnln.readfile then
        return Krnln.readfile(path)
    elseif secure_load and secure_load.readfile then
        return secure_load.readfile(path)
    end
    return nil
end

local function fileExists(path)
    if syn and syn.io and syn.io.exists then
        return syn.io.exists(path)
    elseif isfile then
        return isfile(path)
    elseif Krnln and Krnln.isfile then
        return Krnln.isfile(path)
    elseif secure_load and secure_load.isfile then
        return secure_load.isfile(path)
    end
    return false
end

local function deleteFile(path)
    if syn and syn.io and syn.io.remove then
        syn.io.remove(path)
        return true
    elseif delfile then
        delfile(path)
        return true
    elseif Krnln and Krnln.delfile then
        Krnln.delfile(path)
        return true
    end
    return false
end

local function saveToken(token)
    local data = {token = token}
    local json = HttpService:JSONEncode(data)
    local ok = writeFile(TOKEN_FILE, json)
    if not ok then
        warn("[TrashHub] 无法保存令牌到文件，下次启动需重新输入")
    end
end

local function loadSavedToken()
    if fileExists(TOKEN_FILE) then
        local content = readFile(TOKEN_FILE)
        if content then
            local ok, data = pcall(HttpService.JSONDecode, HttpService, content)
            if ok and data and data.token then
                return data.token
            end
        end
    end
    return nil
end

local function deleteSavedToken()
    if fileExists(TOKEN_FILE) then
        deleteFile(TOKEN_FILE)
        return true
    end
    return false
end

local function showTokenInputUI(callback)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TrashTokenInput"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999999
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 420, 0, 170)
    bg.Position = UDim2.new(0.5, -210, 0.5, -85)
    bg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    bg.BorderSizePixel = 0
    bg.Parent = screenGui
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 12)
    bgCorner.Parent = bg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "TrashHub - 请输入 GitHub Token"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = bg

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 18)
    info.Position = UDim2.new(0, 10, 0, 38)
    info.BackgroundTransparency = 1
    info.Text = hasFileSupport() and "Token 将保存在本地，下次自动加载" or "当前环境不支持保存令牌，每次需手动输入"
    info.TextColor3 = Color3.fromRGB(180, 180, 180)
    info.TextSize = 11
    info.Font = Enum.Font.Gotham
    info.Parent = bg

    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -20, 0, 30)
    inputBox.Position = UDim2.new(0, 10, 0, 60)
    inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    inputBox.Text = ""
    inputBox.PlaceholderText = "输入 GitHub 个人访问令牌..."
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    inputBox.TextSize = 13
    inputBox.Font = Enum.Font.Gotham
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = bg
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = inputBox

    -- 按钮区域：三个按钮平分宽度，位置均匀分布
    local btnWidth = 100
    local btnHeight = 30
    local spacing = 20
    local totalWidth = btnWidth * 3 + spacing * 2
    local startX = (420 - totalWidth) / 2

    local btnOk = Instance.new("TextButton")
    btnOk.Size = UDim2.new(0, btnWidth, 0, btnHeight)
    btnOk.Position = UDim2.new(0, startX, 0, 105)
    btnOk.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    btnOk.Text = "确认"
    btnOk.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnOk.TextSize = 13
    btnOk.Font = Enum.Font.GothamBold
    btnOk.Parent = bg
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btnOk

    local btnSkip = Instance.new("TextButton")
    btnSkip.Size = UDim2.new(0, btnWidth, 0, btnHeight)
    btnSkip.Position = UDim2.new(0, startX + btnWidth + spacing, 0, 105)
    btnSkip.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    btnSkip.Text = "跳过"
    btnSkip.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnSkip.TextSize = 13
    btnSkip.Font = Enum.Font.GothamBold
    btnSkip.Parent = bg
    local btnSkipCorner = Instance.new("UICorner")
    btnSkipCorner.CornerRadius = UDim.new(0, 6)
    btnSkipCorner.Parent = btnSkip

    local btnDelete = Instance.new("TextButton")
    btnDelete.Size = UDim2.new(0, btnWidth, 0, btnHeight)
    btnDelete.Position = UDim2.new(0, startX + (btnWidth + spacing) * 2, 0, 105)
    btnDelete.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    btnDelete.Text = "删除配置"
    btnDelete.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnDelete.TextSize = 13
    btnDelete.Font = Enum.Font.GothamBold
    btnDelete.Parent = bg
    local btnDelCorner = Instance.new("UICorner")
    btnDelCorner.CornerRadius = UDim.new(0, 6)
    btnDelCorner.Parent = btnDelete

    btnOk.MouseButton1Click:Connect(function()
        local token = inputBox.Text
        if token and token ~= "" then
            screenGui:Destroy()
            callback(token)
        else
            title.Text = "Token 不能为空！"
            title.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)

    btnSkip.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        callback("")
    end)

    btnDelete.MouseButton1Click:Connect(function()
        if deleteSavedToken() then
            title.Text = "配置已删除！"
            title.TextColor3 = Color3.fromRGB(100, 255, 100)
            inputBox.Text = ""
            task.wait(1)
            title.Text = "TrashHub - 请输入 GitHub Token"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            title.Text = "删除失败或无配置文件"
            title.TextColor3 = Color3.fromRGB(255, 100, 100)
            task.wait(1)
            title.Text = "TrashHub - 请输入 GitHub Token"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
end

local savedToken = loadSavedToken()
if savedToken then
    PAT = savedToken
else
    local tokenReceived = false
    showTokenInputUI(function(token)
        tokenReceived = true
        PAT = token
        if token ~= "" and hasFileSupport() then
            saveToken(token)
        end
    end)
    while not tokenReceived do
        task.wait()
    end
end

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

local function fetchWithToken(fileName)
    if not PAT or PAT == "" then
        return nil
    end
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

local function fetchWithoutToken(fileName)
    local rawUrl = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", REPO_OWNER, REPO_NAME, BRANCH, urlEncode(fileName))
    local success, content = pcall(game.HttpGet, game, rawUrl)
    if success and content then
        return content
    end
    return nil
end

local function getScriptContent(fileName)
    local content = fetchWithToken(fileName)
    if not content then
        content = fetchWithoutToken(fileName)
    end
    return content
end

local function loadScript(fileName)
    local content = getScriptContent(fileName)
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
    label.Text = "TrashHub已加载"
    label.TextColor3 = Color3.new(1,1,1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local tip = Instance.new("TextLabel")
    tip.Size = UDim2.new(1,-10,0,16)
    tip.Position = UDim2.new(0,5,0,20)
    tip.BackgroundTransparency = 1
    tip.Text = "再次加载？(8)"
    tip.TextColor3 = Color3.new(0.8,0.8,0.8)
    tip.TextSize = 11
    tip.Font = Enum.Font.Gotham
    tip.TextXAlignment = Enum.TextXAlignment.Left
    tip.Parent = frame
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,70,0,22)
    btn.Position = UDim2.new(1,-75,0,9)
    btn.BackgroundColor3 = Color3.fromRGB(0,160,255)
    btn.Text = "重新加载"
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
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="重载失败", Text=tostring(err), Duration=3})
        end
    end)
    task.spawn(function()
        local remaining = 8
        while remaining > 0 and gui and gui.Parent do
            tip.Text = "再次加载？(" .. remaining .. ")"
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
    [11257760806] = {"在后巷", "在后巷.lua"},
    [133086043677134] = {"割草增量", "割草增量.lua"},
    [70960300100792] = {"滴管增量", "滴管增量.lua"},
    [115442728708640] = {"滑翔翼逃生", "滑翔翼逃生.lua"},
    [133379826754141] = {"你更愿意,但它会发生", "你更愿意,但它会发生.lua"},
    [537413528] = {"造船寻宝", "造船寻宝.lua"},
    [79311273910901] = {"刀片旋转", "刀片旋转.lua"},
    [98291788885415] = {"终极+1大小", "终极+1大小.lua"},
    [129195078205390] = {"火球训练", "火球训练.lua"},
    [2753915549] = {"BloxFruits - Sea1", "BloxFruits.lua"},
    [4442272183] = {"BloxFruits - Sea2", "BloxFruits.lua"},
    [79091703265657] = {"BloxFruits - Sea2", "BloxFruits.lua"},
    [7449423635] = {"BloxFruits - Sea3", "BloxFruits.lua"},
    [100117331123089] = {"BloxFruits - Sea3", "BloxFruits.lua"},
    [155382109] = {"大战51区", "大战51区.lua"},
    [130247632398296] = {"动漫战斗模拟器", "动漫战斗模拟器.lua"},
    [3623096087] = {"力量传奇", "力量传奇.lua"},
    [6243946064] = {"Trollge多重宇宙", "Trollge多重宇宙.lua"},
    [6839171747] = {"Doors", "Doors.lua"},
    [3956818381] = {"忍者传奇", "忍者传奇.lua"},
    [3101667897] = {"极速传奇", "极速传奇.lua"},
    [10449761463] = {"最强战场", "最强战场.lua"},
    [102181577519757] = {"黑暗欺骗-Monkey", "黑暗欺骗.lua"},
    [125591428878906] = {"黑暗欺骗-Girl", "黑暗欺骗.lua"},
    [131384651617456] = {"无限提升", "无限提升.lua"},
    [122446657157717] = {"狙击竞技场 - PC_Mobile", "狙击竞技场.lua"},
    [83645629621104] = {"被遗弃", "被遗弃.lua"},
    [16434298947] = {"泉州军区", "泉州军区.lua"},
    [70876832253163] = {"死亡轨迹", "死亡轨迹.lua"},
    [15459962483] = {"圆圈增量", "圆圈增量.lua"},
    [8908228901] = {"鲨鱼咬2", "鲨鱼咬2.lua"},
    [131623223084840] = {"逃离海啸", "逃离海啸.lua"},
    [124955530864032] = {"狙击竞技场 - Mobile", "狙击竞技场.lua"},
    [90625015569871] = {"狙击竞技场 - PC", "狙击竞技场.lua"},
    [74244835465756] = {"SAF2", "SAF2.lua"},
    [12196278347] = {"炼油厂2", "炼油厂2.lua"},
    [103571191458177] = {"挖掘训练", "挖掘训练.lua"},
    [88933961678687] = {"超高速跑者", "超高速跑者.lua"},
    [18519254033] = {"跳跃对决", "跳跃对决.lua"},
    [98927955463992] = {"生存僵尸竞技场", "僵尸生存竞技场.lua"},
    [85558337864610] = {"木筏101天生存", "木筏101天生存.lua"},
    [96645548064314] = {"捕捉与驯服", "捕捉与驯服.lua"},
    [116139828947259] = {"在启示录中生存", "启示录生存.lua"},
    [87018676608089] = {"手枪竞技场", "手枪竞技场.lua"},
    [101733180974837] = {"公牛之战", "公牛之战.lua"},
    [115511501544785] = {"寻找巨型鱼", "寻找巨型鱼.lua"},
    [8343259840] = {"罪恶都市", "CrimCity.lua"},
    [126509999114328] = {"森林中的99夜", "森林99夜.lua"},
    [139802517550914] = {"海上100天", "海上100天.lua"},
    [76265039822282] = {"琥珀警报", "琥珀警报.lua"},
    [80953732024525] = {"在岛上生存", "在岛上生存.lua"},
    [12497348201] = {"FNAF-多人合作", "FNAF.lua"},
    [11958318242] = {"Ohio_AC", "Ohio.lua"},
    [7239319209] = {"Ohio", "Ohio.lua"},
    [98626216952426] = {"纳拉莫核电站", "纳拉莫核电站.lua"},
    [77634959918754] = {"飘流50天", "飘流50天.lua"},
    [79657240466394] = {"集装箱RNG", "集装箱RNG.lua"},
    [128001665358186] = {"恐怖沙威玛", "恐怖沙威玛.lua"},
    [109844393857822] = {"疯狂瘟疫", "疯狂瘟疫.lua"},
    [99641726104567] = {"废弃城市100天", "废弃城市100天.lua"},
    [104449611620196] = {"巨魔之塔无限", "巨魔塔.lua"},
    [109187599373995] = {"木材增量模拟器", "木材增量模拟器.lua"},
    [118433033586507] = {"简单法术", "简单法术.lua"},
    [13822889] = {"伐木大亨", "伐木大亨.lua"},
    [12997619803] = {"克隆王国大亨", "克隆.lua"},
    [1554960397] = {"汽车经销商大亨", "汽车经销商.lua"},
    [80349677404572] = {"喂食你的泰托", "喂食泰托.lua"},
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
    ["被遗弃"] = true,
    ["僵尸生存竞技场"] = true,
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
        v8:SetCore("SendNotification", {Title="TrashHub", Text=currentGameName.." 已加载", Duration=2})
        UI.createSimpleTopUI(PlaceId, GAME_SCRIPTS, function(file) loadScript(file) end)
    else
        v8:SetCore("SendNotification", {Title="加载失败", Text=tostring(err), Duration=3})
        UI.createManualSearchUI(PlaceId, GAME_SCRIPTS, function(file) loadScript(file) end)
    end
    return
end

task.spawn(function()
    local anim = UI.LoadingAnimation.new()
    anim:updateProgress(10, "正在清理旧文件...", "", true)
    for i, path in ipairs(FOLDERS_TO_DELETE) do
        anim:updateProgress(10 + (i / #FOLDERS_TO_DELETE) * 20, "清理残留文件...", path, true)
        deleteFolder(path)
        task.wait(0.05)
    end
    anim:fadeOutDeleteUI()
    anim:updateProgress(40, "检测游戏服务器...", "正在获取游戏信息", false)
    task.wait(0.5)
    local scriptData = GAME_SCRIPTS[PlaceId]
    if scriptData then
        anim:updateProgress(60, "加载脚本中...", scriptData[1], false)
        task.wait(0.5)
        local success, err = pcall(function() loadScript(scriptData[2]) end)
        if success then
            anim:updateProgress(100, "加载完成！", "已注入：" .. scriptData[1], false)
        else
            anim:forceCleanupRainbow()
            anim:updateProgress(85, "执行失败", tostring(err), false)
            v8:SetCore("SendNotification", {Title="加载失败", Text=tostring(err), Duration=3})
        end
        task.wait(0.8)
        anim:fadeOutAndDestroy()
        UI.createSimpleTopUI(PlaceId, GAME_SCRIPTS, function(file) loadScript(file) end)
    else
        anim:forceCleanupRainbow()
        anim:updateProgress(80, "未适配此游戏", "即将打开手动搜索", false)
        task.wait(1)
        anim:fadeOutAndDestroy()
        UI.createManualSearchUI(PlaceId, GAME_SCRIPTS, function(file) loadScript(file) end)
    end
end)
