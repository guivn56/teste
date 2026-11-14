-- NexusHub :: BBC Hub Edition (Single File Corrigido)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Colors = {
    Background = Color3.fromRGB(8, 8, 8),
    Surface = Color3.fromRGB(15, 15, 15),
    Surface2 = Color3.fromRGB(25, 25, 25),
    Stroke = Color3.fromRGB(45, 45, 45),
    Accent = Color3.fromRGB(170, 80, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(140, 140, 140)
}

local function New(c, p, ch)
    local o = Instance.new(c)
    for k, v in pairs(p or {}) do o[k] = v end
    if ch then for _, v in pairs(ch) do v.Parent = o end end
    return o
end

local ScreenGui = New("ScreenGui", {Name = "NexusHub", Parent = CoreGui, ResetOnSpawn = false, IgnoreGuiInset = true})
local UIScale = New("UIScale", {Scale = (UserInputService.TouchEnabled and 0.75) or 1, Parent = ScreenGui})

-- CORREÇÃO: Parent = ScreenGui adicionado aqui
local Main = New("Frame", {
    Size = UDim2.fromOffset(600, 420), Position = UDim2.new(0.5, -300, 0.5, -210),
    BackgroundColor3 = Colors.Background, BorderSizePixel = 0, Active = true, Draggable = true,
    Parent = ScreenGui 
}, {
    New("UICorner", {CornerRadius = UDim.new(0, 10)}),
    New("UIStroke", {Color = Colors.Stroke, Thickness = 1}),
    New("ImageLabel", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Image = "rbxassetid://12629542321", ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, 50, 0, 50), ImageColor3 = Color3.fromRGB(20, 20, 20),
        ImageTransparency = 0.8, ZIndex = -1
    })
})

