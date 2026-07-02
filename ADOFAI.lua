local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Config = {
    Colors = {
        Fire = Color3.fromRGB(255, 110, 50),
        FireBright = Color3.fromRGB(255, 190, 90),
        FireDark = Color3.fromRGB(190, 55, 20),
        Ice = Color3.fromRGB(70, 165, 255),
        IceBright = Color3.fromRGB(130, 220, 255),
        IceDark = Color3.fromRGB(35, 105, 195),
        Track = Color3.fromRGB(235, 235, 250),
        TrackDim = Color3.fromRGB(95, 95, 130),
        TrackDone = Color3.fromRGB(150, 150, 180),
        BgPrimary = Color3.fromRGB(10, 10, 24),
        BgSecondary = Color3.fromRGB(20, 18, 42),
        Perfect = Color3.fromRGB(255, 240, 90),
        EPerfect = Color3.fromRGB(120, 220, 255),
        EarlyLate = Color3.fromRGB(170, 255, 150),
        Miss = Color3.fromRGB(255, 75, 75),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(165, 165, 200),
        Target = Color3.fromRGB(255, 255, 255),
        Panel = Color3.fromRGB(18, 18, 38),
        PortalGlow = Color3.fromRGB(180, 200, 255),
        PortalDark = Color3.fromRGB(20, 15, 45),
        Chain = Color3.fromRGB(120, 120, 140),
        LanternBlue = Color3.fromRGB(80, 180, 255),
        LanternYellow = Color3.fromRGB(255, 220, 90),
        LanternRed = Color3.fromRGB(255, 110, 90),
    },
    UI = {
        Scale = 0.82,
        Width = 920,
        Height = 700,
    },
    Track = {
        Spacing = 72,
        LineWidth = 4,
        TileSize = 26,
        VisibleBefore = 4,
        VisibleAfter = 10,
    },
    Planet = {
        Size = 26,
        GlowSize = 72,
        TrailMax = 10,
    },
    Menu = {
        PortalSize = 230,
        PortalSpacing = 340,
        PortalY = 0.46,
    },
    Judgment = {
        Perfect = math.rad(30),
        EPerfect = math.rad(45),
        Window = math.rad(60),
    },
    Levels = {
        { name = "初遇 · Encounter",  bpm = 92,  music = "rbxassetid://18483575277", angles = {180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180} },
        { name = "柔风 · Breeze",     bpm = 104, music = "rbxassetid://18483577025", angles = {180,180,225,180,135,180,180,225,180,135,180,180,225,180,135,180,180,180,180,180,180,180} },
        { name = "回旋 · Spiral",     bpm = 112, music = "rbxassetid://18483578453", angles = {180,225,225,225,180,135,135,135,180,225,225,180,135,135,180,225,180,135,180,180} },
        { name = "脉冲 · Pulse",      bpm = 122, music = "rbxassetid://18483579701", angles = {180,135,225,135,225,135,225,180,180,135,225,135,225,135,225,180,180,180,180} },
        { name = "风暴 · Storm",      bpm = 132, music = "rbxassetid://18483581342", angles = {180,225,135,225,180,135,225,135,180,225,135,180,225,135,225,135,180,180,180} },
    },
    Audio = {
        MusicVolume = 0.6,
        SfxVolume = 0.8,
        HitSound = "rbxassetid://160832151",
        PerfectSound = "rbxassetid://160832151",
        MissSound = "rbxassetid://160832151",
        WinSound = "rbxassetid://160832151",
    },
}

local function new(class, props, parent)
    local inst = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            inst[k] = v
        end
    end
    if parent then
        inst.Parent = parent
    end
    return inst
end

type Tile = {
    pos: Vector2,
    bwd: number,
    fwd: number,
    orbitAngle: number,
    isGoal: boolean,
}

type GameState = "Menu" | "Playing" | "GameOver" | "Win"

local state: GameState = "Menu"
local tiles: {Tile} = {}
local currentTile = 1
local progress = 0
local bpm = 100
local pivotIsFire = true
local combo = 0
local maxCombo = 0
local perfects = 0
local earlyPerfects = 0
local latePerfects = 0
local earlys = 0
local lates = 0
local misses = 0
local totalTiles = 0
local currentLevel = 1
local cameraPivot = Vector2.new(0, 0)
local cameraAngle = 0
local targetPivot = Vector2.new(0, 0)
local targetAngle = 0
local shakeAmount = 0
local beatPulse = 0
local judgmentAlpha = 0
local judgmentTextValue = ""
local judgmentColorValue = Color3.new(1, 1, 1)
local crashTimer = 0
local menuSelectedLevel = 1
local levelBestAcc = {}

local ScreenGui = new("ScreenGui", {
    Name = "ADanceOfFireAndIce",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100,
    ResetOnSpawn = false,
}, CoreGui)

local UIScale = new("UIScale", {
    Scale = Config.UI.Scale,
}, ScreenGui)

local BgmSound = new("Sound", {
    Name = "Bgm",
    Volume = Config.Audio.MusicVolume,
    Looped = true,
    Parent = ScreenGui,
})

local HitSfx = new("Sound", {
    Name = "HitSfx",
    Volume = Config.Audio.SfxVolume,
    SoundId = Config.Audio.HitSound,
    Parent = ScreenGui,
})

local PerfectSfx = new("Sound", {
    Name = "PerfectSfx",
    Volume = Config.Audio.SfxVolume * 1.1,
    SoundId = Config.Audio.PerfectSound,
    Parent = ScreenGui,
})

local MissSfx = new("Sound", {
    Name = "MissSfx",
    Volume = Config.Audio.SfxVolume * 1.2,
    SoundId = Config.Audio.MissSound,
    Parent = ScreenGui,
})

local WinSfx = new("Sound", {
    Name = "WinSfx",
    Volume = Config.Audio.SfxVolume,
    SoundId = Config.Audio.WinSound,
    Parent = ScreenGui,
})

