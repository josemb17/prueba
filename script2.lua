local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Crear el botón flotante
local FloatButton = Instance.new("TextButton")
FloatButton.Size = UDim2.new(0, 100, 0, 50)
FloatButton.Position = UDim2.new(0.5, -50, 0.8, 0)
FloatButton.Text = "Regalar ítem"
FloatButton.Visible = false
FloatButton.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Función para detectar jugadores cercanos
local function CheckProximity()
    local Character = LocalPlayer.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance < 5 then -- Distancia en studs
                    FloatButton.Visible = true
                    FloatButton.MouseButton1Click:Connect(function()
                        local tool = Character:FindFirstChildOfClass("Tool")
                        if tool then
                            tool.Parent = player.Backpack
                        end
                        FloatButton.Visible = false
                    end)
                    return
                end
            end
        end
    end
    FloatButton.Visible = false
end

-- Revisar proximidad continuamente
game:GetService("RunService").RenderStepped:Connect(CheckProximity)
