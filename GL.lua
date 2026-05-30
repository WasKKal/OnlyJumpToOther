if not Drawing then
    _G.Drawing = { new = function() return { Visible = false, Remove = function() end } end }
end

local WasUIPro = loadstring(game:HttpGet("https://raw.githubusercontent.com/WasKKal/WasUI-For-Roblox/main/WasUIPro.lua", true))()
WasUIPro:SetDefaultTheme("Dark")
WasUIPro:SetLanguage("中文")

local lp = game:GetService("Players").LocalPlayer
local ws = game:GetService("Workspace")
local rs = game:GetService("RunService")
local cam = ws.CurrentCamera
local uis = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local tween = game:GetService("TweenService")
local vu = game:GetService("VirtualUser")
local http = game:GetService("HttpService")
local cg = game:GetService("CoreGui")
local ts = game:GetService("TeleportService")
local Players = game:GetService("Players")

local getgenv = getgenv or function() return _G end

local TrashGeneral = getgenv().TrashGeneral or {
    SpeedEnabled = false; SpeedValue = 50;
    FlyEnabled = false; FlySpeed = 5;
    HighJumpEnabled = false; JumpPower = 70;
    AntiRagdoll = false;
    AntiAFK = false;
    NightVision = false;
    RemoveShadows = false;
    SelectedTime = "8:00";
    SelectedWeather = "Default";
    InfJump = false;
    NoPromptCD = false;
    Aimbot = {
        Enabled = false; ShowFOV = false; FOVSize = 150;
        CheckObstacles = true; Smooth = false; Speed = 300; Distance = 1000;
    };
    EnemyVisual = {
        Enabled = false;
        Hitbox = { Size = 5; Color = Color3.fromRGB(255,0,0); Transparency = 0.7 };
    };
    SilentAim = {
        Enabled = false; TeamCheck = false; VisibleCheck = false;
        TargetMode = "所有"; TargetPart = "HumanoidRootPart"; Method = "Raycast";
        FOVRadius = 130; FOVVisible = true; ShowTarget = false;
        HitChance = 100; HeadshotChanceEnabled = false; HeadshotChance = 0;
        FixedFOV = true; MaxDistance = 500; PriorityMode = "准星最近";
        Wallbang = false; HighlightEnabled = false;
    };
    ESP = {
        Enabled = false; TeamCheck = true; MaxDistance = 200; FontSize = 11;
        FadeOut = { OnDistance = true };
        Drawing = {
            Names = { Enabled = true };
            Distances = { Enabled = true; Position = "Text" };
            Weapons = { Enabled = true };
            Healthbar = { Enabled = true; Width = 2.5 };
            Boxes = { Full = { Enabled = true }; Filled = { Enabled = true; Transparency = 0.75 }; Corner = { Enabled = true } };
            Chams = { Enabled = true };
        };
    };
    Teleport = {
        TargetPlayer = nil; SmoothTeleport = false; TweenSpeed = 300;
        SuckAll = false; LockPlayerToMe = false;
    };
    Entertainment = {
        Rotate = { Enabled = false; Speed = 30 };
        BunnyHop = { Enabled = false; SpeedBoost = 2 };
        RandomRagdoll = false; ReverseControl = false; IceSkating = false;
    };
    Invisibility = { Enabled = false; Mode = "Client" };
    OtherScript = { CardKey = ""; DamaCardKey = "" };
    JobIdToJoin = "";
    Threads = {};
}
getgenv().TrashGeneral = TrashGeneral

local Controls = {}

local function char() return lp.Character or lp.CharacterAdded:Wait() end
local function root() local c = char() return c and c:FindFirstChild("HumanoidRootPart") end
local function hum() local c = char() return c and c:FindFirstChild("Humanoid") end

local function IsEnemy(p)
    if not p or p == lp then return false end
    if lp.Team and p.Team then if lp.Team == p.Team then return false end end
    return true
end

local function ValidEnemies()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if IsEnemy(p) then
            local c = p.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                local h = c:FindFirstChild("Humanoid")
                if h and h.Health > 0 then table.insert(t, p) end
            end
        end
    end
    return t
end

local function hasObstacle(targetPos, targetPlayer)
    if not cam then return true end
    local origin = cam.CFrame.Position
    local dir = (targetPos - origin).Unit
    local dist = (targetPos - origin).Magnitude
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {lp.Character, cam}
    rp.FilterType = Enum.RaycastFilterType.Blacklist
    rp.IgnoreWater = true
    local res = ws:Raycast(origin, dir * dist, rp)
    if res then
        local hit = res.Instance
        if hit then
            local hitPlr = Players:GetPlayerFromCharacter(hit:FindFirstAncestorOfClass("Model"))
            return hitPlr and hitPlr ~= targetPlayer or not hitPlr
        end
    end
    return false
end

local function TargetInFOV()
    local hrp = root(); if not hrp or not cam then return nil, nil end
    local fovRad = TrashGeneral.Aimbot.FOVSize
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    local closest, closestPos = nil, nil
    local closestDist = fovRad
    for _, p in ipairs(ValidEnemies()) do
        local tp = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
        if tp then
            local dist = (tp.Position - hrp.Position).Magnitude
            if dist <= TrashGeneral.Aimbot.Distance then
                local sp, onScr = cam:WorldToViewportPoint(tp.Position)
                if onScr and sp.Z > 0 then
                    local d = (center - Vector2.new(sp.X, sp.Y)).Magnitude
                    if d <= fovRad then
                        if TrashGeneral.Aimbot.CheckObstacles and hasObstacle(tp.Position, p) then continue end
                        if d < closestDist then
                            closestDist = d
                            closest = p
                            closestPos = tp.Position
                        end
                    end
                end
            end
        end
    end
    return closest, closestPos
end

local function aimLoop()
    if not TrashGeneral.Aimbot.Enabled then return end
    local _, tpos = TargetInFOV()
    if tpos then
        pcall(function()
            local cpos = cam.CFrame.Position
            if (tpos - cpos).Magnitude < 0.001 then return end
            local cf = CFrame.lookAt(cpos, tpos)
            if TrashGeneral.Aimbot.Smooth then
                local speed = math.clamp((TrashGeneral.Aimbot.Speed/500)*0.2, 0.02, 0.2)
                cam.CFrame = cam.CFrame:Lerp(cf, speed)
            else
                cam.CFrame = cf
            end
        end)
    end
end

