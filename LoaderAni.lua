local v1 = game:GetService("CoreGui")
local v2 = game:GetService("MarketplaceService")
local v3 = game:GetService("TweenService")
local v4 = game:GetService("UserInputService")
local v5 = game:GetService("StarterGui")
local v6 = game:GetService("Lighting")
local v7 = game:GetService("RunService")
local v8 = game:GetService("HttpService")

local v9 = {}

local function v10(v11, v12, v13)
    return Color3.new(v11.R + (v12.R - v11.R) * v13, v11.G + (v12.G - v11.G) * v13, v11.B + (v12.B - v11.B) * v13)
end

local function v14(v15)
    local v16, v17 = pcall(function() return v2:GetProductInfo(v15) end)
    if v16 and v17 and v17.IconImageAssetId then
        return "rbxassetid://" .. tostring(v17.IconImageAssetId)
    end
    return ""
end

function v9.createSimpleTopUI(v18, v19, v20)
    pcall(function()
        if v1:FindFirstChild("Trash_SimpleTopUI") then
            v1.Trash_SimpleTopUI:Destroy()
        end
    end)
    local v21 = Instance.new("ScreenGui")
    v21.Name = "Trash_SimpleTopUI"
    v21.Parent = v1
    v21.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v21.DisplayOrder = 99999
    v21.IgnoreGuiInset = true
    v21.ResetOnSpawn = false

    local v22 = Instance.new("Frame")
    v22.Size = UDim2.new(0, 200, 0, 40)
    v22.Position = UDim2.new(1, -210, 0, 5)
    v22.BackgroundTransparency = 0.1
    v22.BackgroundColor3 = Color3.new(0, 0, 0)
    v22.Parent = v21
    local v23 = Instance.new("UICorner")
    v23.CornerRadius = UDim.new(0, 6)
    v23.Parent = v22

    local v24 = Instance.new("TextLabel")
    v24.Size = UDim2.new(1, -10, 0, 22)
    v24.Position = UDim2.new(0, 5, 0, 0)
    v24.BackgroundTransparency = 1
    v24.Text = "Script loaded"
    v24.TextColor3 = Color3.new(1, 1, 1)
    v24.TextSize = 14
    v24.Font = Enum.Font.GothamBold
    v24.TextXAlignment = Enum.TextXAlignment.Left
    v24.Parent = v22

    local v25 = Instance.new("TextLabel")
    v25.Size = UDim2.new(1, -10, 0, 16)
    v25.Position = UDim2.new(0, 5, 0, 20)
    v25.BackgroundTransparency = 1
    v25.Text = "Reload? (8)"
    v25.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    v25.TextSize = 11
    v25.Font = Enum.Font.Gotham
    v25.TextXAlignment = Enum.TextXAlignment.Left
    v25.Parent = v22

    local v26 = Instance.new("TextButton")
    v26.Size = UDim2.new(0, 70, 0, 22)
    v26.Position = UDim2.new(1, -75, 0, 9)
    v26.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v26.Text = "Reload"
    v26.TextColor3 = Color3.new(1, 1, 1)
    v26.TextSize = 12
    v26.Parent = v22
    local v27 = Instance.new("UICorner")
    v27.CornerRadius = UDim.new(0, 4)
    v27.Parent = v26

    v26.MouseButton1Click:Connect(function()
        pcall(function() if v21 then v21:Destroy() end end)
        local v28 = v19[v18]
        if v28 then
            local v29, v30 = pcall(v20, v28[2])
            if not v29 then
                v5:SetCore("SendNotification", {Title = "Error", Text = "Load failed: " .. tostring(v30), Duration = 3})
            end
        else
            v5:SetCore("SendNotification", {Title = "Trash", Text = "Game not adapted", Duration = 2})
        end
    end)

    task.spawn(function()
        local v31 = 8
        while v31 > 0 and v21 and v21.Parent do
            v25.Text = "Reload? (" .. v31 .. ")"
            task.wait(1)
            v31 = v31 - 1
        end
        pcall(function() if v21 then v21:Destroy() end end)
    end)
end

