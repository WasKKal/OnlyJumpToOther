local v1 = game:GetService("CoreGui")
local v2 = game:GetService("MarketplaceService")
local v3 = game:GetService("TweenService")
local v4 = game:GetService("UserInputService")
local v5 = game:GetService("StarterGui")
local v6 = game:GetService("Lighting")
local v7 = game:GetService("RunService")
local v8 = game:GetService("HttpService")

local v9 = {}
local v10 = {}
local v11 = false

local function v12(v13, v14, v15)
    return Color3.new(v13.R + (v14.R - v13.R) * v15, v13.G + (v14.G - v13.G) * v15, v13.B + (v14.B - v13.B) * v15)
end

local function v16(v17)
    if v10[v17] then return v10[v17] end
    if v11 then return "rbxassetid://0" end
    v11 = true
    local v18, v19 = pcall(function() return v2:GetProductInfo(v17) end)
    v11 = false
    if v18 and v19 and v19.IconImageAssetId then
        v10[v17] = "rbxassetid://" .. tostring(v19.IconImageAssetId)
        return v10[v17]
    end
    v10[v17] = ""
    return ""
end

function v9.createSimpleTopUI(v20, v21, v22)
    pcall(function()
        if v1:FindFirstChild("Trash_SimpleTopUI") then
            v1.Trash_SimpleTopUI:Destroy()
        end
    end)
    local v23 = Instance.new("ScreenGui")
    v23.Name = "Trash_SimpleTopUI"
    v23.Parent = v1
    v23.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v23.DisplayOrder = 99999
    v23.IgnoreGuiInset = true
    v23.ResetOnSpawn = false

    local v24 = Instance.new("Frame")
    v24.Size = UDim2.new(0, 200, 0, 40)
    v24.Position = UDim2.new(1, -210, 0, 5)
    v24.BackgroundTransparency = 0.1
    v24.BackgroundColor3 = Color3.new(0, 0, 0)
    v24.Parent = v23
    local v25 = Instance.new("UICorner")
    v25.CornerRadius = UDim.new(0, 6)
    v25.Parent = v24

    local v26 = Instance.new("TextLabel")
    v26.Size = UDim2.new(1, -10, 0, 22)
    v26.Position = UDim2.new(0, 5, 0, 0)
    v26.BackgroundTransparency = 1
    v26.Text = "脚本已加载"
    v26.TextColor3 = Color3.new(1, 1, 1)
    v26.TextSize = 14
    v26.Font = Enum.Font.GothamBold
    v26.TextXAlignment = Enum.TextXAlignment.Left
    v26.Parent = v24

    local v27 = Instance.new("TextLabel")
    v27.Size = UDim2.new(1, -10, 0, 16)
    v27.Position = UDim2.new(0, 5, 0, 20)
    v27.BackgroundTransparency = 1
    v27.Text = "重新加载? (8)"
    v27.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    v27.TextSize = 11
    v27.Font = Enum.Font.Gotham
    v27.TextXAlignment = Enum.TextXAlignment.Left
    v27.Parent = v24

    local v28 = Instance.new("TextButton")
    v28.Size = UDim2.new(0, 70, 0, 22)
    v28.Position = UDim2.new(1, -75, 0, 9)
    v28.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v28.Text = "重新加载"
    v28.TextColor3 = Color3.new(1, 1, 1)
    v28.TextSize = 12
    v28.Parent = v24
    local v29 = Instance.new("UICorner")
    v29.CornerRadius = UDim.new(0, 4)
    v29.Parent = v28

    v28.MouseButton1Click:Connect(function()
        pcall(function() if v23 then v23:Destroy() end end)
        local v30 = v21[v20]
        if v30 then
            local v31, v32 = pcall(v22, v30[2])
            if not v31 then
                v5:SetCore("SendNotification", {Title = "错误", Text = "加载失败: " .. tostring(v32), Duration = 3})
            end
        else
            v5:SetCore("SendNotification", {Title = "Trash", Text = "游戏未适配", Duration = 2})
        end
    end)

    task.spawn(function()
        local v33 = 8
        while v33 > 0 and v23 and v23.Parent do
            v27.Text = "重新加载? (" .. v33 .. ")"
            task.wait(1)
            v33 = v33 - 1
        end
        pcall(function() if v23 then v23:Destroy() end end)
    end)
