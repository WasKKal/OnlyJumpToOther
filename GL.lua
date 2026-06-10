if not Drawing then
    _G.Drawing = { new = function() return { Visible = false, Remove = function() end } end }
end

local WasUIPro = loadstring(game:HttpGet("https://raw.githubusercontent.com/WasKKal/WasUI-For-Roblox/main/WasUIPro.lua", true))()
if not WasUIPro then
    error("WasUIPro 加载失败，请检查网络连接")
end
WasUIPro:SetDefaultTheme("Dark")
WasUIPro:SetLanguage("中文")

local v1 = game:GetService("Players")
local v2 = game:GetService("Workspace")
local v3 = game:GetService("RunService")
local v4 = v2.CurrentCamera
local v5 = game:GetService("UserInputService")
local v6 = game:GetService("Lighting")
local v7 = game:GetService("TweenService")
local v8 = game:GetService("VirtualUser")
local v9 = game:GetService("HttpService")
local v10 = game:GetService("CoreGui")
local v11 = game:GetService("TeleportService")
local v12 = v1.LocalPlayer

local getgenv = getgenv or function() return _G end

local r1 = getgenv().TrashGeneral or {
    SpeedEnabled = false; SpeedValue = 50;
    FlyEnabled = false; FlySpeed = 50;
    FlyMode = "普通";
    HighJumpEnabled = false; JumpHeight = 7.2;
    AntiRagdoll = false;
    AntiAFK = false;
    NightVision = false;
    RemoveShadows = false;
    SelectedTime = "8:00";
    SelectedWeather = "Default";
    InfJump = false;
    NoPromptCD = false;
    Noclip = false;
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
    };
    Invisibility = { Enabled = false; Mode = "Client" };
    OtherScript = { CardKey = ""; DamaCardKey = "" };
    JobIdToJoin = "";
    Threads = {};
}
getgenv().TrashGeneral = r1

local ctrl = {}

local function f1() return v12.Character or v12.CharacterAdded:Wait() end
local function f2() local c = f1() return c and c:FindFirstChild("HumanoidRootPart") end
local function f3() local c = f1() return c and c:FindFirstChild("Humanoid") end

local function f4(p)
    if not p or p == v12 then return false end
    if v12.Team and p.Team then if v12.Team == p.Team then return false end end
    return true
end

local function f5()
    local t = {}
    for _, p in ipairs(v1:GetPlayers()) do
        if f4(p) then
            local c = p.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                local h = c:FindFirstChild("Humanoid")
                if h and h.Health > 0 then table.insert(t, p) end
            end
        end
    end
    return t
end

local function f6(tpos, tplr)
    if not v4 then return true end
    local o = v4.CFrame.Position
    local dir = (tpos - o).Unit
    local dist = (tpos - o).Magnitude
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {v12.Character, v4}
    rp.FilterType = Enum.RaycastFilterType.Blacklist
    rp.IgnoreWater = true
    local res = v2:Raycast(o, dir * dist, rp)
    if res then
        local hit = res.Instance
        if hit then
            local hplr = v1:GetPlayerFromCharacter(hit:FindFirstAncestorOfClass("Model"))
            return hplr and hplr ~= tplr or not hplr
        end
    end
    return false
end

local function f7()
    local hrp = f2(); if not hrp or not v4 then return nil, nil end
    local fov = r1.Aimbot.FOVSize
    local center = Vector2.new(v4.ViewportSize.X/2, v4.ViewportSize.Y/2)
    local closest, closestPos = nil, nil
    local closestDist = fov
    for _, p in ipairs(f5()) do
        local tp = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
        if tp then
            local dist = (tp.Position - hrp.Position).Magnitude
            if dist <= r1.Aimbot.Distance then
                local sp, on = v4:WorldToViewportPoint(tp.Position)
                if on and sp.Z > 0 then
                    local d = (center - Vector2.new(sp.X, sp.Y)).Magnitude
                    if d <= fov then
                        if r1.Aimbot.CheckObstacles and f6(tp.Position, p) then continue end
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

local function f8()
    if not r1.Aimbot.Enabled then return end
    local _, tpos = f7()
    if tpos then
        pcall(function()
            local cpos = v4.CFrame.Position
            if (tpos - cpos).Magnitude < 0.001 then return end
            local cf = CFrame.lookAt(cpos, tpos)
            if r1.Aimbot.Smooth then
                local sp = math.clamp((r1.Aimbot.Speed/500)*0.2, 0.02, 0.2)
                v4.CFrame = v4.CFrame:Lerp(cf, sp)
            else
                v4.CFrame = cf
            end
        end)
    end
end

local r2
local function f9()
    if not r2 or not r2.Parent then return end
    local fr = r2:FindFirstChild("FOVFrame")
    if fr then
        local sz = r1.Aimbot.FOVSize*2
        fr.Size = UDim2.new(0, sz, 0, sz)
        fr.Position = UDim2.new(0.5, -r1.Aimbot.FOVSize, 0.5, -r1.Aimbot.FOVSize)
        local _, t = f7()
        fr.UIStroke.Color = t and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    end
end

local function f10()
    if r2 then pcall(function() r2:Destroy() end) end
    local parent = v10 or v12:FindFirstChild("PlayerGui")
    if not parent then return end
    r2 = Instance.new("ScreenGui")
    r2.Name = "TrashFOV"; r2.Parent = parent
    r2.ResetOnSpawn = false; r2.Enabled = r1.Aimbot.ShowFOV
    local fr = Instance.new("Frame"); fr.Name = "FOVFrame"
    fr.Size = UDim2.new(0, r1.Aimbot.FOVSize*2, 0, r1.Aimbot.FOVSize*2)
    fr.Position = UDim2.new(0.5, -r1.Aimbot.FOVSize, 0.5, -r1.Aimbot.FOVSize)
    fr.BackgroundTransparency = 1; fr.Parent = r2
    Instance.new("UICorner", fr).CornerRadius = UDim.new(1,0)
    local st = Instance.new("UIStroke", fr); st.Thickness = 2; st.Transparency = 0.3
    if r1.Threads.FOV then task.cancel(r1.Threads.FOV) end
    r1.Threads.FOV = task.spawn(function()
        while r2 and r2.Parent and r1.Aimbot.ShowFOV do
            pcall(f9); task.wait(0.1)
        end
    end)
