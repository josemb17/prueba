local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- Crear DataStore
local itemDataStore = DataStoreService:GetDataStore("PlayerBackpack")

-- Crear `RemoteEvent` si no existe
local DuplicateBackpackEvent = ReplicatedStorage:FindFirstChild("DuplicateBackpackEvent")
if not DuplicateBackpackEvent then
    DuplicateBackpackEvent = Instance.new("RemoteEvent")
    DuplicateBackpackEvent.Name = "DuplicateBackpackEvent"
    DuplicateBackpackEvent.Parent = ReplicatedStorage
end

-- Crear GUI en el cliente
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, 0, 0.5, 0)
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Text = "Duplicar Backpack"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Obtener el `Backpack` desde DataStore al entrar al juego
game.Players.PlayerAdded:Connect(function(player)
    local success, data = pcall(function()
        return itemDataStore:GetAsync(player.UserId)
    end)

    if success and data then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, itemName in pairs(data) do
                local item = Instance.new("Tool")
                item.Name = itemName
                item.Parent = backpack
            end
            print("Backpack cargado desde DataStore.")
        end
    else
        print("No se encontraron datos previos en DataStore.")
    end
end)

-- Duplicar el `Backpack` sin cambiar atributos y actualizar DataStore
button.MouseButton1Click:Connect(function()
    local player = Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")

    if backpack then
        local newItems = {}

        for _, item in pairs(backpack:GetChildren()) do
            local clonedItem = item:Clone()
            clonedItem.Parent = backpack -- Duplica el ítem en el Backpack
            table.insert(newItems, clonedItem.Name) -- Solo guarda el nombre en DataStore
        end

        -- Enviar solicitud al servidor para actualizar DataStore
        DuplicateBackpackEvent:FireServer(newItems)
        print("Backpack duplicado y solicitud enviada al servidor.")
    else
        print("No se encontró el Backpack del jugador.")
    end
end)

-- Script del servidor (Ejecutado en Delta)
DuplicateBackpackEvent.OnServerEvent:Connect(function(player, newItems)
    local success, errorMessage = pcall(function()
        itemDataStore:SetAsync(player.UserId, newItems)
    end)

    if success then
        print("Backpack actualizado en DataStore correctamente.")
    else
        print("Error al guardar en DataStore:", errorMessage)
    end
end)

print("Botón creado y listo para duplicar el Backpack y actualizar DataStore.")
