local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

-- Crear botón de duplicar
local duplicateButton = Instance.new("TextButton")
duplicateButton.Parent = screenGui
duplicateButton.Size = UDim2.new(0, 200, 0, 50) 
duplicateButton.Position = UDim2.new(0.5, 0, 0.5, 0)
duplicateButton.AnchorPoint = Vector2.new(0.5, 0.5)
duplicateButton.Text = "Duplicar Ítem Seleccionado"
duplicateButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
duplicateButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Crear botón de mostrar/ocultar GUI
local toggleGuiButton = Instance.new("TextButton")
toggleGuiButton.Parent = screenGui
toggleGuiButton.Size = UDim2.new(0, 200, 0, 50) 
toggleGuiButton.Position = UDim2.new(0.5, 0, 0.6, 0)
toggleGuiButton.AnchorPoint = Vector2.new(0.5, 0.5)
toggleGuiButton.Text = "Mostrar/Ocultar GUI"
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
toggleGuiButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Función para identificar el ítem seleccionado
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

-- Función para duplicar el ítem con modificación de Age
local function duplicateSelectedItem()
    local selectedItem = getSelectedItem()
    if selectedItem then
        local clonedItem = selectedItem:Clone()

        -- Modificar el atributo "Age" si existe
        if clonedItem:FindFirstChild("Age") then
            clonedItem.Age.Value = clonedItem.Age.Value + 1 -- Aumentar la edad en 1
        else
            print("El ítem duplicado no tiene un atributo 'Age'.")
        end

        clonedItem.Parent = Players.LocalPlayer.Backpack
        print("Ítem duplicado correctamente con modificación de edad: " .. selectedItem.Name)
    else
        print("No se encontró un ítem seleccionado.")
    end
end

-- Función para alternar la visibilidad de la GUI
local function toggleGui()
    screenGui.Enabled = not screenGui.Enabled
    print("GUI " .. (screenGui.Enabled and "visible" or "oculta"))
end

-- Conectar los botones a sus funciones
duplicateButton.MouseButton1Click:Connect(duplicateSelectedItem)
toggleGuiButton.MouseButton1Click:Connect(toggleGui)

print("Botones creados: duplicar ítem y alternar visibilidad de GUI.")