local function playMusic(levelIdx)
    local level = Config.Levels[math.min(levelIdx, #Config.Levels)]
    if level.music then
        BgmSound.SoundId = level.music
        BgmSound:Play()
    end
end

local function stopMusic()
    BgmSound:Stop()
end

local function playHit(pitch)
    HitSfx.Pitch = pitch or 1
    HitSfx:Play()
end

local Background = new("Frame", {
    Name = "Background",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(8, 6, 22),
    BorderSizePixel = 0,
    Active = false,
}, ScreenGui)

local BgGradient = new("UIGradient", {
    Rotation = 90,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 12, 55)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 8, 32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 4, 18)),
    }),
}, Background)

local StarLayer = new("Frame", {
    Name = "StarLayer",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 2,
}, Background)

local stars = {}
do
    for i = 1, 80 do
        local size = 1 + math.random() * 2.5
        local star = new("Frame", {
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(math.random(), 0, math.random(), 0),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.3 + math.random() * 0.6,
            BorderSizePixel = 0,
            ZIndex = 2,
        }, StarLayer)
        new("UICorner", { CornerRadius = UDim.new(1, 0) }, star)
        table.insert(stars, {
            Frame = star,
            Offset = math.random() * math.pi * 2,
            Speed = 0.5 + math.random() * 1.5,
            BaseAlpha = 0.3 + math.random() * 0.6,
        })
    end
end

local function createGlow(parent, size, color, transparency, zindex)
    local glow = new("Frame", {
        Size = UDim2.new(0, size, 0, size),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = color,
        BackgroundTransparency = transparency,
        BorderSizePixel = 0,
        ZIndex = zindex,
    }, parent)
    new("UICorner", { CornerRadius = UDim.new(1, 0) }, glow)
    return glow
end

local ambientOrbs = {}
do
    local orbData = {
        { Config.Colors.FireDark, UDim2.new(0.1, 0, 0.2, 0), 300 },
        { Config.Colors.IceDark,  UDim2.new(0.88, 0, 0.78, 0), 340 },
        { Config.Colors.FireDark, UDim2.new(0.82, 0, 0.16, 0), 200 },
        { Config.Colors.IceDark,  UDim2.new(0.14, 0, 0.84, 0), 240 },
    }
    for _, data in ipairs(orbData) do
        local orb = new("Frame", {
            Size = UDim2.new(0, data[3], 0, data[3]),
            Position = data[2],
            BackgroundColor3 = data[1],
            BackgroundTransparency = 0.88,
            BorderSizePixel = 0,
            ZIndex = 1,
        }, Background)
        new("UICorner", { CornerRadius = UDim.new(1, 0) }, orb)
        table.insert(ambientOrbs, {
            Frame = orb,
            Offset = math.random() * math.pi * 2,
            BasePos = data[2],
            Speed = 0.2 + math.random() * 0.3,
        })
    end
end

local GameFrame = new("Frame", {
    Name = "GameFrame",
    Size = UDim2.new(0, Config.UI.Width, 0, Config.UI.Height),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Active = false,
    ClipsDescendants = true,
}, ScreenGui)

local GameCenter = Vector2.new(Config.UI.Width * 0.35, Config.UI.Height * 0.42)

local TrackLayer = new("Frame", {
    Name = "TrackLayer",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 5,
}, GameFrame)

local TileLayer = new("Frame", {
    Name = "TileLayer",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 6,
}, GameFrame)

local EffectLayer = new("Frame", {
    Name = "EffectLayer",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 8,
}, GameFrame)

local PlanetLayer = new("Frame", {
    Name = "PlanetLayer",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 12,
}, GameFrame)

local HudLayer = new("Frame", {
    Name = "HudLayer",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 20,
}, GameFrame)

local MenuScreen = new("Frame", {
    Name = "MenuScreen",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Active = false,
    ZIndex = 50,
}, ScreenGui)

local ResultsScreen = new("Frame", {
    Name = "ResultsScreen",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Active = false,
    ZIndex = 60,
    Visible = false,
}, ScreenGui)

local linePool = {}
local tilePool = {}
for i = 1, Config.Track.VisibleAfter + Config.Track.VisibleBefore + 2 do
    local line = new("Frame", {
        Name = "Line",
        BackgroundColor3 = Config.Colors.Track,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 0.5),
        Visible = false,
        ZIndex = 5,
    }, TrackLayer)
    table.insert(linePool, line)

    local marker = new("Frame", {
        Name = "Tile",
        Size = UDim2.new(0, Config.Track.TileSize, 0, Config.Track.TileSize),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Config.Colors.Track,
        BorderSizePixel = 0,
        Rotation = 45,
        Visible = false,
        ZIndex = 6,
    }, TileLayer)
    new("UIStroke", { Color = Color3.fromRGB(20, 20, 40), Thickness = 2, Transparency = 0.4 }, marker)
    table.insert(tilePool, marker)
end

