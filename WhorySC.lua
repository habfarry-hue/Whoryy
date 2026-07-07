-- ============================================================
-- WHORY MENU (AIMBOT + ESP) - DENGAN SISTEM KEY
-- ============================================================

-- === CEK KEY DARI SERVER ===
local keyUrl = "https://raw.githubusercontent.com/habfarry-hue/Whoryy/refs/heads/main/WhorySC.lua"  -- GANTI DENGAN LINK KEY LO
local key = game:HttpGet(keyUrl)

if key ~= "WHORYTCION-" then  -- GANTI DENGAN KEY YANG LO MAU
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "WHORY",
        Text = "Key invalid!",
        Duration = 5
    })
    return
end

-- === SCRIPT UTAMA WHORY ===
local player = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- ===== VARIABEL =====
local aimbotActive = false
local espActive = false
local espName = false
local espHealth = false
local isDragging = false
local dragStart = Vector2.new(0, 0)
local startPos = UDim2.new(0, 20, 0, 80)
local minimized = false
local espObjects = {}

-- ===== GUI WHORY =====
local gui = Instance.new("ScreenGui")
gui.Name = "WhoryMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 260)
main.Position = startPos
main.BackgroundColor3 = Color3.fromRGB(25, 0, 50)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.ZIndex = 10
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 11
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "WHORY"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 12
titleLabel.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 1, -4)
minBtn.Position = UDim2.new(1, -58, 0, 2)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.ZIndex = 12
minBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 1, -4)
closeBtn.Position = UDim2.new(1, -28, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(160, 20, 20)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 12
closeBtn.Parent = titleBar

local restoreBtn = Instance.new("TextButton")
restoreBtn.Size = UDim2.new(0, 45, 0, 45)
restoreBtn.Position = UDim2.new(0, 15, 0, 120)
restoreBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
restoreBtn.Text = "W"
restoreBtn.TextColor3 = Color3.fromRGB(255,255,255)
restoreBtn.TextScaled = true
restoreBtn.Font = Enum.Font.GothamBold
restoreBtn.BorderSizePixel = 0
restoreBtn.Visible = false
restoreBtn.ZIndex = 20
restoreBtn.Parent = gui

minBtn.MouseButton1Click:Connect(function()
    minimized = true
    main.Visible = false
    restoreBtn.Visible = true
end)

restoreBtn.MouseButton1Click:Connect(function()
    minimized = false
    main.Visible = true
    restoreBtn.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    aimbotActive = false
    espActive = false
    gui:Destroy()
end)

-- ===== DRAG =====
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = Vector2.new(mouse.X, mouse.Y)
        startPos = main.Position
    end
end)

uis.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
        local delta = Vector2.new(mouse.X, mouse.Y) - dragStart
        main.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- ===== FUNGSI BUAT TOMBOL =====
local function createButton(text, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 26)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 0, 100)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    btn.Parent = main
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    return btn
end

local function createLabel(text, yPos)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.8, 0, 0, 22)
    lbl.Position = UDim2.new(0.1, 0, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 180, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 10
    lbl.Parent = main
    return lbl
end

-- ===== TARGET =====
local function getTarget()
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local camPos = cam.CFrame.Position
    local camLook = cam.CFrame.LookVector
    local best = nil
    local bestScore = math.huge

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local tChar = plr.Character
            if tChar and tChar:FindFirstChild("HumanoidRootPart") then
                local hrp = tChar.HumanoidRootPart
                local head = tChar:FindFirstChild("Head") or hrp
                local pos = head.Position

                local dist = (pos - camPos).Magnitude
                if dist > 600 then continue end

                local toTarget = (pos - camPos).Unit
                local angle = math.deg(math.acos(math.clamp(camLook:Dot(toTarget), -1, 1)))
                if angle < 45 then
                    local score = dist + angle * 2
                    if score < bestScore then
                        bestScore = score
                        best = {part = head, pos = pos}
                    end
                end
            end
        end
    end
    return best
end

-- ===== AIMBOT =====
local function aimloop()
    if not aimbotActive then return end
    local target = getTarget()
    if not target then return end
    local targetPos = target.part.Position + Vector3.new(0, 0.5, 0)
    local newCF = CFrame.new(cam.CFrame.Position, targetPos)
    cam.CFrame = cam.CFrame:Lerp(newCF, 0.15)
end

local connection
local function startLoop()
    if connection then return end
    connection = runService.RenderStepped:Connect(aimloop)
end
local function stopLoop()
    if connection then connection:Disconnect(); connection = nil end
end

uis.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and aimbotActive then
        startLoop()
    end
end)
uis.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        stopLoop()
    end
end)

