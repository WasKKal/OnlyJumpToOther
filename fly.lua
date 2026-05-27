local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local flyGui = Instance.new("ScreenGui")
flyGui.Name = "FlyGui"
flyGui.Parent = lp:WaitForChild("PlayerGui")
flyGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = flyGui
mainFrame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
mainFrame.BorderColor3 = Color3.fromRGB(103, 221, 213)
mainFrame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
mainFrame.Size = UDim2.new(0, 190, 0, 57)
mainFrame.Active = true
mainFrame.Draggable = true

local btnUp = Instance.new("TextButton")
btnUp.Parent = mainFrame
btnUp.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
btnUp.Size = UDim2.new(0, 44, 0, 28)
btnUp.Font = Enum.Font.SourceSans
btnUp.Text = "Up"
btnUp.TextColor3 = Color3.fromRGB(0, 0, 0)
btnUp.TextSize = 14

local btnDown = Instance.new("TextButton")
btnDown.Parent = mainFrame
btnDown.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
btnDown.Position = UDim2.new(0, 0, 0.491228074, 0)
btnDown.Size = UDim2.new(0, 44, 0, 28)
btnDown.Font = Enum.Font.SourceSans
btnDown.Text = "Down"
btnDown.TextColor3 = Color3.fromRGB(0, 0, 0)
btnDown.TextSize = 14

local btnFlyToggle = Instance.new("TextButton")
btnFlyToggle.Parent = mainFrame
btnFlyToggle.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
btnFlyToggle.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
btnFlyToggle.Size = UDim2.new(0, 56, 0, 28)
btnFlyToggle.Font = Enum.Font.SourceSans
btnFlyToggle.Text = "Fly OFF"
btnFlyToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
btnFlyToggle.TextSize = 14

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
titleLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
titleLabel.Size = UDim2.new(0, 100, 0, 28)
titleLabel.Font = Enum.Font.SourceSans
titleLabel.Text = "Fly GUI v2"
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.TextScaled = true
titleLabel.TextSize = 14
titleLabel.TextWrapped = true

local btnSpeedUp = Instance.new("TextButton")
btnSpeedUp.Parent = mainFrame
btnSpeedUp.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
btnSpeedUp.Position = UDim2.new(0.231578946, 0, 0, 0)
btnSpeedUp.Size = UDim2.new(0, 45, 0, 28)
btnSpeedUp.Font = Enum.Font.SourceSans
btnSpeedUp.Text = "Speed+"
btnSpeedUp.TextColor3 = Color3.fromRGB(0, 0, 0)
btnSpeedUp.TextScaled = true
btnSpeedUp.TextSize = 14
btnSpeedUp.TextWrapped = true

local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speedLabel.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speedLabel.Size = UDim2.new(0, 44, 0, 28)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Text = "1"
speedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
speedLabel.TextScaled = true
speedLabel.TextSize = 14
speedLabel.TextWrapped = true

local btnSpeedDown = Instance.new("TextButton")
btnSpeedDown.Parent = mainFrame
btnSpeedDown.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
btnSpeedDown.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
btnSpeedDown.Size = UDim2.new(0, 45, 0, 29)
btnSpeedDown.Font = Enum.Font.SourceSans
btnSpeedDown.Text = "Speed-"
btnSpeedDown.TextColor3 = Color3.fromRGB(0, 0, 0)
btnSpeedDown.TextScaled = true
btnSpeedDown.TextSize = 14
btnSpeedDown.TextWrapped = true

local btnClose = Instance.new("TextButton")
btnClose.Parent = mainFrame
btnClose.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
btnClose.Font = Enum.Font.SourceSans
btnClose.Size = UDim2.new(0, 45, 0, 28)
btnClose.Text = "Close"
btnClose.TextSize = 30
btnClose.Position = UDim2.new(0, 0, -1, 27)

local btnMinimize = Instance.new("TextButton")
btnMinimize.Parent = mainFrame
btnMinimize.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
btnMinimize.Font = Enum.Font.SourceSans
btnMinimize.Size = UDim2.new(0, 45, 0, 28)
btnMinimize.Text = "Min"
btnMinimize.TextSize = 30
btnMinimize.Position = UDim2.new(0, 44, -1, 27)

local btnRestore = Instance.new("TextButton")
btnRestore.Parent = mainFrame
btnRestore.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
btnRestore.Font = Enum.Font.SourceSans
btnRestore.Size = UDim2.new(0, 45, 0, 28)
btnRestore.Text = "Restore"
btnRestore.TextSize = 30
btnRestore.Position = UDim2.new(0, 44, -1, 57)
btnRestore.Visible = false
local flyActive = false
local flySpeedMultiplier = 1
local flyConnection = nil
local bodyGyro = nil
local bodyVelocity = nil
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastCtrl = {f = 0, b = 0, l = 0, r = 0}
local currentFlySpeed = 50

local function stopFly()
    if flyConnection then flyConnection:Disconnect() end
    flyConnection = nil
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
    bodyGyro = nil
    bodyVelocity = nil
    if lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
    end
    ctrl = {f = 0, b = 0, l = 0, r = 0}
    lastCtrl = {f = 0, b = 0, l = 0, r = 0}
    currentFlySpeed = 50
end

