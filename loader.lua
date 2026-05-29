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
local function buildToken()
    local p1 = "ghp_aFrM7ANhUrR2VP"
    local p2 = "dLvs0kuByJDLLcBU0oKswV"
    local p3 = ""
    return p1 .. p2 .. p3
end
local PAT = buildToken()
local REPO_OWNER = "WasKKal"
local REPO_NAME = "-"
local BRANCH = "main"

local function fetchScriptWithToken(fileName)
    local apiUrl = string.format("https://api.github.com/repos/%s/%s/contents/%s?ref=%s", REPO_OWNER, REPO_NAME, fileName, BRANCH)
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
    local content = fetchScriptWithToken(fileName)
    if not content then
        error("获取脚本内容失败")
    end
    local func = loadstring(content)
    if not func then
        error("loadstring 失败")
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
    tip.Text = "你要再次加载它吗？(8)"
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
            tip.Text = "你要再次加载它吗？(" .. remaining .. ")"
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

local v1 = game:GetService("CoreGui")
local v2 = game:GetService("Players")
local v3 = game:GetService("MarketplaceService")
local v4 = game:GetService("Lighting")
local v5 = game:GetService("RunService")
local v6 = game:GetService("TweenService")
local v7 = game:GetService("UserInputService")
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
    [85724524674243] ={"TheButtonRoom", "TBR.lua"}
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

local function lerpColor(c1, c2, t)
    return Color3.new(c1.R + (c2.R - c1.R) * t, c1.G + (c2.G - c1.G) * t, c1.B + (c2.B - c1.B) * t)
end

local function getGameIcon(placeId)
    local success, info = pcall(function() return v3:GetProductInfo(placeId) end)
    if success and info and info.IconImageAssetId then
        return "rbxassetid://" .. tostring(info.IconImageAssetId)
    end
    return ""
end

local function createSimpleTopUI()
    pcall(function()
        if v1:FindFirstChild("Trash_SimpleTopUI") then
            v1.Trash_SimpleTopUI:Destroy()
        end
    end)
    local gui = Instance.new("ScreenGui")
    gui.Name = "Trash_SimpleTopUI"
    gui.Parent = v1
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
    label.Text = "脚本是否已加载"
    label.TextColor3 = Color3.new(1,1,1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local tip = Instance.new("TextLabel")
    tip.Size = UDim2.new(1,-10,0,16)
    tip.Position = UDim2.new(0,5,0,20)
    tip.BackgroundTransparency = 1
    tip.Text = "若已加载 请忽略此弹窗(8)"
    tip.TextColor3 = Color3.new(0.8,0.8,0.8)
    tip.TextSize = 11
    tip.Font = Enum.Font.Gotham
    tip.TextXAlignment = Enum.TextXAlignment.Left
    tip.Parent = frame
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,70,0,22)
    btn.Position = UDim2.new(1,-75,0,9)
    btn.BackgroundColor3 = Color3.fromRGB(0,160,255)
    btn.Text = "加载"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 12
    btn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,4)
    btnCorner.Parent = btn
    btn.MouseButton1Click:Connect(function()
        pcall(function() if gui then gui:Destroy() end end)
        local scriptData = GAME_SCRIPTS[PlaceId]
        if scriptData then
            local ok, err = pcall(function()
                loadScript(scriptData[2])
            end)
            if not ok then
                v8:SetCore("SendNotification", {Title="错误", Text="加载失败: "..tostring(err), Duration=3})
            end
        else
            v8:SetCore("SendNotification", {Title="Trash", Text="当前游戏暂未适配", Duration=2})
        end
    end)
    task.spawn(function()
        local remaining = 8
        while remaining > 0 and gui and gui.Parent do
            tip.Text = "若已加载 请忽略此弹窗(" .. remaining .. ")"
            task.wait(1)
            remaining = remaining - 1
        end
        pcall(function() if gui then gui:Destroy() end end)
    end)
end

