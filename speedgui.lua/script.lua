local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ძველი გუის წაშლა თუ არსებობს
if playerGui:FindFirstChild("FlyNoclipGui") then
    playerGui.FlyNoclipGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyNoclipGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 160)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- სათაური
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Fly & Noclip GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Parent = Frame

-- Noclip ღილაკი
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(1, -20, 0, 45)
NoclipBtn.Position = UDim2.new(0, 10, 0, 45)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
NoclipBtn.Text = "Noclip (Wall Walk): OFF"
NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipBtn.TextSize = 13
NoclipBtn.Parent = Frame

-- Fly ღილაკი
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(1, -20, 0, 45)
FlyBtn.Position = UDim2.new(0, 10, 0, 100)
FlyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
FlyBtn.Text = "Fly: OFF"
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.TextSize = 13
FlyBtn.Parent = Frame

-- ფუნქციონალი
local noclipEnabled = false
local flyEnabled = false
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local bv, bg

-- Noclip ლოგიკა
runService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        NoclipBtn.Text = "Noclip (Wall Walk): ON"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        NoclipBtn.Text = "Noclip (Wall Walk): OFF"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- Fly ლოგიკა
FlyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart
    
    if flyEnabled then
        FlyBtn.Text = "Fly: ON"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = rootPart
        
        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = rootPart.CFrame
        bg.Parent = rootPart
        
        task.spawn(function()
            while flyEnabled and character and rootPart do
                local cam = workspace.CurrentCamera
                local moveDir = Vector3.new(0, 0, 0)
                
                if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                
                bv.Velocity = moveDir * 50
                bg.CFrame = cam.CFrame
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    else
        FlyBtn.Text = "Fly: ON" -- temporary state reset
        FlyBtn.Text = "Fly: OFF"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)