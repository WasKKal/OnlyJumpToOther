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
local v12 = nil

local function v13(v14, v15, v16)
    return Color3.new(v14.R + (v15.R - v14.R) * v16, v14.G + (v15.G - v14.G) * v16, v14.B + (v15.B - v14.B) * v16)
end

local function v17(v18)
    if v10[v18] then return v10[v18] end
    if v11 then return "rbxassetid://0" end
    v11 = true
    local v19, v20 = pcall(function() return v2:GetProductInfo(v18) end)
    v11 = false
    if v19 and v20 and v20.IconImageAssetId then
        v10[v18] = "rbxassetid://" .. tostring(v20.IconImageAssetId)
        return v10[v18]
    end
    v10[v18] = ""
    return ""
end

function v9.createSimpleTopUI(v21, v22, v23)
    pcall(function()
        if v1:FindFirstChild("Trash_SimpleTopUI") then
            v1.Trash_SimpleTopUI:Destroy()
        end
    end)
    local v24 = Instance.new("ScreenGui")
    v24.Name = "Trash_SimpleTopUI"
    v24.Parent = v1
    v24.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v24.DisplayOrder = 99999
    v24.IgnoreGuiInset = true
    v24.ResetOnSpawn = false

    local v25 = Instance.new("Frame")
    v25.Size = UDim2.new(0, 200, 0, 40)
    v25.Position = UDim2.new(1, -210, 0, 5)
    v25.BackgroundTransparency = 0.1
    v25.BackgroundColor3 = Color3.new(0, 0, 0)
    v25.Parent = v24
    local v26 = Instance.new("UICorner")
    v26.CornerRadius = UDim.new(0, 6)
    v26.Parent = v25

    local v27 = Instance.new("TextLabel")
    v27.Size = UDim2.new(1, -10, 0, 22)
    v27.Position = UDim2.new(0, 5, 0, 0)
    v27.BackgroundTransparency = 1
    v27.Text = "Script loaded"
    v27.TextColor3 = Color3.new(1, 1, 1)
    v27.TextSize = 14
    v27.Font = Enum.Font.GothamBold
    v27.TextXAlignment = Enum.TextXAlignment.Left
    v27.Parent = v25

    local v28 = Instance.new("TextLabel")
    v28.Size = UDim2.new(1, -10, 0, 16)
    v28.Position = UDim2.new(0, 5, 0, 20)
    v28.BackgroundTransparency = 1
    v28.Text = "Reload? (8)"
    v28.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    v28.TextSize = 11
    v28.Font = Enum.Font.Gotham
    v28.TextXAlignment = Enum.TextXAlignment.Left
    v28.Parent = v25

    local v29 = Instance.new("TextButton")
    v29.Size = UDim2.new(0, 70, 0, 22)
    v29.Position = UDim2.new(1, -75, 0, 9)
    v29.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v29.Text = "Reload"
    v29.TextColor3 = Color3.new(1, 1, 1)
    v29.TextSize = 12
    v29.Parent = v25
    local v30 = Instance.new("UICorner")
    v30.CornerRadius = UDim.new(0, 4)
    v30.Parent = v29

    v29.MouseButton1Click:Connect(function()
        pcall(function() if v24 then v24:Destroy() end end)
        local v31 = v22[v21]
        if v31 then
            local v32, v33 = pcall(v23, v31[2])
            if not v32 then
                v5:SetCore("SendNotification", {Title = "Error", Text = "Load failed: " .. tostring(v33), Duration = 3})
            end
        else
            v5:SetCore("SendNotification", {Title = "Trash", Text = "Game not adapted", Duration = 2})
        end
    end)

    task.spawn(function()
        local v34 = 8
        while v34 > 0 and v24 and v24.Parent do
            v28.Text = "Reload? (" .. v34 .. ")"
            task.wait(1)
            v34 = v34 - 1
        end
        pcall(function() if v24 then v24:Destroy() end end)
    end)
end