end

local function f11(state)
    r1.Aimbot.Enabled = state
    if state then
        if r1.Threads.Aimbot then r1.Threads.Aimbot:Disconnect() end
        r1.Threads.Aimbot = v3.RenderStepped:Connect(f8)
    else
        if r1.Threads.Aimbot then r1.Threads.Aimbot:Disconnect(); r1.Threads.Aimbot = nil end
    end
end

local function f12(state)
    r1.Aimbot.ShowFOV = state
    if state then
        if not r2 or not r2.Parent then f10() else r2.Enabled = true end
    else
        if r2 then r2.Enabled = false end
    end
end

local r3, r4 = {}, nil
local function f13()
    for enemy, d in pairs(r3) do
        if not enemy or not enemy.Parent or not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0 then
            if d.highlight then d.highlight:Destroy() end
            if d.conn then d.conn:Disconnect() end
            if d.rem then d.rem:Disconnect() end
            r3[enemy] = nil
        end
    end
    if not r1.EnemyVisual.Enabled then return end
    local all = {}
    for _, p in ipairs(v1:GetPlayers()) do if f4(p) and p.Character then table.insert(all, p.Character) end end
    for _, e in ipairs(all) do
        if e and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
            if not r3[e] then
                local hl = Instance.new("Highlight"); hl.Adornee = e; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillColor = r1.EnemyVisual.Hitbox.Color; hl.FillTransparency = r1.EnemyVisual.Hitbox.Transparency
                hl.Parent = e
                local data = { highlight = hl }
                local hum = e:FindFirstChild("Humanoid")
                if hum then
                    data.conn = hum.Died:Connect(function()
                        if data.highlight then data.highlight:Destroy() end
                        r3[e] = nil
                    end)
                end
                data.rem = e.AncestryChanged:Connect(function()
                    if not e.Parent then if data.highlight then data.highlight:Destroy() end; r3[e] = nil end
                end)
                r3[e] = data
            else
                local d = r3[e]
                if d.highlight then
                    d.highlight.FillColor = r1.EnemyVisual.Hitbox.Color
                    d.highlight.FillTransparency = r1.EnemyVisual.Hitbox.Transparency
                end
            end
        end
    end
end

local function f14()
    if r4 then task.cancel(r4) end
    r4 = task.spawn(function()
        while r1.EnemyVisual.Enabled do pcall(f13); task.wait(0.2) end
        for _, d in pairs(r3) do if d.highlight then d.highlight:Destroy() end end
        r3 = {}
    end)
end

local function f15(state)
    r1.EnemyVisual.Enabled = state
    if state then f14() else
        if r4 then task.cancel(r4); r4 = nil end
        for _, d in pairs(r3) do if d.highlight then d.highlight:Destroy() end end
        r3 = {}
    end
end

local r5, r6, r7 = nil, nil, nil
local function f16()
    if r5 then r5:Disconnect(); r5 = nil end
    if r6 then r6:Destroy(); r6 = nil end
    if r7 then r7:Destroy(); r7 = nil end
    local c = f1()
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = false end
        local hd = c:FindFirstChild("Head")
        if hd then hd.Anchored = false end
    end
end

local function f17()
    if r5 then r5:Disconnect() end
    local c = f1(); if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid"); local hd = c:FindFirstChild("Head")
    if not h or not hd then return end
    h.PlatformStand = true; hd.Anchored = true
    r5 = v3.Heartbeat:Connect(function(dt)
        if not r1.FlyEnabled or not f1() then f16(); return end
        local char = f1(); local hum = char and char:FindFirstChildOfClass("Humanoid")
        local head = char and char:FindFirstChild("Head")
        if not hum or not head then f16(); return end
        local moveDir = hum.MoveDirection * (r1.FlySpeed * dt * 8)
        local headCF = head.CFrame; local camCF = v4.CFrame
        local offset = headCF:ToObjectSpace(camCF).Position
        camCF = camCF * CFrame.new(-offset.X, -offset.Y, -offset.Z + 1)
        local objSpace = CFrame.new(camCF.Position, Vector3.new(headCF.X, camCF.Y, headCF.Z)):VectorToObjectSpace(moveDir)
        local newHeadCF = CFrame.new(headCF.Position) * (camCF - camCF.Position) * CFrame.new(objSpace)
        head.CFrame = newHeadCF
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(head.Position.X, head.Position.Y - 1.5, head.Position.Z)
        end
    end)
end

local function f18()
    if r6 or r7 then return end
    local c = f1(); if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart"); local hum = c:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    hum.PlatformStand = true
    r6 = Instance.new("BodyVelocity")
    r6.MaxForce = Vector3.new(99999, 99999, 99999)
    r6.Velocity = Vector3.new(0,0,0)
    r6.Parent = hrp
    r7 = Instance.new("BodyGyro")
    r7.MaxTorque = Vector3.new(99999, 99999, 99999)
    r7.P = 12500
    r7.Parent = hrp
    if r5 then r5:Disconnect(); r5 = nil end
    r5 = v3.RenderStepped:Connect(function()
        if not r1.FlyEnabled or not f1() then f16(); return end
        local char = f1(); local root = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then f16(); return end
        local move = hum.MoveDirection
        local vert = 0
        if v5:IsKeyDown(Enum.KeyCode.Space) then vert = 1 end
        if v5:IsKeyDown(Enum.KeyCode.LeftControl) then vert = -1 end
        local finalDir = Vector3.new(move.X, vert, move.Z)
        if finalDir.Magnitude > 0 then
            r6.Velocity = v4.CFrame:VectorToWorldSpace(finalDir.Unit) * r1.FlySpeed
        else
            r6.Velocity = Vector3.new(0,0,0)
        end
        if r7 then r7.CFrame = v4.CFrame end
    end)
end

local function f19()
    if r1.FlyMode == "绕过" then f17() else f18() end
end