end

function v9.createManualSearchUI(v34, v35, v36, v37, v38)
    if v1:FindFirstChild("TrashManualSearchUI") then
        v1.TrashManualSearchUI:Destroy()
    end
    local v39 = Instance.new("ScreenGui")
    v39.Name = "TrashManualSearchUI"
    v39.Parent = v1
    v39.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v39.DisplayOrder = 99999
    v39.IgnoreGuiInset = true
    v39.ResetOnSpawn = false

    local v40 = Instance.new("Frame")
    v40.Size = UDim2.new(0, 420, 0, 340)
    v40.Position = UDim2.new(0.5, -210, 0.5, -170)
    v40.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    v40.BackgroundTransparency = 0.1
    v40.BorderSizePixel = 0
    v40.Parent = v39
    local v41 = Instance.new("UICorner")
    v41.CornerRadius = UDim.new(0, 12)
    v41.Parent = v40

    local v42 = Instance.new("Frame")
    v42.Size = UDim2.new(1, 0, 0, 36)
    v42.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    v42.BackgroundTransparency = 0.2
    v42.BorderSizePixel = 0
    v42.Parent = v40
    local v43 = Instance.new("UICorner")
    v43.CornerRadius = UDim.new(0, 12)
    v43.Parent = v42

    local v44 = Instance.new("TextLabel")
    v44.Size = UDim2.new(1, -40, 1, 0)
    v44.Position = UDim2.new(0, 10, 0, 0)
    v44.BackgroundTransparency = 1
    v44.Text = "手动脚本搜索"
    v44.TextColor3 = Color3.fromRGB(255, 255, 255)
    v44.TextSize = 16
    v44.Font = Enum.Font.GothamBold
    v44.TextXAlignment = Enum.TextXAlignment.Left
    v44.Parent = v42

    local v45 = Instance.new("TextButton")
    v45.Size = UDim2.new(0, 28, 0, 28)
    v45.Position = UDim2.new(1, -34, 0, 4)
    v45.BackgroundTransparency = 1
    v45.Text = "X"
    v45.TextColor3 = Color3.fromRGB(255, 255, 255)
    v45.TextSize = 18
    v45.Font = Enum.Font.GothamBold
    v45.Parent = v42
    v45.MouseButton1Click:Connect(function()
        local v46 = v3
        local v47 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        v46:Create(v40, v47, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        task.wait(0.3)
        v39:Destroy()
    end)

    local v48 = false
    local v49 = nil
    local v50 = nil
    v42.InputBegan:Connect(function(v51)
        if v51.UserInputType == Enum.UserInputType.MouseButton1 then
            v48 = true
            v49 = v51.Position
            v50 = v40.Position
        end
    end)
    v42.InputEnded:Connect(function(v52)
        if v52.UserInputType == Enum.UserInputType.MouseButton1 then
            v48 = false
        end
    end)
    v4.InputChanged:Connect(function(v53)
        if v48 and v53.UserInputType == Enum.UserInputType.MouseMovement then
            local v54 = v53.Position - v49
            v40.Position = UDim2.new(v50.X.Scale, v50.X.Offset + v54.X, v50.Y.Scale, v50.Y.Offset + v54.Y)
        end
    end)

    local v55 = Instance.new("TextLabel")
    v55.Size = UDim2.new(1, -20, 0, 24)
    v55.Position = UDim2.new(0, 10, 0, 44)
    v55.BackgroundTransparency = 1
    v55.Text = "输入游戏名称："
    v55.TextColor3 = Color3.fromRGB(200, 200, 200)
    v55.TextSize = 12
    v55.Font = Enum.Font.Gotham
    v55.TextXAlignment = Enum.TextXAlignment.Left
    v55.Parent = v40

    local v56 = Instance.new("TextBox")
    v56.Size = UDim2.new(1, -70, 0, 30)
    v56.Position = UDim2.new(0, 10, 0, 72)
    v56.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v56.Text = ""
    v56.PlaceholderText = "例如: BloxFruits / SniperArena"
    v56.TextColor3 = Color3.fromRGB(255, 255, 255)
    v56.TextSize = 12
    v56.Font = Enum.Font.Gotham
    v56.ClearTextOnFocus = false
    v56.Parent = v40
    local v57 = Instance.new("UICorner")
    v57.CornerRadius = UDim.new(0, 6)
    v57.Parent = v56

    local v58 = Instance.new("TextButton")
    v58.Size = UDim2.new(0, 50, 0, 30)
    v58.Position = UDim2.new(1, -60, 0, 72)
    v58.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v58.Text = "刷新"
    v58.TextColor3 = Color3.fromRGB(255, 255, 255)
    v58.TextSize = 12
    v58.Font = Enum.Font.GothamBold
    v58.Parent = v40
    local v59 = Instance.new("UICorner")
    v59.CornerRadius = UDim.new(0, 6)
    v59.Parent = v58

    local v60 = Instance.new("Frame")
    v60.Size = UDim2.new(1, -20, 0, 170)
    v60.Position = UDim2.new(0, 10, 0, 115)
    v60.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v60.BackgroundTransparency = 0.5
    v60.BorderSizePixel = 0
    v60.Parent = v40
    local v61 = Instance.new("UICorner")
    v61.CornerRadius = UDim.new(0, 8)
    v61.Parent = v60

    local v62 = Instance.new("ScrollingFrame")
    v62.Size = UDim2.new(1, -10, 1, -10)
    v62.Position = UDim2.new(0, 5, 0, 5)
    v62.BackgroundTransparency = 1
    v62.BorderSizePixel = 0
    v62.ScrollBarThickness = 6
    v62.CanvasSize = UDim2.new(0, 0, 0, 0)
    v62.AutomaticCanvasSize = Enum.AutomaticSize.Y
    v62.Parent = v60

    local v63 = Instance.new("UIListLayout")
    v63.Parent = v62
    v63.SortOrder = Enum.SortOrder.LayoutOrder
    v63.Padding = UDim.new(0, 4)

    local v64 = Instance.new("TextLabel")
    v64.Size = UDim2.new(1, -20, 0, 20)
    v64.Position = UDim2.new(0, 10, 0, 295)
    v64.BackgroundTransparency = 1
    v64.Text = ""
    v64.TextColor3 = Color3.fromRGB(255, 100, 100)
    v64.TextSize = 11
    v64.Font = Enum.Font.Gotham
    v64.TextXAlignment = Enum.TextXAlignment.Center
    v64.Parent = v40

    local function v65()
        local v66 = v62:GetChildren()
        for v67 = #v66, 1, -1 do
            local v68 = v66[v67]
            if v68:IsA("Frame") and v68.Name == "ResultItem" then
                v68:Destroy()
            end
        end
        v62.CanvasPosition = Vector2.new(0, 0)
    end

    local function v69(v70, v71, v72)
        v64.Text = "正在加载 " .. v71 .. " ..."
        v64.TextColor3 = Color3.fromRGB(255, 200, 100)
        local v73, v74 = pcall(v36, v70)
        if v73 then
            v64.Text = "加载成功!"
            v64.TextColor3 = Color3.fromRGB(100, 255, 100)
            pcall(function()
                v5:SetCore("SendNotification", {Title = "Trash 手动加载", Text = v71 .. " 已执行", Duration = 3})
            end)
            task.wait(0.5)
            if v72 then v72:Destroy() end
            v9.createSimpleTopUI(v34, v35, v36)
        else
            v64.Text = "失败: " .. tostring(v74):sub(1, 60)
            v64.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end

    local v75 = nil
    local function v76()
        v65()
        local v77 = v56.Text:lower()
        local v78 = {}
        for v79, v80 in pairs(v35) do
            local v81 = v80[1]:lower()
            if v77 == "" or v81:find(v77, 1, true) then
                table.insert(v78, {placeId = v79, name = v80[1], fileName = v80[2]})
            end
        end
        if #v78 == 0 then
            v64.Text = "未找到匹配的游戏"
            v64.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        v64.Text = "找到 " .. #v78 .. " 个结果，点击加载"
        v64.TextColor3 = Color3.fromRGB(200, 200, 200)
        for _, v82 in ipairs(v78) do
            local v83 = Instance.new("TextButton")
            v83.Name = "ResultItem"
            v83.Size = UDim2.new(1, -10, 0, 36)
            v83.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            v83.Text = ""
            v83.AutoButtonColor = false
            v83.Parent = v62
            local v84 = Instance.new("UICorner")
            v84.CornerRadius = UDim.new(0, 6)
            v84.Parent = v83

            local v85 = Instance.new("ImageLabel")
            v85.Size = UDim2.new(0, 28, 0, 28)
            v85.Position = UDim2.new(0, 4, 0.5, -14)
            v85.BackgroundTransparency = 1
            v85.Image = "rbxassetid://0"
            v85.Parent = v83
            local v86 = Instance.new("UICorner")
            v86.CornerRadius = UDim.new(0, 6)
            v86.Parent = v85

            local v87 = Instance.new("TextLabel")
            v87.Size = UDim2.new(1, -40, 1, 0)
            v87.Position = UDim2.new(0, 40, 0, 0)
            v87.BackgroundTransparency = 1
            v87.Text = v82.name
            v87.TextColor3 = Color3.fromRGB(255, 255, 255)
            v87.TextSize = 12
            v87.Font = Enum.Font.Gotham
            v87.TextXAlignment = Enum.TextXAlignment.Left
            v87.Parent = v83

            v83.MouseButton1Click:Connect(function()
                v69(v82.fileName, v82.name, v39)
            end)
            v83.MouseEnter:Connect(function()
                v83.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            end)
            v83.MouseLeave:Connect(function()
                v83.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            end)

            task.spawn(function()
                local v88 = v16(v82.placeId)
                if v88 ~= "" then
                    v85.Image = v88
                end
            end)
        end
    end

    v56:GetPropertyChangedSignal("Text"):Connect(v76)
    v56.FocusLost:Connect(v76)
    v58.MouseButton1Click:Connect(v76)
    v76()

    local v89 = v3
    local v90 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    v40.Size = UDim2.new(0, 0, 0, 0)
    v40.Position = UDim2.new(0.5, 0, 0.5, 0)
    task.wait()
    v89:Create(v40, v90, {Size = UDim2.new(0, 420, 0, 340), Position = UDim2.new(0.5, -210, 0.5, -170)}):Play()
end

function v9._addSettingsButton()
    if v1:FindFirstChild("Trash_SettingsButton") then
        v1.Trash_SettingsButton:Destroy()
    end
    local v95 = Instance.new("TextButton")
    v95.Name = "Trash_SettingsButton"
    v95.Size = UDim2.new(0, 60, 0, 30)
    v95.Position = UDim2.new(1, -70, 1, -40)
    v95.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v95.Text = "设置"
    v95.TextColor3 = Color3.fromRGB(255, 255, 255)
    v95.TextSize = 14
    v95.Font = Enum.Font.GothamBold
    v95.Parent = v1
    local v96 = Instance.new("UICorner")
    v96.CornerRadius = UDim.new(0, 6)
    v96.Parent = v95
    return v95
end

local v148 = {}
v148.__index = v148

function v148.new()
    pcall(function()
        local v149 = v1:FindFirstChild("TrashLoadingScreen")
        if v149 then v149:Destroy() end
    end)
    local self = setmetatable({}, v148)
    self.originalBrightness = v6.Brightness
    self.originalAmbient = v6.Ambient
    self.originalOutdoorAmbient = v6.OutdoorAmbient
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
    self.progress60Time = nil
    self.timeoutCheckConn = nil
    self:_createUI()
    self:_darkenScreen()
    self:_createRainbowEffect()
    self:_createColorBackground()
    self:_checkTimeout()
    return self
end

function v148:_checkTimeout()
    task.spawn(function()
        while self.gui and self.gui.Parent do
            task.wait(0.1)
            -- 检测：若进度到达60%后停留超过5秒
            if self.progress60Time and not self.isTimeout then
                if tick() - self.progress60Time >= 5 then
                    self.isTimeout = true
                    if self.title then
                        self.title.TextColor3 = Color3.fromRGB(255, 0, 0)
                        task.wait(0.5)
                        self.title.Text = "已超时,点此跳过动画"
                    end
                    break
                end
            end
        end
    end)
end

function v148:_createUI()
    self.bg = Instance.new("Frame")
    self.bg.Name = "bg"
    self.bg.Size = UDim2.new(1, 0, 1, 0)
    self.bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.bg.BackgroundTransparency = 0.3
    self.bg.BorderSizePixel = 0
    self.bg.Parent = self.gui

    local v152 = Instance.new("Frame")
    v152.Name = "centerContainer"
    v152.Size = UDim2.new(0, 500, 0, 260)
    v152.Position = UDim2.new(0.5, -250, 0.5, -130)
    v152.BackgroundTransparency = 1
    v152.Parent = self.gui

    self.title = Instance.new("TextButton")
    self.title.Name = "titleLabel"
    self.title.Size = UDim2.new(1, 0, 0, 60)
    self.title.Position = UDim2.new(0, 0, 0, 0)
    self.title.BackgroundTransparency = 1
    self.title.Text = "TrashHub"
    self.title.TextColor3 = Color3.fromRGB(255, 200, 100)
    self.title.TextStrokeTransparency = 0
    self.title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    self.title.Font = Enum.Font.GothamBold
    self.title.TextSize = 48
    self.title.TextXAlignment = Enum.TextXAlignment.Center
    self.title.TextYAlignment = Enum.TextYAlignment.Center
    self.title.Parent = v152
    self.title.AutoButtonColor = false
    self.title.MouseButton1Click:Connect(function()
        if self.isTimeout then
            self:fadeOutAndDestroy()
        end
    end)

    self.status = Instance.new("TextLabel")
    self.status.Name = "statusLabel"
    self.status.Size = UDim2.new(1, 0, 0, 30)
    self.status.Position = UDim2.new(0, 0, 0, 65)
    self.status.BackgroundTransparency = 1
    self.status.Text = "初始化中..."
    self.status.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.status.TextStrokeTransparency = 0.3
    self.status.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    self.status.Font = Enum.Font.Gotham
    self.status.TextSize = 18
    self.status.TextXAlignment = Enum.TextXAlignment.Center
    self.status.Parent = v152

    self.filesLabel = Instance.new("TextLabel")
    self.filesLabel.Name = "filesLabel"
    self.filesLabel.Size = UDim2.new(1, -20, 0, 18)
    self.filesLabel.Position = UDim2.new(0, 10, 0, 100)
    self.filesLabel.BackgroundTransparency = 1
    self.filesLabel.Text = "删除文件中:"
    self.filesLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    self.filesLabel.TextStrokeTransparency = 0.6
    self.filesLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    self.filesLabel.Font = Enum.Font.Gotham
    self.filesLabel.TextSize = 13
    self.filesLabel.TextXAlignment = Enum.TextXAlignment.Center
    self.filesLabel.Parent = v152

    self.currentFile = Instance.new("TextLabel")
    self.currentFile.Name = "currentFileLabel"
    self.currentFile.Size = UDim2.new(1, -20, 0, 18)
    self.currentFile.Position = UDim2.new(0, 10, 0, 118)
    self.currentFile.BackgroundTransparency = 1
    self.currentFile.Text = ""
    self.currentFile.TextColor3 = Color3.fromRGB(255, 200, 100)
    self.currentFile.TextStrokeTransparency = 0.5
    self.currentFile.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    self.currentFile.Font = Enum.Font.Gotham
    self.currentFile.TextSize = 13
    self.currentFile.TextXAlignment = Enum.TextXAlignment.Center
    self.currentFile.Parent = v152

    self.downloadInfo = Instance.new("TextLabel")
    self.downloadInfo.Name = "downloadInfoLabel"
    self.downloadInfo.Size = UDim2.new(1, -20, 0, 18)
    self.downloadInfo.Position = UDim2.new(0, 10, 0, 100)
    self.downloadInfo.BackgroundTransparency = 1
    self.downloadInfo.Text = ""
    self.downloadInfo.TextColor3 = Color3.fromRGB(255, 200, 100)
    self.downloadInfo.TextStrokeTransparency = 0.5
    self.downloadInfo.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    self.downloadInfo.Font = Enum.Font.Gotham
    self.downloadInfo.TextSize = 13
    self.downloadInfo.TextXAlignment = Enum.TextXAlignment.Center
    self.downloadInfo.Visible = false
    self.downloadInfo.Parent = v152

    local v153 = Instance.new("Frame")
    v153.Name = "progressBg"
    v153.Size = UDim2.new(1, -40, 0, 20)
    v153.Position = UDim2.new(0, 20, 0, 145)
    v153.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    v153.BorderSizePixel = 0
    v153.Parent = v152
    local v154 = Instance.new("UICorner")
    v154.CornerRadius = UDim.new(0, 10)
    v154.Parent = v153
    self.progressBg = v153

    self.progressFill = Instance.new("Frame")
    self.progressFill.Name = "progressFill"
    self.progressFill.Size = UDim2.new(0, 0, 1, 0)
    self.progressFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    self.progressFill.BorderSizePixel = 0
    self.progressFill.Parent = v153
    local v155 = Instance.new("UICorner")
    v155.CornerRadius = UDim.new(0, 10)
    v155.Parent = self.progressFill

    self.percent = Instance.new("TextLabel")
    self.percent.Name = "percentLabel"
    self.percent.Size = UDim2.new(0, 60, 0, 20)
    self.percent.Position = UDim2.new(0.5, -30, 0, 170)
    self.percent.BackgroundTransparency = 1
    self.percent.Text = "0%"
    self.percent.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.percent.TextStrokeTransparency = 0.3
    self.percent.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    self.percent.Font = Enum.Font.GothamBold
    self.percent.TextSize = 16
    self.percent.TextXAlignment = Enum.TextXAlignment.Center
    self.percent.Parent = v152
end

function v148:_createColorBackground()
    self.colorBackground = Instance.new("Frame")
    self.colorBackground.Name = "ColorBackground"
    self.colorBackground.Size = UDim2.new(1, 0, 1, 0)
    self.colorBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.colorBackground.AnchorPoint = Vector2.new(0.5, 0.5)
    self.colorBackground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    self.colorBackground.BackgroundTransparency = 1
    self.colorBackground.BorderSizePixel = 0
    self.colorBackground.ZIndex = 1
    self.colorBackground.Parent = self.gui
end

function v148:_createRainbowEffect()
    local v156 = Instance.new("Frame")
    v156.Name = "RainbowEffect"
    v156.Size = UDim2.new(1, 0, 1, 0)
    v156.BackgroundTransparency = 1
    v156.ZIndex = 2
    v156.Parent = self.gui

    local v157 = 55
    local v158 = 200
    local v159 = 0.8
    local v160 = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(128, 0, 128)
    }
    local v161 = {}

    local function v162(v163, v164)
        local v165 = (v163 == 1 or v163 == 3)
        local v166 = (v163 == 1)
        local v167 = (v163 == 3)
        local v168 = (v163 == 2)
        local v169 = (v163 == 4)
        local v170 = Instance.new("Frame")
        v170.Name = string.format("Bar_%d_%d", v163, v164)
        v170.BorderSizePixel = 0
        v170.ZIndex = 2
        v170.BackgroundTransparency = 1
        v170.Parent = v156

        if v165 then
            v170.Size = UDim2.new(1 / v158, 0, 0, v157)
            if v166 then
                v170.AnchorPoint = Vector2.new(0.5, 1)
                v170.Position = UDim2.new((v164 - 0.5) / v158, 0, 1, 0)
            else
                v170.AnchorPoint = Vector2.new(0.5, 0)
                v170.Position = UDim2.new((v164 - 0.5) / v158, 0, 0, 0)
            end
        else
            v170.Size = UDim2.new(0, v157, 1 / v158, 0)
            if v168 then
                v170.AnchorPoint = Vector2.new(1, 0.5)
                v170.Position = UDim2.new(1, 0, (v164 - 0.5) / v158, 0)
            else
                v170.AnchorPoint = Vector2.new(0, 0.5)
                v170.Position = UDim2.new(0, 0, (v164 - 0.5) / v158, 0)
            end
        end

        local v171 = Instance.new("UIGradient")
        if v163 == 1 then
            v171.Rotation = 270
        elseif v163 == 2 then
            v171.Rotation = 180
        elseif v163 == 3 then
            v171.Rotation = 90
        else
            v171.Rotation = 0
        end
        v171.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
        v171.Parent = v170

        local v172
        if v163 == 1 then
            v172 = (v164 - 0.5) / (v158 * 4)
        elseif v163 == 2 then
            v172 = (v158 + v164 - 0.5) / (v158 * 4)
        elseif v163 == 3 then
            v172 = (2 * v158 + v164 - 0.5) / (v158 * 4)
        else
            v172 = (3 * v158 + v164 - 0.5) / (v158 * 4)
        end
        table.insert(v161, {bar = v170, t_global = v172, isHorizontal = v165})

        local v173 = v165 and UDim2.new(1 / v158, 0, 0, v157) or UDim2.new(0, v157, 1 / v158, 0)
        local v174 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        v3:Create(v170, v174, {Size = v173, BackgroundTransparency = 0}):Play()
    end

    for v163 = 1, 4 do
        for v164 = 1, v158 do
            v162(v163, v164)
        end
    end

    self.rainbowBars = v161
    local v175 = tick()
    self.heartbeatConn = v7.Heartbeat:Connect(function()
        local v176 = (tick() - v175) * v159
        local v177 = v176 % 1
        for _, v178 in ipairs(v161) do
            local v179 = v178.t_global - v177
            if v179 < 0 then v179 = v179 + 1 end
            local v180 = math.floor(v179 * #v160) + 1
            local v181 = (v179 * #v160) % 1
            local v182 = v160[v180]
            local v183 = v160[v180 % #v160 + 1]
            v178.bar.BackgroundColor3 = v12(v182, v183, v181)
        end
    end)
end

function v148:_darkenScreen()
    for v184 = 1, 30 do
        local v185 = v184 / 30
        v6.Brightness = self.originalBrightness - (self.originalBrightness - 0.4) * v185
        v6.Ambient = Color3.new(
            self.originalAmbient.R - (self.originalAmbient.R - 0.4) * v185,
            self.originalAmbient.G - (self.originalAmbient.G - 0.4) * v185,
            self.originalAmbient.B - (self.originalAmbient.B - 0.4) * v185
        )
        v6.OutdoorAmbient = Color3.new(
            self.originalOutdoorAmbient.R - (self.originalOutdoorAmbient.R - 0.4) * v185,
            self.originalOutdoorAmbient.G - (self.originalOutdoorAmbient.G - 0.4) * v185,
            self.originalOutdoorAmbient.B - (self.originalOutdoorAmbient.B - 0.4) * v185
        )
        task.wait(0.01)
    end
    v6.Brightness = 0.4
    v6.Ambient = Color3.new(0.4, 0.4, 0.4)
    v6.OutdoorAmbient = Color3.new(0.4, 0.4, 0.4)
end

function v148:updateProgress(v186, v187, v188, v189)
    if not self.gui or not self.gui.Parent then return false end
    -- 记录首次到达60%的时间
    if v186 >= 60 and not self.progress60Time then
        self.progress60Time = tick()
    end
    if v187 then self.status.Text = v187 end
    local v190 = v189 == true
    if self.filesLabel then self.filesLabel.Visible = v190 end
    if self.currentFile then self.currentFile.Visible = v190 end
    if self.downloadInfo then self.downloadInfo.Visible = not v190 end
    if v188 then
        if v190 then
            if self.currentFile then self.currentFile.Text = v188 end
        else
            if self.downloadInfo then self.downloadInfo.Text = v188 end
        end
    end
    if self.progressFill and type(v186) == "number" then
        self.progressFill:TweenSize(UDim2.new(v186 / 100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.3, true)
    end
    if self.percent then
        self.percent.Text = math.floor(v186) .. "%"
    end
    if v186 >= 30 and not self.triggered30 then
        self.triggered30 = true
        if self.colorBackground then
            self.colorBackground.BackgroundTransparency = 0.9
        end
        self:_startColorCycle()
    end
    if v186 >= 90 and not self.triggered90 then
        self.triggered90 = true
        self:stopColorCycle()
        if self.colorBackground then
            v3:Create(self.colorBackground, TweenInfo.new(1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(0, 255, 0),
                BackgroundTransparency = 1,
                Size = UDim2.new(2, 0, 2, 0)
            }):Play()
        end
    end
    if v186 >= 91 and not self.triggered91 then
        self.triggered91 = true
        if self.colorCycleTween then self.colorCycleTween:Cancel() end
        if self.colorBackground then
            self.colorBackground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            self.colorBackground.BackgroundTransparency = 0
            self.colorBackground.Size = UDim2.new(1, 0, 1, 0)
            v3:Create(self.colorBackground, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1,
                Size = UDim2.new(2, 0, 2, 0)
            }):Play()
        end
        if self.rainbowBars then
            for _, v178 in ipairs(self.rainbowBars) do
                local v191 = v178.bar
                if v191 then
                    local v192 = v178.isHorizontal and UDim2.new(v191.Size.X.Scale, v191.Size.X.Offset, 0, 0) or UDim2.new(0, 0, v191.Size.Y.Scale, v191.Size.Y.Offset)
                    v3:Create(v191, TweenInfo.new(0.8), {Size = v192, BackgroundTransparency = 1}):Play()
                end
            end
        end
        if self.heartbeatConn then
            pcall(function() self.heartbeatConn:Disconnect() end)
        end
    end
    return true
end

function v148:_startColorCycle()
    local v160 = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(128, 0, 128)
    }
    local v193 = 1
    local function v194()
        if not self.colorCycleActive then return end
        local v195 = v160[v193]
        v193 = v193 % #v160 + 1
        if self.colorBackground then
            self.colorCycleTween = v3:Create(self.colorBackground, TweenInfo.new(0.5), {BackgroundColor3 = v195})
            self.colorCycleTween.Completed:Connect(v194)
            self.colorCycleTween:Play()
        end
    end
    self.colorCycleActive = true
    v194()
end

function v148:stopColorCycle()
    self.colorCycleActive = false
    if self.colorCycleTween then
        self.colorCycleTween:Cancel()
    end
end

function v148:forceCleanupRainbow()
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

function v148:fadeOutDeleteUI()
    pcall(function()
        if not self.filesLabel or not self.currentFile then return end
        local v196 = TweenInfo.new(0.3)
        v3:Create(self.filesLabel, v196, {TextTransparency = 1}):Play()
        v3:Create(self.currentFile, v196, {TextTransparency = 1}):Play()
        task.wait(0.3)
        self.filesLabel.Visible = false
        self.currentFile.Visible = false
        self.filesLabel.TextTransparency = 0
        self.currentFile.TextTransparency = 0
    end)
end

function v148:setTitleWithAnimation(v197)
    pcall(function()
        if not self.title then return end
        local v198 = TweenInfo.new(0.4)
        v3:Create(self.title, v198, {TextTransparency = 1}):Play()
        task.wait(0.4)
        self.title.Text = v197
        v3:Create(self.title, v198, {TextTransparency = 0}):Play()
        task.wait(0.4)
    end)
end

function v148:fadeOutAndDestroy()
    if not self.gui then return end
    self:forceCleanupRainbow()
    if self.timeoutCheckConn then
        pcall(function() self.timeoutCheckConn:Disconnect() end)
        self.timeoutCheckConn = nil
    end
    local v199 = {
        self.title, self.status, self.filesLabel, self.currentFile,
        self.downloadInfo, self.percent, self.progressFill, self.progressBg,
        self.bg, self.colorBackground
    }
    for v184 = 1, 30 do
        local v185 = v184 / 30
        for _, v200 in ipairs(v199) do
            if v200 then
                if v200 == self.bg or v200 == self.progressBg then
                    if v200:IsA("Frame") then
                        v200.BackgroundTransparency = 0.3 + v185 * 0.7
                    end
                elseif v200:IsA("TextLabel") then
                    v200.TextTransparency = v185
                elseif v200 == self.progressFill or v200 == self.colorBackground then
                    if v200:IsA("Frame") then
                        v200.BackgroundTransparency = v185
                    end
                end
            end
        end
        task.wait(0.01)
    end
    for v184 = 1, 30 do
        local v185 = v184 / 30
        v6.Brightness = 0.4 + (self.originalBrightness - 0.4) * v185
        v6.Ambient = Color3.new(
            0.4 + (self.originalAmbient.R - 0.4) * v185,
            0.4 + (self.originalAmbient.G - 0.4) * v185,
            0.4 + (self.originalAmbient.B - 0.4) * v185
        )
        v6.OutdoorAmbient = Color3.new(
            0.4 + (self.originalOutdoorAmbient.R - 0.4) * v185,
            0.4 + (self.originalOutdoorAmbient.G - 0.4) * v185,
            0.4 + (self.originalOutdoorAmbient.B - 0.4) * v185
        )
        task.wait(0.01)
    end
    v6.Brightness = self.originalBrightness
    v6.Ambient = self.originalAmbient
    v6.OutdoorAmbient = self.originalOutdoorAmbient
    self.gui:Destroy()
end

v148.destroy = v148.fadeOutAndDestroy

v9.LoadingAnimation = v148

return v9