function v9.createManualSearchUI(v32, v33, v34, v35)
    if v1:FindFirstChild("TrashManualSearchUI") then
        v1.TrashManualSearchUI:Destroy()
    end
    local v36 = Instance.new("ScreenGui")
    v36.Name = "TrashManualSearchUI"
    v36.Parent = v1
    v36.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v36.DisplayOrder = 99999
    v36.IgnoreGuiInset = true
    v36.ResetOnSpawn = false

    local v37 = Instance.new("Frame")
    v37.Size = UDim2.new(0, 420, 0, 340)
    v37.Position = UDim2.new(0.5, -210, 0.5, -170)
    v37.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    v37.BackgroundTransparency = 0.1
    v37.BorderSizePixel = 0
    v37.Parent = v36
    local v38 = Instance.new("UICorner")
    v38.CornerRadius = UDim.new(0, 12)
    v38.Parent = v37

    local v39 = Instance.new("Frame")
    v39.Size = UDim2.new(1, 0, 0, 36)
    v39.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    v39.BackgroundTransparency = 0.2
    v39.BorderSizePixel = 0
    v39.Parent = v37
    local v40 = Instance.new("UICorner")
    v40.CornerRadius = UDim.new(0, 12)
    v40.Parent = v39

    local v41 = Instance.new("TextLabel")
    v41.Size = UDim2.new(1, -40, 1, 0)
    v41.Position = UDim2.new(0, 10, 0, 0)
    v41.BackgroundTransparency = 1
    v41.Text = "Manual Script Search"
    v41.TextColor3 = Color3.fromRGB(255, 255, 255)
    v41.TextSize = 16
    v41.Font = Enum.Font.GothamBold
    v41.TextXAlignment = Enum.TextXAlignment.Left
    v41.Parent = v39

    local v42 = Instance.new("TextButton")
    v42.Size = UDim2.new(0, 28, 0, 28)
    v42.Position = UDim2.new(1, -34, 0, 4)
    v42.BackgroundTransparency = 1
    v42.Text = "X"
    v42.TextColor3 = Color3.fromRGB(255, 255, 255)
    v42.TextSize = 18
    v42.Font = Enum.Font.GothamBold
    v42.Parent = v39
    v42.MouseButton1Click:Connect(function()
        local v43 = v3
        local v44 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        v43:Create(v37, v44, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        task.wait(0.3)
        v36:Destroy()
    end)

    local v45 = false
    local v46 = nil
    local v47 = nil
    v39.InputBegan:Connect(function(v48)
        if v48.UserInputType == Enum.UserInputType.MouseButton1 then
            v45 = true
            v46 = v48.Position
            v47 = v37.Position
        end
    end)
    v39.InputEnded:Connect(function(v49)
        if v49.UserInputType == Enum.UserInputType.MouseButton1 then
            v45 = false
        end
    end)
    v4.InputChanged:Connect(function(v50)
        if v45 and v50.UserInputType == Enum.UserInputType.MouseMovement then
            local v51 = v50.Position - v46
            v37.Position = UDim2.new(v47.X.Scale, v47.X.Offset + v51.X, v47.Y.Scale, v47.Y.Offset + v51.Y)
        end
    end)

    local v52 = Instance.new("TextLabel")
    v52.Size = UDim2.new(1, -20, 0, 24)
    v52.Position = UDim2.new(0, 10, 0, 44)
    v52.BackgroundTransparency = 1
    v52.Text = "Enter game name (supports fuzzy search):"
    v52.TextColor3 = Color3.fromRGB(200, 200, 200)
    v52.TextSize = 12
    v52.Font = Enum.Font.Gotham
    v52.TextXAlignment = Enum.TextXAlignment.Left
    v52.Parent = v37

    local v53 = Instance.new("TextBox")
    v53.Size = UDim2.new(1, -70, 0, 30)
    v53.Position = UDim2.new(0, 10, 0, 72)
    v53.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v53.Text = ""
    v53.PlaceholderText = "e.g. BloxFruits / SniperArena"
    v53.TextColor3 = Color3.fromRGB(255, 255, 255)
    v53.TextSize = 12
    v53.Font = Enum.Font.Gotham
    v53.ClearTextOnFocus = false
    v53.Parent = v37
    local v54 = Instance.new("UICorner")
    v54.CornerRadius = UDim.new(0, 6)
    v54.Parent = v53

    local v55 = Instance.new("TextButton")
    v55.Size = UDim2.new(0, 50, 0, 30)
    v55.Position = UDim2.new(1, -60, 0, 72)
    v55.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v55.Text = "刷新"
    v55.TextColor3 = Color3.fromRGB(255, 255, 255)
    v55.TextSize = 12
    v55.Font = Enum.Font.GothamBold
    v55.Parent = v37
    local v56 = Instance.new("UICorner")
    v56.CornerRadius = UDim.new(0, 6)
    v56.Parent = v55

    local v57 = Instance.new("Frame")
    v57.Size = UDim2.new(1, -20, 0, 170)
    v57.Position = UDim2.new(0, 10, 0, 115)
    v57.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v57.BackgroundTransparency = 0.5
    v57.BorderSizePixel = 0
    v57.Parent = v37
    local v58 = Instance.new("UICorner")
    v58.CornerRadius = UDim.new(0, 8)
    v58.Parent = v57

    local v59 = Instance.new("ScrollingFrame")
    v59.Size = UDim2.new(1, -10, 1, -10)
    v59.Position = UDim2.new(0, 5, 0, 5)
    v59.BackgroundTransparency = 1
    v59.BorderSizePixel = 0
    v59.ScrollBarThickness = 6
    v59.CanvasSize = UDim2.new(0, 0, 0, 0)
    v59.AutomaticCanvasSize = Enum.AutomaticSize.Y
    v59.Parent = v57

    local v60 = Instance.new("UIListLayout")
    v60.Parent = v59
    v60.SortOrder = Enum.SortOrder.LayoutOrder
    v60.Padding = UDim.new(0, 4)

    local v61 = Instance.new("TextLabel")
    v61.Size = UDim2.new(1, -20, 0, 20)
    v61.Position = UDim2.new(0, 10, 0, 295)
    v61.BackgroundTransparency = 1
    v61.Text = ""
    v61.TextColor3 = Color3.fromRGB(255, 100, 100)
    v61.TextSize = 11
    v61.Font = Enum.Font.Gotham
    v61.TextXAlignment = Enum.TextXAlignment.Center
    v61.Parent = v37

    local function v62()
        local v63 = v59:GetChildren()
        for v64 = #v63, 1, -1 do
            local v65 = v63[v64]
            if v65:IsA("Frame") and v65.Name == "ResultItem" then
                v65:Destroy()
            end
        end
        v59.CanvasPosition = Vector2.new(0, 0)
    end

    local function v66(v67, v68, v69)
        v61.Text = "Loading " .. v68 .. " ..."
        v61.TextColor3 = Color3.fromRGB(255, 200, 100)
        local v70, v71 = pcall(v34, v67)
        if v70 then
            v61.Text = "Success!"
            v61.TextColor3 = Color3.fromRGB(100, 255, 100)
            pcall(function()
                v5:SetCore("SendNotification", {Title = "Trash Manual Load", Text = v68 .. " executed", Duration = 3})
            end)
            task.wait(0.5)
            if v69 then v69:Destroy() end
            v9.createSimpleTopUI(v32, v33, v34)
        else
            v61.Text = "Failed: " .. tostring(v71):sub(1, 60)
            v61.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end

    local function v72()
        v62()
        local v73 = v53.Text:lower()
        if v73 == "" then
            v61.Text = ""
            return
        end
        local v74 = {}
        for v75, v76 in pairs(v33) do
            local v77 = v76[1]:lower()
            if v77:find(v73, 1, true) then
                table.insert(v74, {placeId = v75, name = v76[1], fileName = v76[2]})
            end
        end
        if #v74 == 0 then
            v61.Text = "No matching games found"
            v61.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        v61.Text = "Found " .. #v74 .. " results, click to load"
        v61.TextColor3 = Color3.fromRGB(200, 200, 200)
        for _, v78 in ipairs(v74) do
            local v79 = Instance.new("TextButton")
            v79.Name = "ResultItem"
            v79.Size = UDim2.new(1, -10, 0, 36)
            v79.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            v79.Text = ""
            v79.AutoButtonColor = false
            v79.Parent = v59
            local v80 = Instance.new("UICorner")
            v80.CornerRadius = UDim.new(0, 6)
            v80.Parent = v79

            local v81 = Instance.new("ImageLabel")
            v81.Size = UDim2.new(0, 28, 0, 28)
            v81.Position = UDim2.new(0, 4, 0.5, -14)
            v81.BackgroundTransparency = 1
            v81.Image = "rbxassetid://0"
            v81.Parent = v79
            local v82 = Instance.new("UICorner")
            v82.CornerRadius = UDim.new(0, 6)
            v82.Parent = v81

            local v83 = Instance.new("TextLabel")
            v83.Size = UDim2.new(1, -40, 1, 0)
            v83.Position = UDim2.new(0, 40, 0, 0)
            v83.BackgroundTransparency = 1
            v83.Text = v78.name
            v83.TextColor3 = Color3.fromRGB(255, 255, 255)
            v83.TextSize = 12
            v83.Font = Enum.Font.Gotham
            v83.TextXAlignment = Enum.TextXAlignment.Left
            v83.Parent = v79

            v79.MouseButton1Click:Connect(function()
                v66(v78.fileName, v78.name, v36)
            end)
            v79.MouseEnter:Connect(function()
                v79.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            end)
            v79.MouseLeave:Connect(function()
                v79.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            end)

            task.spawn(function()
                local v84 = v14(v78.placeId)
                if v84 ~= "" then
                    v81.Image = v84
                end
            end)
        end
    end

    v53:GetPropertyChangedSignal("Text"):Connect(v72)
    v53.FocusLost:Connect(v72)
    v55.MouseButton1Click:Connect(v72)

    local v85 = v3
    local v86 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    v37.Size = UDim2.new(0, 0, 0, 0)
    v37.Position = UDim2.new(0.5, 0, 0.5, 0)
    task.wait()
    v85:Create(v37, v86, {Size = UDim2.new(0, 420, 0, 340), Position = UDim2.new(0.5, -210, 0.5, -170)}):Play()

    local v87 = Instance.new("TextButton")
    v87.Name = "CardSettingBtn"
    v87.Size = UDim2.new(0, 80, 0, 30)
    v87.Position = UDim2.new(1, -90, 1, -40)
    v87.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v87.Text = "卡密设置"
    v87.TextColor3 = Color3.fromRGB(255, 255, 255)
    v87.TextSize = 12
    v87.Font = Enum.Font.GothamBold
    v87.Parent = v37
    local v88 = Instance.new("UICorner")
    v88.CornerRadius = UDim.new(0, 6)
    v88.Parent = v87

    v87.MouseButton1Click:Connect(function()
        v9.showCardViewer(v35)
    end)
end

function v9._addSettingsButton()
    if v1:FindFirstChild("Trash_SettingsButton") then
        v1.Trash_SettingsButton:Destroy()
    end
    local v89 = Instance.new("TextButton")
    v89.Name = "Trash_SettingsButton"
    v89.Size = UDim2.new(0, 60, 0, 30)
    v89.Position = UDim2.new(1, -70, 1, -40)
    v89.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v89.Text = "设置"
    v89.TextColor3 = Color3.fromRGB(255, 255, 255)
    v89.TextSize = 14
    v89.Font = Enum.Font.GothamBold
    v89.Parent = v1
    local v90 = Instance.new("UICorner")
    v90.CornerRadius = UDim.new(0, 6)
    v90.Parent = v89
    return v89
end

function v9.showCardInput(v91, v92)
    pcall(function()
        if v1:FindFirstChild("CardVerifyInput") then
            v1:FindFirstChild("CardVerifyInput"):Destroy()
        end
    end)
    local v93 = Instance.new("ScreenGui")
    v93.Name = "CardVerifyInput"
    v93.Parent = v1
    v93.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v93.DisplayOrder = 999999
    v93.ResetOnSpawn = false
    v93.IgnoreGuiInset = true

    local v94 = Instance.new("Frame")
    v94.Size = UDim2.new(0, 420, 0, 170)
    v94.Position = UDim2.new(0.5, -210, 0.5, -85)
    v94.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    v94.BorderSizePixel = 0
    v94.Parent = v93
    local v95 = Instance.new("UICorner")
    v95.CornerRadius = UDim.new(0, 12)
    v95.Parent = v94

    local v96 = Instance.new("TextLabel")
    v96.Size = UDim2.new(1, 0, 0, 35)
    v96.Position = UDim2.new(0, 0, 0, 0)
    v96.BackgroundTransparency = 1
    v96.Text = "TrashHub - 卡密验证"
    v96.TextColor3 = Color3.fromRGB(255, 255, 255)
    v96.TextSize = 16
    v96.Font = Enum.Font.GothamBold
    v96.Parent = v94

    local v97 = Instance.new("TextLabel")
    v97.Size = UDim2.new(1, -20, 0, 18)
    v97.Position = UDim2.new(0, 10, 0, 38)
    v97.BackgroundTransparency = 1
    v97.Text = v92 and "卡密将保存在本地，下次自动加载" or "当前环境不支持保存，每次需手动输入"
    v97.TextColor3 = Color3.fromRGB(180, 180, 180)
    v97.TextSize = 11
    v97.Font = Enum.Font.Gotham
    v97.Parent = v94

    local v98 = Instance.new("TextBox")
    v98.Size = UDim2.new(1, -20, 0, 30)
    v98.Position = UDim2.new(0, 10, 0, 60)
    v98.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v98.Text = ""
    v98.PlaceholderText = "输入卡密..."
    v98.TextColor3 = Color3.fromRGB(255, 255, 255)
    v98.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    v98.TextSize = 13
    v98.Font = Enum.Font.Gotham
    v98.ClearTextOnFocus = false
    v98.Parent = v94
    local v99 = Instance.new("UICorner")
    v99.CornerRadius = UDim.new(0, 6)
    v99.Parent = v98

    local v100 = 100
    local v101 = 30
    local v102 = 20
    local v103 = v100 * 3 + v102 * 2
    local v104 = (420 - v103) / 2

    local v105 = Instance.new("TextButton")
    v105.Size = UDim2.new(0, v100, 0, v101)
    v105.Position = UDim2.new(0, v104, 0, 105)
    v105.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v105.Text = "确认卡密"
    v105.TextColor3 = Color3.fromRGB(255, 255, 255)
    v105.TextSize = 13
    v105.Font = Enum.Font.GothamBold
    v105.Parent = v94
    local v106 = Instance.new("UICorner")
    v106.CornerRadius = UDim.new(0, 6)
    v106.Parent = v105

    local v107 = Instance.new("TextButton")
    v107.Size = UDim2.new(0, v100, 0, v101)
    v107.Position = UDim2.new(0, v104 + v100 + v102, 0, 105)
    v107.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v107.Text = "清空配置"
    v107.TextColor3 = Color3.fromRGB(255, 255, 255)
    v107.TextSize = 13
    v107.Font = Enum.Font.GothamBold
    v107.Parent = v94
    local v108 = Instance.new("UICorner")
    v108.CornerRadius = UDim.new(0, 6)
    v108.Parent = v107

    local v109 = Instance.new("TextButton")
    v109.Size = UDim2.new(0, v100, 0, v101)
    v109.Position = UDim2.new(0, v104 + (v100 + v102) * 2, 0, 105)
    v109.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v109.Text = "初始化卡密"
    v109.TextColor3 = Color3.fromRGB(255, 255, 255)
    v109.TextSize = 13
    v109.Font = Enum.Font.GothamBold
    v109.Parent = v94
    local v110 = Instance.new("UICorner")
    v110.CornerRadius = UDim.new(0, 6)
    v110.Parent = v109

    v105.MouseButton1Click:Connect(function()
        local v111 = v98.Text
        if v111 and v111 ~= "" then
            v93:Destroy()
            v91(v111)
        else
            v96.Text = "卡密不能为空！"
            v96.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)

    local v112 = v91.deleteCardJson or function() return false end
    v107.MouseButton1Click:Connect(function()
        if v112() then
            v96.Text = "配置已清空！"
            v96.TextColor3 = Color3.fromRGB(100, 255, 100)
            v98.Text = ""
            task.wait(1)
            v96.Text = "TrashHub - 卡密验证"
            v96.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            v96.Text = "清空失败或无配置"
            v96.TextColor3 = Color3.fromRGB(255, 100, 100)
            task.wait(1)
            v96.Text = "TrashHub - 卡密验证"
            v96.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)

    v109.MouseButton1Click:Connect(function()
        if v112() then
            v96.Text = "已初始化，可输入新卡密"
            v96.TextColor3 = Color3.fromRGB(100, 255, 100)
            v98.Text = ""
            task.wait(1)
            v96.Text = "TrashHub - 卡密验证"
            v96.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            v96.Text = "无配置，可直接输入"
            v96.TextColor3 = Color3.fromRGB(255, 200, 100)
            task.wait(1)
            v96.Text = "TrashHub - 卡密验证"
            v96.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
end

function v9.showCardViewer(v113)
    local v114 = Instance.new("ScreenGui")
    v114.Name = "CardViewer"
    v114.Parent = v1
    v114.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v114.DisplayOrder = 999999
    v114.ResetOnSpawn = false
    v114.IgnoreGuiInset = true

    local v115 = Instance.new("Frame")
    v115.Size = UDim2.new(0, 400, 0, 150)
    v115.Position = UDim2.new(0.5, -200, 0.5, -75)
    v115.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    v115.BorderSizePixel = 0
    v115.Parent = v114
    local v116 = Instance.new("UICorner")
    v116.CornerRadius = UDim.new(0, 12)
    v116.Parent = v115

    local v117 = Instance.new("TextLabel")
    v117.Size = UDim2.new(1, 0, 0, 35)
    v117.Position = UDim2.new(0, 0, 0, 0)
    v117.BackgroundTransparency = 1
    v117.Text = "当前卡密"
    v117.TextColor3 = Color3.fromRGB(255, 255, 255)
    v117.TextSize = 16
    v117.Font = Enum.Font.GothamBold
    v117.Parent = v115

    local v118 = Instance.new("TextBox")
    v118.Size = UDim2.new(1, -40, 0, 30)
    v118.Position = UDim2.new(0, 20, 0, 50)
    v118.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v118.Text = v113 or "无已保存卡密"
    v118.TextColor3 = Color3.fromRGB(255, 255, 255)
    v118.TextSize = 13
    v118.Font = Enum.Font.Gotham
    v118.ClearTextOnFocus = false
    v118.TextEditable = false
    v118.Parent = v115
    local v119 = Instance.new("UICorner")
    v119.CornerRadius = UDim.new(0, 6)
    v119.Parent = v118

    local v120 = Instance.new("TextButton")
    v120.Size = UDim2.new(0, 100, 0, 30)
    v120.Position = UDim2.new(0.5, -50, 0, 100)
    v120.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    v120.Text = "关闭"
    v120.TextColor3 = Color3.fromRGB(255, 255, 255)
    v120.TextSize = 13
    v120.Font = Enum.Font.GothamBold
    v120.Parent = v115
    local v121 = Instance.new("UICorner")
    v121.CornerRadius = UDim.new(0, 6)
    v121.Parent = v120

    v120.MouseButton1Click:Connect(function()
        v114:Destroy()
    end)
end

local v122 = {}
v122.__index = v122

function v122.new()
    pcall(function()
        local v123 = v1:FindFirstChild("TrashLoadingScreen")
        if v123 then v123:Destroy() end
    end)
    local v124 = setmetatable({}, v122)
    v124.originalBrightness = v6.Brightness
    v124.originalAmbient = v6.Ambient
    v124.originalOutdoorAmbient = v6.OutdoorAmbient
    v124.gui = Instance.new("ScreenGui")
    v124.gui.Name = "TrashLoadingScreen"
    v124.gui.Parent = v1
    v124.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v124.gui.DisplayOrder = 999999
    v124.gui.ResetOnSpawn = false
    v124.gui.IgnoreGuiInset = true
    v124.triggered30 = false
    v124.triggered90 = false
    v124.triggered91 = false
    v124.colorCycleActive = false
    v124.colorCycleTween = nil
    v124.heartbeatConn = nil
    v124.rainbowBars = nil
    v124.isTimeout = false
    v124.startTime = tick()
    v124:_createUI()
    v124:_darkenScreen()
    v124:_createRainbowEffect()
    v124:_createColorBackground()
    v124:_checkTimeout()
    return v124
end

function v122:_checkTimeout()
    task.spawn(function()
        while v124.gui and v124.gui.Parent and not v124.triggered30 do
            task.wait(0.1)
            if tick() - v124.startTime >= 5 and not v124.triggered30 then
                v124.isTimeout = true
                if v124.title then
                    v124.title.TextColor3 = Color3.fromRGB(255, 0, 0)
                    task.wait(0.5)
                    v124.title.Text = "Timeout, click to skip"
                    v124.title.MouseButton1Click:Connect(function()
                        v124:fadeOutAndDestroy()
                    end)
                end
                break
            end
        end
    end)
end

function v122:_createUI()
    v124.bg = Instance.new("Frame")
    v124.bg.Name = "bg"
    v124.bg.Size = UDim2.new(1, 0, 1, 0)
    v124.bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    v124.bg.BackgroundTransparency = 0.3
    v124.bg.BorderSizePixel = 0
    v124.bg.Parent = v124.gui

    local v125 = Instance.new("Frame")
    v125.Name = "centerContainer"
    v125.Size = UDim2.new(0, 500, 0, 260)
    v125.Position = UDim2.new(0.5, -250, 0.5, -130)
    v125.BackgroundTransparency = 1
    v125.Parent = v124.gui

    v124.title = Instance.new("TextLabel")
    v124.title.Name = "titleLabel"
    v124.title.Size = UDim2.new(1, 0, 0, 60)
    v124.title.Position = UDim2.new(0, 0, 0, 0)
    v124.title.BackgroundTransparency = 1
    v124.title.Text = "TrashHub"
    v124.title.TextColor3 = Color3.fromRGB(255, 200, 100)
    v124.title.TextStrokeTransparency = 0
    v124.title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    v124.title.Font = Enum.Font.GothamBold
    v124.title.TextSize = 48
    v124.title.TextXAlignment = Enum.TextXAlignment.Center
    v124.title.TextYAlignment = Enum.TextYAlignment.Center
    v124.title.Parent = v125

    v124.status = Instance.new("TextLabel")
    v124.status.Name = "statusLabel"
    v124.status.Size = UDim2.new(1, 0, 0, 30)
    v124.status.Position = UDim2.new(0, 0, 0, 65)
    v124.status.BackgroundTransparency = 1
    v124.status.Text = "Initializing..."
    v124.status.TextColor3 = Color3.fromRGB(255, 255, 255)
    v124.status.TextStrokeTransparency = 0.3
    v124.status.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    v124.status.Font = Enum.Font.Gotham
    v124.status.TextSize = 18
    v124.status.TextXAlignment = Enum.TextXAlignment.Center
    v124.status.Parent = v125

    v124.filesLabel = Instance.new("TextLabel")
    v124.filesLabel.Name = "filesLabel"
    v124.filesLabel.Size = UDim2.new(1, -20, 0, 18)
    v124.filesLabel.Position = UDim2.new(0, 10, 0, 100)
    v124.filesLabel.BackgroundTransparency = 1
    v124.filesLabel.Text = "Deleting files:"
    v124.filesLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    v124.filesLabel.TextStrokeTransparency = 0.6
    v124.filesLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    v124.filesLabel.Font = Enum.Font.Gotham
    v124.filesLabel.TextSize = 13
    v124.filesLabel.TextXAlignment = Enum.TextXAlignment.Center
    v124.filesLabel.Parent = v125

    v124.currentFile = Instance.new("TextLabel")
    v124.currentFile.Name = "currentFileLabel"
    v124.currentFile.Size = UDim2.new(1, -20, 0, 18)
    v124.currentFile.Position = UDim2.new(0, 10, 0, 118)
    v124.currentFile.BackgroundTransparency = 1
    v124.currentFile.Text = ""
    v124.currentFile.TextColor3 = Color3.fromRGB(255, 200, 100)
    v124.currentFile.TextStrokeTransparency = 0.5
    v124.currentFile.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    v124.currentFile.Font = Enum.Font.Gotham
    v124.currentFile.TextSize = 13
    v124.currentFile.TextXAlignment = Enum.TextXAlignment.Center
    v124.currentFile.Parent = v125

    v124.downloadInfo = Instance.new("TextLabel")
    v124.downloadInfo.Name = "downloadInfoLabel"
    v124.downloadInfo.Size = UDim2.new(1, -20, 0, 18)
    v124.downloadInfo.Position = UDim2.new(0, 10, 0, 100)
    v124.downloadInfo.BackgroundTransparency = 1
    v124.downloadInfo.Text = ""
    v124.downloadInfo.TextColor3 = Color3.fromRGB(255, 200, 100)
    v124.downloadInfo.TextStrokeTransparency = 0.5
    v124.downloadInfo.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    v124.downloadInfo.Font = Enum.Font.Gotham
    v124.downloadInfo.TextSize = 13
    v124.downloadInfo.TextXAlignment = Enum.TextXAlignment.Center
    v124.downloadInfo.Visible = false
    v124.downloadInfo.Parent = v125

    local v126 = Instance.new("Frame")
    v126.Name = "progressBg"
    v126.Size = UDim2.new(1, -40, 0, 20)
    v126.Position = UDim2.new(0, 20, 0, 145)
    v126.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    v126.BorderSizePixel = 0
    v126.Parent = v125
    local v127 = Instance.new("UICorner")
    v127.CornerRadius = UDim.new(0, 10)
    v127.Parent = v126
    v124.progressBg = v126

    v124.progressFill = Instance.new("Frame")
    v124.progressFill.Name = "progressFill"
    v124.progressFill.Size = UDim2.new(0, 0, 1, 0)
    v124.progressFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    v124.progressFill.BorderSizePixel = 0
    v124.progressFill.Parent = v126
    local v128 = Instance.new("UICorner")
    v128.CornerRadius = UDim.new(0, 10)
    v128.Parent = v124.progressFill

    v124.percent = Instance.new("TextLabel")
    v124.percent.Name = "percentLabel"
    v124.percent.Size = UDim2.new(0, 60, 0, 20)
    v124.percent.Position = UDim2.new(0.5, -30, 0, 170)
    v124.percent.BackgroundTransparency = 1
    v124.percent.Text = "0%"
    v124.percent.TextColor3 = Color3.fromRGB(255, 255, 255)
    v124.percent.TextStrokeTransparency = 0.3
    v124.percent.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    v124.percent.Font = Enum.Font.GothamBold
    v124.percent.TextSize = 16
    v124.percent.TextXAlignment = Enum.TextXAlignment.Center
    v124.percent.Parent = v125
end

function v122:_createColorBackground()
    v124.colorBackground = Instance.new("Frame")
    v124.colorBackground.Name = "ColorBackground"
    v124.colorBackground.Size = UDim2.new(1, 0, 1, 0)
    v124.colorBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
    v124.colorBackground.AnchorPoint = Vector2.new(0.5, 0.5)
    v124.colorBackground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    v124.colorBackground.BackgroundTransparency = 1
    v124.colorBackground.BorderSizePixel = 0
    v124.colorBackground.ZIndex = 1
    v124.colorBackground.Parent = v124.gui
end

function v122:_createRainbowEffect()
    local v129 = Instance.new("Frame")
    v129.Name = "RainbowEffect"
    v129.Size = UDim2.new(1, 0, 1, 0)
    v129.BackgroundTransparency = 1
    v129.ZIndex = 2
    v129.Parent = v124.gui

    local v130 = 55
    local v131 = 200
    local v132 = 0.8
    local v133 = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(128, 0, 128)
    }
    local v134 = {}

    local function v135(v136, v137)
        local v138 = (v136 == 1 or v136 == 3)
        local v139 = (v136 == 1)
        local v140 = (v136 == 3)
        local v141 = (v136 == 2)
        local v142 = (v136 == 4)
        local v143 = Instance.new("Frame")
        v143.Name = string.format("Bar_%d_%d", v136, v137)
        v143.BorderSizePixel = 0
        v143.ZIndex = 2
        v143.BackgroundTransparency = 1
        v143.Parent = v129

        if v138 then
            v143.Size = UDim2.new(1 / v131, 0, 0, v130)
            if v139 then
                v143.AnchorPoint = Vector2.new(0.5, 1)
                v143.Position = UDim2.new((v137 - 0.5) / v131, 0, 1, 0)
            else
                v143.AnchorPoint = Vector2.new(0.5, 0)
                v143.Position = UDim2.new((v137 - 0.5) / v131, 0, 0, 0)
            end
        else
            v143.Size = UDim2.new(0, v130, 1 / v131, 0)
            if v141 then
                v143.AnchorPoint = Vector2.new(1, 0.5)
                v143.Position = UDim2.new(1, 0, (v137 - 0.5) / v131, 0)
            else
                v143.AnchorPoint = Vector2.new(0, 0.5)
                v143.Position = UDim2.new(0, 0, (v137 - 0.5) / v131, 0)
            end
        end

        local v144 = Instance.new("UIGradient")
        if v136 == 1 then
            v144.Rotation = 270
        elseif v136 == 2 then
            v144.Rotation = 180
        elseif v136 == 3 then
            v144.Rotation = 90
        else
            v144.Rotation = 0
        end
        v144.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
        v144.Parent = v143

        local v145
        if v136 == 1 then
            v145 = (v137 - 0.5) / (v131 * 4)
        elseif v136 == 2 then
            v145 = (v131 + v137 - 0.5) / (v131 * 4)
        elseif v136 == 3 then
            v145 = (2 * v131 + v137 - 0.5) / (v131 * 4)
        else
            v145 = (3 * v131 + v137 - 0.5) / (v131 * 4)
        end
        table.insert(v134, {bar = v143, t_global = v145, isHorizontal = v138})

        local v146 = v138 and UDim2.new(1 / v131, 0, 0, v130) or UDim2.new(0, v130, 1 / v131, 0)
        local v147 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        v3:Create(v143, v147, {Size = v146, BackgroundTransparency = 0}):Play()
    end

    for v136 = 1, 4 do
        for v137 = 1, v131 do
            v135(v136, v137)
        end
    end

    v124.rainbowBars = v134
    local v148 = tick()
    v124.heartbeatConn = v7.Heartbeat:Connect(function()
        local v149 = (tick() - v148) * v132
        local v150 = v149 % 1
        for _, v151 in ipairs(v134) do
            local v152 = v151.t_global - v150
            if v152 < 0 then v152 = v152 + 1 end
            local v153 = math.floor(v152 * #v133) + 1
            local v154 = (v152 * #v133) % 1
            local v155 = v133[v153]
            local v156 = v133[v153 % #v133 + 1]
            v151.bar.BackgroundColor3 = v10(v155, v156, v154)
        end
    end)
end

function v122:_darkenScreen()
    for v157 = 1, 30 do
        local v158 = v157 / 30
        v6.Brightness = v124.originalBrightness - (v124.originalBrightness - 0.4) * v158
        v6.Ambient = Color3.new(
            v124.originalAmbient.R - (v124.originalAmbient.R - 0.4) * v158,
            v124.originalAmbient.G - (v124.originalAmbient.G - 0.4) * v158,
            v124.originalAmbient.B - (v124.originalAmbient.B - 0.4) * v158
        )
        v6.OutdoorAmbient = Color3.new(
            v124.originalOutdoorAmbient.R - (v124.originalOutdoorAmbient.R - 0.4) * v158,
            v124.originalOutdoorAmbient.G - (v124.originalOutdoorAmbient.G - 0.4) * v158,
            v124.originalOutdoorAmbient.B - (v124.originalOutdoorAmbient.B - 0.4) * v158
        )
        task.wait(0.01)
    end
    v6.Brightness = 0.4
    v6.Ambient = Color3.new(0.4, 0.4, 0.4)
    v6.OutdoorAmbient = Color3.new(0.4, 0.4, 0.4)
end

function v122:updateProgress(v159, v160, v161, v162)
    if not v124.gui or not v124.gui.Parent then return false end
    if v160 then v124.status.Text = v160 end
    local v163 = v162 == true
    if v124.filesLabel then v124.filesLabel.Visible = v163 end
    if v124.currentFile then v124.currentFile.Visible = v163 end
    if v124.downloadInfo then v124.downloadInfo.Visible = not v163 end
    if v161 then
        if v163 then
            if v124.currentFile then v124.currentFile.Text = v161 end
        else
            if v124.downloadInfo then v124.downloadInfo.Text = v161 end
        end
    end
    if v124.progressFill and type(v159) == "number" then
        v124.progressFill:TweenSize(UDim2.new(v159 / 100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.3, true)
    end
    if v124.percent then
        v124.percent.Text = math.floor(v159) .. "%"
    end
    if v159 >= 30 and not v124.triggered30 then
        v124.triggered30 = true
        if v124.colorBackground then
            v124.colorBackground.BackgroundTransparency = 0.9
        end
        v124:_startColorCycle()
    end
    if v159 >= 90 and not v124.triggered90 then
        v124.triggered90 = true
        v124:stopColorCycle()
        if v124.colorBackground then
            v3:Create(v124.colorBackground, TweenInfo.new(1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(0, 255, 0),
                BackgroundTransparency = 1,
                Size = UDim2.new(2, 0, 2, 0)
            }):Play()
        end
    end
    if v159 >= 91 and not v124.triggered91 then
        v124.triggered91 = true
        if v124.colorCycleTween then v124.colorCycleTween:Cancel() end
        if v124.colorBackground then
            v124.colorBackground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            v124.colorBackground.BackgroundTransparency = 0
            v124.colorBackground.Size = UDim2.new(1, 0, 1, 0)
            v3:Create(v124.colorBackground, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1,
                Size = UDim2.new(2, 0, 2, 0)
            }):Play()
        end
        if v124.rainbowBars then
            for _, v151 in ipairs(v124.rainbowBars) do
                local v164 = v151.bar
                if v164 then
                    local v165 = v151.isHorizontal and UDim2.new(v164.Size.X.Scale, v164.Size.X.Offset, 0, 0) or UDim2.new(0, 0, v164.Size.Y.Scale, v164.Size.Y.Offset)
                    v3:Create(v164, TweenInfo.new(0.8), {Size = v165, BackgroundTransparency = 1}):Play()
                end
            end
        end
        if v124.heartbeatConn then
            pcall(function() v124.heartbeatConn:Disconnect() end)
        end
    end
    return true
end

function v122:_startColorCycle()
    local v133 = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(128, 0, 128)
    }
    local v166 = 1
    local function v167()
        if not v124.colorCycleActive then return end
        local v168 = v133[v166]
        v166 = v166 % #v133 + 1
        if v124.colorBackground then
            v124.colorCycleTween = v3:Create(v124.colorBackground, TweenInfo.new(0.5), {BackgroundColor3 = v168})
            v124.colorCycleTween.Completed:Connect(v167)
            v124.colorCycleTween:Play()
        end
    end
    v124.colorCycleActive = true
    v167()
end

function v122:stopColorCycle()
    v124.colorCycleActive = false
    if v124.colorCycleTween then
        v124.colorCycleTween:Cancel()
    end
end

function v122:forceCleanupRainbow()
    v124:stopColorCycle()
    pcall(function()
        if v124.heartbeatConn then
            v124.heartbeatConn:Disconnect()
            v124.heartbeatConn = nil
        end
    end)
    pcall(function()
        if v124.gui and v124.gui:FindFirstChild("RainbowEffect") then
            v124.gui.RainbowEffect.Visible = false
        end
    end)
end

function v122:fadeOutDeleteUI()
    pcall(function()
        if not v124.filesLabel or not v124.currentFile then return end
        local v169 = TweenInfo.new(0.3)
        v3:Create(v124.filesLabel, v169, {TextTransparency = 1}):Play()
        v3:Create(v124.currentFile, v169, {TextTransparency = 1}):Play()
        task.wait(0.3)
        v124.filesLabel.Visible = false
        v124.currentFile.Visible = false
        v124.filesLabel.TextTransparency = 0
        v124.currentFile.TextTransparency = 0
    end)
end

function v122:setTitleWithAnimation(v170)
    pcall(function()
        if not v124.title then return end
        local v171 = TweenInfo.new(0.4)
        v3:Create(v124.title, v171, {TextTransparency = 1}):Play()
        task.wait(0.4)
        v124.title.Text = v170
        v3:Create(v124.title, v171, {TextTransparency = 0}):Play()
        task.wait(0.4)
    end)
end

function v122:fadeOutAndDestroy()
    if not v124.gui then return end
    v124:forceCleanupRainbow()
    local v172 = {
        v124.title, v124.status, v124.filesLabel, v124.currentFile,
        v124.downloadInfo, v124.percent, v124.progressFill, v124.progressBg,
        v124.bg, v124.colorBackground
    }
    for v157 = 1, 30 do
        local v158 = v157 / 30
        for _, v173 in ipairs(v172) do
            if v173 then
                if v173 == v124.bg or v173 == v124.progressBg then
                    if v173:IsA("Frame") then
                        v173.BackgroundTransparency = 0.3 + v158 * 0.7
                    end
                elseif v173:IsA("TextLabel") then
                    v173.TextTransparency = v158
                elseif v173 == v124.progressFill or v173 == v124.colorBackground then
                    if v173:IsA("Frame") then
                        v173.BackgroundTransparency = v158
                    end
                end
            end
        end
        task.wait(0.01)
    end
    for v157 = 1, 30 do
        local v158 = v157 / 30
        v6.Brightness = 0.4 + (v124.originalBrightness - 0.4) * v158
        v6.Ambient = Color3.new(
            0.4 + (v124.originalAmbient.R - 0.4) * v158,
            0.4 + (v124.originalAmbient.G - 0.4) * v158,
            0.4 + (v124.originalAmbient.B - 0.4) * v158
        )
        v6.OutdoorAmbient = Color3.new(
            0.4 + (v124.originalOutdoorAmbient.R - 0.4) * v158,
            0.4 + (v124.originalOutdoorAmbient.G - 0.4) * v158,
            0.4 + (v124.originalOutdoorAmbient.B - 0.4) * v158
        )
        task.wait(0.01)
    end
    v6.Brightness = v124.originalBrightness
    v6.Ambient = v124.originalAmbient
    v6.OutdoorAmbient = v124.originalOutdoorAmbient
    v124.gui:Destroy()
end

v122.destroy = v122.fadeOutAndDestroy

v9.LoadingAnimation = v122

return v9