local r8
local function f20()
    if r8 then task.cancel(r8) end
    r8 = task.spawn(function()
        local last = os.clock()
        while r1.Entertainment.Rotate.Enabled do
            local now = os.clock(); local dt = now - last; last = now
            local sp = r1.Entertainment.Rotate.Speed
            if sp > 0 and dt > 0 then
                local hrp = f2()
                if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(sp * dt), 0) end
            end
            task.wait()
        end
    end)
end
local function f21() if r8 then task.cancel(r8); r8 = nil end end

local r9, r10 = 16, nil
local function f22()
    if r10 then task.cancel(r10) end
    r10 = task.spawn(function()
        local lastJump = 0
        while r1.Entertainment.BunnyHop.Enabled do
            local h = f3(); local hrp = f2()
            if h and hrp then
                local moving = h.MoveDirection.Magnitude > 0.1
                local onGround = h.FloorMaterial ~= Enum.Material.Air
                if moving and onGround and (tick() - lastJump) > 0.3 then
                    h:ChangeState(Enum.HumanoidStateType.Jumping)
                    lastJump = tick()
                    if h.WalkSpeed ~= r1.Entertainment.BunnyHop.SpeedBoost * 16 then
                        r9 = h.WalkSpeed
                        h.WalkSpeed = r1.Entertainment.BunnyHop.SpeedBoost * 16
                    end
                elseif not moving and h.WalkSpeed ~= r9 then
                    h.WalkSpeed = r9
                end
            end
            task.wait(0.05)
        end
        local h = f3(); if h then h.WalkSpeed = r9 end
    end)
end
local function f23()
    if r10 then task.cancel(r10); r10 = nil end
    local h = f3(); if h then h.WalkSpeed = r9 end
end

