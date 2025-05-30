local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

-- Crear botón para mostrar atributos
local showAttributesButton = Instance.new("TextButton")
showAttributesButton.Parent = screenGui
showAttributesButton.Size = UDim2.new(0, 200, 0, 50)
showAttributesButton.Position = UDim2.new(0.5, 0, 0.6, 0)
showAttributesButton.AnchorPoint = Vector2.new(0.5, 0.5)
showAttributesButton.Text = "Mostrar Atributos"
showAttributesButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
showAttributesButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Crear botón para duplicar ítem con modificación
local duplicateButton = Instance.new("TextButton")
duplicateButton.Parent = screenGui
duplicateButton.Size = UDim2.new(0, 200, 0, 50)
duplicateButton.Position = UDim2.new(0.5, 0, 0.75, 0)
duplicateButton.AnchorPoint = Vector2.new(0.5, 0.5)
duplicateButton.Text = "Duplicar con Modificación"
duplicateButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
duplicateButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Crear ventana de atributos
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 300, 0, 200)
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

-- Función para mostrar los atributos del ítem seleccionado
local function showItemAttributes()
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
            label.Text = attr.Name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.BackgroundTransparency = 1
        end
        
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #attributes * 25)
    else
        print("No hay ítem seleccionado.")
    end
end

-- Función para duplicar el ítem seleccionado con modificación
local function duplicateSelectedItem()
    local selectedItem = getSelectedItem()
    if selectedItem then
        local clonedItem = selectedItem:Clone()
        
        -- Modificar un atributo antes de copiarlo (Ejemplo: cambiar el nombre)
        clonedItem.Name = selectedItem.Name .. "_Modificado"
        
        clonedItem.Parent = Players.LocalPlayer.Backpack
        print("Ítem duplicado correctamente con modificaciones: " .. clonedItem.Name)
    else
        print("No se encontró un ítem seleccionado.")
    end
end

-- Conectar botones a sus funciones
showAttributesButton.MouseButton1Click:Connect(showItemAttributes)
duplicateButton.MouseButton1Click:Connect(duplicateSelectedItem)

print("Botones creados para mostrar atributos y duplicar ítem con modificación.")