-- Top Bar
New("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Colors.Surface, Parent = Main}, {
    New("UICorner", {CornerRadius = UDim.new(0, 10)}),
    New("TextLabel", {Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(15, 0), BackgroundTransparency = 1, Text = "Airflow", TextColor3 = Colors.Text, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
})

-- Sidebar
local Sidebar = New("Frame", {Size = UDim2.new(0, 150, 1, -40), Position = UDim2.fromOffset(0, 40), BackgroundColor3 = Colors.Background, Parent = Main}, {
    New("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}),
    New("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
})

-- Content Area
local Content = New("Frame", {Size = UDim2.new(1, -150, 1, -40), Position = UDim2.fromOffset(150, 40), BackgroundColor3 = Colors.Surface, Parent = Main}, {
    New("UICorner", {CornerRadius = UDim.new(0, 10)})
})

local Tabs = {}

local function CreateTab(name)
    local Btn = New("TextButton", {Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Colors.Background, Text = name, TextColor3 = Colors.Muted, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = Sidebar}, {
        New("UICorner", {CornerRadius = UDim.new(0, 6)}),
        New("UIPadding", {PaddingLeft = UDim.new(0, 10)})
    })

    local Frame = New("ScrollingFrame", {Size = UDim2.new(1, -20, 1, -20), Position = UDim2.fromOffset(10, 10), BackgroundTransparency = 1, ScrollBarThickness = 4, CanvasSize = UDim2.new(0, 0, 0, 0), Visible = false, Parent = Content}, {
        New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
    })
    
    Frame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Frame.CanvasSize = UDim2.new(0, 0, 0, Frame.UIListLayout.AbsoluteContentSize.Y + 20)
    end)

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = Colors.Background
            t.Btn.TextColor3 = Colors.Muted
            t.Frame.Visible = false
        end
        Btn.BackgroundColor3 = Colors.Surface2
        Btn.TextColor3 = Colors.Accent
        Frame.Visible = true
    end)

    Tabs[name] = {Btn = Btn, Frame = Frame}
    return Frame
end

local function CreateSection(parent, title)
    New("TextLabel", {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1, Text = title, TextColor3 = Colors.Muted, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = parent})
end

local function CreateToggle(parent, title, default, subElements)
    local Frame = New("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Colors.Surface2, Parent = parent}, {
        New("UICorner", {CornerRadius = UDim.new(0, 6)}),
        New("UIStroke", {Color = Colors.Stroke, Thickness = 1})
    })
    New("TextLabel", {Size = UDim2.new(1, -80, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1, Text = title, TextColor3 = Colors.Text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})

    local Track = New("Frame", {Size = UDim2.fromOffset(36, 20), Position = UDim2.new(1, -46, 0.5, -10), BackgroundColor3 = Colors.Background, Parent = Frame}, {New("UICorner", {CornerRadius = UDim.new(1, 0)})})
    local Knob = New("Frame", {Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Colors.Text, Parent = Track}, {New("UICorner", {CornerRadius = UDim.new(1, 0)})})
    
    local state = default
    local function update()
        Track.BackgroundColor3 = state and Colors.Accent or Colors.Background
        TweenService:Create(Knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
    end
    update()

    New("TextButton", {Size = UDim2.new(1, -80, 1, 0), BackgroundTransparency = 1, Text = "", Parent = Frame}).MouseButton1Click:Connect(function()
        state = not state
        update()
    end)

    if subElements and #subElements > 0 then
        local Arrow = New("TextButton", {Size = UDim2.fromOffset(20, 20), Position = UDim2.new(1, -75, 0.5, -10), BackgroundTransparency = 1, Text = "☰", TextColor3 = Colors.Muted, TextSize = 14, Parent = Frame})
        local SubFrame = New("Frame", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 5), BackgroundColor3 = Colors.Background, ClipsDescendants = true, Parent = Frame}, {
            New("UICorner", {CornerRadius = UDim.new(0, 6)}), New("UIListLayout", {Padding = UDim.new(0, 5)}), New("UIPadding", {PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
        })
        
        Frame.AutomaticSize = Enum.AutomaticSize.Y
        local open = false
        Arrow.MouseButton1Click:Connect(function()
            open = not open
            Arrow.TextColor3 = open and Colors.Accent or Colors.Muted
            TweenService:Create(SubFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = open and UDim2.new(1, 0, 0, (#subElements * 35) + 10) or UDim2.new(1, 0, 0, 0)}):Play()
        end)

        for _, el in ipairs(subElements) do
            if el.Type == "Slider" then
                local SFrame = New("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = SubFrame})
                New("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = el.Title, TextColor3 = Colors.Text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = SFrame})
                New("Frame", {Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 1, -5), BackgroundColor3 = Colors.Surface, Parent = SFrame}, {
                    New("Frame", {Size = UDim2.new(0.5, 0, 1, 0), BackgroundColor3 = Colors.Accent, Parent = SFrame})
                })
            end
        end
    end
end

-- Criando Abas
local TabVisuals = CreateTab("VISUALS")
local TabPlayer = CreateTab("PLAYER")
local TabCombat = CreateTab("COMBAT")
local TabWorld = CreateTab("WORLD")
local TabMisc = CreateTab("MISC")
local TabLoot = CreateTab("LOOTFINDER")
local TabServer = CreateTab("SERVER")

-- Preenchendo COMBAT (com as setinhas)
CreateSection(TabCombat, "AIM")
CreateToggle(TabCombat, "Silent Aim", true, { { Type = "Slider", Title = "Hit Chance" }, { Type = "Slider", Title = "Target Part" } })
CreateToggle(TabCombat, "Aimbot", false, { { Type = "Slider", Title = "Smoothness" }, { Type = "Slider", Title = "FOV" } })

-- Preenchendo MISC (igual BBC Hub)
CreateSection(TabMisc, "MISC")
CreateToggle(TabMisc, "Fast Trade")
CreateToggle(TabMisc, "Panic Mode")
CreateToggle(TabMisc, "Pass Door")
CreateToggle(TabMisc, "Screen Effects")
CreateSection(TabMisc, "DETECT")
CreateToggle(TabMisc, "Content Creator")
CreateToggle(TabMisc, "Tester")
CreateToggle(TabMisc, "Moderator")
CreateToggle(TabMisc, "Cheater")

-- Watermark (Timer no topo)
local WM = New("Frame", {Size = UDim2.new(0, 200, 0, 30), Position = UDim2.new(0.5, 0, 0, 10), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Colors.Background, ZIndex = 1, Parent = ScreenGui}, {
    New("UICorner", {CornerRadius = UDim.new(0, 8)}),
    New("UIStroke", {Color = Colors.Accent, Thickness = 1})
})
local WMText = New("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "Airflow", TextColor3 = Colors.Text, Font = Enum.Font.GothamBold, TextSize = 14, Parent = WM})

task.spawn(function()
    while task.wait(1) do
        if WMText then WMText.Text = "Airflow | " .. os.date("%H:%M:%S") end
    end
end)

-- Abre a primeira aba
task.defer(function()
    if Tabs["COMBAT"] then Tabs["COMBAT"].Btn.MouseButton1Click:Fire() end
end)
