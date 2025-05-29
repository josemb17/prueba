local StarterGui = game:GetService("StarterGui")
local StarterPack = game:GetService("StarterPack")
local Players = game:GetService("Players")

-- Crear la GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = StarterGui

-- Crear el botón
local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 200, 0, 50) -- Tamaño del botón
button.Position = UDim2.new(0.5, -100, 0.5, -25) -- Posición centrada
button.Text = "Duplicar Ítems"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Color rojo

-- Función para duplicar ítems
local function duplicateItems(player)
    for _, item in pairs(StarterPack:GetChildren()) do
        local clonedItem = item:Clone()
        clonedItem.Parent = player.Backpack -- Agrega el ítem clonado al inventario del jugador
    end
end

-- Conectar el botón con la función
button.MouseButton1Click:Connect(function()
    local player = Players.LocalPlayer
    if player then
        duplicateItems(player)
    end
end)
