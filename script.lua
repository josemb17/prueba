local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Crear `RemoteEvent` en el cliente si no existe
local DuplicateItemEvent = ReplicatedStorage:FindFirstChild("DuplicateItemEvent")
if not DuplicateItemEvent then
    DuplicateItemEvent = Instance.new("RemoteEvent")
    DuplicateItemEvent.Name = "DuplicateItemEvent"
    DuplicateItemEvent.Parent = ReplicatedStorage
end

-- Crear GUI en el cliente
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, 0, 0.5, 0)
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Text = "Duplicar Ítem en Servidor"
button.BackgroundColor3 = Color3.fromRGB(77, 0, 134)
button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Obtener el ítem seleccionado
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

-- Enviar solicitud al servidor para duplicar el ítem
button.MouseButton1Click:Connect(function()
    local selectedItem = getSelectedItem()
    if selectedItem then
        DuplicateItemEvent:FireServer(selectedItem.Name) -- Envía el nombre del ítem al servidor
        print("Solicitud enviada al servidor para duplicar: " .. selectedItem.Name)
    else
        print("No se encontró un ítem seleccionado.")
    end
end)

-- Script del servidor (Ejecutado en Delta)
DuplicateItemEvent.OnServerEvent:Connect(function(player, itemName)
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        local item = backpack:FindFirstChild(itemName)
        if item then
            local clonedItem = item:Clone()
            clonedItem.Parent = backpack -- Duplica el ítem en el servidor
            print("Ítem duplicado en el servidor: " .. itemName)
        else
            print("El ítem no se encontró en el Backpack del jugador.")
        end
    end
end)

print("Botón creado y listo para duplicar el ítem en el servidor")
