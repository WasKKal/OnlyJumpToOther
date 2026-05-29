local v1, v2, v3, v4, v5 = cloneref(game:GetService("Workspace")), cloneref(game:GetService("RunService")), cloneref(game:GetService("Players")), game:GetService("CoreGui"), cloneref(game:GetService("Lighting"))

local v6 = {
    v7 = true,
    v8 = true,
    v9 = 250,
    v10 = 13,
    v11 = 6,
    v12 = 0.5,
    v13 = {
        v14 = true,
        v15 = false,
        v16 = false,
    },
    v17 = { 
        v18 = false, v19 = Color3.fromRGB(0, 255, 0),
        v20 = true, v21 = Color3.fromRGB(0, 255, 0),
        v22 = false, v23 = Color3.fromRGB(255, 0, 0),
    },
    v24 = {
        v25 = {
            v26 = true,
            v27 = true,
            v28 = Color3.fromRGB(0, 200, 255),
            v29 = 70,
            v30 = Color3.fromRGB(255, 255, 255),
            v31 = 30,
            v32 = true,
        },
        v33 = {
            v34 = true,
            v35 = Color3.fromRGB(170, 221, 255),
        },
        v36 = {
            v37 = true,
        },
        v38 = {
            v39 = true, 
            v40 = "Text",
            v41 = Color3.fromRGB(200, 200, 200),
        },
        v42 = {
            v43 = true, v44 = Color3.fromRGB(0, 200, 255),
            v45 = true,
            v46 = false,
            v47 = Color3.fromRGB(255, 255, 255), v48 = Color3.fromRGB(119, 120, 255),
        },
        v49 = {
            v50 = true,  
            v51 = false,
            v52 = true,
            v53 = Color3.fromRGB(255, 255, 255),
            v54 = 2.5,
            v55 = true, v56 = Color3.fromRGB(200, 0, 0), v57 = Color3.fromRGB(255, 150, 0), v58 = Color3.fromRGB(0, 200, 0), 
        },
        v59 = {
            v60 = true,
            v61 = 120,
            v62 = true, v63 = Color3.fromRGB(100, 150, 255), v64 = Color3.fromRGB(200, 220, 255), 
            v65 = true, v66 = Color3.fromRGB(20, 30, 50), v67 = Color3.fromRGB(10, 20, 40), 
            v68 = {
                v69 = true,
                v70 = 0.85,
                v71 = Color3.fromRGB(0, 0, 0),
            },
            v72 = {
                v73 = true,
                v74 = Color3.fromRGB(100, 150, 255),
            },
            v75 = {
                v76 = true,
                v77 = Color3.fromRGB(150, 200, 255),
            },
        };
    };
    v78 = {
        v79 = v2;
    };
    v80 = {};
}

local v81 = v6.v78;
local v82 = v3.LocalPlayer;
local v83 = game.Workspace.CurrentCamera;
local v84 = v1.CurrentCamera;
local v85, v86 = -45, tick();

local v87 = {
    ["Wooden Bow"] = "http://www.roblox.com/asset/?id=17677465400",
    ["Crossbow"] = "http://www.roblox.com/asset/?id=17677473017",
    ["Salvaged SMG"] = "http://www.roblox.com/asset/?id=17677463033",
    ["Salvaged AK47"] = "http://www.roblox.com/asset/?id=17677455113",
    ["Salvaged AK74u"] = "http://www.roblox.com/asset/?id=17677442346",
    ["Salvaged M14"] = "http://www.roblox.com/asset/?id=17677444642",
    ["Salvaged Python"] = "http://www.roblox.com/asset/?id=17677451737",
    ["Military PKM"] = "http://www.roblox.com/asset/?id=17677449448",
    ["Military M4A1"] = "http://www.roblox.com/asset/?id=17677479536",
    ["Bruno's M4A1"] = "http://www.roblox.com/asset/?id=17677471185",
    ["Military Barrett"] = "http://www.roblox.com/asset/?id=17677482998",
    ["Salvaged Skorpion"] = "http://www.roblox.com/asset/?id=17677459658",
    ["Salvaged Pump Action"] = "http://www.roblox.com/asset/?id=17677457186",
    ["Military AA12"] = "http://www.roblox.com/asset/?id=17677475227",
    ["Salvaged Break Action"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged Pipe Rifle"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged P250"] = "http://www.roblox.com/asset/?id=17677447257",
    ["Nail Gun"] = "http://www.roblox.com/asset/?id=17677484756"
};