local function createPlanet(color, brightColor, name)
    local container = new("Frame", {
        Name = name,
        Size = UDim2.new(0, Config.Planet.Size, 0, Config.Planet.Size),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 14,
        Visible = false,
    }, PlanetLayer)

    local outerGlow = createGlow(container, Config.Planet.GlowSize, brightColor, 0.6, 12)
    local innerGlow = createGlow(container, Config.Planet.Size * 2.2, color, 0.5, 13)

    local body = new("Frame", {
        Name = "Body",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        ZIndex = 15,
    }, container)
    new("UICorner", { CornerRadius = UDim.new(1, 0) }, body)
    new("UIStroke", { Color = brightColor, Thickness = 2, Transparency = 0.3 }, body)

    local shine = new("Frame", {
        Name = "Shine",
        Size = UDim2.new(0.35, 0, 0.35, 0),
        Position = UDim2.new(0.22, 0, 0.18, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 16,
    }, container)
    new("UICorner", { CornerRadius = UDim.new(1, 0) }, shine)

    return {
        Container = container,
        OuterGlow = outerGlow,
        InnerGlow = innerGlow,
        Body = body,
        Shine = shine,
        Color = color,
        BrightColor = brightColor,
    }
end

local FirePlanet = createPlanet(Config.Colors.Fire, Config.Colors.FireBright, "FirePlanet")
local IcePlanet = createPlanet(Config.Colors.Ice, Config.Colors.IceBright, "IcePlanet")

local TrailLayer = new("Frame", {
    Name = "TrailLayer",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 10,
}, PlanetLayer)

local trailPoints: {Vector2} = {}
local trailDots = {}
for i = 1, Config.Planet.TrailMax do
    local dot = new("Frame", {
        Name = "TrailDot",
        Size = UDim2.new(0, 14, 0, 14),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 10,
    }, TrailLayer)
    new("UICorner", { CornerRadius = UDim.new(1, 0) }, dot)
    table.insert(trailDots, dot)
end

local function updateTrail(headPos, color)
    table.insert(trailPoints, 1, headPos)
    if #trailPoints > Config.Planet.TrailMax then
        table.remove(trailPoints)
    end
    for i, dot in ipairs(trailDots) do
        local pt = trailPoints[i]
        if pt then
            dot.Visible = true
            dot.Position = UDim2.new(0, pt.X, 0, pt.Y)
            local t = (i - 1) / Config.Planet.TrailMax
            dot.BackgroundTransparency = 0.4 + t * 0.6
            local s = 1 - t * 0.7
            dot.Size = UDim2.new(0, 14 * s, 0, 14 * s)
            dot.BackgroundColor3 = color
        else
            dot.Visible = false
        end
    end
end

local function clearTrail()
    trailPoints = {}
    for _, dot in ipairs(trailDots) do
        dot.Visible = false
    end
end

local particles = {}
local function spawnBurst(pos, color, count)
    for i = 1, count do
        local angle = math.random() * math.pi * 2
        local speed = 40 + math.random() * 120
        local life = 0.4 + math.random() * 0.4
        local size = 4 + math.random() * 6
        local p = new("Frame", {
            Size = UDim2.new(0, size, 0, size),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, pos.X, 0, pos.Y),
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            ZIndex = 9,
        }, EffectLayer)
        new("UICorner", { CornerRadius = UDim.new(1, 0) }, p)
        table.insert(particles, {
            Frame = p,
            Pos = pos,
            Vel = Vector2.new(math.cos(angle) * speed, math.sin(angle) * speed),
            Life = life,
            MaxLife = life,
        })
    end
end

local function updateParticles(dt)
    for i = #particles, 1, -1 do
        local p = particles[i]
        p.Life = p.Life - dt
        if p.Life <= 0 then
            p.Frame:Destroy()
            table.remove(particles, i)
        else
            p.Pos = p.Pos + p.Vel * dt
            p.Vel = p.Vel * 0.92
            p.Frame.Position = UDim2.new(0, p.Pos.X, 0, p.Pos.Y)
            local t = 1 - p.Life / p.MaxLife
            p.Frame.BackgroundTransparency = t
        end
    end
end

local judgmentText = new("TextLabel", {
    Name = "Judgment",
    Size = UDim2.new(0, 300, 0, 50),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.3, 0),
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.GothamBlack,
    TextSize = 38,
    TextColor3 = Config.Colors.Perfect,
    TextStrokeTransparency = 0.5,
    TextStrokeColor3 = Color3.new(0, 0, 0),
    ZIndex = 21,
    Visible = false,
}, HudLayer)

local comboText = new("TextLabel", {
    Name = "Combo",
    Size = UDim2.new(0, 200, 0, 40),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.4, 0),
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    TextColor3 = Config.Colors.TextDim,
    ZIndex = 21,
    Visible = false,
}, HudLayer)

local levelNameText = new("TextLabel", {
    Name = "LevelName",
    Size = UDim2.new(0, 400, 0, 30),
    AnchorPoint = Vector2.new(0, 0),
    Position = UDim2.new(0.04, 0, 0.04, 0),
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    TextColor3 = Config.Colors.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 21,
    Visible = false,
}, HudLayer)

local bpmText = new("TextLabel", {
    Name = "BPM",
    Size = UDim2.new(0, 200, 0, 26),
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(0.96, 0, 0.05, 0),
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 18,
    TextColor3 = Config.Colors.TextDim,
    TextXAlignment = Enum.TextXAlignment.Right,
    ZIndex = 21,
    Visible = false,
}, HudLayer)

local progressBarBg = new("Frame", {
    Name = "ProgressBg",
    Size = UDim2.new(0, Config.UI.Width - 80, 0, 6),
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 0.97, 0),
    BackgroundColor3 = Config.Colors.Panel,
    BorderSizePixel = 0,
    ZIndex = 21,
    Visible = false,
}, HudLayer)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, progressBarBg)

local progressBarFill = new("Frame", {
    Name = "ProgressFill",
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = Config.Colors.Fire,
    BorderSizePixel = 0,
    ZIndex = 22,
}, progressBarBg)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, progressBarFill)

local progressText = new("TextLabel", {
    Name = "ProgressText",
    Size = UDim2.new(0, 200, 0, 24),
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 0.955, 0),
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 16,
    TextColor3 = Config.Colors.TextDim,
    ZIndex = 21,
    Visible = false,
}, HudLayer)

