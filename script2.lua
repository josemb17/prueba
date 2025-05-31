local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local itemStore = DataStoreService:GetDataStore("DuplicatedItemsStore")

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

-- Campo de entrada para el nuevo nombre
local nameInput = Instance.new("TextBox")
nameInput.Parent = screenGui
nameInput.Size = UDim2.new(0, 200, 0, 50)
nameInput.Position = UDim2.new(0.5, 0, 0.7, 0)
nameInput.AnchorPoint = Vector2.new(0.5, 0.5)
nameInput.Text = "Nuevo Nombre"
nameInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
nameInput.TextColor3 = Color3.fromRGB(0, 0, 0)

-- Botón para generar un nuevo ítem
local generateItemButton = Instance.new("TextButton")
generateItemButton.Parent = screenGui
generateItemButton.Size = UDim2.new(0, 200, 0, 50)
generateItemButton.Position = UDim2.new(0.5, 0, 0.8, 0)
generateItemButton.AnchorPoint = Vector2.new(0.5, 0.5)
generateItemButton.Text = "Generar Nuevo Ítem"
generateItemButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
generateItemButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Obtener ítem seleccionado
local function getSelectedItem()
    local player = Players.LocalPlayer
    if player and player.Character then
        return player.Character:FindFirstChildOfClass("Tool")
    end
    return nil
end

-- Duplicar ítem con nombre personalizado y guardarlo
local function duplicateSelectedItem()
    local selectedItem = getSelectedItem()
    if selectedItem then
        local clonedItem = selectedItem:Clone()
        local newName = nameInput.Text
        
        if newName and newName ~= "" and newName ~= "Nuevo Nombre" then
            clonedItem.Name = newName
        else
            clonedItem.Name = selectedItem.Name .. "_Nuevo"
        end

        clonedItem.Parent = Players.LocalPlayer.Backpack

        -- Guardar en DataStore
        local playerKey = tostring(Players.LocalPlayer.UserId)
        local success, errorMessage = pcall(function()
            itemStore:SetAsync(playerKey, clonedItem.Name)
        end)
        
        if success then
            print("Ítem guardado correctamente en DataStore.")
        else
            print("Error al guardar el ítem: " .. errorMessage)
        end
    else
        print("No se encontró un ítem seleccionado.")
    end
end

-- Cargar ítems al entrar
Players.PlayerAdded:Connect(function(player)
    local playerKey = tostring(player.UserId)
    local success, storedItem = pcall(function()
        return itemStore:GetAsync(playerKey)
    end)
    
    if success and storedItem then
        print("Ítem recuperado: " .. storedItem)
    else
        print("No se encontraron ítems guardados.")
    end
end)

-- Guardar ítems al salir
Players.PlayerRemoving:Connect(function(player)
    local playerKey = tostring(player.UserId)
    local success, errorMessage = pcall(function()
        itemStore:SetAsync(playerKey, getSelectedItem() and getSelectedItem().Name or "")
    end)

    if success then
        print("Ítem guardado correctamente al salir del juego.")
    else
        print("Error al guardar el ítem al salir: " .. errorMessage)
    end
end)

-- Conectar el botón
generateItemButton.MouseButton1Click:Connect(duplicateSelectedItem)

print("Interfaz creada con DataStore para guardar ítems duplicados.")
