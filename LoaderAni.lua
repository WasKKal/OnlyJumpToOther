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

local v19 = game:GetService("CoreGui")
local v20 = game:GetService("Lighting")
local v21 = game:GetService("RunService")
local v22 = game:GetService("TweenService")

local function v23(v24, v25, v26)
    return Color3.new(v24.R + (v25.R - v24.R) * v26, v24.G + (v25.G - v24.G) * v26, v24.B + (v25.B - v24.B) * v26)
end

local v27 = {}
v27.__index = v27

function v27.new()
    pcall(function()
        local v28 = v19:FindFirstChild("TrashLoadingScreen")
        if v28 then v28:Destroy() end
    end)
    local v29 = setmetatable({}, v27)
    v29.originalBrightness = v20.Brightness
    v29.originalAmbient = v20.Ambient
    v29.originalOutdoorAmbient = v20.OutdoorAmbient
    v29.gui = Instance.new("ScreenGui")
    v29.gui.Name = "TrashLoadingScreen"
    v29.gui.Parent = v19
    v29.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v29.gui.DisplayOrder = 999999
    v29.gui.ResetOnSpawn = false
    v29.gui.IgnoreGuiInset = true
    v29.triggered30 = false
    v29.triggered90 = false
    v29.triggered91 = false
    v29.colorCycleActive = false
    v29.colorCycleTween = nil
    v29.heartbeatConn = nil
    v29.rainbowBars = nil
    v29.isTimeout = false
    v29.startTime = tick()
    v29:_createUI()
    v29:_darkenScreen()
    v29:_createRainbowEffect()
    v29:_createColorBackground()
    v29:_checkTimeout()
    return v29
end

function v27:_checkTimeout()
    task.spawn(function()
        while self.gui and self.gui.Parent and not self.triggered30 do
            task.wait(0.1)
            if tick() - self.startTime >= 5 and not self.triggered30 then
                self.isTimeout = true
                if self.title then
                    self.title.TextColor3 = Color3.fromRGB(255,0,0)
                    task.wait(0.5)
                    self.title.Text = "超时,点此跳过"
                    self.title.MouseButton1Click:Connect(function()
                        self:fadeOutAndDestroy()
                    end)
                end
                break
            end
        end
    end)
end

function v27:_createUI()
    self.bg = Instance.new("Frame")
    self.bg.Name = "bg"
    self.bg.Size = UDim2.new(1,0,1,0)
    self.bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
    self.bg.BackgroundTransparency = 0.3
    self.bg.BorderSizePixel = 0
    self.bg.Parent = self.gui
    local v30 = Instance.new("Frame")
    v30.Name = "centerContainer"
    v30.Size = UDim2.new(0,500,0,260)
    v30.Position = UDim2.new(0.5,-250,0.5,-130)
    v30.BackgroundTransparency = 1
    v30.Parent = self.gui
    self.title = Instance.new("TextLabel")
    self.title.Name = "titleLabel"
    self.title.Size = UDim2.new(1,0,0,60)
    self.title.Position = UDim2.new(0,0,0,0)
    self.title.BackgroundTransparency = 1
    self.title.Text = "Loading..."
    self.title.TextColor3 = Color3.fromRGB(255,200,100)
    self.title.TextStrokeTransparency = 0
    self.title.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    self.title.Font = Enum.Font.GothamBold
    self.title.TextSize = 48
    self.title.TextXAlignment = Enum.TextXAlignment.Center
    self.title.TextYAlignment = Enum.TextYAlignment.Center
    self.title.Parent = v30
    self.status = Instance.new("TextLabel")
    self.status.Name = "statusLabel"
    self.status.Size = UDim2.new(1,0,0,30)
    self.status.Position = UDim2.new(0,0,0,65)
    self.status.BackgroundTransparency = 1
    self.status.Text = "初始化中..."
    self.status.TextColor3 = Color3.fromRGB(255,255,255)
    self.status.TextStrokeTransparency = 0.3
    self.status.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    self.status.Font = Enum.Font.Gotham
    self.status.TextSize = 18
    self.status.TextXAlignment = Enum.TextXAlignment.Center
    self.status.Parent = v30
    self.filesLabel = Instance.new("TextLabel")
    self.filesLabel.Name = "filesLabel"
    self.filesLabel.Size = UDim2.new(1,-20,0,18)
    self.filesLabel.Position = UDim2.new(0,10,0,100)
    self.filesLabel.BackgroundTransparency = 1
    self.filesLabel.Text = "删除文件中:"
    self.filesLabel.TextColor3 = Color3.fromRGB(180,180,180)
    self.filesLabel.TextStrokeTransparency = 0.6
    self.filesLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    self.filesLabel.Font = Enum.Font.Gotham
    self.filesLabel.TextSize = 13
    self.filesLabel.TextXAlignment = Enum.TextXAlignment.Center
    self.filesLabel.Parent = v30
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
    self.currentFile.Parent = v30
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
    self.downloadInfo.Parent = v30
    local v31 = Instance.new("Frame")
    v31.Name = "progressBg"
    v31.Size = UDim2.new(1,-40,0,20)
    v31.Position = UDim2.new(0,20,0,145)
    v31.BackgroundColor3 = Color3.fromRGB(60,60,60)
    v31.BorderSizePixel = 0
    v31.Parent = v30
    local v32 = Instance.new("UICorner")
    v32.CornerRadius = UDim.new(0,10)
    v32.Parent = v31
    self.progressBg = v31
    self.progressFill = Instance.new("Frame")
    self.progressFill.Name = "progressFill"
    self.progressFill.Size = UDim2.new(0,0,1,0)
    self.progressFill.BackgroundColor3 = Color3.fromRGB(255,200,100)
    self.progressFill.BorderSizePixel = 0
    self.progressFill.Parent = v31
    local v33 = Instance.new("UICorner")
    v33.CornerRadius = UDim.new(0,10)
    v33.Parent = self.progressFill
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
    self.percent.Parent = v30