local fovCircle
local function updateFOV()
    if not fovCircle or not fovCircle.Parent then return end
    local frame = fovCircle:FindFirstChild("FOVFrame")
    if frame then
        local size = TrashGeneral.Aimbot.FOVSize*2
        frame.Size = UDim2.new(0, size, 0, size)
        frame.Position = UDim2.new(0.5, -TrashGeneral.Aimbot.FOVSize, 0.5, -TrashGeneral.Aimbot.FOVSize)
        local _, t = TargetInFOV()
        frame.UIStroke.Color = t and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    end
end

local function createFOV()
    if fovCircle then pcall(function() fovCircle:Destroy() end) end
    local parent = cg or lp:FindFirstChild("PlayerGui")
    if not parent then return end
    fovCircle = Instance.new("ScreenGui")
    fovCircle.Name = "TrashFOV"; fovCircle.Parent = parent
    fovCircle.ResetOnSpawn = false; fovCircle.Enabled = TrashGeneral.Aimbot.ShowFOV
    local frame = Instance.new("Frame"); frame.Name = "FOVFrame"
    frame.Size = UDim2.new(0, TrashGeneral.Aimbot.FOVSize*2, 0, TrashGeneral.Aimbot.FOVSize*2)
    frame.Position = UDim2.new(0.5, -TrashGeneral.Aimbot.FOVSize, 0.5, -TrashGeneral.Aimbot.FOVSize)
    frame.BackgroundTransparency = 1; frame.Parent = fovCircle
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1,0)
    local stroke = Instance.new("UIStroke", frame); stroke.Thickness = 2; stroke.Transparency = 0.3
    if TrashGeneral.Threads.FOV then task.cancel(TrashGeneral.Threads.FOV) end
    TrashGeneral.Threads.FOV = task.spawn(function()
        while fovCircle and fovCircle.Parent and TrashGeneral.Aimbot.ShowFOV do
            pcall(updateFOV); task.wait(0.1)
        end
    end)
end

local function toggleAimbot(state)
    TrashGeneral.Aimbot.Enabled = state
    if state then
        if TrashGeneral.Threads.Aimbot then TrashGeneral.Threads.Aimbot:Disconnect() end
        TrashGeneral.Threads.Aimbot = rs.RenderStepped:Connect(aimLoop)
    else
        if TrashGeneral.Threads.Aimbot then TrashGeneral.Threads.Aimbot:Disconnect(); TrashGeneral.Threads.Aimbot = nil end
    end
end

local function toggleFOV(state)
    TrashGeneral.Aimbot.ShowFOV = state
    if state then
        if not fovCircle or not fovCircle.Parent then createFOV() else fovCircle.Enabled = true end
    else
        if fovCircle then fovCircle.Enabled = false end
    end
end

local enemyVisObjects, enemyVisLoop = {}, nil
local function updateEnemyVis()
    for enemy, d in pairs(enemyVisObjects) do
        if not enemy or not enemy.Parent or not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0 then
            if d.highlight then d.highlight:Destroy() end
            if d.conn then d.conn:Disconnect() end
            if d.rem then d.rem:Disconnect() end
            enemyVisObjects[enemy] = nil
        end
    end
    if not TrashGeneral.EnemyVisual.Enabled then return end
    local all = {}
    for _, p in ipairs(Players:GetPlayers()) do if IsEnemy(p) and p.Character then table.insert(all, p.Character) end end
    for _, e in ipairs(all) do
        if e and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
            if not enemyVisObjects[e] then
                local hl = Instance.new("Highlight"); hl.Adornee = e; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillColor = TrashGeneral.EnemyVisual.Hitbox.Color; hl.FillTransparency = TrashGeneral.EnemyVisual.Hitbox.Transparency
                hl.Parent = e
                local data = { highlight = hl }
                local hum = e:FindFirstChild("Humanoid")
                if hum then
                    data.conn = hum.Died:Connect(function()
                        if data.highlight then data.highlight:Destroy() end
                        enemyVisObjects[e] = nil
                    end)
                end
                data.rem = e.AncestryChanged:Connect(function()
                    if not e.Parent then if data.highlight then data.highlight:Destroy() end; enemyVisObjects[e] = nil end
                end)
                enemyVisObjects[e] = data
            else
                local d = enemyVisObjects[e]
                if d.highlight then
                    d.highlight.FillColor = TrashGeneral.EnemyVisual.Hitbox.Color
                    d.highlight.FillTransparency = TrashGeneral.EnemyVisual.Hitbox.Transparency
                end
            end
        end
    end
end

local function startEnemyVisLoop()
    if enemyVisLoop then task.cancel(enemyVisLoop) end
    enemyVisLoop = task.spawn(function()
        while TrashGeneral.EnemyVisual.Enabled do pcall(updateEnemyVis); task.wait(0.2) end
        for _, d in pairs(enemyVisObjects) do if d.highlight then d.highlight:Destroy() end end
        enemyVisObjects = {}
    end)
end

local function toggleEnemyVis(state)
    TrashGeneral.EnemyVisual.Enabled = state
    if state then startEnemyVisLoop() else
        if enemyVisLoop then task.cancel(enemyVisLoop); enemyVisLoop = nil end
        for _, d in pairs(enemyVisObjects) do if d.highlight then d.highlight:Destroy() end end
        enemyVisObjects = {}
    end
end

local flightConn
local function startFlight()
    if flightConn then flightConn:Disconnect() end
    local c = lp.Character; if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid"); local hd = c:FindFirstChild("Head")
    if not h or not hd then return end
    h.PlatformStand = true; hd.Anchored = true
    flightConn = rs.Heartbeat:Connect(function(dt)
        if not TrashGeneral.FlyEnabled or not lp.Character then stopFlight(); return end
        local char = lp.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
        local head = char and char:FindFirstChild("Head")
        if not hum or not head then stopFlight(); return end
        local moveDir = hum.MoveDirection * (TrashGeneral.FlySpeed * dt * 50)
        local headCF = head.CFrame; local camCF = cam.CFrame
        local offset = headCF:ToObjectSpace(camCF).Position
        camCF = camCF * CFrame.new(-offset.X, -offset.Y, -offset.Z + 1)
        local objSpace = CFrame.new(camCF.Position, Vector3.new(headCF.X, camCF.Y, headCF.Z)):VectorToObjectSpace(moveDir)
        head.CFrame = CFrame.new(headCF.Position) * (camCF - camCF.Position) * CFrame.new(objSpace)
    end)
end
local function stopFlight()
    if flightConn then flightConn:Disconnect(); flightConn = nil end
    local c = lp.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = false end
        local hd = c:FindFirstChild("Head")
        if hd then hd.Anchored = false end
    end
end