function v9.createManualSearchUI(v35, v36, v37, v38, v39)
    if v1:FindFirstChild("TrashManualSearchUI") then
        v1.TrashManualSearchUI:Destroy()
    end
    local v40 = Instance.new("ScreenGui")
    v40.Name = "TrashManualSearchUI"
    v40.Parent = v1
    v40.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v40.DisplayOrder = 99999
    v40.IgnoreGuiInset = true
    v40.ResetOnSpawn = false

    local v41 = Instance.new("Frame")
    v41.Size = UDim2.new(0, 420, 0, 400)
    v41.Position = UDim2.new(0.5, -210, 0.5, -200)
    v41.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    v41.BackgroundTransparency = 0.1
    v41.BorderSizePixel = 0
    v41.Parent = v40
    local v42 = Instance.new("UICorner")
    v42.CornerRadius = UDim.new(0, 12)
    v42.Parent = v41

    local v43 = Instance.new("Frame")
    v43.Size = UDim2.new(1, 0, 0, 36)
    v43.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    v43.BackgroundTransparency = 0.2
    v43.BorderSizePixel = 0
    v43.Parent = v41
    local v44 = Instance.new("UICorner")
    v44.CornerRadius = UDim.new(0, 12)
    v44.Parent = v43

    local v45 = Instance.new("TextLabel")
    v45.Size = UDim2.new(1, -40, 1, 0)
    v45.Position = UDim2.new(0, 10, 0, 0)
    v45.BackgroundTransparency = 1
    v45.Text = "Manual Script Search"
    v45.TextColor3 = Color3.fromRGB(255, 255, 255)
    v45.TextSize = 16
    v45.Font = Enum.Font.GothamBold
    v45.TextXAlignment = Enum.TextXAlignment.Left
    v45.Parent = v43

    local v46 = Instance.new("TextButton")
    v46.Size = UDim2.new(0, 28, 0, 28)
    v46.Position = UDim2.new(1, -34, 0, 4)
    v46.BackgroundTransparency = 1
    v46.Text = "X"
    v46.TextColor3 = Color3.fromRGB(255, 255, 255)
    v46.TextSize = 18
    v46.Font = Enum.Font.GothamBold
    v46.Parent = v43
    v46.MouseButton1Click:Connect(function()
        local v47 = v3
        local v48 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        v47:Create(v41, v48, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        task.wait(0.3)
        v40:Destroy()
    end)

    local v49 = false
    local v50 = nil
    local v51 = nil
    v43.InputBegan:Connect(function(v52)
        if v52.UserInputType == Enum.UserInputType.MouseButton1 then
            v49 = true
            v50 = v52.Position
            v51 = v41.Position
        end
    end)
    v43.InputEnded:Connect(function(v53)
        if v53.UserInputType == Enum.UserInputType.MouseButton1 then
            v49 = false
        end
    end)
    v4.InputChanged:Connect(function(v54)
        if v49 and v54.UserInputType == Enum.UserInputType.MouseMovement then
            local v55 = v54.Position - v50
            v41.Position = UDim2.new(v51.X.Scale, v51.X.Offset + v55.X, v51.Y.Scale, v51.Y.Offset + v55.Y)
        end
    end)

    local v56 = Instance.new("TextLabel")
    v56.Size = UDim2.new(1, -20, 0, 24)
    v56.Position = UDim2.new(0, 10, 0, 44)
    v56.BackgroundTransparency = 1
    v56.Text = "Enter game name (supports fuzzy search):"
    v56.TextColor3 = Color3.fromRGB(200, 200, 200)
    v56.TextSize = 12
    v56.Font = Enum.Font.Gotham
    v56.TextXAlignment = Enum.TextXAlignment.Left
    v56.Parent = v41

    local v57 = Instance.new("TextBox")
    v57.Size = UDim2.new(1, -70, 0, 30)
    v57.Position = UDim2.new(0, 10, 0, 72)
    v57.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v57.Text = ""
    v57.PlaceholderText = "e.g. BloxFruits / SniperArena"
    v57.TextColor3 = Color3.fromRGB(255, 255, 255)
    v57.TextSize = 12
    v57.Font = Enum.Font.Gotham
    v57.ClearTextOnFocus = false
    v57.Parent = v41
    local v58 = Instance.new("UICorner")
    v58.CornerRadius = UDim.new(0, 6)
    v58.Parent = v57

    local v59 = Instance.new("TextButton")
    v59.Size = UDim2.new(0, 50, 0, 30)
    v59.Position = UDim2.new(1, -60, 0, 72)
    v59.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v59.Text = "刷新"
    v59.TextColor3 = Color3.fromRGB(255, 255, 255)
    v59.TextSize = 12
    v59.Font = Enum.Font.GothamBold
    v59.Parent = v41
    local v60 = Instance.new("UICorner")
    v60.CornerRadius = UDim.new(0, 6)
    v60.Parent = v59

    local v61 = Instance.new("Frame")
    v61.Size = UDim2.new(1, -20, 0, 200)
    v61.Position = UDim2.new(0, 10, 0, 115)
    v61.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v61.BackgroundTransparency = 0.5
    v61.BorderSizePixel = 0
    v61.Parent = v41
    local v62 = Instance.new("UICorner")
    v62.CornerRadius = UDim.new(0, 8)
    v62.Parent = v61

    local v63 = Instance.new("ScrollingFrame")
    v63.Size = UDim2.new(1, -10, 1, -10)
    v63.Position = UDim2.new(0, 5, 0, 5)
    v63.BackgroundTransparency = 1
    v63.BorderSizePixel = 0
    v63.ScrollBarThickness = 6
    v63.CanvasSize = UDim2.new(0, 0, 0, 0)
    v63.AutomaticCanvasSize = Enum.AutomaticSize.Y
    v63.Parent = v61

    local v64 = Instance.new("UIListLayout")
    v64.Parent = v63
    v64.SortOrder = Enum.SortOrder.LayoutOrder
    v64.Padding = UDim.new(0, 4)

    local v65 = Instance.new("TextLabel")
    v65.Size = UDim2.new(1, -20, 0, 20)
    v65.Position = UDim2.new(0, 10, 0, 330)
    v65.BackgroundTransparency = 1
    v65.Text = ""
    v65.TextColor3 = Color3.fromRGB(255, 100, 100)
    v65.TextSize = 11
    v65.Font = Enum.Font.Gotham
    v65.TextXAlignment = Enum.TextXAlignment.Center
    v65.Parent = v41

    local function v66()
        local v67 = v63:GetChildren()
        for v68 = #v67, 1, -1 do
            local v69 = v67[v68]
            if v69:IsA("Frame") and v69.Name == "ResultItem" then
                v69:Destroy()
            end
        end
        v63.CanvasPosition = Vector2.new(0, 0)
    end

    local function v70(v71, v72, v73)
        v65.Text = "Loading " .. v72 .. " ..."
        v65.TextColor3 = Color3.fromRGB(255, 200, 100)
        local v74, v75 = pcall(v37, v71)
        if v74 then
            v65.Text = "Success!"
            v65.TextColor3 = Color3.fromRGB(100, 255, 100)
            pcall(function()
                v5:SetCore("SendNotification", {Title = "Trash Manual Load", Text = v72 .. " executed", Duration = 3})
            end)
            task.wait(0.5)
            if v73 then v73:Destroy() end
            v9.createSimpleTopUI(v35, v36, v37)
        else
            v65.Text = "Failed: " .. tostring(v75):sub(1, 60)
            v65.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end

    local function v76()
        v66()
        local v77 = v57.Text:lower()
        if v77 == "" then
            v65.Text = ""
            return
        end
        local v78 = {}
        for v79, v80 in pairs(v36) do
            local v81 = v80[1]:lower()
            if v81:find(v77, 1, true) then
                table.insert(v78, {placeId = v79, name = v80[1], fileName = v80[2]})
            end
        end
        if #v78 == 0 then
            v65.Text = "No matching games found"
            v65.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        v65.Text = "Found " .. #v78 .. " results, click to load"
        v65.TextColor3 = Color3.fromRGB(200, 200, 200)
        for _, v82 in ipairs(v78) do
            local v83 = Instance.new("TextButton")
            v83.Name = "ResultItem"
            v83.Size = UDim2.new(1, -10, 0, 36)
            v83.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            v83.Text = ""
            v83.AutoButtonColor = false
            v83.Parent = v63
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
                v70(v82.fileName, v82.name, v40)
            end)
            v83.MouseEnter:Connect(function()
                v83.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            end)
            v83.MouseLeave:Connect(function()
                v83.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            end)

            task.spawn(function()
                local v88 = v17(v82.placeId)
                if v88 ~= "" then
                    v85.Image = v88
                end
            end)
        end
    end

    v57:GetPropertyChangedSignal("Text"):Connect(v76)
    v57.FocusLost:Connect(v76)
    v59.MouseButton1Click:Connect(v76)

    local v89 = v3
    local v90 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    v41.Size = UDim2.new(0, 0, 0, 0)
    v41.Position = UDim2.new(0.5, 0, 0.5, 0)
    task.wait()
    v89:Create(v41, v90, {Size = UDim2.new(0, 420, 0, 400), Position = UDim2.new(0.5, -210, 0.5, -200)}):Play()

    local v91 = Instance.new("TextButton")
    v91.Name = "CardSettingBtn"
    v91.Size = UDim2.new(0, 80, 0, 30)
    v91.Position = UDim2.new(1, -90, 1, -40)
    v91.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v91.Text = "卡密设置"
    v91.TextColor3 = Color3.fromRGB(255, 255, 255)
    v91.TextSize = 12
    v91.Font = Enum.Font.GothamBold
    v91.Parent = v41
    local v92 = Instance.new("UICorner")
    v92.CornerRadius = UDim.new(0, 6)
    v92.Parent = v91

    v91.MouseButton1Click:Connect(function()
        if v12 and v12.Parent then
            v12:Destroy()
            v12 = nil
        else
            v12 = v9.showCardViewer(v38, v39, nil)
        end
    end)