local v88 = {}
do
    function v88:v89(v90, v91)
        local v92 = typeof(v90) == 'string' and Instance.new(v90) or v90
        for v93, v94 in pairs(v91) do
            v92[v93] = v94
        end
        return v92;
    end
    
    function v88:v95(v96, v97)
        local v98 = math.max(0.1, 1 - (v97 / v6.v9))
        if v96:IsA("TextLabel") then
            v96.TextTransparency = 1 - v98
        elseif v96:IsA("ImageLabel") then
            v96.ImageTransparency = 1 - v98
        elseif v96:IsA("UIStroke") then
            v96.Transparency = 1 - v98
        elseif v96:IsA("Frame") and (v96 == v99 or v96 == v100) then
            v96.BackgroundTransparency = 1 - v98
        elseif v96:IsA("Frame") then
            v96.BackgroundTransparency = 1 - v98
        elseif v96:IsA("Highlight") then
            v96.FillTransparency = 1 - v98
            v96.OutlineTransparency = 1 - v98
        end;
    end;  
end;

do
    local v101 = v88:v89("ScreenGui", {
        Parent = v4,
        Name = "ESPHolder",
    });

    local v102 = function(v103)
        if v101:FindFirstChild(v103.Name) then
            v101[v103.Name]:Destroy()
        end
    end

    local v104 = function(v105)
        coroutine.wrap(v102)(v105)
        local v106 = v88:v89("TextLabel", {Parent = v101, Position = UDim2.new(0.5, 0, 0, -11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = v6.v10, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local v107 = v88:v89("TextLabel", {Parent = v101, Position = UDim2.new(0.5, 0, 0, 11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = v6.v10, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local v108 = v88:v89("TextLabel", {Parent = v101, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = v6.v10, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local v109 = v88:v89("Frame", {Parent = v101, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.85, BorderSizePixel = 0})
        local v110 = v88:v89("UIGradient", {Parent = v109, Enabled = v6.v24.v59.v65, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, v6.v24.v59.v66), ColorSequenceKeypoint.new(1, v6.v24.v59.v67)}})
        local v111 = v88:v89("UIStroke", {Parent = v109, Enabled = v6.v24.v59.v62, Transparency = 0, Color = Color3.fromRGB(100, 150, 255), LineJoinMode = Enum.LineJoinMode.Miter, Thickness = 1})
        local v112 = v88:v89("UIGradient", {Parent = v111, Enabled = v6.v24.v59.v62, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, v6.v24.v59.v63), ColorSequenceKeypoint.new(1, v6.v24.v59.v64)}})
        local v113 = v88:v89("Frame", {Parent = v101, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0})
        local v114 = v88:v89("Frame", {Parent = v101, ZIndex = -1, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0})
        local v115 = v88:v89("UIGradient", {Parent = v113, Enabled = v6.v24.v49.v55, Rotation = -90, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, v6.v24.v49.v56), ColorSequenceKeypoint.new(0.5, v6.v24.v49.v57), ColorSequenceKeypoint.new(1, v6.v24.v49.v58)}})
        local v116 = v88:v89("ImageLabel", {Parent = v101, BackgroundTransparency = 1, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Size = UDim2.new(0, 40, 0, 40)})
        local v117 = v88:v89("UIGradient", {Parent = v116, Rotation = -90, Enabled = v6.v24.v42.v46, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, v6.v24.v42.v47), ColorSequenceKeypoint.new(1, v6.v24.v42.v48)}})
        
        local v118 = v88:v89("Highlight", {Parent = v101, FillTransparency = 1, OutlineTransparency = 0, OutlineColor = Color3.fromRGB(255, 255, 255), DepthMode = "AlwaysOnTop"})
        
        local v119 = v88:v89("Frame", {Parent = v101, BackgroundColor3 = v6.v24.v59.v75.v77, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0})
        local v120 = v88:v89("Frame", {Parent = v101, BackgroundColor3 = v6.v24.v59.v75.v77, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0})
        local v121 = v88:v89("Frame", {Parent = v101, BackgroundColor3 = v6.v24.v59.v75.v77, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0})
        local v122 = v88:v89("Frame", {Parent = v101, BackgroundColor3 = v6.v24.v59.v75.v77, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0})
        local v123 = v88:v89("Frame", {Parent = v101, BackgroundColor3 = v6.v24.v59.v75.v77, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0})
        local v124 = v88:v89("Frame", {Parent = v101, BackgroundColor3 = v6.v24.v59.v75.v77, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0})
        local v125 = v88:v89("Frame", {Parent = v101, BackgroundColor3 = v6.v24.v59.v75.v77, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0})
        local v126 = v88:v89("Frame", {Parent = v101, BackgroundColor3 = v6.v24.v59.v75.v77, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0})
        
        local function v127(v128)
            local v129 = Instance.new("UICorner")
            v129.CornerRadius = UDim.new(0, 4)
            v129.Parent = v128
        end
        v127(v119)
        v127(v120)
        v127(v121)
        v127(v122)
        v127(v123)
        v127(v124)
        v127(v125)
        v127(v126)
        
        local v130 = v88:v89("TextLabel", {Parent = v101, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = v6.v10, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        local v131 = v88:v89("TextLabel", {Parent = v101, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = v6.v10, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        
        local v132 = function()
            local v133;
            local function v134()
                v109.Visible = false;
                v106.Visible = false;
                v107.Visible = false;
                v108.Visible = false;
                v113.Visible = false;
                v114.Visible = false;
                v116.Visible = false;
                v119.Visible = false;
                v120.Visible = false;
                v121.Visible = false;
                v122.Visible = false;
                v123.Visible = false;
                v124.Visible = false;
                v125.Visible = false;
                v126.Visible = false;
                v130.Visible = false;
                v118.Enabled = false;
                v131.Visible = false;
                if not v105 then
                    v101:Destroy();
                    v133:Disconnect();
                end
            end
            
            v133 = v81.v79.RenderStepped:Connect(function()
                if v105.Character and v105.Character:FindFirstChild("HumanoidRootPart") then
                    local v135 = v105.Character.HumanoidRootPart
                    local v136 = v105.Character:WaitForChild("Humanoid");
                    local v137, v138 = v84:WorldToScreenPoint(v135.Position)
                    local v139 = (v84.CFrame.Position - v135.Position).Magnitude / 3.5714285714
                    
                    if v138 and v139 <= v6.v9 then
                        local v140 = v135.Size.Y
                        local v141 = (v140 * v84.ViewportSize.Y) / (v137.Z * 2)
                        local v142, v143 = 3 * v141, 4.5 * v141
                        
                        local v144 = math.max(0.3, 1 - (v139 / v6.v9))
                        local v145 = math.max(v6.v11, v6.v10 * v144)
                        local v146 = math.max(v6.v12, 1.5 * v144)
                        
                        if v6.v13.v14 then
                            v88:v95(v109, v139)
                            v88:v95(v111, v139)
                            v88:v95(v106, v139)
                            v88:v95(v107, v139)
                            v88:v95(v108, v139)
                            v88:v95(v113, v139)
                            v88:v95(v114, v139)
                            v88:v95(v116, v139)
                            v88:v95(v119, v139)
                            v88:v95(v120, v139)
                            v88:v95(v121, v139)
                            v88:v95(v122, v139)
                            v88:v95(v123, v139)
                            v88:v95(v124, v139)
                            v88:v95(v125, v139)
                            v88:v95(v126, v139)
                            v88:v95(v118, v139)
                            v88:v95(v130, v139)
                            v88:v95(v131, v139)
                        end

                        if v6.v8 and v105 ~= v82 and ((v82.Team ~= v105.Team and v105.Team) or (not v82.Team and not v105.Team)) and v105.Character and v105.Character:FindFirstChild("HumanoidRootPart") and v105.Character:FindFirstChild("Humanoid") then

                            do
                                local v147 = tick() * 2
                                local v148 = (v147 % 6) / 6
                                local v149 = Color3.fromHSV(v148, 1, 1)
                                v118.Adornee = v105.Character
                                v118.Enabled = v6.v24.v25.v26
                                v118.FillColor = v149
                                v118.OutlineColor = v149
                                do
                                    if v6.v24.v25.v27 then
                                        local v150 = math.atan(math.sin(tick() * 2)) * 2 / math.pi
                                        v118.FillTransparency = v6.v24.v25.v29 * v150 * 0.01
                                        v118.OutlineTransparency = v6.v24.v25.v31 * v150 * 0.01
                                    end
                                end
                                if v6.v24.v25.v32 then
                                    v118.DepthMode = "Occluded"
                                else
                                    v118.DepthMode = "AlwaysOnTop"
                                end
                            end;

                            do
                                local v151 = v146
                                local v152 = v142 / 5
                                local v153 = v151
                                
                                v119.Visible = v6.v24.v59.v75.v76
                                v119.Position = UDim2.new(0, v137.X - v142/2, 0, v137.Y - v143/2)
                                v119.Size = UDim2.new(0, v152, 0, v153)
                                
                                v120.Visible = v6.v24.v59.v75.v76
                                v120.Position = UDim2.new(0, v137.X - v142/2, 0, v137.Y - v143/2)
                                v120.Size = UDim2.new(0, v153, 0, v152)
                                
                                v121.Visible = v6.v24.v59.v75.v76
                                v121.Position = UDim2.new(0, v137.X + v142/2 - v152, 0, v137.Y - v143/2)
                                v121.Size = UDim2.new(0, v152, 0, v153)
                                
                                v122.Visible = v6.v24.v59.v75.v76
                                v122.Position = UDim2.new(0, v137.X + v142/2 - v153, 0, v137.Y - v143/2)
                                v122.Size = UDim2.new(0, v153, 0, v152)
                                
                                v123.Visible = v6.v24.v59.v75.v76
                                v123.Position = UDim2.new(0, v137.X - v142/2, 0, v137.Y + v143/2 - v153)
                                v123.Size = UDim2.new(0, v152, 0, v153)
                                
                                v124.Visible = v6.v24.v59.v75.v76
                                v124.Position = UDim2.new(0, v137.X - v142/2, 0, v137.Y + v143/2 - v152)
                                v124.Size = UDim2.new(0, v153, 0, v152)
                                
                                v125.Visible = v6.v24.v59.v75.v76
                                v125.Position = UDim2.new(0, v137.X + v142/2 - v152, 0, v137.Y + v143/2 - v153)
                                v125.Size = UDim2.new(0, v152, 0, v153)
                                
                                v126.Visible = v6.v24.v59.v75.v76
                                v126.Position = UDim2.new(0, v137.X + v142/2 - v153, 0, v137.Y + v143/2 - v152)
                                v126.Size = UDim2.new(0, v153, 0, v152)
                            end

                            do
                                v109.Position = UDim2.new(0, v137.X - v142 / 2, 0, v137.Y - v143 / 2)
                                v109.Size = UDim2.new(0, v142, 0, v143)
                                v109.Visible = v6.v24.v59.v72.v73;

                                if v6.v24.v59.v68.v69 then
                                    v109.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                    if v6.v24.v59.v65 then
                                        v109.BackgroundTransparency = v6.v24.v59.v68.v70;
                                    else
                                        v109.BackgroundTransparency = 1
                                    end
                                    v109.BorderSizePixel = 1
                                else
                                    v109.BackgroundTransparency = 1
                                end
                                v111.Thickness = v146
                                v85 = v85 + (tick() - v86) * v6.v24.v59.v61 * math.cos(math.pi / 4 * tick() - math.pi / 2)
                                if v6.v24.v59.v60 then
                                    v110.Rotation = v85
                                    v112.Rotation = v85
                                else
                                    v110.Rotation = -45
                                    v112.Rotation = -45
                                end
                                v86 = tick()
                            end

                            do  
                                local v154 = v136.Health / v136.MaxHealth;
                                v113.Visible = v6.v24.v49.v50;
                                v113.Position = UDim2.new(0, v137.X - v142 / 2 - 6, 0, v137.Y - v143 / 2 + v143 * (1 - v154))  
                                v113.Size = UDim2.new(0, v6.v24.v49.v54, 0, v143 * v154)  
                                
                                v114.Visible = v6.v24.v49.v50;
                                v114.Position = UDim2.new(0, v137.X - v142 / 2 - 6, 0, v137.Y - v143 / 2)  
                                v114.Size = UDim2.new(0, v6.v24.v49.v54, 0, v143)
                            end

                            do
                                v106.Visible = v6.v24.v33.v34
                                v106.TextSize = v145
                                if v6.v17.v20 and v82:IsFriendsWith(v105.UserId) then
                                    v106.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s', v6.v17.v21.R * 255, v6.v17.v21.G * 255, v6.v17.v21.B * 255, v105.Name)
                                else
                                    v106.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s', 255, 0, 0, v105.Name)
                                end
                                v106.Position = UDim2.new(0, v137.X, 0, v137.Y - v143 / 2 - 9)
                            end
                            
                            do
                                if v6.v24.v38.v39 then
                                    if v6.v24.v38.v40 == "Bottom" then
                                        v108.Position = UDim2.new(0, v137.X, 0, v137.Y + v143 / 2 + 18)
                                        v116.Position = UDim2.new(0, v137.X - 21, 0, v137.Y + v143 / 2 + 15);
                                        v107.Position = UDim2.new(0, v137.X, 0, v137.Y + v143 / 2 + 7)
                                        v107.Text = string.format("%d meters", math.floor(v139))
                                        v107.Visible = true
                                        v107.TextSize = v145
                                    elseif v6.v24.v38.v40 == "Text" then
                                        v108.Position = UDim2.new(0, v137.X, 0, v137.Y + v143 / 2 + 8)
                                        v116.Position = UDim2.new(0, v137.X - 21, 0, v137.Y + v143 / 2 + 5);
                                        v107.Visible = false
                                        v106.TextSize = v145
                                        if v6.v17.v20 and v82:IsFriendsWith(v105.UserId) then
                                            v106.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s [%d]', v6.v17.v21.R * 255, v6.v17.v21.G * 255, v6.v17.v21.B * 255, v105.Name, math.floor(v139))
                                        else
                                            v106.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s [%d]', 255, 0, 0, v105.Name, math.floor(v139))
                                        end
                                        v106.Visible = v6.v24.v33.v34
                                    end
                                end
                            end

                            do
                                v108.Text = "none"
                                v108.Visible = v6.v24.v42.v43
                                v108.TextSize = v145
                                v116.Size = UDim2.new(0, 40 * v144, 0, 40 * v144)
                            end                            
                        else
                            v134();
                        end
                    else
                        v134();
                    end
                else
                    v134();
                end
            end)
        end
        coroutine.wrap(v132)();
    end
    do
        for v155, v156 in pairs(game:GetService("Players"):GetPlayers()) do
            if v156.Name ~= v82.Name then
                coroutine.wrap(v104)(v156)
            end      
        end
        
        game:GetService("Players").PlayerAdded:Connect(function(v157)
            coroutine.wrap(v104)(v157)
        end);
        
        game:GetService("Players").PlayerRemoving:Connect(function(v158)
            local v159 = v101:FindFirstChild(v158.Name)
            if v159 then v159:Destroy() end
        end);
    end;
end;