local function generateTrack(levelIdx)
    local level = Config.Levels[math.min(levelIdx, #Config.Levels)]
    local result: {Tile} = {}
    local fwd = 0
    local pos = Vector2.new(0, 0)
    for i, oaDeg in ipairs(level.angles) do
        local orbitAngle = math.rad(oaDeg)
        local bwd = fwd - orbitAngle
        result[i] = {
            pos = pos,
            bwd = bwd,
            fwd = fwd,
            orbitAngle = orbitAngle,
            isGoal = (i == #level.angles),
        }
        if i < #level.angles then
            pos = pos + Vector2.new(math.cos(fwd), math.sin(fwd)) * Config.Track.Spacing
            fwd = fwd + math.pi + math.rad(level.angles[i + 1])
        end
    end
    return result, level
end

local function worldToScreen(worldPos)
    local rel = worldPos - cameraPivot
    local cr = math.cos(cameraAngle)
    local sr = math.sin(cameraAngle)
    local sx = GameCenter.X + rel.X * cr - rel.Y * sr
    local sy = GameCenter.Y + rel.X * sr + rel.Y * cr
    return Vector2.new(sx, sy)
end

local function setLine(frame, p1, p2, color, thickness)
    local dx = p2.X - p1.X
    local dy = p2.Y - p1.Y
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 1 then
        frame.Visible = false
        return
    end
    frame.Visible = true
    frame.Size = UDim2.new(0, len, 0, thickness)
    frame.Position = UDim2.new(0, p1.X, 0, p1.Y)
    frame.Rotation = math.deg(math.atan2(dy, dx))
    frame.BackgroundColor3 = color
end

local function drawTrack()
    local fromIdx = math.max(1, currentTile - Config.Track.VisibleBefore)
    local toIdx = math.min(#tiles, currentTile + Config.Track.VisibleAfter)
    local lineIdx = 1
    for i = fromIdx, toIdx - 1 do
        local p1 = worldToScreen(tiles[i].pos)
        local p2 = worldToScreen(tiles[i + 1].pos)
        local color
        if i < currentTile then
            color = Config.Colors.TrackDone
        elseif i == currentTile then
            color = Config.Colors.Track
        else
            color = Config.Colors.TrackDim
        end
        setLine(linePool[lineIdx], p1, p2, color, Config.Track.LineWidth)
        lineIdx = lineIdx + 1
    end
    for i = lineIdx, #linePool do
        linePool[i].Visible = false
    end

    local tileIdx = 1
    local t = tick()
    for i = fromIdx, toIdx do
        local sp = worldToScreen(tiles[i].pos)
        local marker = tilePool[tileIdx]
        marker.Visible = true
        marker.Position = UDim2.new(0, sp.X, 0, sp.Y)
        local stroke = marker:FindFirstChildOfClass("UIStroke")
        if i < currentTile then
            marker.BackgroundColor3 = Config.Colors.TrackDone
            local s = Config.Track.TileSize * 0.75
            marker.Size = UDim2.new(0, s, 0, s)
            if stroke then stroke.Transparency = 0.6 end
        elseif i == currentTile then
            marker.BackgroundColor3 = Config.Colors.Target
            local pulse = 1 + math.sin(t * 5) * 0.08 + beatPulse * 0.2
            local s = Config.Track.TileSize * 1.25 * pulse
            marker.Size = UDim2.new(0, s, 0, s)
            if stroke then
                stroke.Transparency = 0.1
                stroke.Color = Config.Colors.Target
            end
        elseif i == currentTile + 1 then
            local col = tiles[i].isGoal and Config.Colors.Perfect or Config.Colors.Target
            marker.BackgroundColor3 = col
            local s = Config.Track.TileSize * 1.05
            marker.Size = UDim2.new(0, s, 0, s)
            if stroke then
                stroke.Transparency = 0.2
                stroke.Color = col
            end
        else
            local col = tiles[i].isGoal and Config.Colors.Perfect or Config.Colors.TrackDim
            marker.BackgroundColor3 = col
            marker.Size = UDim2.new(0, Config.Track.TileSize, 0, Config.Track.TileSize)
            if stroke then stroke.Transparency = 0.5 end
        end
        tileIdx = tileIdx + 1
    end
    for i = tileIdx, #tilePool do
        tilePool[i].Visible = false
    end
end

local function hideTrack()
    for _, line in ipairs(linePool) do
        line.Visible = false
    end
    for _, tile in ipairs(tilePool) do
        tile.Visible = false
    end
end

local showResults
local openMenu
local setMenuVisible

local function updateHud()
    if state ~= "Playing" then return end
    local level = Config.Levels[math.min(currentLevel, #Config.Levels)]
    levelNameText.Text = level.name
    bpmText.Text = tostring(bpm) .. " BPM"
    if combo > 0 then
        comboText.Text = tostring(combo) .. " COMBO"
    else
        comboText.Text = ""
    end
    local pct = math.min(1, (currentTile - 1) / totalTiles)
    progressBarFill.Size = UDim2.new(pct, 0, 1, 0)
    progressText.Text = tostring(currentTile - 1) .. " / " .. tostring(totalTiles)
end

local function setHudVisible(visible)
    levelNameText.Visible = visible
    bpmText.Visible = visible
    comboText.Visible = visible
    progressBarBg.Visible = visible
    progressText.Visible = visible
    judgmentText.Visible = visible
end

local function showJudgment(text, color)
    judgmentTextValue = text
    judgmentColorValue = color
    judgmentText.Text = text
    judgmentText.TextColor3 = color
    judgmentAlpha = 1
end

local function startLevel(levelIdx)
    currentLevel = levelIdx
    tiles = generateTrack(levelIdx)
    local level = Config.Levels[math.min(levelIdx, #Config.Levels)]
    bpm = level.bpm
    totalTiles = #level.angles
    currentTile = 1
    progress = 0
    combo = 0
    maxCombo = 0
    perfects = 0
    earlyPerfects = 0
    latePerfects = 0
    earlys = 0
    lates = 0
    misses = 0
    pivotIsFire = true
    crashTimer = 0
    shakeAmount = 0
    beatPulse = 0
    judgmentAlpha = 0
    judgmentText.Text = ""
    clearTrail()

    local tile1 = tiles[1]
    cameraPivot = tile1.pos
    targetPivot = tile1.pos
    cameraAngle = -tile1.fwd
    targetAngle = -tile1.fwd

    FirePlanet.Container.Visible = true
    IcePlanet.Container.Visible = true
    if menuPanel then menuPanel:Destroy() end
    MenuScreen.Visible = false
    ResultsScreen.Visible = false
    ResultsScreen.Active = false
    GameFrame.Visible = true
    setHudVisible(true)
    playMusic(levelIdx)
    state = "Playing"
    updateHud()
end

local function fail()
    if state ~= "Playing" then return end
    state = "GameOver"
    misses = misses + 1
    crashTimer = 0.9
    shakeAmount = 14
    stopMusic()
    MissSfx:Play()
    spawnBurst(GameCenter, Config.Colors.Miss, 24)
    showJudgment("MISS", Config.Colors.Miss)
    FirePlanet.Container.Visible = false
    IcePlanet.Container.Visible = false
    clearTrail()
end

local function win()
    if state ~= "Playing" then return end
    state = "Win"
    local hits = perfects + earlyPerfects + latePerfects + earlys + lates
    local total = hits + misses
    local acc = total > 0 and (perfects * 100 + (earlyPerfects + latePerfects) * 95 + (earlys + lates) * 80) / total or 100
    stopMusic()
    spawnBurst(GameCenter, Config.Colors.Perfect, 36)
    showJudgment("CLEAR!", Config.Colors.Perfect)
    task.delay(0.8, function()
        showResults(true, acc)
    end)
end

local function advanceTile()
    local tile = tiles[currentTile]
    progress = tile.orbitAngle
    combo = combo + 1
    if combo > maxCombo then maxCombo = combo end

    local orbitingAngle = tile.bwd + progress
    local orbitingPos = tile.pos + Vector2.new(math.cos(orbitingAngle), math.sin(orbitingAngle)) * Config.Track.Spacing
    local screenPos = worldToScreen(orbitingPos)
    local orbitColor = pivotIsFire and Config.Colors.Ice or Config.Colors.Fire
    spawnBurst(screenPos, orbitColor, 12)
    beatPulse = 1

    currentTile = currentTile + 1
    progress = 0
    pivotIsFire = not pivotIsFire

    local nextTile = tiles[currentTile]
    if nextTile and nextTile.isGoal then
        win()
        return
    end

    targetPivot = nextTile.pos
    targetAngle = -nextTile.fwd

    updateHud()
end

local function handleTap()
    if state ~= "Playing" then return end
    if currentTile > #tiles then return end
    local tile = tiles[currentTile]
    local err = progress - tile.orbitAngle

    if err < -Config.Judgment.Window then
        fail()
        return
    end

    if err > Config.Judgment.Window then
        fail()
        return
    end

    local absErr = math.abs(err)
    if absErr <= Config.Judgment.Perfect then
        perfects = perfects + 1
        showJudgment("PERFECT", Config.Colors.Perfect)
        PerfectSfx:Play()
        playHit(1.15)
    elseif absErr <= Config.Judgment.EPerfect then
        if err < 0 then
            earlyPerfects = earlyPerfects + 1
            showJudgment("EARLY PERFECT", Config.Colors.EPerfect)
        else
            latePerfects = latePerfects + 1
            showJudgment("LATE PERFECT", Config.Colors.EPerfect)
        end
        playHit(1.05)
    else
        if err < 0 then
            earlys = earlys + 1
            showJudgment("EARLY", Config.Colors.EarlyLate)
        else
            lates = lates + 1
            showJudgment("LATE", Config.Colors.EarlyLate)
        end
        playHit(0.9)
    end
    advanceTile()
end

local resultsPanel
function showResults(cleared, accuracy)
    state = "Menu"
    if cleared and accuracy > (levelBestAcc[currentLevel] or 0) then
        levelBestAcc[currentLevel] = accuracy
    end
    if resultsPanel then resultsPanel:Destroy() end
    ResultsScreen.Visible = true
    ResultsScreen.Active = true
    GameFrame.Visible = false

    resultsPanel = new("Frame", {
        Name = "Results",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 8, 24),
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        ZIndex = 40,
        Active = true,
    }, ResultsScreen)

    local title = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 72),
        Position = UDim2.new(0, 0, 0.05, 0),
        BackgroundTransparency = 1,
        Text = cleared and "恭 喜 !" or "挑 战 失 败",
        Font = Enum.Font.GothamBlack,
        TextSize = 56,
        TextColor3 = cleared and Config.Colors.Perfect or Config.Colors.Miss,
        TextStrokeTransparency = 0.4,
        ZIndex = 41,
    }, resultsPanel)

    local levelLabel = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 26),
        Position = UDim2.new(0, 0, 0.17, 0),
        BackgroundTransparency = 1,
        Text = Config.Levels[math.min(currentLevel, #Config.Levels)].name,
        Font = Enum.Font.GothamMedium,
        TextSize = 18,
        TextColor3 = Config.Colors.TextDim,
        ZIndex = 41,
    }, resultsPanel)

    local statsArea = new("Frame", {
        Size = UDim2.new(0, 720, 0, 320),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.28, 0),
        BackgroundTransparency = 1,
        ZIndex = 41,
    }, resultsPanel)

    local function addStat(col, row, labelText, value, color)
        local colX = (col - 1) / 3
        local rowY = (row - 1) * 0.28
        local label = new("TextLabel", {
            Size = UDim2.new(0.33, 0, 0, 28),
            Position = UDim2.new(colX, 0, rowY, 0),
            BackgroundTransparency = 1,
            Text = labelText,
            Font = Enum.Font.GothamMedium,
            TextSize = 20,
            TextColor3 = Config.Colors.Text,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 42,
        }, statsArea)
        local val = new("TextLabel", {
            Size = UDim2.new(0.33, 0, 0, 42),
            Position = UDim2.new(colX, 0, rowY + 0.075, 0),
            BackgroundTransparency = 1,
            Text = tostring(value),
            Font = Enum.Font.GothamBold,
            TextSize = 38,
            TextColor3 = color,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextStrokeTransparency = 0.6,
            ZIndex = 42,
        }, statsArea)
    end

    addStat(1, 1, "稍 快", earlyPerfects, Color3.fromRGB(255, 220, 80))
    addStat(2, 1, "完 美", perfects, Config.Colors.Perfect)
    addStat(3, 1, "稍 慢", latePerfects, Color3.fromRGB(255, 220, 80))
    addStat(1, 2, "提 前", earlys, Color3.fromRGB(255, 120, 100))
    addStat(2, 2, "太 快", 0, Color3.fromRGB(255, 170, 90))
    addStat(3, 2, "太 慢", lates, Color3.fromRGB(255, 170, 90))
    addStat(1, 3, "错 过", misses, Color3.fromRGB(180, 130, 255))
    addStat(2, 3, "按 太 快", 0, Color3.fromRGB(180, 130, 255))

    local accLabel = new("TextLabel", {
        Size = UDim2.new(0.5, 0, 0, 48),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.32, 0, 0.72, 0),
        BackgroundTransparency = 1,
        Text = string.format("精 准 度: %.2f%%", accuracy),
        Font = Enum.Font.GothamBold,
        TextSize = 28,
        TextColor3 = Config.Colors.Text,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextStrokeTransparency = 0.5,
        ZIndex = 42,
    }, resultsPanel)

    local comboLabel = new("TextLabel", {
        Size = UDim2.new(0.5, 0, 0, 48),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.68, 0, 0.72, 0),
        BackgroundTransparency = 1,
        Text = "最 高 连 击: " .. tostring(maxCombo),
        Font = Enum.Font.GothamBold,
        TextSize = 28,
        TextColor3 = Config.Colors.Text,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextStrokeTransparency = 0.5,
        ZIndex = 42,
    }, resultsPanel)

    local hint = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        Position = UDim2.new(0, 0, 0.9, 0),
        BackgroundTransparency = 1,
        Text = "点 击 任 意 处 返 回",
        Font = Enum.Font.GothamMedium,
        TextSize = 16,
        TextColor3 = Config.Colors.TextDim,
        TextTransparency = 0.3,
        ZIndex = 41,
    }, resultsPanel)

    local clickBtn = new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 50,
    }, resultsPanel)

    clickBtn.MouseButton1Click:Connect(function()
        openMenu()
    end)
