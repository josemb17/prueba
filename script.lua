local StarterGui = game:GetService("StarterGui")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = StarterGui

-- Crear el botón
local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 200, 0, 50) -- Tamaño del botón
button.Position = UDim2.new(0.5, -100, 0.5, -25) -- Posición centrada
button.Text = "Duplicar"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Color rojo

-- Función al presionar el botón
button.MouseButton1Click:Connect(function()
    print("Botón presionado, ejecutando duplicación...")
    -- Aquí puedes llamar a la función de duplicado
end)
