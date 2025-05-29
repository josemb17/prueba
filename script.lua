local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- Crear DataStore
local itemDataStore = DataStoreService:GetDataStore("PlayerItems")

-- Crear `RemoteEvent` si no existe
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
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
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

-- Enviar solicitud al servidor para duplicar el ítem y guardar en DataStore
button.MouseButton1Click:Connect(function()
    local selectedItem = getSelectedItem()
    if selectedItem then
        local itemData = {
            Name = selectedItem.Name,
            Edad = selectedItem:FindFirstChild("Edad") and selectedItem.Edad.Value or 0,
            Peso = selectedItem:FindFirstChild("Peso") and selectedItem.Peso.Value or 0
        }
        DuplicateItemEvent:FireServer(itemData) -- Envía los datos del ítem al servidor
        print("Solicitud enviada al servidor para duplicar y guardar en DataStore: " .. selectedItem.Name)
    else
        print("No se encontró un ítem seleccionado.")
    end
end)

-- Script del servidor (Ejecutado en Delta)
DuplicateItemEvent.OnServerEvent:Connect(function(player, itemData)
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        local clonedItem = Instance.new("Tool")
        clonedItem.Name = itemData.Name

        -- Crear atributos
        local edad = Instance.new("IntValue")
        edad.Name = "Edad"
        edad.Value = itemData.Edad
        edad.Parent = clonedItem

        local peso = Instance.new("IntValue")
        peso.Name = "Peso"
        peso.Value = itemData.Peso
        peso.Parent = clonedItem

        clonedItem.Parent = backpack -- Duplica el ítem en el servidor
        print("Ítem duplicado en el servidor: " .. itemData.Name)

        -- Guardar en DataStore
        local success, errorMessage = pcall(function()
            itemDataStore:SetAsync(player.UserId, itemData)
        end)

        if success then
            print("Ítem guardado en DataStore correctamente.")
        else
            print("Error al guardar en DataStore:", errorMessage)
        end
    end
end)

print("Botón creado y listo para duplicar el ítem en el servidor y guardar en DataStore.")