end

local menuPanel
local menuScroller
local menuWorldName
local menuLevelName
local menuAccLabel
local menuLeftArrow
local menuRightArrow
local menuSwitching = false
local menuPortals = {}
local levelBestAcc = {}

local function buildPortalPreview(parent, levelIdx)
    local level = Config.Levels[levelIdx]
    local previewTiles = {}
    local pfwd = -math.pi / 2
    local ppos = Vector2.new(0, 0)
    local pspacing = 20
    for i, oaDeg in ipairs(level.angles) do
        local oa = math.rad(oaDeg)
        local pbwd = pfwd - oa
        previewTiles[i] = { pos = ppos, bwd = pbwd, fwd = pfwd }
        if i < #level.angles then
            ppos = ppos + Vector2.new(math.cos(pfwd), math.sin(pfwd)) * pspacing
            pfwd = pfwd + math.pi + math.rad(level.angles[i + 1])
        end
    end

    local centerIdx = math.min(3, #previewTiles)
    local centerTile = previewTiles[centerIdx]
    local camAngle = -math.pi / 2 - centerTile.fwd
    local camPivot = centerTile.pos
    local ps = Config.Menu.PortalSize
    local cx = ps * 0.5
    local cy = ps * 0.5
    local radius = ps * 0.5 - 10

    local function wp(sp)
        local rel = sp - camPivot
        local cr = math.cos(camAngle)
        local sr = math.sin(camAngle)
        return Vector2.new(cx + rel.X * cr - rel.Y * sr, cy + rel.X * sr + rel.Y * cr)
    end

    local clipFrame = new("Frame", {
        Size = UDim2.new(0, ps, 0, ps),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 34,
    }, parent)
    new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, clipFrame)

    local maxLines = #previewTiles - 1
    for i = 1, maxLines do
        local p1 = wp(previewTiles[i].pos)
        local p2 = wp(previewTiles[i + 1].pos)
        local dx = p2.X - p1.X
        local dy = p2.Y - p1.Y
        local len = math.sqrt(dx * dx + dy * dy)
        if len < 1 then continue end
        new("Frame", {
            Size = UDim2.new(0, len, 0, 3),
            Position = UDim2.new(0, p1.X, 0, p1.Y),
            BackgroundColor3 = i < centerIdx and Config.Colors.TrackDone or Config.Colors.TrackDim,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 0.5),
            Rotation = math.deg(math.atan2(dy, dx)),
            ZIndex = 35,
        }, clipFrame)
    end

    for i, pt in ipairs(previewTiles) do
        local sp = wp(pt.pos)
        local dx = sp.X - cx
        local dy = sp.Y - cy
        if dx * dx + dy * dy > radius * radius then continue end
        new("Frame", {
            Size = UDim2.new(0, 11, 0, 11),
            Position = UDim2.new(0, sp.X, 0, sp.Y),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = i == centerIdx and Config.Colors.Target
                or (i < centerIdx and Config.Colors.TrackDone or Config.Colors.TrackDim),
            BackgroundTransparency = i == centerIdx and 0 or 0.3,
            BorderSizePixel = 0,
            Rotation = 45,
            ZIndex = 36,
        }, clipFrame)
    end
