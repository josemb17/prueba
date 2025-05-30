local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

-- Crear botón centrado
local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 200, 0, 50) 
button.Position = UDim2.new(0.5, 0, 0.5, 0)
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Text = "Duplicar Ítem Seleccionado"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Identificar el ítem seleccionado
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

-- Duplicar ítem seleccionado con modificación de atributo
local function duplicateSelectedItem()
    local selectedItem = getSelectedItem()
    if selectedItem then
        local clonedItem = selectedItem:Clone()
        
        -- Modificar el atributo "Age" si existe
        if clonedItem:FindFirstChild("Age") then
            clonedItem.Age.Value = clonedItem.Age.Value + 1 -- Ejemplo: aumentar la edad en 1
        else
            print("El ítem duplicado no tiene un atributo 'Age'.")
        end
        
        clonedItem.Parent = Players.LocalPlayer.Backpack
        print("Ítem duplicado correctamente con modificación de edad: " .. selectedItem.Name)
    else
        print("No se encontró un ítem seleccionado.")
    end
end

-- Conectar el botón a la función
button.MouseButton1Click:Connect(duplicateSelectedItem)

print("Botón creado y listo para duplicar el ítem con modificación de edad.")