local function startFly()
    if flyActive then return end
    local char = lp.Character
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not torso then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand = true
        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
        hum:ChangeState(Enum.HumanoidStateType.Swimming)
    end
    bodyGyro = Instance.new("BodyGyro", torso)
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = torso.CFrame
    bodyVelocity = Instance.new("BodyVelocity", torso)
    bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    flyActive = true
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyActive or not lp.Character then return end
        local torso = lp.Character:FindFirstChild("UpperTorso") or lp.Character:FindFirstChild("Torso")
        if not torso then return end
        local speed = currentFlySpeed * flySpeedMultiplier
        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            local cam = Workspace.CurrentCamera
            local look = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local move = (look * (ctrl.f + ctrl.b)) + (right * (ctrl.l + ctrl.r))
            bodyVelocity.velocity = move * speed
            lastCtrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
        elseif speed ~= 0 then
            local cam = Workspace.CurrentCamera
            local look = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local move = (look * (lastCtrl.f + lastCtrl.b)) + (right * (lastCtrl.l + lastCtrl.r))
            bodyVelocity.velocity = move * speed
        else
            bodyVelocity.velocity = Vector3.new(0, 0, 0)
        end
        bodyGyro.cframe = Workspace.CurrentCamera.CFrame
    end)
end

local function setFlyState(state)
    if state and not flyActive then
        startFly()
        btnFlyToggle.Text = "Fly ON"
        btnFlyToggle.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    elseif not state and flyActive then
        stopFly()
        flyActive = false
        btnFlyToggle.Text = "Fly OFF"
        btnFlyToggle.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
    end
end

btnFlyToggle.MouseButton1Click:Connect(function()
    setFlyState(not flyActive)
end)
local upHold = nil
btnUp.MouseButton1Down:Connect(function()
    upHold = RunService.RenderStepped:Connect(function()
        if flyActive then
            ctrl.f = 1
            ctrl.b = 0
        else
            local char = lp.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
            end
        end
    end)
end)
btnUp.MouseLeave:Connect(function()
    if upHold then upHold:Disconnect() end
    if flyActive then ctrl.f = 0; ctrl.b = 0 end
end)

local downHold = nil
btnDown.MouseButton1Down:Connect(function()
    downHold = RunService.RenderStepped:Connect(function()
        if flyActive then
            ctrl.b = 1
            ctrl.f = 0
        else
            local char = lp.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)
            end
        end
    end)
end)
btnDown.MouseLeave:Connect(function()
    if downHold then downHold:Disconnect() end
    if flyActive then ctrl.f = 0; ctrl.b = 0 end
end)

btnSpeedUp.MouseButton1Click:Connect(function()
    flySpeedMultiplier = math.min(flySpeedMultiplier + 1, 10)
    speedLabel.Text = tostring(flySpeedMultiplier)
end)

btnSpeedDown.MouseButton1Click:Connect(function()
    flySpeedMultiplier = math.max(flySpeedMultiplier - 1, 1)
    speedLabel.Text = tostring(flySpeedMultiplier)
end)

btnClose.MouseButton1Click:Connect(function()
    flyGui:Destroy()
end)

btnMinimize.MouseButton1Click:Connect(function()
    btnUp.Visible = false
    btnDown.Visible = false
    btnFlyToggle.Visible = false
    btnSpeedUp.Visible = false
    speedLabel.Visible = false
    btnSpeedDown.Visible = false
    btnMinimize.Visible = false
    btnRestore.Visible = true
    mainFrame.BackgroundTransparency = 1
    btnClose.Position = UDim2.new(0, 0, -1, 57)
end)

btnRestore.MouseButton1Click:Connect(function()
    btnUp.Visible = true
    btnDown.Visible = true
    btnFlyToggle.Visible = true
    btnSpeedUp.Visible = true
    speedLabel.Visible = true
    btnSpeedDown.Visible = true
    btnMinimize.Visible = true
    btnRestore.Visible = false
    mainFrame.BackgroundTransparency = 0
    btnClose.Position = UDim2.new(0, 0, -1, 27)
end)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not flyActive then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then
        ctrl.f = 1
        ctrl.b = 0
    elseif key == Enum.KeyCode.S then
        ctrl.b = 1
        ctrl.f = 0
    elseif key == Enum.KeyCode.A then
        ctrl.l = 1
        ctrl.r = 0
    elseif key == Enum.KeyCode.D then
        ctrl.r = 1
        ctrl.l = 0
    elseif key == Enum.KeyCode.Space then
        currentFlySpeed = 100
    elseif key == Enum.KeyCode.LeftShift then
        currentFlySpeed = 20
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if processed or not flyActive then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then
        ctrl.f = 0
    elseif key == Enum.KeyCode.S then
        ctrl.b = 0
    elseif key == Enum.KeyCode.A then
        ctrl.l = 0
    elseif key == Enum.KeyCode.D then
        ctrl.r = 0
    elseif key == Enum.KeyCode.Space or key == Enum.KeyCode.LeftShift then
        currentFlySpeed = 50
    end
end)
lp.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    if flyActive then
        stopFly()
        flyActive = false
        setFlyState(true)
    end
end)

print("飞行UI已加载 | 点击 Fly ON 开启，W/A/S/D 控制，空格加速，Shift减速")