end

local function buildPortal(parent, idx)
    local ps = Config.Menu.PortalSize

    local outerGlow = new("Frame", {
        Name = "PortalGlow" .. idx,
        Size = UDim2.new(0, ps + 50, 0, ps + 50),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Config.Colors.PortalGlow,
        BackgroundTransparency = 0.88,
        BorderSizePixel = 0,
        ZIndex = 32,
    }, parent)
    new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, outerGlow)

    local portal = new("Frame", {
        Name = "Portal" .. idx,
        Size = UDim2.new(0, ps, 0, ps),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Config.Colors.PortalDark,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 33,
    }, parent)
    new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, portal)

    new("UIStroke", {
        Color = Config.Colors.PortalGlow,
        Thickness = 3,
        Transparency = 0.25,
    }, portal)

    buildPortalPreview(portal, idx)
    return portal
end

local function buildLantern(parent, color, offsetX)
    local lantern = new("Frame", {
        Size = UDim2.new(0, 22, 0, 30),
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, offsetX, 0, -4),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        ZIndex = 35,
    }, parent)
    new("UICorner", { CornerRadius = UDim.new(0.4, 0) }, lantern)
    local glow = new("Frame", {
        Size = UDim2.new(0, 44, 0, 44),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        ZIndex = 34,
    }, lantern)
    new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, glow)
end

local function buildChain(parent)
    local chainCount = 8
    for i = 1, chainCount do
        local t = i / (chainCount + 1)
        local link = new("Frame", {
            Size = UDim2.new(0, 6, 0, 6),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(t, 0, 0.5, 0),
            BackgroundColor3 = Config.Colors.Chain,
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            ZIndex = 31,
        }, parent)
        new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, link)
    end
end

