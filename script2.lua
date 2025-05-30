local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

-- Crear ventana de información (movible)
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, 0, 0.3, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Crear área desplazable para los atributos
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Parent = frame
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
scrollingFrame.ScrollBarThickness = 10
scrollingFrame.BackgroundTransparency = 1

-- Campo de entrada para el nuevo nombre
local nameInput = Instance.new("TextBox")
nameInput.Parent = frame
nameInput.Size = UDim2.new(0, 200, 0, 50)
nameInput.Position = UDim2.new(0.5, 0, 0.65, 0)
nameInput.AnchorPoint = Vector2.new(0.5, 0.5)
nameInput.Text = "Nuevo Nombre"
nameInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
nameInput.TextColor3 = Color3.fromRGB(0, 0, 0)

-- Botón para mostrar/ocultar información
local infoButton = Instance.new("TextButton")
infoButton.Parent = frame
infoButton.Size = UDim2.new(0, 200, 0, 50)
infoButton.Position = UDim2.new(0.5, 0, 0.8, 0)
infoButton.AnchorPoint = Vector2.new(0.5, 0.5)
infoButton.Text = "Mostrar/Ocultar Info"
infoButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
infoButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Botón para generar un nuevo ítem
local generateItemButton = Instance.new("TextButton")
generateItemButton.Parent = frame
generateItemButton.Size = UDim2.new(0, 200, 0, 50)
generateItemButton.Position = UDim2.new(0.5, 0, 0.95, 0)
generateItemButton.AnchorPoint = Vector2.new(0.5, 0.5)
generateItemButton.Text = "Generar Nuevo Ítem"
generateItemButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
generateItemButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Hacer el frame movible
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("Interfaz creada con opción de mover la ventana y modificar el nombre antes de duplicar.")