end

function v27:_createColorBackground()
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

function v27:_createRainbowEffect()
    local v34 = Instance.new("Frame")
    v34.Name = "RainbowEffect"
    v34.Size = UDim2.new(1,0,1,0)
    v34.BackgroundTransparency = 1
    v34.ZIndex = 2
    v34.Parent = self.gui
    local v35 = 55
    local v36 = 200
    local v37 = 0.8
    local v38 = {
        Color3.fromRGB(255,0,0), Color3.fromRGB(255,165,0), Color3.fromRGB(255,255,0),
        Color3.fromRGB(0,255,0), Color3.fromRGB(0,255,255), Color3.fromRGB(0,0,255),
        Color3.fromRGB(128,0,128)
    }
    local v39 = {}
    local function v40(v41, v42)
        local v43 = (v41 == 1 or v41 == 3)
        local v44 = (v41 == 1)
        local v45 = (v41 == 3)
        local v46 = (v41 == 2)
        local v47 = (v41 == 4)
        local v48 = Instance.new("Frame")
        v48.Name = string.format("Bar_%d_%d", v41, v42)
        v48.BorderSizePixel = 0
        v48.ZIndex = 2
        v48.BackgroundTransparency = 1
        v48.Parent = v34
        if v43 then
            v48.Size = UDim2.new(1/v36, 0, 0, v35)
            if v44 then
                v48.AnchorPoint = Vector2.new(0.5, 1)
                v48.Position = UDim2.new((v42 - 0.5)/v36, 0, 1, 0)
            else
                v48.AnchorPoint = Vector2.new(0.5, 0)
                v48.Position = UDim2.new((v42 - 0.5)/v36, 0, 0, 0)
            end
        else
            v48.Size = UDim2.new(0, v35, 1/v36, 0)
            if v46 then
                v48.AnchorPoint = Vector2.new(1, 0.5)
                v48.Position = UDim2.new(1, 0, (v42 - 0.5)/v36, 0)
            else
                v48.AnchorPoint = Vector2.new(0, 0.5)
                v48.Position = UDim2.new(0, 0, (v42 - 0.5)/v36, 0)
            end
        end
        local v49 = Instance.new("UIGradient")
        if v41 == 1 then
            v49.Rotation = 270
        elseif v41 == 2 then
            v49.Rotation = 180
        elseif v41 == 3 then
            v49.Rotation = 90
        else
            v49.Rotation = 0
        end
        v49.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})
        v49.Parent = v48
        local v50
        if v41 == 1 then
            v50 = (v42 - 0.5) / (v36 * 4)
        elseif v41 == 2 then
            v50 = (v36 + v42 - 0.5) / (v36 * 4)
        elseif v41 == 3 then
            v50 = (2 * v36 + v42 - 0.5) / (v36 * 4)
        else
            v50 = (3 * v36 + v42 - 0.5) / (v36 * 4)
        end
        table.insert(v39, {bar = v48, t_global = v50, isHorizontal = v43})
        local v51 = v43 and UDim2.new(1/v36, 0, 0, v35) or UDim2.new(0, v35, 1/v36, 0)
        local v52 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        v22:Create(v48, v52, {Size = v51, BackgroundTransparency = 0}):Play()
    end
    for v53 = 1, 4 do
        for v54 = 1, v36 do
            v40(v53, v54)
        end
    end
    self.rainbowBars = v39
    local v55 = tick()
    self.heartbeatConn = v21.Heartbeat:Connect(function()
        local v56 = (tick() - v55) * v37
        local v57 = v56 % 1
        for _, v58 in ipairs(v39) do
            local v59 = v58.t_global - v57
            if v59 < 0 then v59 = v59 + 1 end
            local v60 = math.floor(v59 * #v38) + 1
            local v61 = (v59 * #v38) % 1
            local v62 = v38[v60]
            local v63 = v38[v60 % #v38 + 1]
            v58.bar.BackgroundColor3 = v23(v62, v63, v61)
        end
    end)
end

function v27:_darkenScreen()
    for v64 = 1, 30 do
        local v65 = v64 / 30
        v20.Brightness = self.originalBrightness - (self.originalBrightness - 0.4) * v65
        v20.Ambient = Color3.new(
            self.originalAmbient.R - (self.originalAmbient.R - 0.4) * v65,
            self.originalAmbient.G - (self.originalAmbient.G - 0.4) * v65,
            self.originalAmbient.B - (self.originalAmbient.B - 0.4) * v65
        )
        v20.OutdoorAmbient = Color3.new(
            self.originalOutdoorAmbient.R - (self.originalOutdoorAmbient.R - 0.4) * v65,
            self.originalOutdoorAmbient.G - (self.originalOutdoorAmbient.G - 0.4) * v65,
            self.originalOutdoorAmbient.B - (self.originalOutdoorAmbient.B - 0.4) * v65
        )
        task.wait(0.01)
    end
    v20.Brightness = 0.4
    v20.Ambient = Color3.new(0.4, 0.4, 0.4)
    v20.OutdoorAmbient = Color3.new(0.4, 0.4, 0.4)
end

function v27:updateProgress(v66, v67, v68, v69)
    if not self.gui or not self.gui.Parent then return false end
    if v67 then self.status.Text = v67 end
    local v70 = v69 == true
    if self.filesLabel then self.filesLabel.Visible = v70 end
    if self.currentFile then self.currentFile.Visible = v70 end
    if self.downloadInfo then self.downloadInfo.Visible = not v70 end
    if v68 then
        if v70 then
            if self.currentFile then self.currentFile.Text = v68 end
        else
            if self.downloadInfo then self.downloadInfo.Text = v68 end
        end
    end
    if self.progressFill and type(v66) == "number" then
        self.progressFill:TweenSize(UDim2.new(v66/100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.3, true)
    end
    if self.percent then
        self.percent.Text = math.floor(v66) .. "%"
    end
    if v66 >= 30 and not self.triggered30 then
        self.triggered30 = true
        if self.colorBackground then
            self.colorBackground.BackgroundTransparency = 0.9
        end
        self:_startColorCycle()
    end
    if v66 >= 90 and not self.triggered90 then
        self.triggered90 = true
        self:stopColorCycle()
        if self.colorBackground then
            local v71 = v22
            v71:Create(self.colorBackground, TweenInfo.new(1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(0,255,0),
                BackgroundTransparency = 1,
                Size = UDim2.new(2,0,2,0)
            }):Play()
        end
    end
    if v66 >= 91 and not self.triggered91 then
        self.triggered91 = true
        if self.colorCycleTween then self.colorCycleTween:Cancel() end
        if self.colorBackground then
            self.colorBackground.BackgroundColor3 = Color3.fromRGB(255,0,0)
            self.colorBackground.BackgroundTransparency = 0
            self.colorBackground.Size = UDim2.new(1,0,1,0)
            local v72 = v22
            v72:Create(self.colorBackground, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1,
                Size = UDim2.new(2,0,2,0)
            }):Play()
        end
        if self.rainbowBars then
            local v73 = v22
            for _, v74 in ipairs(self.rainbowBars) do
                local v75 = v74.bar
                if v75 then
                    local v76 = v74.isHorizontal and UDim2.new(v75.Size.X.Scale, v75.Size.X.Offset, 0, 0) or UDim2.new(0, 0, v75.Size.Y.Scale, v75.Size.Y.Offset)
                    v73:Create(v75, TweenInfo.new(0.8), {Size = v76, BackgroundTransparency = 1}):Play()
                end
            end
        end
        if self.heartbeatConn then
            pcall(function() self.heartbeatConn:Disconnect() end)
        end
    end
    return true
end

function v27:_startColorCycle()
    local v77 = {
        Color3.fromRGB(255,0,0), Color3.fromRGB(255,165,0), Color3.fromRGB(255,255,0),
        Color3.fromRGB(0,255,0), Color3.fromRGB(0,255,255), Color3.fromRGB(0,0,255),
        Color3.fromRGB(128,0,128)
    }
    local v78 = 1
    local v79 = v22
    local function v80()
        if not self.colorCycleActive then return end
        local v81 = v77[v78]
        v78 = v78 % #v77 + 1
        if self.colorBackground then
            self.colorCycleTween = v79:Create(self.colorBackground, TweenInfo.new(0.5), {BackgroundColor3 = v81})
            self.colorCycleTween.Completed:Connect(v80)
            self.colorCycleTween:Play()
        end
    end
    self.colorCycleActive = true
    v80()
end

function v27:stopColorCycle()
    self.colorCycleActive = false
    if self.colorCycleTween then
        self.colorCycleTween:Cancel()
    end
end

function v27:forceCleanupRainbow()
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

function v27:fadeOutDeleteUI()
    pcall(function()
        if not self.filesLabel or not self.currentFile then return end
        local v82 = v22
        local v83 = TweenInfo.new(0.3)
        v82:Create(self.filesLabel, v83, {TextTransparency = 1}):Play()
        v82:Create(self.currentFile, v83, {TextTransparency = 1}):Play()
        task.wait(0.3)
        self.filesLabel.Visible = false
        self.currentFile.Visible = false
        self.filesLabel.TextTransparency = 0
        self.currentFile.TextTransparency = 0
    end)
end

function v27:setTitleWithAnimation(v84)
    pcall(function()
        if not self.title then return end
        local v85 = v22
        local v86 = TweenInfo.new(0.4)
        v85:Create(self.title, v86, {TextTransparency = 1}):Play()
        task.wait(0.4)
        self.title.Text = v84
        v85:Create(self.title, v86, {TextTransparency = 0}):Play()
        task.wait(0.4)
    end)
end

function v27:fadeOutAndDestroy()
    if not self.gui then return end
    self:forceCleanupRainbow()
    local v87 = {
        self.title, self.status, self.filesLabel, self.currentFile,
        self.downloadInfo, self.percent, self.progressFill, self.progressBg,
        self.bg, self.colorBackground
    }
    for v88 = 1, 30 do
        local v89 = v88 / 30
        for _, v90 in ipairs(v87) do
            if v90 then
                if v90 == self.bg or v90 == self.progressBg then
                    if v90:IsA("Frame") then
                        v90.BackgroundTransparency = 0.3 + v89 * 0.7
                    end
                elseif v90:IsA("TextLabel") then
                    v90.TextTransparency = v89
                elseif v90 == self.progressFill or v90 == self.colorBackground then
                    if v90:IsA("Frame") then
                        v90.BackgroundTransparency = v89
                    end
                end
            end
        end
        task.wait(0.01)
    end
    for v91 = 1, 30 do
        local v92 = v91 / 30
        v20.Brightness = 0.4 + (self.originalBrightness - 0.4) * v92
        v20.Ambient = Color3.new(
            0.4 + (self.originalAmbient.R - 0.4) * v92,
            0.4 + (self.originalAmbient.G - 0.4) * v92,
            0.4 + (self.originalAmbient.B - 0.4) * v92
        )
        v20.OutdoorAmbient = Color3.new(
            0.4 + (self.originalOutdoorAmbient.R - 0.4) * v92,
            0.4 + (self.originalOutdoorAmbient.G - 0.4) * v92,
            0.4 + (self.originalOutdoorAmbient.B - 0.4) * v92
        )
        task.wait(0.01)
    end
    v20.Brightness = self.originalBrightness
    v20.Ambient = self.originalAmbient
    v20.OutdoorAmbient = self.originalOutdoorAmbient
    self.gui:Destroy()
end

v27.destroy = v27.fadeOutAndDestroy

return v27