local function createManualSearchUI()
    if v1:FindFirstChild("TrashManualSearchUI") then
        v1.TrashManualSearchUI:Destroy()
    end
    local gui = Instance.new("ScreenGui")
    gui.Name = "TrashManualSearchUI"
    gui.Parent = v1
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 99999
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0,420,0,340)
    mainFrame.Position = UDim2.new(0.5,-210,0.5,-170)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,40)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,12)
    corner.Parent = mainFrame
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1,0,0,36)
    titleBar.BackgroundColor3 = Color3.fromRGB(45,45,55)
    titleBar.BackgroundTransparency = 0.2
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0,12)
    titleCorner.Parent = titleBar
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,-40,1,0)
    titleLabel.Position = UDim2.new(0,10,0,0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "这是一个AiUi by DeepSeek"
    titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,28,0,28)
    closeBtn.Position = UDim2.new(1,-34,0,4)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        local ts = v6
        local ti = TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
        ts:Create(mainFrame,ti,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
        task.wait(0.3)
        gui:Destroy()
    end)
    local dragging = false
    local dragStart = nil
    local frameStart = nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = mainFrame.Position
        end
    end)
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    v7.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(frameStart.X.Scale,frameStart.X.Offset+delta.X,frameStart.Y.Scale,frameStart.Y.Offset+delta.Y)
        end
    end)
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1,-20,0,24)
    infoLabel.Position = UDim2.new(0,10,0,44)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "输入游戏名称（支持模糊搜索）："
    infoLabel.TextColor3 = Color3.fromRGB(200,200,200)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Parent = mainFrame
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1,-70,0,30)
    searchBox.Position = UDim2.new(0,10,0,72)
    searchBox.BackgroundColor3 = Color3.fromRGB(20,20,30)
    searchBox.Text = ""
    searchBox.PlaceholderText = "例如：BloxFruits / 狙击竞技场"
    searchBox.TextColor3 = Color3.fromRGB(255,255,255)
    searchBox.TextSize = 12
    searchBox.Font = Enum.Font.Gotham
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = mainFrame
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0,6)
    searchCorner.Parent = searchBox
    local searchBtn = Instance.new("TextButton")
    searchBtn.Size = UDim2.new(0,50,0,30)
    searchBtn.Position = UDim2.new(1,-60,0,72)
    searchBtn.BackgroundColor3 = Color3.fromRGB(0,160,255)
    searchBtn.Text = "搜索"
    searchBtn.TextColor3 = Color3.fromRGB(255,255,255)
    searchBtn.TextSize = 12
    searchBtn.Font = Enum.Font.GothamBold
    searchBtn.Parent = mainFrame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,6)
    btnCorner.Parent = searchBtn
    local resultFrame = Instance.new("Frame")
    resultFrame.Size = UDim2.new(1,-20,0,170)
    resultFrame.Position = UDim2.new(0,10,0,115)
    resultFrame.BackgroundColor3 = Color3.fromRGB(20,20,30)
    resultFrame.BackgroundTransparency = 0.5
    resultFrame.BorderSizePixel = 0
    resultFrame.Parent = mainFrame
    local resultCorner = Instance.new("UICorner")
    resultCorner.CornerRadius = UDim.new(0,8)
    resultCorner.Parent = resultFrame
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1,-10,1,-10)
    scrollingFrame.Position = UDim2.new(0,5,0,5)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.Parent = resultFrame
    local resultList = Instance.new("UIListLayout")
    resultList.Parent = scrollingFrame
    resultList.SortOrder = Enum.SortOrder.LayoutOrder
    resultList.Padding = UDim.new(0,4)
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1,-20,0,20)
    statusLabel.Position = UDim2.new(0,10,0,295)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = mainFrame
    local function clearResults()
        local children = scrollingFrame:GetChildren()
        for i = #children, 1, -1 do
            local child = children[i]
            if child:IsA("Frame") and child.Name == "ResultItem" then
                child:Destroy()
            end
        end
        scrollingFrame.CanvasPosition = Vector2.new(0,0)
    end
    local function loadScriptFromFileName(fileName, scriptName, searchGui)
        statusLabel.Text = "正在加载 " .. scriptName .. " ..."
        statusLabel.TextColor3 = Color3.fromRGB(255,200,100)
        local ok, err = pcall(function()
            loadScript(fileName)
        end)
        if ok then
            statusLabel.Text = "加载成功！"
            statusLabel.TextColor3 = Color3.fromRGB(100,255,100)
            pcall(function()
                v8:SetCore("SendNotification", {Title="Trash 手动加载", Text=scriptName.." 已成功执行", Duration=3})
            end)
            task.wait(0.5)
            if searchGui then searchGui:Destroy() end
            createSimpleTopUI()
        else
            statusLabel.Text = "失败: " .. tostring(err):sub(1,60)
            statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
        end
    end
    local function updateResults()
        clearResults()
        local query = searchBox.Text:lower()
        if query == "" then
            statusLabel.Text = ""
            return
        end
        local matches = {}
        for placeId, data in pairs(GAME_SCRIPTS) do
            local gameName = data[1]:lower()
            if gameName:find(query, 1, true) then
                table.insert(matches, {placeId = placeId, name = data[1], fileName = data[2]})
            end
        end
        if #matches == 0 then
            statusLabel.Text = "未找到匹配的游戏，请尝试其他关键词"
            statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
            return
        end
        statusLabel.Text = "找到 " .. #matches .. " 个结果，点击加载"
        statusLabel.TextColor3 = Color3.fromRGB(200,200,200)
        for _, match in ipairs(matches) do
            local resultItem = Instance.new("TextButton")
            resultItem.Name = "ResultItem"
            resultItem.Size = UDim2.new(1,-10,0,36)
            resultItem.BackgroundColor3 = Color3.fromRGB(40,40,50)
            resultItem.Text = ""
            resultItem.AutoButtonColor = false
            resultItem.Parent = scrollingFrame
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0,6)
            itemCorner.Parent = resultItem
            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0,28,0,28)
            icon.Position = UDim2.new(0,4,0.5,-14)
            icon.BackgroundTransparency = 1
            icon.Image = "rbxassetid://0"
            icon.Parent = resultItem
            local iconCorner = Instance.new("UICorner")
            iconCorner.CornerRadius = UDim.new(0,6)
            iconCorner.Parent = icon
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1,-40,1,0)
            nameLabel.Position = UDim2.new(0,40,0,0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = match.name
            nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
            nameLabel.TextSize = 12
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = resultItem
            resultItem.MouseButton1Click:Connect(function()
                loadScriptFromFileName(match.fileName, match.name, gui)
            end)
            resultItem.MouseEnter:Connect(function()
                resultItem.BackgroundColor3 = Color3.fromRGB(60,60,70)
            end)
            resultItem.MouseLeave:Connect(function()
                resultItem.BackgroundColor3 = Color3.fromRGB(40,40,50)
            end)
            task.spawn(function()
                local iconUrl = getGameIcon(match.placeId)
                if iconUrl ~= "" then
                    icon.Image = iconUrl
                end
            end)
        end
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(updateResults)
    searchBox.FocusLost:Connect(function()
        updateResults()
    end)
    searchBtn.MouseButton1Click:Connect(updateResults)
    local ts = v6
    local ti = TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    mainFrame.Size = UDim2.new(0,0,0,0)
    mainFrame.Position = UDim2.new(0.5,0,0.5,0)
    task.wait()
    ts:Create(mainFrame,ti,{Size=UDim2.new(0,420,0,340),Position=UDim2.new(0.5,-210,0.5,-170)}):Play()
end

local LoadingAnimation = {}
LoadingAnimation.__index = LoadingAnimation

function LoadingAnimation.new()
    pcall(function()
        local old = v1:FindFirstChild("TrashLoadingScreen")
        if old then old:Destroy() end
    end)
    local self = setmetatable({}, LoadingAnimation)
    self.originalBrightness = v4.Brightness
    self.originalAmbient = v4.Ambient
    self.originalOutdoorAmbient = v4.OutdoorAmbient
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "TrashLoadingScreen"
    self.gui.Parent = v1
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.gui.DisplayOrder = 999999
    self.gui.ResetOnSpawn = false
    self.gui.IgnoreGuiInset = true
    self.triggered30 = false
    self.triggered90 = false
    self.triggered91 = false
    self.colorCycleActive = false
    self.colorCycleTween = nil
    self.heartbeatConn = nil
    self.rainbowBars = nil
    self.isTimeout = false
    self.startTime = tick()
    self:_createUI()
    self:_darkenScreen()
    self:_createRainbowEffect()
    self:_createColorBackground()
    self:_checkTimeout()
    return self
end

function LoadingAnimation:_checkTimeout()
    task.spawn(function()
        while self.gui and self.gui.Parent and not self.triggered30 do
            task.wait(0.1)
            if tick() - self.startTime >= 5 and not self.triggered30 then
                self.isTimeout = true
                if self.title then
                    self.title.TextColor3 = Color3.fromRGB(255,0,0)
                    task.wait(0.5)
                    self.title.Text = "已超时,点此跳过"
                    self.title.MouseButton1Click:Connect(function()
                        self:fadeOutAndDestroy()
                    end)
                end
                break
            end
        end
    end)
end

function LoadingAnimation:_createUI()
    self.bg = Instance.new("Frame")
    self.bg.Name = "bg"
    self.bg.Size = UDim2.new(1,0,1,0)
    self.bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
    self.bg.BackgroundTransparency = 0.3
    self.bg.BorderSizePixel = 0
    self.bg.Parent = self.gui
    local container = Instance.new("Frame")
    container.Name = "centerContainer"
    container.Size = UDim2.new(0,500,0,260)
    container.Position = UDim2.new(0.5,-250,0.5,-130)
    container.BackgroundTransparency = 1
    container.Parent = self.gui
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
    self.title.Parent = container
    self.status = Instance.new("TextLabel")
    self.status.Name = "statusLabel"
    self.status.Size = UDim2.new(1,0,0,30)
    self.status.Position = UDim2.new(0,0,0,65)
    self.status.BackgroundTransparency = 1
    self.status.Text = "正在初始化中…"
    self.status.TextColor3 = Color3.fromRGB(255,255,255)
    self.status.TextStrokeTransparency = 0.3
    self.status.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    self.status.Font = Enum.Font.Gotham
    self.status.TextSize = 18
    self.status.TextXAlignment = Enum.TextXAlignment.Center
    self.status.Parent = container
    self.filesLabel = Instance.new("TextLabel")
    self.filesLabel.Name = "filesLabel"
    self.filesLabel.Size = UDim2.new(1,-20,0,18)
    self.filesLabel.Position = UDim2.new(0,10,0,100)
    self.filesLabel.BackgroundTransparency = 1
    self.filesLabel.Text = "正在删除文件:"
    self.filesLabel.TextColor3 = Color3.fromRGB(180,180,180)
    self.filesLabel.TextStrokeTransparency = 0.6
    self.filesLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    self.filesLabel.Font = Enum.Font.Gotham
    self.filesLabel.TextSize = 13
    self.filesLabel.TextXAlignment = Enum.TextXAlignment.Center
    self.filesLabel.Parent = container
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
    self.currentFile.Parent = container
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
    self.downloadInfo.Parent = container
    local progressBg = Instance.new("Frame")
    progressBg.Name = "progressBg"
    progressBg.Size = UDim2.new(1,-40,0,20)
    progressBg.Position = UDim2.new(0,20,0,145)
    progressBg.BackgroundColor3 = Color3.fromRGB(60,60,60)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = container
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0,10)
    bgCorner.Parent = progressBg
    self.progressBg = progressBg
    self.progressFill = Instance.new("Frame")
    self.progressFill.Name = "progressFill"
    self.progressFill.Size = UDim2.new(0,0,1,0)
    self.progressFill.BackgroundColor3 = Color3.fromRGB(255,200,100)
    self.progressFill.BorderSizePixel = 0
    self.progressFill.Parent = progressBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0,10)
    fillCorner.Parent = self.progressFill
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
    self.percent.Parent = container