local rotateThread
local function startRotate()
    if rotateThread then task.cancel(rotateThread) end
    rotateThread = task.spawn(function()
        local last = os.clock()
        while TrashGeneral.Entertainment.Rotate.Enabled do
            local now = os.clock(); local dt = now - last; last = now
            local sp = TrashGeneral.Entertainment.Rotate.Speed
            if sp > 0 and dt > 0 then
                local hrp = root()
                if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(sp * dt), 0) end
            end
            task.wait()
        end
    end)
end
local function stopRotate() if rotateThread then task.cancel(rotateThread); rotateThread = nil end end

local bunnyHopThread
local origWalkSpeed = 16
local function startBunnyHop()
    if bunnyHopThread then task.cancel(bunnyHopThread) end
    bunnyHopThread = task.spawn(function()
        local lastJump = 0
        while TrashGeneral.Entertainment.BunnyHop.Enabled do
            local h = hum(); local hrp = root()
            if h and hrp then
                local moving = h.MoveDirection.Magnitude > 0.1
                local onGround = h.FloorMaterial ~= Enum.Material.Air
                if moving and onGround and (tick() - lastJump) > 0.3 then
                    h:ChangeState(Enum.HumanoidStateType.Jumping)
                    lastJump = tick()
                    if h.WalkSpeed ~= TrashGeneral.Entertainment.BunnyHop.SpeedBoost * 16 then
                        origWalkSpeed = h.WalkSpeed
                        h.WalkSpeed = TrashGeneral.Entertainment.BunnyHop.SpeedBoost * 16
                    end
                elseif not moving and h.WalkSpeed ~= origWalkSpeed then
                    h.WalkSpeed = origWalkSpeed
                end
            end
            task.wait(0.05)
        end
        local h = hum(); if h then h.WalkSpeed = origWalkSpeed end
    end)
end
local function stopBunnyHop()
    if bunnyHopThread then task.cancel(bunnyHopThread); bunnyHopThread = nil end
    local h = hum(); if h then h.WalkSpeed = origWalkSpeed end
end

local suckAllThread
local function startSuckAll()
    if suckAllThread then task.cancel(suckAllThread) end
    suckAllThread = task.spawn(function()
        while TrashGeneral.Teleport.SuckAll do
            local myHRP = root()
            if myHRP then
                local tcf = myHRP.CFrame
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= lp then
                        local c = p.Character
                        if c then
                            local hrp = c:FindFirstChild("HumanoidRootPart")
                            if hrp then hrp.CFrame = tcf end
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end
local function stopSuckAll() if suckAllThread then task.cancel(suckAllThread); suckAllThread = nil end end

local lockPlayerThread
local function startLockPlayer()
    if lockPlayerThread then task.cancel(lockPlayerThread) end
    lockPlayerThread = task.spawn(function()
        while TrashGeneral.Teleport.LockPlayerToMe do
            local myRoot = root(); local target = TrashGeneral.Teleport.TargetPlayer
            if myRoot and target then
                local tchar = target.Character
                if tchar then
                    local trp = tchar:FindFirstChild("HumanoidRootPart")
                    if trp then trp.CFrame = myRoot.CFrame * CFrame.new(10, 5, 0) end
                end
            end
            task.wait()
        end
    end)
end
local function stopLockPlayer() if lockPlayerThread then task.cancel(lockPlayerThread); lockPlayerThread = nil end end

local ESPManager = {}
do
    local ScreenGui, Connections = nil, {}
    local function Create(cls, props) local inst = typeof(cls)=='string' and Instance.new(cls) or cls; for k,v in pairs(props) do inst[k]=v end; return inst end
    local function CreateESP(plr)
        if not ScreenGui or Connections[plr] then return end
        local Name = Create("TextLabel", {Parent=ScreenGui, Position=UDim2.new(0.5,0,0,-11), Size=UDim2.new(0,100,0,20), AnchorPoint=Vector2.new(0.5,0.5), BackgroundTransparency=1, TextColor3=Color3.new(1,1,1), Font=Enum.Font.Code, TextSize=11, RichText=true})
        local Dist = Create("TextLabel", {Parent=ScreenGui, Position=UDim2.new(0.5,0,0,11), Size=UDim2.new(0,100,0,20), AnchorPoint=Vector2.new(0.5,0.5), BackgroundTransparency=1, TextColor3=Color3.new(1,1,1), Font=Enum.Font.Code, TextSize=11})
        local Box = Create("Frame", {Parent=ScreenGui, BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.75, BorderSizePixel=0})
        local Outline = Create("UIStroke", {Parent=Box, Color=Color3.new(1,1,1), LineJoinMode=Enum.LineJoinMode.Miter})
        Connections[plr] = rs.RenderStepped:Connect(function()
            if not TrashGeneral.ESP.Enabled then Box.Visible,Name.Visible,Dist.Visible = false,false,false; return end
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = plr.Character.HumanoidRootPart
                local hum = plr.Character:FindFirstChild("Humanoid"); if not hum then return end
                local pos, on = cam:WorldToScreenPoint(HRP.Position)
                if on then
                    local dist = (cam.CFrame.Position - HRP.Position).Magnitude/3.57
                    if dist <= TrashGeneral.ESP.MaxDistance then
                        local s = HRP.Size.Y; local scale = (s*cam.ViewportSize.Y)/(pos.Z*2); local w,h = 3*scale, 4.5*scale
                        Box.Position = UDim2.new(0,pos.X-w/2,0,pos.Y-h/2); Box.Size = UDim2.new(0,w,0,h); Box.Visible = true
                        if TrashGeneral.ESP.Drawing.Names.Enabled then Name.Position = UDim2.new(0,pos.X,0,pos.Y-h/2-9); Name.Text = plr.Name; Name.Visible = true end
                        if TrashGeneral.ESP.Drawing.Distances.Enabled then Dist.Position = UDim2.new(0,pos.X,0,pos.Y+h/2+7); Dist.Text = math.floor(dist).."m"; Dist.Visible = true end
                    else Box.Visible,Name.Visible,Dist.Visible = false,false,false end
                else Box.Visible,Name.Visible,Dist.Visible = false,false,false end
            else Box.Visible,Name.Visible,Dist.Visible = false,false,false end
        end)
    end
    function ESPManager.Start()
        if ScreenGui then return end
        ScreenGui = Create("ScreenGui", {Parent=cg, Name="Trash_ESPHolder"})
        for _, v in ipairs(Players:GetPlayers()) do if v ~= lp then CreateESP(v) end end
        Connections.PlayerAdded = Players.PlayerAdded:Connect(function(v) if v ~= lp then CreateESP(v) end end)
    end
    function ESPManager.Stop()
        if ScreenGui then ScreenGui:Destroy(); ScreenGui = nil end
        for _, c in pairs(Connections) do if type(c)=="table" then for _,v in ipairs(c) do v:Disconnect() end else c:Disconnect() end end
        Connections = {}
    end
    function ESPManager.SetEnabled(v) TrashGeneral.ESP.Enabled = v; if v then ESPManager.Start() else ESPManager.Stop() end end
end

local function teleportToPlayer(target)
    if not target then return end
    local tchar = target.Character
    if not tchar then local timeout = 0; while not tchar and timeout < 5 do task.wait(0.1); tchar = target.Character; timeout+=0.1 end end
    if not tchar then WasUIPro:Notify({Title="传送",Content="目标玩家未加载",Duration=2}); return end
    local trp = tchar:FindFirstChild("HumanoidRootPart") or tchar:FindFirstChild("Head")
    if not trp then WasUIPro:Notify({Title="传送",Content="无可用根部件",Duration=2}); return end
    if TrashGeneral.Teleport.SmoothTeleport then
        local hrp = root(); if not hrp then return end
        local dist = (hrp.Position - trp.Position).Magnitude
        local tw = tween:Create(hrp, TweenInfo.new(dist/TrashGeneral.Teleport.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = trp.CFrame}); tw:Play()
    else
        local hrp = root(); if hrp then hrp.CFrame = trp.CFrame end
    end
    WasUIPro:Notify({Title="传送",Content="已传送至 "..target.Name, Duration=2})
end

local invisThread, invisPlatform
local function startInvis()
    local mode = TrashGeneral.Invisibility.Mode
    local c = lp.Character; if not c then return end
    if mode == "Client" then
        for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.LocalTransparencyModifier = 1 end end
    elseif mode == "CFrame" then
        local hrp = root(); if hrp then hrp.CFrame = CFrame.new(hrp.Position.X, -1000, hrp.Position.Z) end
        local h = hum(); if h then h.PlatformStand = true end
        if invisPlatform then invisPlatform:Destroy() end
        invisPlatform = Instance.new("Part"); invisPlatform.Size = Vector3.new(5,0.5,5); invisPlatform.Anchored = true; invisPlatform.Transparency = 1; invisPlatform.Parent = ws
        if invisThread then task.cancel(invisThread) end
        invisThread = task.spawn(function()
            while TrashGeneral.Invisibility.Enabled and TrashGeneral.Invisibility.Mode == "CFrame" do
                local hrp = root(); if hrp then invisPlatform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y-2, hrp.Position.Z) end
                task.wait(0.05)
            end
        end)
    end