local r11
local function f24()
    if r11 then task.cancel(r11) end
    r11 = task.spawn(function()
        while r1.Teleport.SuckAll do
            local myHRP = f2()
            if myHRP then
                local tcf = myHRP.CFrame
                for _, p in ipairs(v1:GetPlayers()) do
                    if p ~= v12 then
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
local function f25() if r11 then task.cancel(r11); r11 = nil end end

local r12
local function f26()
    if r12 then task.cancel(r12) end
    r12 = task.spawn(function()
        while r1.Teleport.LockPlayerToMe do
            local myRoot = f2(); local target = r1.Teleport.TargetPlayer
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
local function f27() if r12 then task.cancel(r12); r12 = nil end end

local r13 = {}
do
    local r14, r15 = nil, {}
    local function r16(cls, props) local inst = typeof(cls)=='string' and Instance.new(cls) or cls; for k,v in pairs(props) do inst[k]=v end; return inst end
    local function r17(plr)
        if not r14 or r15[plr] then return end
        local r18 = r16("TextLabel", {Parent=r14, Position=UDim2.new(0.5,0,0,-11), Size=UDim2.new(0,100,0,20), AnchorPoint=Vector2.new(0.5,0.5), BackgroundTransparency=1, TextColor3=Color3.new(1,1,1), Font=Enum.Font.Code, TextSize=11, RichText=true})
        local r19 = r16("TextLabel", {Parent=r14, Position=UDim2.new(0.5,0,0,11), Size=UDim2.new(0,100,0,20), AnchorPoint=Vector2.new(0.5,0.5), BackgroundTransparency=1, TextColor3=Color3.new(1,1,1), Font=Enum.Font.Code, TextSize=11})
        local r20 = r16("Frame", {Parent=r14, BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.75, BorderSizePixel=0})
        local r21 = r16("UIStroke", {Parent=r20, Color=Color3.new(1,1,1), LineJoinMode=Enum.LineJoinMode.Miter})
        r15[plr] = v3.RenderStepped:Connect(function()
            if not r1.ESP.Enabled then r20.Visible,r18.Visible,r19.Visible = false,false,false; return end
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = plr.Character.HumanoidRootPart
                local hum = plr.Character:FindFirstChild("Humanoid"); if not hum then return end
                local pos, on = v4:WorldToScreenPoint(HRP.Position)
                if on then
                    local dist = (v4.CFrame.Position - HRP.Position).Magnitude/3.57
                    if dist <= r1.ESP.MaxDistance then
                        local s = HRP.Size.Y; local scale = (s*v4.ViewportSize.Y)/(pos.Z*2); local w,h = 3*scale, 4.5*scale
                        r20.Position = UDim2.new(0,pos.X-w/2,0,pos.Y-h/2); r20.Size = UDim2.new(0,w,0,h); r20.Visible = true
                        if r1.ESP.Drawing.Names.Enabled then r18.Position = UDim2.new(0,pos.X,0,pos.Y-h/2-9); r18.Text = plr.Name; r18.Visible = true end
                        if r1.ESP.Drawing.Distances.Enabled then r19.Position = UDim2.new(0,pos.X,0,pos.Y+h/2+7); r19.Text = math.floor(dist).."m"; r19.Visible = true end
                    else r20.Visible,r18.Visible,r19.Visible = false,false,false end
                else r20.Visible,r18.Visible,r19.Visible = false,false,false end
            else r20.Visible,r18.Visible,r19.Visible = false,false,false end
        end)
    end
    function r13.Start()
        if r14 then return end
        r14 = r16("ScreenGui", {Parent=v10, Name="Trash_ESPHolder"})
        for _, v in ipairs(v1:GetPlayers()) do if v ~= v12 then r17(v) end end
        r15.PlayerAdded = v1.PlayerAdded:Connect(function(v) if v ~= v12 then r17(v) end end)
    end
    function r13.Stop()
        if r14 then r14:Destroy(); r14 = nil end
        for _, c in pairs(r15) do if type(c)=="table" then for _,v in ipairs(c) do v:Disconnect() end else c:Disconnect() end end
        r15 = {}
    end
    function r13.SetEnabled(v) r1.ESP.Enabled = v; if v then r13.Start() else r13.Stop() end end
end

local function f28(target)
    if not target then return end
    local tchar = target.Character
    if not tchar then local tm = 0; while not tchar and tm < 5 do task.wait(0.1); tchar = target.Character; tm = tm + 0.1 end end
    if not tchar then WasUIPro:Notify({Title="传送",Content="目标玩家未加载",Duration=2}); return end
    local trp = tchar:FindFirstChild("HumanoidRootPart") or tchar:FindFirstChild("Head")
    if not trp then WasUIPro:Notify({Title="传送",Content="无可用根部件",Duration=2}); return end
    if r1.Teleport.SmoothTeleport then
        local hrp = f2(); if not hrp then return end
        local dist = (hrp.Position - trp.Position).Magnitude
        local tw = v7:Create(hrp, TweenInfo.new(dist/r1.Teleport.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = trp.CFrame}); tw:Play()
    else
        local hrp = f2(); if hrp then hrp.CFrame = trp.CFrame end
    end
    WasUIPro:Notify({Title="传送",Content="已传送至 "..target.Name, Duration=2})
end

local r22, r23, r24
local groundY = nil
local function getGroundY(pos)
    local ray = Ray.new(pos + Vector3.new(0, 10, 0), Vector3.new(0, -200, 0))
    local hit, hitPos = v2:FindPartOnRay(ray, f1())
    if hitPos then
        return hitPos.Y + 2
    end
    return pos.Y
end

local function f29()
    local mode = r1.Invisibility.Mode
    local c = f1(); if not c then return end
    if mode == "Client" then
        for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.LocalTransparencyModifier = 1 end end
    elseif mode == "CFrame" then
        local hrp = f2(); if not hrp then return end
        groundY = getGroundY(hrp.Position)
        local belowY = groundY - 80
        hrp.CFrame = CFrame.new(hrp.Position.X, belowY, hrp.Position.Z)
        local h = f3(); if h then h.PlatformStand = true end
        if r23 then r23:Destroy() end
        if r24 then r24:Destroy() end
        r23 = Instance.new("Part"); r23.Size = Vector3.new(5,0.5,5); r23.Anchored = true; r23.Transparency = 1; r23.CanCollide = false; r23.Parent = v2
        r24 = Instance.new("Part"); r24.Size = Vector3.new(1,1,1); r24.Anchored = true; r24.Transparency = 1; r24.CanCollide = false; r24.Parent = v2
        if r22 then task.cancel(r22) end
        local bv = nil
        local bg = nil
        r22 = task.spawn(function()
            while r1.Invisibility.Enabled and r1.Invisibility.Mode == "CFrame" do
                local hrp = f2()
                if hrp and groundY then
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.MaxForce = Vector3.new(99999, 99999, 99999)
                        bv.Velocity = Vector3.new(0,0,0)
                        bv.Parent = hrp
                        bg = Instance.new("BodyGyro")
                        bg.MaxTorque = Vector3.new(99999, 99999, 99999)
                        bg.P = 12500
                        bg.Parent = hrp
                    end
                    local hum = f3()
                    local move = Vector3.new(0,0,0)
                    if hum then move = hum.MoveDirection end
                    local vert = 0
                    if v5:IsKeyDown(Enum.KeyCode.Space) then vert = 1 end
                    if v5:IsKeyDown(Enum.KeyCode.LeftControl) then vert = -1 end
                    local finalDir = Vector3.new(move.X, vert, move.Z)
                    local speed = 20
                    if finalDir.Magnitude > 0 then
                        bv.Velocity = finalDir.Unit * speed
                    else
                        bv.Velocity = Vector3.new(0,0,0)
                    end
                    if bg then bg.CFrame = CFrame.new(hrp.Position, hrp.Position + hrp.CFrame.LookVector) end
                    local newPos = hrp.Position
                    hrp.CFrame = CFrame.new(newPos.X, belowY, newPos.Z)
                    r23.CFrame = CFrame.new(hrp.Position.X, belowY, hrp.Position.Z)
                    r24.Position = Vector3.new(hrp.Position.X, groundY, hrp.Position.Z)
                    local camCF = CFrame.new(r24.Position, r24.Position + (v4.CFrame.LookVector * 10))
                    v4.CFrame = camCF
                end
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    end
end

local function f30()
    if r1.Invisibility.Mode == "Client" then
        local c = f1(); if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end end end
    elseif r1.Invisibility.Mode == "CFrame" then
        local h = f3(); if h then h.PlatformStand = false end
        if r23 then r23:Destroy(); r23 = nil end
        if r24 then r24:Destroy(); r24 = nil end
        if r22 then task.cancel(r22); r22 = nil end
        local hrp = f2()
        if hrp then
            local ray = Ray.new(hrp.Position + Vector3.new(0,10,0), Vector3.new(0,-200,0))
            local hit, pos = v2:FindPartOnRay(ray, hrp.Parent)
            if pos then
                hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
            else
                hrp.CFrame = CFrame.new(hrp.Position.X, 200, hrp.Position.Z)
            end
        end
        groundY = nil
    end
end

local function f31(state)
    r1.Invisibility.Enabled = state
    if state then f29() else f30() end
end

local r25
local function f32()
    local c = f1(); if not c or not c:FindFirstChild("HumanoidRootPart") then return nil end
    local lr = c.HumanoidRootPart
    local cand = {}
    local tmode = r1.SilentAim.TargetMode
    local function proc(model)
        if r1.SilentAim.TeamCheck and model.Team and model.Team == v12.Team then return end
        local hum = model:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then return end
        local part = model:FindFirstChild(r1.SilentAim.TargetPart) or model:FindFirstChild("HumanoidRootPart")
        if not part then return end
        if r1.SilentAim.VisibleCheck then
            local o = v4.CFrame.Position; local dir = part.Position - o
            local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = {c, part.Parent}
            if v2:Raycast(o, dir.Unit * dir.Magnitude, rp) then return end
        end
        local dist = (lr.Position - part.Position).Magnitude
        if dist > r1.SilentAim.MaxDistance then return end
        table.insert(cand, {model=model, part=part, dist=dist, health=hum.Health})
    end
    if tmode == "玩家" or tmode == "所有" then for _, p in ipairs(v1:GetPlayers()) do if p ~= v12 and p.Character then proc(p.Character) end end end
    if tmode == "NPC" or tmode == "所有" then
        for _, v in ipairs(v2:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and not v1:GetPlayerFromCharacter(v) then proc(v) end
        end
    end
    if #cand == 0 then return nil end
    table.sort(cand, function(a,b)
        local pri = r1.SilentAim.PriorityMode
        if pri == "最低血量" then return a.health < b.health
        elseif pri == "距离最近" then return a.dist < b.dist end
        return a.dist < b.dist
    end)
    return cand[1].part
end

local r26, r27, r28
r26 = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local method = getnamecallmethod(); local args = {...}; local self = args[1]
    if r1.SilentAim.Enabled and not checkcaller() and math.random() <= r1.SilentAim.HitChance/100 and r25 then
        local curMethod = r1.SilentAim.Method
        if (method == "FindPartOnRayWithIgnoreList" and curMethod == method) or
           (method == "FindPartOnRayWithWhitelist" and curMethod == method) or
           ((method == "FindPartOnRay" or method == "findPartOnRay") and curMethod:lower() == method:lower()) then
            if args[2] and args[2].Origin then
                if r1.SilentAim.Wallbang then return r25, r25.Position end
                local dir = (r25.Position - args[2].Origin).Unit * 1000
                args[2] = Ray.new(args[2].Origin, dir)
                return r26(unpack(args))
            end
        elseif method == "Raycast" and curMethod == method then
            if args[2] and args[3] then
                if r1.SilentAim.Wallbang then
                    local dir = (r25.Position - args[2]).Unit * 1000
                    local wp = RaycastParams.new(); wp.FilterType = Enum.RaycastFilterType.Include; wp.FilterDescendantsInstances = {r25.Parent}
                    return r26(args[1], args[2], dir, wp)
                end
                args[3] = (r25.Position - args[2]).Unit * 1000
                return r26(unpack(args))
            end
        elseif (method == "ScreenPointToRay" or method == "ViewportPointToRay") and curMethod == method and self == v4 then
            return Ray.new(v4.CFrame.Position, (r25.Position - v4.CFrame.Position).Unit)
        end
    end
    return r26(...)
end))

r27 = hookmetamethod(game, "__index", newcclosure(function(self, idx)
    if self == v12:GetMouse() and not checkcaller() and r1.SilentAim.Enabled and r1.SilentAim.Method == "Mouse.Hit/Target" and r25 then
        if idx:lower() == "hit" then return r25.CFrame end
    end
    return r27(self, idx)
end))

r28 = hookfunction(Ray.new, newcclosure(function(o, d)
    if r1.SilentAim.Enabled and r1.SilentAim.Method == "Ray" and r25 and not checkcaller() and math.random() <= r1.SilentAim.HitChance/100 then
        return r28(o, (r25.Position - o).Unit * 1000)
    end
    return r28(o, d)
end))

local r29
local function f33()
    if r29 then r29:Disconnect() end
    r29 = v3.RenderStepped:Connect(function()
        if not r1.Noclip then return end
        local c = f1()
        if c then
            for _, part in ipairs(c:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function f34()
    if r29 then r29:Disconnect(); r29 = nil end
    local c = f1()
    if c then
        for _, part in ipairs(c:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function f35(state)
    r1.Noclip = state
    if state then f33() else f34() end
end

local function f36()
    for _, ctrl in pairs(ctrl) do
        if ctrl.SetValue then
            pcall(function() ctrl:SetValue(false) end)
        end
    end
    r1.FlyEnabled = false; f16()
    r1.SpeedEnabled = false; local h = f3(); if h then h.WalkSpeed = 16 end
    r1.HighJumpEnabled = false; h = f3(); if h then h.JumpHeight = 7.2 end
    r13.SetEnabled(false)
    f15(false)
    f21(); f23(); f25(); f27()
    f11(false); r1.SilentAim.Enabled = false
    f31(false)
    r1.InfJump = false; if r1.Threads.InfJump then r1.Threads.InfJump:Disconnect() end
    r1.NoPromptCD = false
    f35(false)
end

local c1 = WasUIPro:CreateWindow({
    Title = "TrashHub 通用",
    MinimizedText = "TrashHub",
    Folder = "TrashHub_Config",
    SnowEnabled = true
})

if not c1 then
    error("无法创建窗口，请检查 WasUIPro 版本或参数")
end

local c2 = c1:Tab({ Title = "人物" })
local c3 = c1:Tab({ Title = "环境" })
local c4 = c1:Tab({ Title = "瞄准" })
local c5 = c1:Tab({ Title = "ESP" })
local c6 = c1:Tab({ Title = "传送" })
local c7 = c1:Tab({ Title = "其他" })
local c8 = c1:Tab({ Title = "娱乐" })
local c9 = c1:Tab({ Title = "配置" })

local c10 = c2:Category({ Title = "移动辅助", IconName = "zap" })
ctrl.FlightToggle = c10:Toggle({
    Title = "飞行",
    Value = r1.FlyEnabled,
    FeatureName = "飞行",
    Tooltip = "开启后可自由飞行",
    Callback = function(state)
        r1.FlyEnabled = state
        if state then f19() else f16() end
    end
})
ctrl.FlyMode = c10:Dropdown({
    Title = "飞行方式",
    Values = { "绕过", "普通" },
    Value = r1.FlyMode,
    Tooltip = "选择飞行模式",
    Callback = function(selected)
        r1.FlyMode = selected
        if r1.FlyEnabled then
            f16()
            f19()
        end
    end
})
c10:Slider({
    Title = "飞行速度",
    Min = 1, Max = 200, Default = r1.FlySpeed,
    Callback = function(val) r1.FlySpeed = val end
})
ctrl.SpeedToggle = c10:Toggle({
    Title = "加速",
    Value = r1.SpeedEnabled,
    FeatureName = "加速",
    Tooltip = "开启后移动速度加快",
    Callback = function(state)
        r1.SpeedEnabled = state
        local h = f3()
        if h then h.WalkSpeed = state and r1.SpeedValue or 16 end
    end
})
c10:Slider({
    Title = "加速速度",
    Min = 16, Max = 200, Default = r1.SpeedValue,
    Callback = function(val)
        r1.SpeedValue = val
        if r1.SpeedEnabled then
            local h = f3()
            if h then h.WalkSpeed = val end
        end
    end
})
ctrl.HighJumpToggle = c10:Toggle({
    Title = "高跳",
    Value = r1.HighJumpEnabled,
    FeatureName = "高跳",
    Tooltip = "大幅提高跳跃高度",
    Callback = function(state)
        r1.HighJumpEnabled = state
        local h = f3()
        if h then
            if state then
                h.JumpHeight = r1.JumpHeight
                if not r1.Threads.HighJump then
                    r1.Threads.HighJump = h.Jumping:Connect(function()
                        h.JumpHeight = r1.JumpHeight
                    end)
                end
                if not r1.Threads.HighJumpCharAdded then
                    r1.Threads.HighJumpCharAdded = v12.CharacterAdded:Connect(function()
                        task.wait(0.5)
                        local newH = f3()
                        if newH and r1.HighJumpEnabled then
                            newH.JumpHeight = r1.JumpHeight
                            if not r1.Threads.HighJump then
                                r1.Threads.HighJump = newH.Jumping:Connect(function()
                                    newH.JumpHeight = r1.JumpHeight
                                end)
                            end
                        end
                    end)
                end
            else
                h.JumpHeight = 7.2
                if r1.Threads.HighJump then
                    r1.Threads.HighJump:Disconnect()
                    r1.Threads.HighJump = nil
                end
                if r1.Threads.HighJumpCharAdded then
                    r1.Threads.HighJumpCharAdded:Disconnect()
                    r1.Threads.HighJumpCharAdded = nil
                end
            end
        end
    end
})
c10:Slider({
    Title = "跳跃高度",
    Min = 7.2, Max = 50, Default = r1.JumpHeight,
    Callback = function(val)
        r1.JumpHeight = val
        if r1.HighJumpEnabled then
            local h = f3()
            if h then h.JumpHeight = val end
        end
    end
})
ctrl.InfJumpToggle = c10:Toggle({
    Title = "无限跳跃",
    Value = r1.InfJump,
    FeatureName = "无限跳跃",
    Tooltip = "长按空格可连续跳跃",
    Callback = function(state)
        r1.InfJump = state
        if state then
            if r1.Threads.InfJump then r1.Threads.InfJump:Disconnect() end
            r1.Threads.InfJump = v5.JumpRequest:Connect(function()
                if r1.InfJump then
                    local h = f3()
                    if h and h:GetState() == Enum.HumanoidStateType.Landed then
                        h:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            if r1.Threads.InfJump then r1.Threads.InfJump:Disconnect() end
        end
    end
})
ctrl.NoclipToggle = c10:Toggle({
    Title = "穿墙",
    Value = r1.Noclip,
    FeatureName = "穿墙",
    Tooltip = "允许角色穿过墙壁",
    Callback = function(state) f35(state) end
})

local c11 = c2:Category({ Title = "防护", IconName = "shield" })
ctrl.AntiRagdoll = c11:Toggle({
    Title = "反布娃娃",
    Value = r1.AntiRagdoll,
    FeatureName = "反布娃娃",
    Tooltip = "防止角色进入布娃娃状态",
    Callback = function(state)
        r1.AntiRagdoll = state
        if state then
            local h = f3()
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
ctrl.AntiAFK = c11:Toggle({
    Title = "反挂机",
    Value = r1.AntiAFK,
    FeatureName = "反挂机",
    Tooltip = "阻止空闲踢出",
    Callback = function(state)
        r1.AntiAFK = state
        if state then
            r1.Threads.AntiAFK = task.spawn(function()
                while r1.AntiAFK do
                    pcall(function()
                        v8:Button2Down(Vector2.new(0,0), v4.CFrame)
                        task.wait(1)
                        v8:Button2Up(Vector2.new(0,0), v4.CFrame)
                        task.wait(60)
                    end)
                end
            end)
        else
            if r1.Threads.AntiAFK then task.cancel(r1.Threads.AntiAFK) end
        end
    end
})

local c12 = c2:Category({ Title = "隐身", IconName = "eye-off" })
ctrl.InvisibilityToggle = c12:Toggle({
    Title = "启用隐身",
    Value = r1.Invisibility.Enabled,
    FeatureName = "隐身",
    Callback = f31,
    Tooltip = "让其他玩家看不到你"
})
c12:Dropdown({
    Title = "隐身模式",
    Values = { "客户端", "伪隐身(非客户端)" },
    Value = r1.Invisibility.Mode == "Client" and "客户端" or "伪隐身(非客户端)",
    Callback = function(selected)
        r1.Invisibility.Mode = selected == "客户端" and "Client" or "CFrame"
        if r1.Invisibility.Enabled then
            f30()
            f29()
        end
    end
})

local c13 = c3:Category({ Title = "视觉增强", IconName = "sun" })
ctrl.NightVision = c13:Toggle({
    Title = "夜视",
    Value = r1.NightVision,
    FeatureName = "夜视",
    Tooltip = "提高环境亮度",
    Callback = function(state)
        r1.NightVision = state
        v6.Ambient = state and Color3.new(1,1,1) or Color3.new(0,0,0)
        v6.Brightness = state and 2 or 0.5
    end
})
ctrl.RemoveShadows = c13:Toggle({
    Title = "删除阴影",
    Value = r1.RemoveShadows,
    FeatureName = "删除阴影",
    Tooltip = "移除所有阴影效果",
    Callback = function(state)
        r1.RemoveShadows = state
        v6.GlobalShadows = not state
    end
})
c13:Button({
    Text = "删除纹理",
    Icon = "zap",
    Tooltip = "将大部分零件材质设置为光滑塑料",
    Callback = function()
        pcall(function()
            for _, v in ipairs(v2:GetDescendants()) do
                if v:IsA("Part") or v:IsA("MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
        end)
    end
})
c13:Button({
    Text = "删除天空盒",
    Icon = "cloud-off",
    Callback = function()
        pcall(function()
            if v6.Sky then v6.Sky:Destroy() end
        end)
    end
})

local c14 = c3:Category({ Title = "时间调节", IconName = "clock" })
ctrl.TimeDropdown = c14:Dropdown({
    Title = "修改时间",
    Values = { "8:00", "12:00", "18:00", "24:00" },
    Value = r1.SelectedTime,
    Callback = function(sel)
        r1.SelectedTime = sel
    end
})
c14:Button({
    Text = "确认修改时间",
    Icon = "check",
    Callback = function()
        local hour = tonumber(r1.SelectedTime:match("(%d+):"))
        if hour then v6.TimeOfDay = string.format("%02d:00:00", hour) end
    end
})

local c15 = c4:Category({ Title = "普通自瞄", IconName = "crosshair" })
ctrl.Aimbot = c15:Toggle({
    Title = "自动瞄准",
    Value = r1.Aimbot.Enabled,
    FeatureName = "自动瞄准",
    Callback = f11,
    Tooltip = "自动将镜头对准敌人"
})
ctrl.ShowFOV = c15:Toggle({
    Title = "显示FOV圈",
    Value = r1.Aimbot.ShowFOV,
    FeatureName = "FOV圈",
    Callback = f12,
    Tooltip = "显示自瞄范围圈"
})
c15:Slider({
    Title = "FOV大小",
    Min = 30, Max = 500, Default = r1.Aimbot.FOVSize,
    Callback = function(val)
        r1.Aimbot.FOVSize = val
        if r1.Aimbot.ShowFOV then f10() end
    end
})
ctrl.CheckObstacles = c15:Toggle({
    Title = "掩体判断",
    Value = r1.Aimbot.CheckObstacles,
    FeatureName = "掩体判断",
    Tooltip = "忽略视野中的障碍物",
    Callback = function(state) r1.Aimbot.CheckObstacles = state end
})
ctrl.SmoothAim = c15:Toggle({
    Title = "平滑自瞄",
    Value = r1.Aimbot.Smooth,
    FeatureName = "平滑自瞄",
    Tooltip = "自瞄移动更自然",
    Callback = function(state) r1.Aimbot.Smooth = state end
})
c15:Slider({
    Title = "自瞄速度",
    Min = 100, Max = 500, Default = r1.Aimbot.Speed,
    Callback = function(val) r1.Aimbot.Speed = val end
})
c15:Slider({
    Title = "自瞄距离",
    Min = 100, Max = 5000, Default = r1.Aimbot.Distance,
    Callback = function(val) r1.Aimbot.Distance = val end
})

local c16 = c4:Category({ Title = "Hitbox", IconName = "users" })
ctrl.EnemyVisual = c16:Toggle({
    Title = "启用",
    Value = r1.EnemyVisual.Enabled,
    FeatureName = "Hitbox",
    Callback = f15,
    Tooltip = "修改其他玩家的Hitbox高亮效果"
})
c16:Slider({
    Title = "Hitbox大小",
    Min = 1, Max = 20, Default = r1.EnemyVisual.Hitbox.Size,
    Callback = function(val) r1.EnemyVisual.Hitbox.Size = val end
})
c16:Slider({
    Title = "Hitbox透明度",
    Min = 0, Max = 1, Default = r1.EnemyVisual.Hitbox.Transparency,
    Callback = function(val) r1.EnemyVisual.Hitbox.Transparency = val end
})

local c17 = c4:Category({ Title = "静默自瞄", IconName = "target" })
ctrl.SilentAim = c17:Toggle({
    Title = "启用静默自瞄",
    Value = r1.SilentAim.Enabled,
    FeatureName = "静默自瞄",
    Tooltip = "在不移动镜头的情况下击中敌人",
    Callback = function(state) r1.SilentAim.Enabled = state end
})
c17:Dropdown({
    Title = "目标种类",
    Values = { "玩家", "NPC", "所有" },
    Value = r1.SilentAim.TargetMode,
    Callback = function(val) r1.SilentAim.TargetMode = val end
})
c17:Dropdown({
    Title = "目标部位",
    Values = { "Head", "HumanoidRootPart" },
    Value = r1.SilentAim.TargetPart,
    Callback = function(val) r1.SilentAim.TargetPart = val end
})
c17:Dropdown({
    Title = "优先模式",
    Values = { "准星最近", "距离最近", "最低血量", "最近的人(无FOV)" },
    Value = r1.SilentAim.PriorityMode,
    Callback = function(val) r1.SilentAim.PriorityMode = val end
})
c17:Dropdown({
    Title = "静默方式",
    Values = { "Raycast", "FindPartOnRay", "ScreenPointToRay", "ViewportPointToRay", "Ray", "Mouse.Hit/Target" },
    Value = r1.SilentAim.Method,
    Callback = function(val) r1.SilentAim.Method = val end
})
c17:Slider({
    Title = "命中率",
    Min = 0, Max = 100, Default = r1.SilentAim.HitChance,
    Callback = function(val) r1.SilentAim.HitChance = val end
})
c17:Toggle({
    Title = "可见性检查",
    Value = r1.SilentAim.VisibleCheck,
    FeatureName = "可见性检查",
    Callback = function(state) r1.SilentAim.VisibleCheck = state end
})
c17:Toggle({
    Title = "穿墙",
    Value = r1.SilentAim.Wallbang,
    FeatureName = "穿墙",
    Callback = function(state) r1.SilentAim.Wallbang = state end
})

local c18 = c5:Category({ Title = "基础控制", IconName = "eye" })
ctrl.ESP = c18:Toggle({
    Title = "启用ESP",
    Value = r1.ESP.Enabled,
    FeatureName = "ESP",
    Callback = function(state) r13.SetEnabled(state) end,
    Tooltip = "显示玩家方框信息"
})
c18:Slider({
    Title = "最大距离",
    Min = 50, Max = 500, Default = r1.ESP.MaxDistance,
    Callback = function(val) r1.ESP.MaxDistance = val end
})

local c19 = c6:Category({ Title = "玩家传送", IconName = "send" })
local pnames = {}
for _, p in ipairs(v1:GetPlayers()) do if p ~= v12 then table.insert(pnames, p.Name) end end
ctrl.TeleportDropdown = c19:Dropdown({
    Title = "选择玩家",
    Values = pnames,
    Value = "无",
    Callback = function(selected)
        for _, p in ipairs(v1:GetPlayers()) do
            if p.Name == selected then r1.Teleport.TargetPlayer = p; break end
        end
    end
})
task.spawn(function()
    while task.wait(5) do
        local names = {}
        for _, p in ipairs(v1:GetPlayers()) do if p ~= v12 then table.insert(names, p.Name) end end
        ctrl.TeleportDropdown:UpdateOptions(names, ctrl.TeleportDropdown.SelectedValue)
    end
end)
c19:Button({
    Text = "确认传送",
    Icon = "send",
    Callback = function()
        if r1.Teleport.TargetPlayer then
            f28(r1.Teleport.TargetPlayer)
        else
            WasUIPro:Notify({Title="传送", Content="请先选择一个玩家", Duration=2})
        end
    end
})
ctrl.LockPlayer = c19:Toggle({
    Title = "锁定玩家到自己",
    Value = r1.Teleport.LockPlayerToMe,
    FeatureName = "锁定玩家",
    Tooltip = "将目标玩家持续拉到你附近",
    Callback = function(state)
        r1.Teleport.LockPlayerToMe = state
        if state then f26() else f27() end
    end
})
ctrl.SmoothTeleport = c19:Toggle({
    Title = "平滑传送",
    Value = r1.Teleport.SmoothTeleport,
    FeatureName = "平滑传送",
    Callback = function(state) r1.Teleport.SmoothTeleport = state end
})
c19:Slider({
    Title = "传送速度",
    Min = 50, Max = 500, Default = r1.Teleport.TweenSpeed,
    Callback = function(val) r1.Teleport.TweenSpeed = val end
})
ctrl.SuckAll = c19:Toggle({
    Title = "循环吸人",
    Value = r1.Teleport.SuckAll,
    FeatureName = "循环吸人",
    Tooltip = "将所有玩家传送到你脚下",
    Callback = function(state)
        r1.Teleport.SuckAll = state
        if state then f24() else f25() end
    end
})

local c20 = c7:Category({ Title = "游戏信息", IconName = "info" })
c20:Button({
    Text = "复制PlaceID",
    Icon = "copy",
    Callback = function() if setclipboard then setclipboard(tostring(game.PlaceId)) end end
})
c20:Button({
    Text = "复制JobID",
    Icon = "copy",
    Callback = function() if setclipboard then setclipboard(game.JobId) end end
})

local c21 = c7:Category({ Title = "服务器跳跃", IconName = "log-in" })
ctrl.JobIdInput = c21:TextInput({
    Title = "输入目标JobID",
    Placeholder = "",
    Value = r1.JobIdToJoin,
    Callback = function(val) r1.JobIdToJoin = val end
})
c21:Button({
    Text = "确认加入",
    Icon = "log-in",
    Callback = function()
        if r1.JobIdToJoin ~= "" then
            pcall(function() v11:TeleportToPlaceInstance(game.PlaceId, r1.JobIdToJoin, v12) end)
        end
    end
})
c21:Button({
    Text = "切换服务器",
    Icon = "refresh-cw",
    Callback = function() pcall(function() v11:Teleport(game.PlaceId) end) end
})

local c22 = c7:Category({ Title = "实用设置", IconName = "settings" })
ctrl.GlobalChat = c22:Toggle({
    Title = "启用全局聊天",
    Value = true,
    FeatureName = "全局聊天",
    Tooltip = "开启新聊天窗口",
    Callback = function(state)
        pcall(function() game:GetService("TextChatService").ChatWindowConfiguration.Enabled = state end)
    end
})
ctrl.NoPromptCD = c22:Toggle({
    Title = "交互无CD",
    Value = r1.NoPromptCD,
    FeatureName = "交互无CD",
    Tooltip = "立即拾取物品",
    Callback = function(state)
        r1.NoPromptCD = state
        for _, obj in ipairs(v2:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then obj.HoldDuration = state and 0 or 0.5 end
        end
    end
})

local c23 = c8:Category({ Title = "旋转", IconName = "rotate-cw" })
ctrl.Rotate = c23:Toggle({
    Title = "启用旋转",
    Value = r1.Entertainment.Rotate.Enabled,
    FeatureName = "旋转",
    Tooltip = "原地旋转角色",
    Callback = function(state)
        r1.Entertainment.Rotate.Enabled = state
        if state then f20() else f21() end
    end
})
c23:Slider({
    Title = "旋转速度",
    Min = 360, Max = 720, Default = r1.Entertainment.Rotate.Speed,
    Callback = function(val) r1.Entertainment.Rotate.Speed = val end
})

local c24 = c8:Category({ Title = "兔子跳", IconName = "rabbit" })
ctrl.BunnyHop = c24:Toggle({
    Title = "启用兔子跳",
    Value = r1.Entertainment.BunnyHop.Enabled,
    FeatureName = "兔子跳",
    Tooltip = "自动跳跃并加速",
    Callback = function(state)
        r1.Entertainment.BunnyHop.Enabled = state
        if state then f22() else f23() end
    end
})
c24:Slider({
    Title = "加速倍率",
    Min = 1, Max = 5, Default = r1.Entertainment.BunnyHop.SpeedBoost,
    Callback = function(val) r1.Entertainment.BunnyHop.SpeedBoost = val end
})

local c25 = c9:Category({ Title = "全局控制", IconName = "power" })
c25:Button({
    Text = "关闭所有功能",
    Icon = "power",
    Callback = f36
})

task.spawn(function()
    v3.RenderStepped:Connect(function()
        if r1.SpeedEnabled then
            local h = f3()
            if h then h.WalkSpeed = r1.SpeedValue end
        end
        if r1.SilentAim.Enabled then
            r25 = f32()
        end
        f8()
    end)
end)

task.spawn(function()
    if r1.Aimbot.Enabled then f11(true) end
    if r1.Aimbot.ShowFOV then f10() end
    if r1.EnemyVisual.Enabled then f15(true) end
    if r1.ESP.Enabled then r13.SetEnabled(true) end
    if r1.FlyEnabled then f19() end
    if r1.Entertainment.Rotate.Enabled then f20() end
    if r1.Entertainment.BunnyHop.Enabled then f22() end
    if r1.Teleport.SuckAll then f24() end
    if r1.Teleport.LockPlayerToMe then f26() end
    if r1.Invisibility.Enabled then f31(true) end
    if r1.Noclip then f35(true) end
end)

WasUIPro:Notify({Title="TrashHub 通用", Content="加载成功", Duration=3})
