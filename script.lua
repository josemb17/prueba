local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Crear GUI en el cliente
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

-- Crear botón centrado
local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 200, 0, 50) -- Tamaño del botón
button.Position = UDim2.new(0.5, 0, 0.5, 0) -- Se coloca en el centro de la pantalla
button.AnchorPoint = Vector2.new(0.5, 0.5) -- Ajusta el punto de anclaje para que esté realmente centrado
button.Text = "Duplicar Ítems"
button.BackgroundColor3 = Color3.fromRGB(77, 0, 134) -- Color rojo
button.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco

-- Función para duplicar ítems en el cliente
local function duplicateItems()
    local player = Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")

    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            local clonedItem = item:Clone()
            clonedItem.Parent = backpack -- Agrega el ítem clonado al inventario
        end
        print("Inventario duplicado correctamente.")
    else
        print("No se encontró el Backpack del jugador.")
    end
end

-- Conectar el botón a la función
button.MouseButton1Click:Connect(duplicateItems)

print("Botón creado y centrado automáticamente")