local function updateMenuInfo()
    local level = Config.Levels[math.min(menuSelectedLevel, #Config.Levels)]
    menuWorldName.Text = "世 界 " .. tostring(menuSelectedLevel)
    menuLevelName.Text = level.name
    local acc = levelBestAcc[menuSelectedLevel] or 0
    menuAccLabel.Text = string.format("精 准 度:  %.2f%%", acc)
    if menuLeftArrow then menuLeftArrow.Visible = menuSelectedLevel > 1 end
    if menuRightArrow then menuRightArrow.Visible = menuSelectedLevel < #Config.Levels end
end

local function snapScroller()
    local sp = Config.Menu.PortalSpacing
    menuScroller.Position = UDim2.new(0.5, -(menuSelectedLevel - 1) * sp, 0.5, 0)
end

local function switchLevel(dir)
    if menuSwitching then return end
    local newIdx = menuSelectedLevel + dir
    if newIdx < 1 or newIdx > #Config.Levels then return end
    menuSwitching = true

    local sp = Config.Menu.PortalSpacing
    local targetX = -((newIdx - 1) * sp)
    local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(menuScroller, tweenInfo, {
        Position = UDim2.new(0.5, targetX, 0.5, 0),
    })
    tween:Play()
    tween.Completed:Connect(function()
        menuSwitching = false
    end)

    menuSelectedLevel = newIdx
    updateMenuInfo()
end

function openMenu()
    state = "Menu"
    if resultsPanel then resultsPanel:Destroy() end
    if menuPanel then menuPanel:Destroy() end
    ResultsScreen.Visible = false
    ResultsScreen.Active = false
    MenuScreen.Visible = true
    GameFrame.Visible = true
    hideTrack()
    setHudVisible(false)
    FirePlanet.Container.Visible = false
    IcePlanet.Container.Visible = false
    clearTrail()
    menuSelectedLevel = 1

    menuPanel = new("Frame", {
        Name = "MenuPanel",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Active = false,
        ZIndex = 31,
    }, MenuScreen)

    local title = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 44),
        Position = UDim2.new(0, 0, 0.03, 0),
        BackgroundTransparency = 1,
        Text = "冰 与 火 之 舞",
        Font = Enum.Font.GothamBlack,
        TextSize = 30,
        TextColor3 = Config.Colors.Text,
        TextStrokeTransparency = 0.7,
        ZIndex = 32,
    }, menuPanel)
    new("UIGradient", {
        Rotation = 0,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Config.Colors.IceBright),
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Config.Colors.FireBright),
        }),
    }, title)

    local subtitle = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0.1, 0),
        BackgroundTransparency = 1,
        Text = "A DANCE OF FIRE AND ICE",
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = Config.Colors.TextDim,
        TextTransparency = 0.3,
        ZIndex = 32,
    }, menuPanel)

    menuWorldName = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0.16, 0),
        BackgroundTransparency = 1,
        Text = "世 界 1",
        Font = Enum.Font.GothamBold,
        TextSize = 22,
        TextColor3 = Config.Colors.Text,
        TextStrokeTransparency = 0.6,
        ZIndex = 32,
    }, menuPanel)

    local scrollClip = new("Frame", {
        Name = "ScrollClip",
        Size = UDim2.new(1, 0, 0, Config.Menu.PortalSize + 80),
        Position = UDim2.new(0, 0, Config.Menu.PortalY, -Config.Menu.PortalSize * 0.5 - 40),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Active = false,
        ZIndex = 31,
    }, menuPanel)

    menuScroller = new("Frame", {
        Name = "Scroller",
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Active = false,
        ZIndex = 33,
    }, scrollClip)

    local sp = Config.Menu.PortalSpacing
    menuPortals = {}
    for i = 1, #Config.Levels do
        local portalX = (i - 1) * sp
        local portalHolder = new("Frame", {
            Name = "PortalHolder" .. i,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, portalX, 0.5, 0),
            BackgroundTransparency = 1,
            ZIndex = 33,
        }, menuScroller)
        local portal = buildPortal(portalHolder, i)
        menuPortals[i] = portalHolder

        if i < #Config.Levels then
            local chainHolder = new("Frame", {
                Name = "Chain" .. i,
                Size = UDim2.new(0, sp, 0, 6),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, portalX + Config.Menu.PortalSize * 0.5, 0.5, 0),
                BackgroundTransparency = 1,
                ZIndex = 31,
            }, menuScroller)
            buildChain(chainHolder)
            buildLantern(chainHolder, Config.Colors.LanternBlue, -sp * 0.3)
            buildLantern(chainHolder, Config.Colors.LanternYellow, 0)
            buildLantern(chainHolder, Config.Colors.LanternRed, sp * 0.3)
        end
    end

    snapScroller()

    local prevBtn = new("TextButton", {
        Size = UDim2.new(0, 52, 0, 52),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.07, 0, Config.Menu.PortalY, 0),
        BackgroundColor3 = Color3.fromRGB(40, 38, 70),
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        Text = "◀",
        Font = Enum.Font.GothamBlack,
        TextSize = 22,
        TextColor3 = Config.Colors.Text,
        ZIndex = 40,
    }, menuPanel)
    new("UICorner", { CornerRadius = UDim.new(0.3, 0) }, prevBtn)
    new("UIStroke", { Color = Config.Colors.PortalGlow, Thickness = 2, Transparency = 0.4 }, prevBtn)
    menuLeftArrow = prevBtn

    local nextBtn = new("TextButton", {
        Size = UDim2.new(0, 52, 0, 52),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.93, 0, Config.Menu.PortalY, 0),
        BackgroundColor3 = Color3.fromRGB(40, 38, 70),
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        Text = "▶",
        Font = Enum.Font.GothamBlack,
        TextSize = 22,
        TextColor3 = Config.Colors.Text,
        ZIndex = 40,
    }, menuPanel)
    new("UICorner", { CornerRadius = UDim.new(0.3, 0) }, nextBtn)
    new("UIStroke", { Color = Config.Colors.PortalGlow, Thickness = 2, Transparency = 0.4 }, nextBtn)
    menuRightArrow = nextBtn

    menuLevelName = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.new(0, 0, 0.74, 0),
        BackgroundTransparency = 1,
        Text = "",
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        TextColor3 = Config.Colors.Text,
        TextStrokeTransparency = 0.5,
        ZIndex = 35,
    }, menuPanel)

    menuAccLabel = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.new(0, 0, 0.81, 0),
        BackgroundTransparency = 1,
        Text = "",
        Font = Enum.Font.GothamMedium,
        TextSize = 16,
        TextColor3 = Config.Colors.IceBright,
        ZIndex = 35,
    }, menuPanel)

    local startBtn = new("TextButton", {
        Size = UDim2.new(0, 200, 0, 50),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.88, 0),
        BackgroundColor3 = Config.Colors.Fire,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        Text = "开 始",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Config.Colors.Text,
        ZIndex = 35,
    }, menuPanel)
    new("UICorner", { CornerRadius = UDim.new(0, 14) }, startBtn)
    new("UIStroke", { Color = Config.Colors.FireBright, Thickness = 2, Transparency = 0.4 }, startBtn)

    prevBtn.MouseButton1Click:Connect(function()
        switchLevel(-1)
    end)
    nextBtn.MouseButton1Click:Connect(function()
        switchLevel(1)
    end)
    startBtn.MouseButton1Click:Connect(function()
        startLevel(menuSelectedLevel)
    end)

    updateMenuInfo()