end

function v9._addSettingsButton()
    if v1:FindFirstChild("Trash_SettingsButton") then
        v1.Trash_SettingsButton:Destroy()
    end
    local v93 = Instance.new("TextButton")
    v93.Name = "Trash_SettingsButton"
    v93.Size = UDim2.new(0, 60, 0, 30)
    v93.Position = UDim2.new(1, -70, 1, -40)
    v93.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v93.Text = "设置"
    v93.TextColor3 = Color3.fromRGB(255, 255, 255)
    v93.TextSize = 14
    v93.Font = Enum.Font.GothamBold
    v93.Parent = v1
    local v94 = Instance.new("UICorner")
    v94.CornerRadius = UDim.new(0, 6)
    v94.Parent = v93
    return v93
end

function v9.showCardInput(v95, v96, v97)
    pcall(function()
        if v1:FindFirstChild("CardVerifyInput") then
            v1:FindFirstChild("CardVerifyInput"):Destroy()
        end
    end)
    local v98 = Instance.new("ScreenGui")
    v98.Name = "CardVerifyInput"
    v98.Parent = v1
    v98.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v98.DisplayOrder = 999999
    v98.ResetOnSpawn = false
    v98.IgnoreGuiInset = true

    local v99 = Instance.new("Frame")
    v99.Size = UDim2.new(0, 420, 0, 170)
    v99.Position = UDim2.new(0.5, -210, 0.5, -85)
    v99.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    v99.BorderSizePixel = 0
    v99.Parent = v98
    local v100 = Instance.new("UICorner")
    v100.CornerRadius = UDim.new(0, 12)
    v100.Parent = v99

    local v101 = Instance.new("TextLabel")
    v101.Size = UDim2.new(1, 0, 0, 35)
    v101.Position = UDim2.new(0, 0, 0, 0)
    v101.BackgroundTransparency = 1
    v101.Text = "TrashHub - 卡密验证"
    v101.TextColor3 = Color3.fromRGB(255, 255, 255)
    v101.TextSize = 16
    v101.Font = Enum.Font.GothamBold
    v101.Parent = v99

    local v102 = Instance.new("TextLabel")
    v102.Size = UDim2.new(1, -20, 0, 18)
    v102.Position = UDim2.new(0, 10, 0, 38)
    v102.BackgroundTransparency = 1
    v102.Text = v96 and "卡密将保存在本地，下次自动加载" or "当前环境不支持保存，每次需手动输入"
    v102.TextColor3 = Color3.fromRGB(180, 180, 180)
    v102.TextSize = 11
    v102.Font = Enum.Font.Gotham
    v102.Parent = v99

    local v103 = Instance.new("TextBox")
    v103.Size = UDim2.new(1, -20, 0, 30)
    v103.Position = UDim2.new(0, 10, 0, 60)
    v103.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v103.Text = ""
    v103.PlaceholderText = "输入卡密..."
    v103.TextColor3 = Color3.fromRGB(255, 255, 255)
    v103.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    v103.TextSize = 13
    v103.Font = Enum.Font.Gotham
    v103.ClearTextOnFocus = false
    v103.Parent = v99
    local v104 = Instance.new("UICorner")
    v104.CornerRadius = UDim.new(0, 6)
    v104.Parent = v103

    local v105 = 100
    local v106 = 30
    local v107 = 20
    local v108 = v105 * 3 + v107 * 2
    local v109 = (420 - v108) / 2

    local v110 = Instance.new("TextButton")
    v110.Size = UDim2.new(0, v105, 0, v106)
    v110.Position = UDim2.new(0, v109, 0, 105)
    v110.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v110.Text = "确认卡密"
    v110.TextColor3 = Color3.fromRGB(255, 255, 255)
    v110.TextSize = 13
    v110.Font = Enum.Font.GothamBold
    v110.Parent = v99
    local v111 = Instance.new("UICorner")
    v111.CornerRadius = UDim.new(0, 6)
    v111.Parent = v110

    local v112 = Instance.new("TextButton")
    v112.Size = UDim2.new(0, v105, 0, v106)
    v112.Position = UDim2.new(0, v109 + v105 + v107, 0, 105)
    v112.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v112.Text = "清空配置"
    v112.TextColor3 = Color3.fromRGB(255, 255, 255)
    v112.TextSize = 13
    v112.Font = Enum.Font.GothamBold
    v112.Parent = v99
    local v113 = Instance.new("UICorner")
    v113.CornerRadius = UDim.new(0, 6)
    v113.Parent = v112

    local v114 = Instance.new("TextButton")
    v114.Size = UDim2.new(0, v105, 0, v106)
    v114.Position = UDim2.new(0, v109 + (v105 + v107) * 2, 0, 105)
    v114.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v114.Text = "初始化卡密"
    v114.TextColor3 = Color3.fromRGB(255, 255, 255)
    v114.TextSize = 13
    v114.Font = Enum.Font.GothamBold
    v114.Parent = v99
    local v115 = Instance.new("UICorner")
    v115.CornerRadius = UDim.new(0, 6)
    v115.Parent = v114

    v110.MouseButton1Click:Connect(function()
        local v116 = v103.Text
        if v116 and v116 ~= "" then
            v98:Destroy()
            v95(v116)
        else
            v101.Text = "卡密不能为空！"
            v101.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)

    local v117 = v97 or function() return false end
    v112.MouseButton1Click:Connect(function()
        if v117() then
            v101.Text = "配置已清空！"
            v101.TextColor3 = Color3.fromRGB(100, 255, 100)
            v103.Text = ""
            task.wait(1)
            v101.Text = "TrashHub - 卡密验证"
            v101.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            v101.Text = "清空失败或无配置"
            v101.TextColor3 = Color3.fromRGB(255, 100, 100)
            task.wait(1)
            v101.Text = "TrashHub - 卡密验证"
            v101.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)

    v114.MouseButton1Click:Connect(function()
        if v117() then
            v101.Text = "已初始化，可输入新卡密"
            v101.TextColor3 = Color3.fromRGB(100, 255, 100)
            v103.Text = ""
            task.wait(1)
            v101.Text = "TrashHub - 卡密验证"
            v101.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            v101.Text = "无配置，可直接输入"
            v101.TextColor3 = Color3.fromRGB(255, 200, 100)
            task.wait(1)
            v101.Text = "TrashHub - 卡密验证"
            v101.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
end

function v9.showCardInputWithPreset(v118, v119, v120, v121)
    pcall(function()
        if v1:FindFirstChild("CardVerifyInput") then
            v1:FindFirstChild("CardVerifyInput"):Destroy()
        end
    end)
    local v122 = Instance.new("ScreenGui")
    v122.Name = "CardVerifyInput"
    v122.Parent = v1
    v122.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v122.DisplayOrder = 999999
    v122.ResetOnSpawn = false
    v122.IgnoreGuiInset = true

    local v123 = Instance.new("Frame")
    v123.Size = UDim2.new(0, 420, 0, 170)
    v123.Position = UDim2.new(0.5, -210, 0.5, -85)
    v123.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    v123.BorderSizePixel = 0
    v123.Parent = v122
    local v124 = Instance.new("UICorner")
    v124.CornerRadius = UDim.new(0, 12)
    v124.Parent = v123

    local v125 = Instance.new("TextLabel")
    v125.Size = UDim2.new(1, 0, 0, 35)
    v125.Position = UDim2.new(0, 0, 0, 0)
    v125.BackgroundTransparency = 1
    v125.Text = "TrashHub - 更换卡密"
    v125.TextColor3 = Color3.fromRGB(255, 255, 255)
    v125.TextSize = 16
    v125.Font = Enum.Font.GothamBold
    v125.Parent = v123

    local v126 = Instance.new("TextLabel")
    v126.Size = UDim2.new(1, -20, 0, 18)
    v126.Position = UDim2.new(0, 10, 0, 38)
    v126.BackgroundTransparency = 1
    v126.Text = v120 and "新卡密将自动保存" or "输入新卡密后点击确认"
    v126.TextColor3 = Color3.fromRGB(180, 180, 180)
    v126.TextSize = 11
    v126.Font = Enum.Font.Gotham
    v126.Parent = v123

    local v127 = Instance.new("TextBox")
    v127.Size = UDim2.new(1, -20, 0, 30)
    v127.Position = UDim2.new(0, 10, 0, 60)
    v127.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v127.Text = v121 or ""
    v127.PlaceholderText = "输入新卡密..."
    v127.TextColor3 = Color3.fromRGB(255, 255, 255)
    v127.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    v127.TextSize = 13
    v127.Font = Enum.Font.Gotham
    v127.ClearTextOnFocus = false
    v127.Parent = v123
    local v128 = Instance.new("UICorner")
    v128.CornerRadius = UDim.new(0, 6)
    v128.Parent = v127

    local v129 = 100
    local v130 = 30
    local v131 = 20
    local v132 = v129 * 2 + v131
    local v133 = (420 - v132) / 2

    local v134 = Instance.new("TextButton")
    v134.Size = UDim2.new(0, v129, 0, v130)
    v134.Position = UDim2.new(0, v133, 0, 105)
    v134.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v134.Text = "确认更换"
    v134.TextColor3 = Color3.fromRGB(255, 255, 255)
    v134.TextSize = 13
    v134.Font = Enum.Font.GothamBold
    v134.Parent = v123
    local v135 = Instance.new("UICorner")
    v135.CornerRadius = UDim.new(0, 6)
    v135.Parent = v134

    local v136 = Instance.new("TextButton")
    v136.Size = UDim2.new(0, v129, 0, v130)
    v136.Position = UDim2.new(0, v133 + v129 + v131, 0, 105)
    v136.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    v136.Text = "取消"
    v136.TextColor3 = Color3.fromRGB(255, 255, 255)
    v136.TextSize = 13
    v136.Font = Enum.Font.GothamBold
    v136.Parent = v123
    local v137 = Instance.new("UICorner")
    v137.CornerRadius = UDim.new(0, 6)
    v137.Parent = v136

    v134.MouseButton1Click:Connect(function()
        local v138 = v127.Text
        if v138 and v138 ~= "" then
            v122:Destroy()
            v118(v138)
        else
            v125.Text = "卡密不能为空！"
            v125.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)

    v136.MouseButton1Click:Connect(function()
        v122:Destroy()
        if v119 then v119() end
    end)
end

function v9.showCardViewer(v139, v140, v141)
    local v142 = Instance.new("ScreenGui")
    v142.Name = "CardViewer"
    v142.Parent = v1
    v142.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v142.DisplayOrder = 999999
    v142.ResetOnSpawn = false
    v142.IgnoreGuiInset = true

    local v143 = Instance.new("Frame")
    v143.Size = UDim2.new(0, 400, 0, 180)
    v143.Position = UDim2.new(0.5, -200, 0.5, -90)
    v143.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    v143.BorderSizePixel = 0
    v143.Parent = v142
    local v144 = Instance.new("UICorner")
    v144.CornerRadius = UDim.new(0, 12)
    v144.Parent = v143

    local v145 = Instance.new("TextLabel")
    v145.Size = UDim2.new(1, 0, 0, 35)
    v145.Position = UDim2.new(0, 0, 0, 0)
    v145.BackgroundTransparency = 1
    v145.Text = "当前卡密"
    v145.TextColor3 = Color3.fromRGB(255, 255, 255)
    v145.TextSize = 16
    v145.Font = Enum.Font.GothamBold
    v145.Parent = v143

    local v146 = Instance.new("TextBox")
    v146.Size = UDim2.new(1, -40, 0, 30)
    v146.Position = UDim2.new(0, 20, 0, 45)
    v146.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v146.Text = v139 or "无已保存卡密"
    v146.TextColor3 = Color3.fromRGB(255, 255, 255)
    v146.TextSize = 13
    v146.Font = Enum.Font.Gotham
    v146.ClearTextOnFocus = false
    v146.TextEditable = false
    v146.Parent = v143
    local v147 = Instance.new("UICorner")
    v147.CornerRadius = UDim.new(0, 6)
    v147.Parent = v146

    local v148 = Instance.new("TextLabel")
    v148.Size = UDim2.new(1, -40, 0, 20)
    v148.Position = UDim2.new(0, 20, 0, 85)
    v148.BackgroundTransparency = 1
    if v140 and v140 > 0 then
        local v149 = math.floor(v140 / 86400)
        local v150 = math.floor((v140 % 86400) / 3600)
        local v151 = math.floor((v140 % 3600) / 60)
        local v152 = v140 % 60
        v148.Text = string.format("剩余时长：%d天 %02d时 %02d分 %02d秒", v149, v150, v151, v152)
        v148.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        v148.Text = "剩余时长：未知或已过期"
        v148.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    v148.TextSize = 12
    v148.Font = Enum.Font.Gotham
    v148.TextXAlignment = Enum.TextXAlignment.Center
    v148.Parent = v143

    local v153 = Instance.new("TextButton")
    v153.Size = UDim2.new(0, 100, 0, 30)
    v153.Position = UDim2.new(0.3, -50, 0, 120)
    v153.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v153.Text = "更换卡密"
    v153.TextColor3 = Color3.fromRGB(255, 255, 255)
    v153.TextSize = 13
    v153.Font = Enum.Font.GothamBold
    v153.Parent = v143
    local v154 = Instance.new("UICorner")
    v154.CornerRadius = UDim.new(0, 6)
    v154.Parent = v153

    local v155 = Instance.new("TextButton")
    v155.Size = UDim2.new(0, 100, 0, 30)
    v155.Position = UDim2.new(0.7, -50, 0, 120)
    v155.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    v155.Text = "关闭"
    v155.TextColor3 = Color3.fromRGB(255, 255, 255)
    v155.TextSize = 13
    v155.Font = Enum.Font.GothamBold
    v155.Parent = v143
    local v156 = Instance.new("UICorner")
    v156.CornerRadius = UDim.new(0, 6)
    v156.Parent = v155

    v153.MouseButton1Click:Connect(function()
        if v141 then
            v141()
        end
        v142:Destroy()
    end)

    v155.MouseButton1Click:Connect(function()
        v142:Destroy()
    end)

    return v142
end

function v9.showLowTimeWarning(v157, v158, v159)
    local v160 = Instance.new("ScreenGui")
    v160.Name = "LowTimeWarning"
    v160.Parent = v1
    v160.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v160.DisplayOrder = 999999
    v160.ResetOnSpawn = false
    v160.IgnoreGuiInset = true

    local v161 = Instance.new("Frame")
    v161.Size = UDim2.new(0, 420, 0, 150)
    v161.Position = UDim2.new(0.5, -210, 0.5, -75)
    v161.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    v161.BorderSizePixel = 0
    v161.Parent = v160
    local v162 = Instance.new("UICorner")
    v162.CornerRadius = UDim.new(0, 12)
    v162.Parent = v161

    local v163 = Instance.new("TextLabel")
    v163.Size = UDim2.new(1, 0, 0, 35)
    v163.Position = UDim2.new(0, 0, 0, 0)
    v163.BackgroundTransparency = 1
    v163.Text = "卡密即将过期"
    v163.TextColor3 = Color3.fromRGB(255, 100, 100)
    v163.TextSize = 16
    v163.Font = Enum.Font.GothamBold
    v163.Parent = v161

    local v164 = Instance.new("TextLabel")
    v164.Size = UDim2.new(1, -20, 0, 40)
    v164.Position = UDim2.new(0, 10, 0, 40)
    v164.BackgroundTransparency = 1
    v164.Text = "剩余时间不足4小时，是否更换卡密？"
    v164.TextColor3 = Color3.fromRGB(255, 255, 255)
    v164.TextSize = 13
    v164.Font = Enum.Font.Gotham
    v164.TextWrapped = true
    v164.Parent = v161

    local v165 = Instance.new("TextButton")
    v165.Size = UDim2.new(0, 100, 0, 30)
    v165.Position = UDim2.new(0.3, -50, 0, 95)
    v165.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v165.Text = "更换"
    v165.TextColor3 = Color3.fromRGB(255, 255, 255)
    v165.TextSize = 13
    v165.Font = Enum.Font.GothamBold
    v165.Parent = v161
    local v166 = Instance.new("UICorner")
    v166.CornerRadius = UDim.new(0, 6)
    v166.Parent = v165

    local v167 = Instance.new("TextButton")
    v167.Size = UDim2.new(0, 100, 0, 30)
    v167.Position = UDim2.new(0.7, -50, 0, 95)
    v167.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    v167.Text = "跳过"
    v167.TextColor3 = Color3.fromRGB(255, 255, 255)
    v167.TextSize = 13
    v167.Font = Enum.Font.GothamBold
    v167.Parent = v161
    local v168 = Instance.new("UICorner")
    v168.CornerRadius = UDim.new(0, 6)
    v168.Parent = v167

    v165.MouseButton1Click:Connect(function()
        v160:Destroy()
        v158()
    end)

    v167.MouseButton1Click:Connect(function()
        v160:Destroy()
        if v159 then v159() end
    end)
end

local v169 = {}
v169.__index = v169

function v169.new()
    pcall(function()
        local v170 = v1:FindFirstChild("TrashLoadingScreen")
        if v170 then v170:Destroy() end
    end)
    local self = setmetatable({}, v169)
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
    self:_createUI()
    self:_darkenScreen()
    self:_createRainbowEffect()
    self:_createColorBackground()
    self:_checkTimeout()
    return self
end

function v169:_checkTimeout()
    task.spawn(function()
        while self.gui and self.gui.Parent and not self.triggered30 do
            task.wait(0.1)
            if tick() - self.startTime >= 5 and not self.triggered30 then
                self.isTimeout = true
                if self.title then
                    self.title.TextColor3 = Color3.fromRGB(255, 0, 0)
                    task.wait(0.5)
                    self.title.Text = "Timeout, click to skip"
                    local v171 = nil
                    v171 = self.title.MouseButton1Click:Connect(function()
                        if v171 then v171:Disconnect() end
                        self:fadeOutAndDestroy()
                    end)
                end
                break
            end
        end
    end)
end

function v169:_createUI()
    self.bg = Instance.new("Frame")
    self.bg.Name = "bg"
    self.bg.Size = UDim2.new(1, 0, 1, 0)
    self.bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.bg.BackgroundTransparency = 0.3
    self.bg.BorderSizePixel = 0
    self.bg.Parent = self.gui

    local v173 = Instance.new("Frame")
    v173.Name = "centerContainer"
    v173.Size = UDim2.new(0, 500, 0, 260)
    v173.Position = UDim2.new(0.5, -250, 0.5, -130)
    v173.BackgroundTransparency = 1
    v173.Parent = self.gui

    self.title = Instance.new("TextLabel")
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
    self.title.Parent = v173

    self.status = Instance.new("TextLabel")
    self.status.Name = "statusLabel"
    self.status.Size = UDim2.new(1, 0, 0, 30)
    self.status.Position = UDim2.new(0, 0, 0, 65)
    self.status.BackgroundTransparency = 1
    self.status.Text = "Initializing..."
    self.status.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.status.TextStrokeTransparency = 0.3
    self.status.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    self.status.Font = Enum.Font.Gotham
    self.status.TextSize = 18
    self.status.TextXAlignment = Enum.TextXAlignment.Center
    self.status.Parent = v173

    self.filesLabel = Instance.new("TextLabel")
    self.filesLabel.Name = "filesLabel"
    self.filesLabel.Size = UDim2.new(1, -20, 0, 18)
    self.filesLabel.Position = UDim2.new(0, 10, 0, 100)
    self.filesLabel.BackgroundTransparency = 1
    self.filesLabel.Text = "Deleting files:"
    self.filesLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    self.filesLabel.TextStrokeTransparency = 0.6
    self.filesLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    self.filesLabel.Font = Enum.Font.Gotham
    self.filesLabel.TextSize = 13
    self.filesLabel.TextXAlignment = Enum.TextXAlignment.Center
    self.filesLabel.Parent = v173

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
    self.currentFile.Parent = v173

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
    self.downloadInfo.Parent = v173

    local v174 = Instance.new("Frame")
    v174.Name = "progressBg"
    v174.Size = UDim2.new(1, -40, 0, 20)
    v174.Position = UDim2.new(0, 20, 0, 145)
    v174.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    v174.BorderSizePixel = 0
    v174.Parent = v173
    local v175 = Instance.new("UICorner")
    v175.CornerRadius = UDim.new(0, 10)
    v175.Parent = v174
    self.progressBg = v174

    self.progressFill = Instance.new("Frame")
    self.progressFill.Name = "progressFill"
    self.progressFill.Size = UDim2.new(0, 0, 1, 0)
    self.progressFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    self.progressFill.BorderSizePixel = 0
    self.progressFill.Parent = v174
    local v176 = Instance.new("UICorner")
    v176.CornerRadius = UDim.new(0, 10)
    v176.Parent = self.progressFill

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
    self.percent.Parent = v173
end

function v169:_createColorBackground()
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

function v169:_createRainbowEffect()
    local v177 = Instance.new("Frame")
    v177.Name = "RainbowEffect"
    v177.Size = UDim2.new(1, 0, 1, 0)
    v177.BackgroundTransparency = 1
    v177.ZIndex = 2
    v177.Parent = self.gui

    local v178 = 55
    local v179 = 200
    local v180 = 0.8
    local v181 = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(128, 0, 128)
    }
    local v182 = {}

    local function v183(v184, v185)
        local v186 = (v184 == 1 or v184 == 3)
        local v187 = (v184 == 1)
        local v188 = (v184 == 3)
        local v189 = (v184 == 2)
        local v190 = (v184 == 4)
        local v191 = Instance.new("Frame")
        v191.Name = string.format("Bar_%d_%d", v184, v185)
        v191.BorderSizePixel = 0
        v191.ZIndex = 2
        v191.BackgroundTransparency = 1
        v191.Parent = v177

        if v186 then
            v191.Size = UDim2.new(1 / v179, 0, 0, v178)
            if v187 then
                v191.AnchorPoint = Vector2.new(0.5, 1)
                v191.Position = UDim2.new((v185 - 0.5) / v179, 0, 1, 0)
            else
                v191.AnchorPoint = Vector2.new(0.5, 0)
                v191.Position = UDim2.new((v185 - 0.5) / v179, 0, 0, 0)
            end
        else
            v191.Size = UDim2.new(0, v178, 1 / v179, 0)
            if v189 then
                v191.AnchorPoint = Vector2.new(1, 0.5)
                v191.Position = UDim2.new(1, 0, (v185 - 0.5) / v179, 0)
            else
                v191.AnchorPoint = Vector2.new(0, 0.5)
                v191.Position = UDim2.new(0, 0, (v185 - 0.5) / v179, 0)
            end
        end

        local v192 = Instance.new("UIGradient")
        if v184 == 1 then
            v192.Rotation = 270
        elseif v184 == 2 then
            v192.Rotation = 180
        elseif v184 == 3 then
            v192.Rotation = 90
        else
            v192.Rotation = 0
        end
        v192.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
        v192.Parent = v191

        local v193
        if v184 == 1 then
            v193 = (v185 - 0.5) / (v179 * 4)
        elseif v184 == 2 then
            v193 = (v179 + v185 - 0.5) / (v179 * 4)
        elseif v184 == 3 then
            v193 = (2 * v179 + v185 - 0.5) / (v179 * 4)
        else
            v193 = (3 * v179 + v185 - 0.5) / (v179 * 4)
        end
        table.insert(v182, {bar = v191, t_global = v193, isHorizontal = v186})

        local v194 = v186 and UDim2.new(1 / v179, 0, 0, v178) or UDim2.new(0, v178, 1 / v179, 0)
        local v195 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        v3:Create(v191, v195, {Size = v194, BackgroundTransparency = 0}):Play()
    end

    for v184 = 1, 4 do
        for v185 = 1, v179 do
            v183(v184, v185)
        end
    end

    self.rainbowBars = v182
    local v196 = tick()
    self.heartbeatConn = v7.Heartbeat:Connect(function()
        local v197 = (tick() - v196) * v180
        local v198 = v197 % 1
        for _, v199 in ipairs(v182) do
            local v200 = v199.t_global - v198
            if v200 < 0 then v200 = v200 + 1 end
            local v201 = math.floor(v200 * #v181) + 1
            local v202 = (v200 * #v181) % 1
            local v203 = v181[v201]
            local v204 = v181[v201 % #v181 + 1]
            v199.bar.BackgroundColor3 = v13(v203, v204, v202)
        end
    end)
end

function v169:_darkenScreen()
    for v205 = 1, 30 do
        local v206 = v205 / 30
        v6.Brightness = self.originalBrightness - (self.originalBrightness - 0.4) * v206
        v6.Ambient = Color3.new(
            self.originalAmbient.R - (self.originalAmbient.R - 0.4) * v206,
            self.originalAmbient.G - (self.originalAmbient.G - 0.4) * v206,
            self.originalAmbient.B - (self.originalAmbient.B - 0.4) * v206
        )
        v6.OutdoorAmbient = Color3.new(
            self.originalOutdoorAmbient.R - (self.originalOutdoorAmbient.R - 0.4) * v206,
            self.originalOutdoorAmbient.G - (self.originalOutdoorAmbient.G - 0.4) * v206,
            self.originalOutdoorAmbient.B - (self.originalOutdoorAmbient.B - 0.4) * v206
        )
        task.wait(0.01)
    end
    v6.Brightness = 0.4
    v6.Ambient = Color3.new(0.4, 0.4, 0.4)
    v6.OutdoorAmbient = Color3.new(0.4, 0.4, 0.4)
end

function v169:updateProgress(v207, v208, v209, v210)
    if not self.gui or not self.gui.Parent then return false end
    if v208 then self.status.Text = v208 end
    local v211 = v210 == true
    if self.filesLabel then self.filesLabel.Visible = v211 end
    if self.currentFile then self.currentFile.Visible = v211 end
    if self.downloadInfo then self.downloadInfo.Visible = not v211 end
    if v209 then
        if v211 then
            if self.currentFile then self.currentFile.Text = v209 end
        else
            if self.downloadInfo then self.downloadInfo.Text = v209 end
        end
    end
    if self.progressFill and type(v207) == "number" then
        self.progressFill:TweenSize(UDim2.new(v207 / 100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.3, true)
    end
    if self.percent then
        self.percent.Text = math.floor(v207) .. "%"
    end
    if v207 >= 30 and not self.triggered30 then
        self.triggered30 = true
        if self.colorBackground then
            self.colorBackground.BackgroundTransparency = 0.9
        end
        self:_startColorCycle()
    end
    if v207 >= 90 and not self.triggered90 then
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
    if v207 >= 91 and not self.triggered91 then
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
            for _, v199 in ipairs(self.rainbowBars) do
                local v212 = v199.bar
                if v212 then
                    local v213 = v199.isHorizontal and UDim2.new(v212.Size.X.Scale, v212.Size.X.Offset, 0, 0) or UDim2.new(0, 0, v212.Size.Y.Scale, v212.Size.Y.Offset)
                    v3:Create(v212, TweenInfo.new(0.8), {Size = v213, BackgroundTransparency = 1}):Play()
                end
            end
        end
        if self.heartbeatConn then
            pcall(function() self.heartbeatConn:Disconnect() end)
        end
    end
    return true
end

function v169:_startColorCycle()
    local v181 = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(128, 0, 128)
    }
    local v214 = 1
    local function v215()
        if not self.colorCycleActive then return end
        local v216 = v181[v214]
        v214 = v214 % #v181 + 1
        if self.colorBackground then
            self.colorCycleTween = v3:Create(self.colorBackground, TweenInfo.new(0.5), {BackgroundColor3 = v216})
            self.colorCycleTween.Completed:Connect(v215)
            self.colorCycleTween:Play()
        end
    end
    self.colorCycleActive = true
    v215()
end

function v169:stopColorCycle()
    self.colorCycleActive = false
    if self.colorCycleTween then
        self.colorCycleTween:Cancel()
    end
end

function v169:forceCleanupRainbow()
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

function v169:fadeOutDeleteUI()
    pcall(function()
        if not self.filesLabel or not self.currentFile then return end
        local v217 = TweenInfo.new(0.3)
        v3:Create(self.filesLabel, v217, {TextTransparency = 1}):Play()
        v3:Create(self.currentFile, v217, {TextTransparency = 1}):Play()
        task.wait(0.3)
        self.filesLabel.Visible = false
        self.currentFile.Visible = false
        self.filesLabel.TextTransparency = 0
        self.currentFile.TextTransparency = 0
    end)
end

function v169:setTitleWithAnimation(v218)
    pcall(function()
        if not self.title then return end
        local v219 = TweenInfo.new(0.4)
        v3:Create(self.title, v219, {TextTransparency = 1}):Play()
        task.wait(0.4)
        self.title.Text = v218
        v3:Create(self.title, v219, {TextTransparency = 0}):Play()
        task.wait(0.4)
    end)
end

function v169:fadeOutAndDestroy()
    if not self.gui then return end
    self:forceCleanupRainbow()
    local v220 = {
        self.title, self.status, self.filesLabel, self.currentFile,
        self.downloadInfo, self.percent, self.progressFill, self.progressBg,
        self.bg, self.colorBackground
    }
    for v205 = 1, 30 do
        local v206 = v205 / 30
        for _, v221 in ipairs(v220) do
            if v221 then
                if v221 == self.bg or v221 == self.progressBg then
                    if v221:IsA("Frame") then
                        v221.BackgroundTransparency = 0.3 + v206 * 0.7
                    end
                elseif v221:IsA("TextLabel") then
                    v221.TextTransparency = v206
                elseif v221 == self.progressFill or v221 == self.colorBackground then
                    if v221:IsA("Frame") then
                        v221.BackgroundTransparency = v206
                    end
                end
            end
        end
        task.wait(0.01)
    end
    for v205 = 1, 30 do
        local v206 = v205 / 30
        v6.Brightness = 0.4 + (self.originalBrightness - 0.4) * v206
        v6.Ambient = Color3.new(
            0.4 + (self.originalAmbient.R - 0.4) * v206,
            0.4 + (self.originalAmbient.G - 0.4) * v206,
            0.4 + (self.originalAmbient.B - 0.4) * v206
        )
        v6.OutdoorAmbient = Color3.new(
            0.4 + (self.originalOutdoorAmbient.R - 0.4) * v206,
            0.4 + (self.originalOutdoorAmbient.G - 0.4) * v206,
            0.4 + (self.originalOutdoorAmbient.B - 0.4) * v206
        )
        task.wait(0.01)
    end
    v6.Brightness = self.originalBrightness
    v6.Ambient = self.originalAmbient
    v6.OutdoorAmbient = self.originalOutdoorAmbient
    self.gui:Destroy()
end

v169.destroy = v169.fadeOutAndDestroy

v9.LoadingAnimation = v169
v9.onRequestChangeCard = nil

return v9