-- ===== ESP =====
local function updateESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}

    if not espActive then return end

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local char = plr.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            if hrp and hum then
                -- Outline highlight
                local hl = Instance.new("Highlight")
                hl.FillColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 1
                hl.OutlineColor = Color3.fromRGB(200, 200, 255)
                hl.OutlineTransparency = 0.4
                hl.Parent = char
                table.insert(espObjects, hl)

                -- NAME
                if espName then
                    local bill = Instance.new("BillboardGui")
                    bill.Size = UDim2.new(0, 200, 0, 30)
                    bill.Adornee = hrp
                    bill.StudsOffset = Vector3.new(0, 3, 0)
                    bill.AlwaysOnTop = true
                    bill.Parent = char

                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Text = plr.Name
                    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
                    nameLabel.TextScaled = true
                    nameLabel.Font = Enum.Font.GothamBold
                    nameLabel.Parent = bill
                    table.insert(espObjects, bill)
                end

                -- HEALTH (vertikal)
                if espHealth then
                    local healthBill = Instance.new("BillboardGui")
                    healthBill.Size = UDim2.new(0, 10, 0, 120)
                    healthBill.Adornee = hrp
                    healthBill.StudsOffset = Vector3.new(2.5, 0, 0)
                    healthBill.AlwaysOnTop = true
                    healthBill.Parent = char

                    local healthBg = Instance.new("Frame")
                    healthBg.Size = UDim2.new(1, 0, 1, 0)
                    healthBg.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
                    healthBg.BackgroundTransparency = 0.4
                    healthBg.BorderSizePixel = 0
                    healthBg.Parent = healthBill
                    table.insert(espObjects, healthBg)

                    local healthFill = Instance.new("Frame")
                    local ratio = hum.Health / hum.MaxHealth
                    healthFill.Size = UDim2.new(1, 0, ratio, 0)
                    healthFill.Position = UDim2.new(0, 0, 1 - ratio, 0)
                    healthFill.BackgroundColor3 = ratio > 0.5 and Color3.fromRGB(0, 255, 0) or (ratio > 0.25 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0))
                    healthFill.BorderSizePixel = 0
                    healthFill.Parent = healthBg
                    table.insert(espObjects, healthFill)

                    local healthCon
                    healthCon = hum:GetPropertyChangedSignal("Health"):Connect(function()
                        local newRatio = hum.Health / hum.MaxHealth
                        healthFill.Size = UDim2.new(1, 0, newRatio, 0)
                        healthFill.Position = UDim2.new(0, 0, 1 - newRatio, 0)
                        if newRatio > 0.5 then
                            healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                        elseif newRatio > 0.25 then
                            healthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                        else
                            healthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end)
                    table.insert(espObjects, healthCon)
                end
            end
        end
    end
end

game.Players.PlayerAdded:Connect(updateESP)
game.Players.PlayerRemoving:Connect(updateESP)

-- ===== MENU =====
local y = 45

local lbl1 = createLabel("▸ AIMBOT", y)
y = y + 28

local btnAim = createButton("  ◉ AIMBOT  OFF", y, Color3.fromRGB(60,0,100))
btnAim.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    btnAim.Text = aimbotActive and "  ◉ AIMBOT  ON" or "  ◉ AIMBOT  OFF"
    btnAim.BackgroundColor3 = aimbotActive and Color3.fromRGB(0,120,0) or Color3.fromRGB(60,0,100)
    if not aimbotActive then stopLoop() end
end)
y = y + 32

local lbl2 = createLabel("▸ ESP MENU", y)
y = y + 28

local btnEsp = createButton("  ◉ ESP  OFF", y, Color3.fromRGB(60,0,100))
btnEsp.MouseButton1Click:Connect(function()
    espActive = not espActive
    btnEsp.Text = espActive and "  ◉ ESP  ON" or "  ◉ ESP  OFF"
    btnEsp.BackgroundColor3 = espActive and Color3.fromRGB(0,120,0) or Color3.fromRGB(60,0,100)
    updateESP()
end)
y = y + 28

local btnName = createButton("  ◉ NAME  OFF", y, Color3.fromRGB(60,0,100))
btnName.MouseButton1Click:Connect(function()
    espName = not espName
    btnName.Text = espName and "  ◉ NAME  ON" or "  ◉ NAME  OFF"
    btnName.BackgroundColor3 = espName and Color3.fromRGB(0,120,0) or Color3.fromRGB(60,0,100)
    updateESP()
end)
y = y + 28

local btnHealth = createButton("  ◉ HEALTH  OFF", y, Color3.fromRGB(60,0,100))
btnHealth.MouseButton1Click:Connect(function()
    espHealth = not espHealth
    btnHealth.Text = espHealth and "  ◉ HEALTH  ON" or "  ◉ HEALTH  OFF"
    btnHealth.BackgroundColor3 = espHealth and Color3.fromRGB(0,120,0) or Color3.fromRGB(60,0,100)
    updateESP()
end)

-- ===== NOTIFIKASI =====
print("✅ WHORY MENU LOADED!")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "WHORY",
    Text = "ESP: Outline, Name, Health (vertikal)",
    Duration = 3
})