end

function LoadingAnimation:_createColorBackground()
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

function LoadingAnimation:_createRainbowEffect()
    local effectContainer = Instance.new("Frame")
    effectContainer.Name = "RainbowEffect"
    effectContainer.Size = UDim2.new(1,0,1,0)
    effectContainer.BackgroundTransparency = 1
    effectContainer.ZIndex = 2
    effectContainer.Parent = self.gui
    local barLength = 55
    local barsPerEdge = 200
    local speed = 0.8
    local colors = {
        Color3.fromRGB(255,0,0),Color3.fromRGB(255,165,0),Color3.fromRGB(255,255,0),
        Color3.fromRGB(0,255,0),Color3.fromRGB(0,255,255),Color3.fromRGB(0,0,255),
        Color3.fromRGB(128,0,128)
    }
    local bars = {}
    local function createBarWithAnimation(edgeIdx, i)
        local isHorizontal = (edgeIdx == 1 or edgeIdx == 3)
        local isBottom = (edgeIdx == 1)
        local isTop = (edgeIdx == 3)
        local isRight = (edgeIdx == 2)
        local isLeft = (edgeIdx == 4)
        local bar = Instance.new("Frame")
        bar.Name = string.format("Bar_%d_%d", edgeIdx, i)
        bar.BorderSizePixel = 0
        bar.ZIndex = 2
        bar.BackgroundTransparency = 1
        bar.Parent = effectContainer
        if isHorizontal then
            bar.Size = UDim2.new(1/barsPerEdge,0,0,barLength)
            if isBottom then
                bar.AnchorPoint = Vector2.new(0.5,1)
                bar.Position = UDim2.new((i-0.5)/barsPerEdge,0,1,0)
            else
                bar.AnchorPoint = Vector2.new(0.5,0)
                bar.Position = UDim2.new((i-0.5)/barsPerEdge,0,0,0)
            end
        else
            bar.Size = UDim2.new(0,barLength,1/barsPerEdge,0)
            if isRight then
                bar.AnchorPoint = Vector2.new(1,0.5)
                bar.Position = UDim2.new(1,0,(i-0.5)/barsPerEdge,0)
            else
                bar.AnchorPoint = Vector2.new(0,0.5)
                bar.Position = UDim2.new(0,0,(i-0.5)/barsPerEdge,0)
            end
        end
        local gradient = Instance.new("UIGradient")
        if edgeIdx == 1 then
            gradient.Rotation = 270
        elseif edgeIdx == 2 then
            gradient.Rotation = 180
        elseif edgeIdx == 3 then
            gradient.Rotation = 90
        else
            gradient.Rotation = 0
        end
        gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
        gradient.Parent = bar
        local t_global
        if edgeIdx == 1 then
            t_global = (i-0.5)/(barsPerEdge*4)
        elseif edgeIdx == 2 then
            t_global = (barsPerEdge+i-0.5)/(barsPerEdge*4)
        elseif edgeIdx == 3 then
            t_global = (2*barsPerEdge+i-0.5)/(barsPerEdge*4)
        else
            t_global = (3*barsPerEdge+i-0.5)/(barsPerEdge*4)
        end
        table.insert(bars, {bar = bar, t_global = t_global, isHorizontal = isHorizontal})
        local targetSize = isHorizontal and UDim2.new(1/barsPerEdge,0,0,barLength) or UDim2.new(0,barLength,1/barsPerEdge,0)
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        v6:Create(bar, tweenInfo, {Size = targetSize, BackgroundTransparency = 0}):Play()
    end
    for edgeIdx = 1, 4 do
        for i = 1, barsPerEdge do
            createBarWithAnimation(edgeIdx, i)
        end
    end
    self.rainbowBars = bars
    local startTime = tick()
    self.heartbeatConn = v5.Heartbeat:Connect(function()
        local elapsed = (tick() - startTime) * speed
        local offset = elapsed % 1
        for _, data in ipairs(bars) do
            local currentT = data.t_global - offset
            if currentT < 0 then currentT = currentT + 1 end
            local seg = math.floor(currentT * #colors) + 1
            local pos = (currentT * #colors) % 1
            local c1 = colors[seg]
            local c2 = colors[seg % #colors + 1]
            data.bar.BackgroundColor3 = lerpColor(c1, c2, pos)
        end
    end)
end

function LoadingAnimation:_darkenScreen()
    for i = 1, 30 do
        local p = i / 30
        v4.Brightness = self.originalBrightness - (self.originalBrightness - 0.4) * p
        v4.Ambient = Color3.new(
            self.originalAmbient.R - (self.originalAmbient.R - 0.4) * p,
            self.originalAmbient.G - (self.originalAmbient.G - 0.4) * p,
            self.originalAmbient.B - (self.originalAmbient.B - 0.4) * p
        )
        v4.OutdoorAmbient = Color3.new(
            self.originalOutdoorAmbient.R - (self.originalOutdoorAmbient.R - 0.4) * p,
            self.originalOutdoorAmbient.G - (self.originalOutdoorAmbient.G - 0.4) * p,
            self.originalOutdoorAmbient.B - (self.originalOutdoorAmbient.B - 0.4) * p
        )
        task.wait(0.01)
    end
    v4.Brightness = 0.4
    v4.Ambient = Color3.new(0.4, 0.4, 0.4)
    v4.OutdoorAmbient = Color3.new(0.4, 0.4, 0.4)
end

function LoadingAnimation:updateProgress(percent, statusText, detailText, showDeleteUI)
    if not self.gui or not self.gui.Parent then return false end
    if statusText then self.status.Text = statusText end
    local isDeleteMode = showDeleteUI == true
    if self.filesLabel then self.filesLabel.Visible = isDeleteMode end
    if self.currentFile then self.currentFile.Visible = isDeleteMode end
    if self.downloadInfo then self.downloadInfo.Visible = not isDeleteMode end
    if detailText then
        if isDeleteMode then
            if self.currentFile then self.currentFile.Text = detailText end
        else
            if self.downloadInfo then self.downloadInfo.Text = detailText end
        end
    end
    if self.progressFill and type(percent) == "number" then
        self.progressFill:TweenSize(UDim2.new(percent/100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.3, true)
    end
    if self.percent then
        self.percent.Text = math.floor(percent) .. "%"
    end
    if percent >= 30 and not self.triggered30 then
        self.triggered30 = true
        if self.colorBackground then
            self.colorBackground.BackgroundTransparency = 0.9
        end
        self:_startColorCycle()
    end
    if percent >= 90 and not self.triggered90 then
        self.triggered90 = true
        self:stopColorCycle()
        if self.colorBackground then
            local ts = v6
            ts:Create(self.colorBackground, TweenInfo.new(1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(0,255,0),
                BackgroundTransparency = 1,
                Size = UDim2.new(2,0,2,0)
            }):Play()
        end
    end
    if percent >= 91 and not self.triggered91 then
        self.triggered91 = true
        if self.colorCycleTween then self.colorCycleTween:Cancel() end
        if self.colorBackground then
            self.colorBackground.BackgroundColor3 = Color3.fromRGB(255,0,0)
            self.colorBackground.BackgroundTransparency = 0
            self.colorBackground.Size = UDim2.new(1,0,1,0)
            local ts = v6
            ts:Create(self.colorBackground, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1,
                Size = UDim2.new(2,0,2,0)
            }):Play()
        end
        if self.rainbowBars then
            local ts = v6
            for _, d in ipairs(self.rainbowBars) do
                local bar = d.bar
                if bar then
                    local tar = d.isHorizontal and UDim2.new(bar.Size.X.Scale, bar.Size.X.Offset, 0, 0) or UDim2.new(0, 0, bar.Size.Y.Scale, bar.Size.Y.Offset)
                    ts:Create(bar, TweenInfo.new(0.8), {Size = tar, BackgroundTransparency = 1}):Play()
                end
            end
        end
        if self.heartbeatConn then
            pcall(function() self.heartbeatConn:Disconnect() end)
        end
    end
    return true
end

function LoadingAnimation:_startColorCycle()
    local colors = {
        Color3.fromRGB(255,0,0),Color3.fromRGB(255,165,0),Color3.fromRGB(255,255,0),
        Color3.fromRGB(0,255,0),Color3.fromRGB(0,255,255),Color3.fromRGB(0,0,255),
        Color3.fromRGB(128,0,128)
    }
    local idx = 1
    local ts = v6
    local function nextC()
        if not self.colorCycleActive then return end
        local tar = colors[idx]
        idx = idx % #colors + 1
        if self.colorBackground then
            self.colorCycleTween = ts:Create(self.colorBackground, TweenInfo.new(0.5), {BackgroundColor3 = tar})
            self.colorCycleTween.Completed:Connect(nextC)
            self.colorCycleTween:Play()
        end
    end
    self.colorCycleActive = true
    nextC()
end

function LoadingAnimation:stopColorCycle()
    self.colorCycleActive = false
    if self.colorCycleTween then
        self.colorCycleTween:Cancel()
    end
end

function LoadingAnimation:forceCleanupRainbow()
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

function LoadingAnimation:fadeOutDeleteUI()
    pcall(function()
        if not self.filesLabel or not self.currentFile then return end
        local ts = v6
        local ti = TweenInfo.new(0.3)
        ts:Create(self.filesLabel, ti, {TextTransparency = 1}):Play()
        ts:Create(self.currentFile, ti, {TextTransparency = 1}):Play()
        task.wait(0.3)
        self.filesLabel.Visible = false
        self.currentFile.Visible = false
        self.filesLabel.TextTransparency = 0
        self.currentFile.TextTransparency = 0
    end)
end

function LoadingAnimation:setTitleWithAnimation(newTitle)
    pcall(function()
        if not self.title then return end
        local ts = v6
        local ti = TweenInfo.new(0.4)
        ts:Create(self.title, ti, {TextTransparency = 1}):Play()
        task.wait(0.4)
        self.title.Text = newTitle
        ts:Create(self.title, ti, {TextTransparency = 0}):Play()
        task.wait(0.4)
    end)
end

function LoadingAnimation:fadeOutAndDestroy()
    if not self.gui then return end
    self:forceCleanupRainbow()
    local elements = {
        self.title, self.status, self.filesLabel, self.currentFile,
        self.downloadInfo, self.percent, self.progressFill, self.progressBg,
        self.bg, self.colorBackground
    }
    for i = 1, 30 do
        local p = i / 30
        for _, e in ipairs(elements) do
            if e then
                if e == self.bg or e == self.progressBg then
                    if e:IsA("Frame") then
                        e.BackgroundTransparency = 0.3 + p * 0.7
                    end
                elseif e:IsA("TextLabel") then
                    e.TextTransparency = p
                elseif e == self.progressFill or e == self.colorBackground then
                    if e:IsA("Frame") then
                        e.BackgroundTransparency = p
                    end
                end
            end
        end
        task.wait(0.01)
    end
    for i = 1, 30 do
        local p = i / 30
        v4.Brightness = 0.4 + (self.originalBrightness - 0.4) * p
        v4.Ambient = Color3.new(
            0.4 + (self.originalAmbient.R - 0.4) * p,
            0.4 + (self.originalAmbient.G - 0.4) * p,
            0.4 + (self.originalAmbient.B - 0.4) * p
        )
        v4.OutdoorAmbient = Color3.new(
            0.4 + (self.originalOutdoorAmbient.R - 0.4) * p,
            0.4 + (self.originalOutdoorAmbient.G - 0.4) * p,
            0.4 + (self.originalOutdoorAmbient.B - 0.4) * p
        )
        task.wait(0.01)
    end
    v4.Brightness = self.originalBrightness
    v4.Ambient = self.originalAmbient
    v4.OutdoorAmbient = self.originalOutdoorAmbient
    self.gui:Destroy()
end

LoadingAnimation.destroy = LoadingAnimation.fadeOutAndDestroy

local SKIP_ANIMATION_GAMES = {
    ["被遗弃"] = true,
    ["僵尸生存竞技场"] = true,
}

local currentGameData = GAME_SCRIPTS[PlaceId]
local currentGameName = currentGameData and currentGameData[1] or nil

if currentGameName and SKIP_ANIMATION_GAMES[currentGameName] then
    for _, path in ipairs(FOLDERS_TO_DELETE) do
        deleteFolder(path)
        task.wait(0.05)
    end
    local success, err = pcall(function()
        loadScript(currentGameData[2])
    end)
    if success then
        v8:SetCore("SendNotification", {Title = "TrashHub", Text = currentGameName .. " 脚本已加载", Duration = 2})
        createSimpleTopUI()
    else
        v8:SetCore("SendNotification", {Title = "加载失败", Text = tostring(err), Duration = 3})
        createManualSearchUI()
    end
    return
end

task.spawn(function()
    local loader = LoadingAnimation.new()
    loader:updateProgress(10, "正在清理旧文件…", "", true)
    for i, path in ipairs(FOLDERS_TO_DELETE) do
        loader:updateProgress(10 + (i / #FOLDERS_TO_DELETE) * 20, "清理残留文件…", path, true)
        deleteFolder(path)
        task.wait(0.05)
    end
    loader:fadeOutDeleteUI()
    loader:updateProgress(40, "检测游戏服务器…", "正在获取游戏信息", false)
    task.wait(0.5)
    local scriptData = GAME_SCRIPTS[PlaceId]
    if scriptData then
        loader:updateProgress(60, "加载脚本中…", scriptData[1], false)
        task.wait(0.5)
        local success, err = pcall(function()
            loadScript(scriptData[2])
        end)
        if success then
            loader:updateProgress(100, "加载完成！", "已注入：" .. scriptData[1], false)
        else
            loader:forceCleanupRainbow()
            loader:updateProgress(85, "执行失败", tostring(err), false)
            v8:SetCore("SendNotification", {
                Title = "加载失败",
                Text = tostring(err),
                Duration = 3
            })
        end
        task.wait(0.8)
        loader:fadeOutAndDestroy()
        createSimpleTopUI()
    else
        loader:forceCleanupRainbow()
        loader:updateProgress(80, "未适配此游戏", "即将打开手动搜索", false)
        task.wait(1)
        loader:fadeOutAndDestroy()
        createManualSearchUI()
    end
end)
