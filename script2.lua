local Players = game:GetService("Players")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

-- Crear ventana de información
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, 0, 0.3, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Visible = false

-- Crear área desplazable para los atributos
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Parent = frame
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
scrollingFrame.ScrollBarThickness = 10
scrollingFrame.BackgroundTransparency = 1

-- Crear botón para mostrar/ocultar información
local infoButton = Instance.new("TextButton")
infoButton.Parent = screenGui
infoButton.Size = UDim2.new(0, 200, 0, 50)
infoButton.Position = UDim2.new(0.5, 0, 0.6, 0)
infoButton.AnchorPoint = Vector2.new(0.5, 0.5)
infoButton.Text = "Mostrar/Ocultar Info"
infoButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
infoButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Función para obtener el ítem seleccionado
local function getSelectedItem()
    local player = Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")

    if backpack and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid:IsA("Humanoid") and humanoid.Parent then
            local tool = humanoid.Parent:FindFirstChildOfClass("Tool") -- Busca el ítem equipado
            return tool
        end
    end
    return nil
end

-- Función para extraer y mostrar la información del ítem
local function extractItemInfo()
    frame.Visible = not frame.Visible -- Alternar visibilidad
    
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    local selectedItem = getSelectedItem()
    if selectedItem then
        local attributes = selectedItem:GetChildren()
        
        for i, attr in ipairs(attributes) do
            local label = Instance.new("TextLabel")
            label.Parent = scrollingFrame
            label.Size = UDim2.new(1, 0, 0, 25)
            label.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
            label.Text = attr.Name .. ": " .. (attr:IsA("ValueBase") and tostring(attr.Value) or "Objeto")
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.BackgroundTransparency = 1
        end
        
        -- Mostrar propiedades generales
        local generalProps = {"Parent", "ClassName", "Archivable", "Name"}
        for i, prop in ipairs(generalProps) do
            local label = Instance.new("TextLabel")
            label.Parent = scrollingFrame
            label.Size = UDim2.new(1, 0, 0, 25)
            label.Position = UDim2.new(0, 0, 0, (#attributes + i - 1) * 25)
            label.Text = prop .. ": " .. tostring(selectedItem[prop])
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.BackgroundTransparency = 1
        end
        
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, (#attributes + #generalProps) * 25)
    else
        print("No se encontró un ítem seleccionado.")
    end
end

-- Conectar el botón a la función
infoButton.MouseButton1Click:Connect(extractItemInfo)

print("Botón creado para mostrar información del ítem seleccionado.")
