-- Grow a Garden Auto-Farm + Backpack Duplication

--// Servicios
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsertService = game:GetService("InsertService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer.Backpack
local PlayerGui = LocalPlayer.PlayerGui

--// Crear GUI para el botón
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -25)
button.Text = "Duplicar Inventario"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)

--// Función para duplicar los ítems del Backpack
local function duplicateBackpackItems()
    for _, item in pairs(Backpack:GetChildren()) do
        local clonedItem = item:Clone()
        clonedItem.Parent = Backpack -- Duplica el ítem en el inventario
    end
    print("Inventario duplicado correctamente.")
end

--// Conectar el botón a la función de duplicación
button.MouseButton1Click:Connect(duplicateBackpackItems)

print("Botón creado y listo para duplicar los ítems.")