end
local function stopInvis()
    if TrashGeneral.Invisibility.Mode == "Client" then
        local c = lp.Character; if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end end end
    elseif TrashGeneral.Invisibility.Mode == "CFrame" then
        local h = hum(); if h then h.PlatformStand = false end
        if invisPlatform then invisPlatform:Destroy(); invisPlatform = nil end
        if invisThread then task.cancel(invisThread); invisThread = nil end
    end
end
local function toggleInvis(state)
    TrashGeneral.Invisibility.Enabled = state
    if state then startInvis() else stopInvis() end
end

local currentTargetPart
local function getTarget()
    local c = lp.Character; if not c or not c:FindFirstChild("HumanoidRootPart") then return nil end
    local localRoot = c.HumanoidRootPart
    local candidates = {}
    local tmode = TrashGeneral.SilentAim.TargetMode
    local function process(model)
        if TrashGeneral.SilentAim.TeamCheck and model.Team and model.Team == lp.Team then return end
        local hum = model:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then return end
        local part = model:FindFirstChild(TrashGeneral.SilentAim.TargetPart) or model:FindFirstChild("HumanoidRootPart")
        if not part then return end
        if TrashGeneral.SilentAim.VisibleCheck then
            local origin = cam.CFrame.Position; local dir = part.Position - origin
            local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = {c, part.Parent}
            if ws:Raycast(origin, dir.Unit * dir.Magnitude, rp) then return end
        end
        local dist = (localRoot.Position - part.Position).Magnitude
        if dist > TrashGeneral.SilentAim.MaxDistance then return end
        table.insert(candidates, {model=model, part=part, dist=dist, health=hum.Health})
    end
    if tmode == "玩家" or tmode == "所有" then for _, p in ipairs(Players:GetPlayers()) do if p ~= lp and p.Character then process(p.Character) end end end
    if tmode == "NPC" or tmode == "所有" then
        for _, v in ipairs(ws:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(v) then process(v) end
        end
    end
    if #candidates == 0 then return nil end
    table.sort(candidates, function(a,b)
        local pri = TrashGeneral.SilentAim.PriorityMode
        if pri == "最低血量" then return a.health < b.health
        elseif pri == "距离最近" then return a.dist < b.dist end
        return a.dist < b.dist
    end)
    return candidates[1].part
end

local oldNamecall, oldIndex, oldRayNew
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local method = getnamecallmethod(); local args = {...}; local self = args[1]
    if TrashGeneral.SilentAim.Enabled and not checkcaller() and math.random() <= TrashGeneral.SilentAim.HitChance/100 and currentTargetPart then
        local curMethod = TrashGeneral.SilentAim.Method
        if (method == "FindPartOnRayWithIgnoreList" and curMethod == method) or
           (method == "FindPartOnRayWithWhitelist" and curMethod == method) or
           ((method == "FindPartOnRay" or method == "findPartOnRay") and curMethod:lower() == method:lower()) then
            if args[2] and args[2].Origin then
                if TrashGeneral.SilentAim.Wallbang then return currentTargetPart, currentTargetPart.Position end
                local dir = (currentTargetPart.Position - args[2].Origin).Unit * 1000
                args[2] = Ray.new(args[2].Origin, dir)
                return oldNamecall(unpack(args))
            end
        elseif method == "Raycast" and curMethod == method then
            if args[2] and args[3] then
                if TrashGeneral.SilentAim.Wallbang then
                    local dir = (currentTargetPart.Position - args[2]).Unit * 1000
                    local wp = RaycastParams.new(); wp.FilterType = Enum.RaycastFilterType.Include; wp.FilterDescendantsInstances = {currentTargetPart.Parent}
                    return oldNamecall(args[1], args[2], dir, wp)
                end
                args[3] = (currentTargetPart.Position - args[2]).Unit * 1000
                return oldNamecall(unpack(args))
            end
        elseif (method == "ScreenPointToRay" or method == "ViewportPointToRay") and curMethod == method and self == cam then
            return Ray.new(cam.CFrame.Position, (currentTargetPart.Position - cam.CFrame.Position).Unit)
        end
    end
    return oldNamecall(...)
end))

oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, idx)
    if self == lp:GetMouse() and not checkcaller() and TrashGeneral.SilentAim.Enabled and TrashGeneral.SilentAim.Method == "Mouse.Hit/Target" and currentTargetPart then
        if idx:lower() == "hit" then return currentTargetPart.CFrame end
    end
    return oldIndex(self, idx)
end))

oldRayNew = hookfunction(Ray.new, newcclosure(function(origin, direction)
    if TrashGeneral.SilentAim.Enabled and TrashGeneral.SilentAim.Method == "Ray" and currentTargetPart and not checkcaller() and math.random() <= TrashGeneral.SilentAim.HitChance/100 then
        return oldRayNew(origin, (currentTargetPart.Position - origin).Unit * 1000)
    end
    return oldRayNew(origin, direction)
end))

local function disableAll()
    for _, control in pairs(Controls) do
        if control.SetValue then
            pcall(function() control:SetValue(false) end)
        end
    end
    TrashGeneral.FlyEnabled = false; stopFlight()
    TrashGeneral.SpeedEnabled = false; local h = hum(); if h then h.WalkSpeed = 16 end
    TrashGeneral.HighJumpEnabled = false; h = hum(); if h then h.JumpPower = 50 end
    ESPManager.SetEnabled(false)
    toggleEnemyVis(false)
    stopRotate(); stopBunnyHop(); stopSuckAll(); stopLockPlayer()
    toggleAimbot(false); TrashGeneral.SilentAim.Enabled = false
    toggleInvis(false)
    TrashGeneral.InfJump = false; if TrashGeneral.Threads.InfJump then TrashGeneral.Threads.InfJump:Disconnect() end
    TrashGeneral.Entertainment.RandomRagdoll = false; if TrashGeneral.Threads.RandomRagdoll then task.cancel(TrashGeneral.Threads.RandomRagdoll) end
    TrashGeneral.Entertainment.ReverseControl = false; if TrashGeneral.Threads.ReverseControl then TrashGeneral.Threads.ReverseControl:Disconnect() end
    TrashGeneral.Entertainment.IceSkating = false
    TrashGeneral.NoPromptCD = false
end

-- ==================== UI 部分 (使用 WasUIPro) ====================

local mainWindow = WasUIPro:CreateWindow({
    Title = "TrashHub 通用",
    MinimizedText = "TrashHub",
    TitleTag = {
        { text = "1.0", backgroundColor = Color3.fromRGB(0,152,211), textColor = Color3.fromRGB(255,255,255) }
    },
    Folder = "TrashHub_Config"
})

local tabCharacters = mainWindow:Tab({ Title = "人物" })
local tabEnvironment = mainWindow:Tab({ Title = "环境" })
local tabAim = mainWindow:Tab({ Title = "瞄准" })
local tabESP = mainWindow:Tab({ Title = "ESP" })
local tabTeleport = mainWindow:Tab({ Title = "传送" })
local tabOthers = mainWindow:Tab({ Title = "其他" })
local tabEntertainment = mainWindow:Tab({ Title = "娱乐" })
local tabConfig = mainWindow:Tab({ Title = "配置" })