end

function setMenuVisible(visible)
    if menuPanel then
        menuPanel.Visible = visible
    end
end

local function updatePlanets()
    if currentTile > #tiles then
        FirePlanet.Container.Visible = false
        IcePlanet.Container.Visible = false
        return
    end
    local tile = tiles[currentTile]
    local pivotScreen = worldToScreen(tile.pos)
    local orbitingAngle = tile.bwd + progress
    local orbitingWorld = tile.pos + Vector2.new(math.cos(orbitingAngle), math.sin(orbitingAngle)) * Config.Track.Spacing
    local orbitingScreen = worldToScreen(orbitingWorld)

    local pivot, orbiting
    if pivotIsFire then
        pivot = FirePlanet
        orbiting = IcePlanet
    else
        pivot = IcePlanet
        orbiting = FirePlanet
    end

    pivot.Container.Position = UDim2.new(0, pivotScreen.X, 0, pivotScreen.Y)
    pivot.Container.Visible = true
    local pivotScale = 1 + beatPulse * 0.3
    pivot.Container.Size = UDim2.new(0, Config.Planet.Size * pivotScale, 0, Config.Planet.Size * pivotScale)

    orbiting.Container.Position = UDim2.new(0, orbitingScreen.X, 0, orbitingScreen.Y)
    orbiting.Container.Visible = true
    orbiting.Container.Size = UDim2.new(0, Config.Planet.Size, 0, Config.Planet.Size)

    updateTrail(orbitingScreen, orbiting.Color)
end

local function update(dt)
    if state == "Playing" then
        local tile = tiles[currentTile]
        local rate = bpm * math.pi / 60
        progress = progress + rate * dt

        if progress > tile.orbitAngle + Config.Judgment.Window then
            fail()
        end

        beatPulse = math.max(0, beatPulse - dt * 4)

        local blend = 1 - math.exp(-dt * 12)
        cameraPivot = cameraPivot + (targetPivot - cameraPivot) * blend
        local angleDiff = targetAngle - cameraAngle
        while angleDiff > math.pi do angleDiff = angleDiff - math.pi * 2 end
        while angleDiff < -math.pi do angleDiff = angleDiff + math.pi * 2 end
        cameraAngle = cameraAngle + angleDiff * blend

        updatePlanets()
        drawTrack()
        updateHud()
        updateParticles(dt)

        if judgmentAlpha > 0 then
            judgmentAlpha = math.max(0, judgmentAlpha - dt * 1.5)
            judgmentText.TextTransparency = 1 - judgmentAlpha
            judgmentText.TextStrokeTransparency = 1 - judgmentAlpha * 0.5
        end
    elseif state == "GameOver" then
        crashTimer = crashTimer - dt
        shakeAmount = math.max(0, shakeAmount - dt * 30)
        drawTrack()
        updateParticles(dt)
        if crashTimer <= 0 then
            local hits = perfects + earlyPerfects + latePerfects + earlys + lates
            local total = hits + misses
            local acc = total > 0 and (perfects * 100 + (earlyPerfects + latePerfects) * 95 + (earlys + lates) * 80) / total or 0
            showResults(false, acc)
        end
        if judgmentAlpha > 0 then
            judgmentAlpha = math.max(0, judgmentAlpha - dt * 1.2)
            judgmentText.TextTransparency = 1 - judgmentAlpha
        end
    elseif state == "Win" then
        beatPulse = math.max(0, beatPulse - dt * 4)
        updateParticles(dt)
        if judgmentAlpha > 0 then
            judgmentAlpha = math.max(0, judgmentAlpha - dt * 1.2)
            judgmentText.TextTransparency = 1 - judgmentAlpha
        end
    end

    if state == "Menu" then
        updateParticles(dt)
        for _, orb in ipairs(ambientOrbs) do
            local t = tick() * orb.Speed + orb.Offset
            local px = orb.BasePos.X.Scale + math.cos(t) * 0.03
            local py = orb.BasePos.Y.Scale + math.sin(t * 0.8) * 0.03
            orb.Frame.Position = UDim2.new(px, 0, py, 0)
            orb.Frame.BackgroundTransparency = 0.86 + math.sin(t * 1.5) * 0.06
        end
    end

    for _, s in ipairs(stars) do
        local t = tick() * s.Speed + s.Offset
        local alpha = s.BaseAlpha + math.sin(t * 2) * 0.25
        s.Frame.BackgroundTransparency = 1 - math.clamp(alpha, 0.05, 0.9)
    end

    local shakeX = (math.random() - 0.5) * shakeAmount
    local shakeY = (math.random() - 0.5) * shakeAmount
    GameFrame.Position = UDim2.new(0.5, shakeX, 0.5, shakeY)
end

UserInputService.InputBegan:Connect(function(input, processed)
    if state == "Playing" then
        if input.UserInputType == Enum.UserInputType.Keyboard
            or input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            handleTap()
        end
    end
end)

local renderConn
renderConn = RunService.RenderStepped:Connect(function(dt)
    update(dt)
end)

openMenu()