-- 人物标签页
local charMoveCategory = tabCharacters:Category({ Title = "移动辅助", IconName = "zap" })
Controls.FlightToggle = charMoveCategory:Toggle({
    Title = "飞行",
    Value = TrashGeneral.FlyEnabled,
    Tooltip = "开启后可自由飞行",
    Callback = function(state)
        TrashGeneral.FlyEnabled = state
        if state then startFlight() else stopFlight() end
    end
})
charMoveCategory:Slider({
    Title = "飞行速度",
    Min = 1, Max = 10, Default = TrashGeneral.FlySpeed,
    Callback = function(val) TrashGeneral.FlySpeed = val end
})
Controls.SpeedToggle = charMoveCategory:Toggle({
    Title = "加速",
    Value = TrashGeneral.SpeedEnabled,
    Tooltip = "开启后移动速度加快",
    Callback = function(state)
        TrashGeneral.SpeedEnabled = state
        local h = hum()
        if h then h.WalkSpeed = state and TrashGeneral.SpeedValue or 16 end
    end
})
charMoveCategory:Slider({
    Title = "加速速度",
    Min = 16, Max = 200, Default = TrashGeneral.SpeedValue,
    Callback = function(val)
        TrashGeneral.SpeedValue = val
        if TrashGeneral.SpeedEnabled then
            local h = hum()
            if h then h.WalkSpeed = val end
        end
    end
})
Controls.HighJumpToggle = charMoveCategory:Toggle({
    Title = "高跳",
    Value = TrashGeneral.HighJumpEnabled,
    Tooltip = "大幅提高跳跃高度",
    Callback = function(state)
        TrashGeneral.HighJumpEnabled = state
        local h = hum()
        if h then
            if state then
                h.JumpPower = TrashGeneral.JumpPower
                if not TrashGeneral.Threads.HighJump then
                    TrashGeneral.Threads.HighJump = h.Jumping:Connect(function()
                        h.JumpPower = TrashGeneral.JumpPower
                    end)
                end
            else
                h.JumpPower = 50
                if TrashGeneral.Threads.HighJump then
                    TrashGeneral.Threads.HighJump:Disconnect()
                    TrashGeneral.Threads.HighJump = nil
                end
            end
        end
    end
})
charMoveCategory:Slider({
    Title = "跳跃高度",
    Min = 30, Max = 200, Default = TrashGeneral.JumpPower,
    Callback = function(val)
        TrashGeneral.JumpPower = val
        if TrashGeneral.HighJumpEnabled then
            local h = hum()
            if h then h.JumpPower = val end
        end
    end
})
charMoveCategory:Toggle({
    Title = "无限跳跃",
    Value = TrashGeneral.InfJump,
    Tooltip = "长按空格可连续跳跃",
    Callback = function(state)
        TrashGeneral.InfJump = state
        if state then
            TrashGeneral.Threads.InfJump = uis.JumpRequest:Connect(function()
                if TrashGeneral.InfJump then
                    local h = hum()
                    if h and h:GetState() == Enum.HumanoidStateType.Landed then
                        h:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            if TrashGeneral.Threads.InfJump then TrashGeneral.Threads.InfJump:Disconnect() end
        end
    end
})

local charProtectCategory = tabCharacters:Category({ Title = "防护", IconName = "shield" })
Controls.AntiRagdoll = charProtectCategory:Toggle({
    Title = "反布娃娃",
    Value = TrashGeneral.AntiRagdoll,
    Tooltip = "防止角色进入布娃娃状态",
    Callback = function(state)
        TrashGeneral.AntiRagdoll = state
        if state then
            local h = hum()
            if h then
                h.StateChanged:Connect(function(_, new)
                    if new == Enum.HumanoidStateType.Ragdoll then
                        h:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end)
            end
        end
    end
})
Controls.AntiAFK = charProtectCategory:Toggle({
    Title = "反挂机",
    Value = TrashGeneral.AntiAFK,
    Tooltip = "阻止空闲踢出",
    Callback = function(state)
        TrashGeneral.AntiAFK = state
        if state then
            TrashGeneral.Threads.AntiAFK = task.spawn(function()
                while TrashGeneral.AntiAFK do
                    pcall(function()
                        vu:Button2Down(Vector2.new(0,0), cam.CFrame)
                        task.wait(1)
                        vu:Button2Up(Vector2.new(0,0), cam.CFrame)
                        task.wait(60)
                    end)
                end
            end)
        else
            if TrashGeneral.Threads.AntiAFK then task.cancel(TrashGeneral.Threads.AntiAFK) end
        end
    end
})

local charInvisCategory = tabCharacters:Category({ Title = "隐身", IconName = "eye-off" })
Controls.InvisibilityToggle = charInvisCategory:Toggle({
    Title = "启用隐身",
    Value = TrashGeneral.Invisibility.Enabled,
    Callback = toggleInvis,
    Tooltip = "让其他玩家看不到你"
})
charInvisCategory:Dropdown({
    Title = "隐身模式",
    Values = { "Client", "CFrame" },
    Value = TrashGeneral.Invisibility.Mode,
    Callback = function(selected)
        TrashGeneral.Invisibility.Mode = selected
        if TrashGeneral.Invisibility.Enabled then
            stopInvis()
            startInvis()
        end
    end
})

-- 环境标签页
local envVisualCategory = tabEnvironment:Category({ Title = "视觉增强", IconName = "sun" })
Controls.NightVision = envVisualCategory:Toggle({
    Title = "夜视",
    Value = TrashGeneral.NightVision,
    Tooltip = "提高环境亮度",
    Callback = function(state)
        TrashGeneral.NightVision = state
        lighting.Ambient = state and Color3.new(1,1,1) or Color3.new(0,0,0)
        lighting.Brightness = state and 2 or 0.5
    end
})
Controls.RemoveShadows = envVisualCategory:Toggle({
    Title = "删除阴影",
    Value = TrashGeneral.RemoveShadows,
    Tooltip = "移除所有阴影效果",
    Callback = function(state)
        TrashGeneral.RemoveShadows = state
        lighting.GlobalShadows = not state
    end
})
envVisualCategory:Button({
    Text = "删除纹理",
    Icon = "zap",
    Tooltip = "将大部分零件材质设置为光滑塑料",
    Callback = function()
        pcall(function()
            for _, v in ipairs(ws:GetDescendants()) do
                if v:IsA("Part") or v:IsA("MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
        end)
    end
})
envVisualCategory:Button({
    Text = "删除天空盒",
    Icon = "cloud-off",
    Callback = function()
        pcall(function()
            if lighting.Sky then lighting.Sky:Destroy() end
        end)
    end
})

local envTimeCategory = tabEnvironment:Category({ Title = "时间调节", IconName = "clock" })
Controls.TimeDropdown = envTimeCategory:Dropdown({
    Title = "修改时间",
    Values = { "8:00", "12:00", "18:00", "24:00" },
    Value = TrashGeneral.SelectedTime,
    Callback = function(sel)
        TrashGeneral.SelectedTime = sel
    end
})
envTimeCategory:Button({
    Text = "确认修改时间",
    Icon = "check",
    Callback = function()
        local hour = tonumber(TrashGeneral.SelectedTime:match("(%d+):"))
        if hour then lighting.TimeOfDay = string.format("%02d:00:00", hour) end
    end
})

-- 瞄准标签页
local aimNormalCategory = tabAim:Category({ Title = "普通自瞄", IconName = "crosshair" })
Controls.Aimbot = aimNormalCategory:Toggle({
    Title = "自动瞄准",
    Value = TrashGeneral.Aimbot.Enabled,
    Callback = toggleAimbot,
    Tooltip = "自动将镜头对准敌人"
})
Controls.ShowFOV = aimNormalCategory:Toggle({
    Title = "显示FOV圈",
    Value = TrashGeneral.Aimbot.ShowFOV,
    Callback = toggleFOV,
    Tooltip = "显示自瞄范围圈"
})
aimNormalCategory:Slider({
    Title = "FOV大小",
    Min = 30, Max = 500, Default = TrashGeneral.Aimbot.FOVSize,
    Callback = function(val)
        TrashGeneral.Aimbot.FOVSize = val
        if TrashGeneral.Aimbot.ShowFOV then createFOV() end
    end
})
Controls.CheckObstacles = aimNormalCategory:Toggle({
    Title = "掩体判断",
    Value = TrashGeneral.Aimbot.CheckObstacles,
    Tooltip = "忽略视野中的障碍物",
    Callback = function(state) TrashGeneral.Aimbot.CheckObstacles = state end
})
Controls.SmoothAim = aimNormalCategory:Toggle({
    Title = "平滑自瞄",
    Value = TrashGeneral.Aimbot.Smooth,
    Tooltip = "自瞄移动更自然",
    Callback = function(state) TrashGeneral.Aimbot.Smooth = state end
})
aimNormalCategory:Slider({
    Title = "自瞄速度",
    Min = 100, Max = 500, Default = TrashGeneral.Aimbot.Speed,
    Callback = function(val) TrashGeneral.Aimbot.Speed = val end
})
aimNormalCategory:Slider({
    Title = "自瞄距离",
    Min = 100, Max = 5000, Default = TrashGeneral.Aimbot.Distance,
    Callback = function(val) TrashGeneral.Aimbot.Distance = val end
})

local aimEnemyVisCategory = tabAim:Category({ Title = "敌人视觉辅助", IconName = "users" })
Controls.EnemyVisual = aimEnemyVisCategory:Toggle({
    Title = "启用",
    Value = TrashGeneral.EnemyVisual.Enabled,
    Callback = toggleEnemyVis,
    Tooltip = "高亮显示敌人"
})
aimEnemyVisCategory:Slider({
    Title = "Hitbox大小",
    Min = 1, Max = 20, Default = TrashGeneral.EnemyVisual.Hitbox.Size,
    Callback = function(val) TrashGeneral.EnemyVisual.Hitbox.Size = val end
})
aimEnemyVisCategory:Slider({
    Title = "Hitbox透明度",
    Min = 0, Max = 1, Default = TrashGeneral.EnemyVisual.Hitbox.Transparency,
    Callback = function(val) TrashGeneral.EnemyVisual.Hitbox.Transparency = val end
})

local aimSilentCategory = tabAim:Category({ Title = "静默自瞄", IconName = "target" })
Controls.SilentAim = aimSilentCategory:Toggle({
    Title = "启用静默自瞄",
    Value = TrashGeneral.SilentAim.Enabled,
    Tooltip = "在不移动镜头的情况下击中敌人",
    Callback = function(state) TrashGeneral.SilentAim.Enabled = state end
})
aimSilentCategory:Dropdown({
    Title = "目标种类",
    Values = { "玩家", "NPC", "所有" },
    Value = TrashGeneral.SilentAim.TargetMode,
    Callback = function(val) TrashGeneral.SilentAim.TargetMode = val end
})
aimSilentCategory:Dropdown({
    Title = "目标部位",
    Values = { "Head", "HumanoidRootPart" },
    Value = TrashGeneral.SilentAim.TargetPart,
    Callback = function(val) TrashGeneral.SilentAim.TargetPart = val end
})
aimSilentCategory:Dropdown({
    Title = "优先模式",
    Values = { "准星最近", "距离最近", "最低血量", "最近的人(无FOV)" },
    Value = TrashGeneral.SilentAim.PriorityMode,
    Callback = function(val) TrashGeneral.SilentAim.PriorityMode = val end
})
aimSilentCategory:Dropdown({
    Title = "静默方式",
    Values = { "Raycast", "FindPartOnRay", "ScreenPointToRay", "ViewportPointToRay", "Ray", "Mouse.Hit/Target" },
    Value = TrashGeneral.SilentAim.Method,
    Callback = function(val) TrashGeneral.SilentAim.Method = val end
})
aimSilentCategory:Slider({
    Title = "命中率",
    Min = 0, Max = 100, Default = TrashGeneral.SilentAim.HitChance,
    Callback = function(val) TrashGeneral.SilentAim.HitChance = val end
})
aimSilentCategory:Toggle({
    Title = "可见性检查",
    Value = TrashGeneral.SilentAim.VisibleCheck,
    Callback = function(state) TrashGeneral.SilentAim.VisibleCheck = state end
})
aimSilentCategory:Toggle({
    Title = "穿墙",
    Value = TrashGeneral.SilentAim.Wallbang,
    Callback = function(state) TrashGeneral.SilentAim.Wallbang = state end
})

-- ESP标签页
local espControlCategory = tabESP:Category({ Title = "基础控制", IconName = "eye" })
Controls.ESP = espControlCategory:Toggle({
    Title = "启用ESP",
    Value = TrashGeneral.ESP.Enabled,
    Callback = function(state) ESPManager.SetEnabled(state) end,
    Tooltip = "显示玩家方框信息"
})
espControlCategory:Slider({
    Title = "最大距离",
    Min = 50, Max = 500, Default = TrashGeneral.ESP.MaxDistance,
    Callback = function(val) TrashGeneral.ESP.MaxDistance = val end
})

-- 传送标签页
local teleportPlayerCategory = tabTeleport:Category({ Title = "玩家传送", IconName = "send" })
local playerNames = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= lp then table.insert(playerNames, p.Name) end end
Controls.TeleportDropdown = teleportPlayerCategory:Dropdown({
    Title = "选择玩家",
    Values = playerNames,
    Value = "无",
    Callback = function(selected)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name == selected then TrashGeneral.Teleport.TargetPlayer = p; break end
        end
    end
})
task.spawn(function()
    while task.wait(5) do
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do if p ~= lp then table.insert(names, p.Name) end end
        Controls.TeleportDropdown:UpdateOptions(names, Controls.TeleportDropdown.SelectedValue)
    end
end)
teleportPlayerCategory:Button({
    Text = "确认传送",
    Icon = "send",
    Callback = function()
        if TrashGeneral.Teleport.TargetPlayer then
            teleportToPlayer(TrashGeneral.Teleport.TargetPlayer)
        else
            WasUIPro:Notify({Title="传送", Content="请先选择一个玩家", Duration=2})
        end
    end
})
Controls.LockPlayer = teleportPlayerCategory:Toggle({
    Title = "锁定玩家到自己",
    Value = TrashGeneral.Teleport.LockPlayerToMe,
    Tooltip = "将目标玩家持续拉到你附近",
    Callback = function(state)
        TrashGeneral.Teleport.LockPlayerToMe = state
        if state then startLockPlayer() else stopLockPlayer() end
    end
})
Controls.SmoothTeleport = teleportPlayerCategory:Toggle({
    Title = "平滑传送",
    Value = TrashGeneral.Teleport.SmoothTeleport,
    Callback = function(state) TrashGeneral.Teleport.SmoothTeleport = state end
})
teleportPlayerCategory:Slider({
    Title = "传送速度",
    Min = 50, Max = 500, Default = TrashGeneral.Teleport.TweenSpeed,
    Callback = function(val) TrashGeneral.Teleport.TweenSpeed = val end
})
Controls.SuckAll = teleportPlayerCategory:Toggle({
    Title = "循环吸人",
    Value = TrashGeneral.Teleport.SuckAll,
    Tooltip = "将所有玩家传送到你脚下",
    Callback = function(state)
        TrashGeneral.Teleport.SuckAll = state
        if state then startSuckAll() else stopSuckAll() end
    end
})

-- 其他标签页
local otherInfoCategory = tabOthers:Category({ Title = "游戏信息", IconName = "info" })
otherInfoCategory:Button({
    Text = "复制PlaceID",
    Icon = "copy",
    Callback = function() if setclipboard then setclipboard(tostring(game.PlaceId)) end end
})
otherInfoCategory:Button({
    Text = "复制JobID",
    Icon = "copy",
    Callback = function() if setclipboard then setclipboard(game.JobId) end end
})

local otherServerCategory = tabOthers:Category({ Title = "服务器跳跃", IconName = "log-in" })
Controls.JobIdInput = otherServerCategory:TextInput({
    Title = "输入目标JobID",
    Placeholder = "",
    Value = TrashGeneral.JobIdToJoin,
    Callback = function(val) TrashGeneral.JobIdToJoin = val end
})
otherServerCategory:Button({
    Text = "确认加入",
    Icon = "log-in",
    Callback = function()
        if TrashGeneral.JobIdToJoin ~= "" then
            pcall(function() ts:TeleportToPlaceInstance(game.PlaceId, TrashGeneral.JobIdToJoin, lp) end)
        end
    end
})
otherServerCategory:Button({
    Text = "切换服务器",
    Icon = "refresh-cw",
    Callback = function() pcall(function() ts:Teleport(game.PlaceId) end) end
})

local otherUtilCategory = tabOthers:Category({ Title = "实用设置", IconName = "settings" })
Controls.GlobalChat = otherUtilCategory:Toggle({
    Title = "启用全局聊天",
    Value = true,
    Tooltip = "开启新聊天窗口",
    Callback = function(state)
        pcall(function() game:GetService("TextChatService").ChatWindowConfiguration.Enabled = state end)
    end
})
Controls.NoPromptCD = otherUtilCategory:Toggle({
    Title = "交互无CD",
    Value = TrashGeneral.NoPromptCD,
    Tooltip = "立即拾取物品",
    Callback = function(state)
        TrashGeneral.NoPromptCD = state
        for _, obj in ipairs(ws:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then obj.HoldDuration = state and 0 or 0.5 end
        end
    end
})

-- 娱乐标签页
local entertainRotateCategory = tabEntertainment:Category({ Title = "旋转", IconName = "rotate-cw" })
Controls.Rotate = entertainRotateCategory:Toggle({
    Title = "启用旋转",
    Value = TrashGeneral.Entertainment.Rotate.Enabled,
    Tooltip = "原地旋转角色",
    Callback = function(state)
        TrashGeneral.Entertainment.Rotate.Enabled = state
        if state then startRotate() else stopRotate() end
    end
})
entertainRotateCategory:Slider({
    Title = "旋转速度",
    Min = 360, Max = 720, Default = TrashGeneral.Entertainment.Rotate.Speed,
    Callback = function(val) TrashGeneral.Entertainment.Rotate.Speed = val end
})

local entertainBunnyHopCategory = tabEntertainment:Category({ Title = "兔子跳", IconName = "rabbit" })
Controls.BunnyHop = entertainBunnyHopCategory:Toggle({
    Title = "启用兔子跳",
    Value = TrashGeneral.Entertainment.BunnyHop.Enabled,
    Tooltip = "自动跳跃并加速",
    Callback = function(state)
        TrashGeneral.Entertainment.BunnyHop.Enabled = state
        if state then startBunnyHop() else stopBunnyHop() end
    end
})
entertainBunnyHopCategory:Slider({
    Title = "加速倍率",
    Min = 1, Max = 5, Default = TrashGeneral.Entertainment.BunnyHop.SpeedBoost,
    Callback = function(val) TrashGeneral.Entertainment.BunnyHop.SpeedBoost = val end
})

local entertainTrollCategory = tabEntertainment:Category({ Title = "恶搞自己", IconName = "smile" })
Controls.RandomRagdoll = entertainTrollCategory:Toggle({
    Title = "随机摔倒",
    Value = TrashGeneral.Entertainment.RandomRagdoll,
    Tooltip = "角色会周期性摔倒",
    Callback = function(state)
        TrashGeneral.Entertainment.RandomRagdoll = state
        if state then
            TrashGeneral.Threads.RandomRagdoll = task.spawn(function()
                while TrashGeneral.Entertainment.RandomRagdoll do
                    local h = hum()
                    if h then
                        h:ChangeState(Enum.HumanoidStateType.Ragdoll)
                        task.wait(0.1)
                        h:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                    task.wait(math.random(30,90)/10)
                end
            end)
        else
            if TrashGeneral.Threads.RandomRagdoll then task.cancel(TrashGeneral.Threads.RandomRagdoll) end
        end
    end
})
Controls.ReverseControl = entertainTrollCategory:Toggle({
    Title = "反向控制",
    Value = TrashGeneral.Entertainment.ReverseControl,
    Tooltip = "WASD方向颠倒",
    Callback = function(state)
        TrashGeneral.Entertainment.ReverseControl = state
        if state then
            TrashGeneral.Threads.ReverseControl = rs.Heartbeat:Connect(function()
                local h = hum()
                if h then h.MoveDirection = -h.MoveDirection end
            end)
        else
            if TrashGeneral.Threads.ReverseControl then TrashGeneral.Threads.ReverseControl:Disconnect() end
        end
    end
})
Controls.IceSkating = entertainTrollCategory:Toggle({
    Title = "隐形滑板",
    Value = TrashGeneral.Entertainment.IceSkating,
    Tooltip = "让角色像在冰面上滑动",
    Callback = function(state)
        TrashGeneral.Entertainment.IceSkating = state
        local c = lp.Character
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CustomPhysicalProperties = state and PhysicalProperties.new(0,0,0,0,0) or nil
                end
            end
        end
    end
})

-- 配置标签页
local configGlobalCategory = tabConfig:Category({ Title = "全局控制", IconName = "power" })
configGlobalCategory:Button({
    Text = "关闭所有功能",
    Icon = "power",
    Callback = disableAll
})

-- 启动时恢复状态
task.spawn(function()
    rs.RenderStepped:Connect(function()
        if TrashGeneral.SpeedEnabled then
            local h = hum()
            if h then h.WalkSpeed = TrashGeneral.SpeedValue end
        end
        if TrashGeneral.SilentAim.Enabled then
            currentTargetPart = getTarget()
        end
        aimLoop()
    end)
end)

task.spawn(function()
    if TrashGeneral.Aimbot.Enabled then toggleAimbot(true) end
    if TrashGeneral.Aimbot.ShowFOV then createFOV() end
    if TrashGeneral.EnemyVisual.Enabled then toggleEnemyVis(true) end
    if TrashGeneral.ESP.Enabled then ESPManager.SetEnabled(true) end
    if TrashGeneral.FlyEnabled then startFlight() end
    if TrashGeneral.Entertainment.Rotate.Enabled then startRotate() end
    if TrashGeneral.Entertainment.BunnyHop.Enabled then startBunnyHop() end
    if TrashGeneral.Teleport.SuckAll then startSuckAll() end
    if TrashGeneral.Teleport.LockPlayerToMe then startLockPlayer() end
    if TrashGeneral.Invisibility.Enabled then toggleInvis(true) end
end)

WasUIPro:Notify({Title="TrashHub 通用", Content="加载成功", Duration=3, Icon="check"})
