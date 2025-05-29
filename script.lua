local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local DataStoreService = game:GetService("DataStoreService")

-- Crear carpeta Tools si no existe
local ToolsFolder = ServerStorage:FindFirstChild("Tools")
if not ToolsFolder then
    ToolsFolder = Instance.new("Folder")
    ToolsFolder.Name = "Tools"
    ToolsFolder.Parent = ServerStorage
    warn("🧰 Carpeta 'Tools' creada en ServerStorage. Agrega aquí tus ítems base.")
end

-- Crear RemoteEvent si no existe
local duplicateEvent = ReplicatedStorage:FindFirstChild("DuplicateItemEvent")
if not duplicateEvent then
    duplicateEvent = Instance.new("RemoteEvent")
    duplicateEvent.Name = "DuplicateItemEvent"
    duplicateEvent.Parent = ReplicatedStorage
end

-- Crear DataStore
local inventoryStore = DataStoreService:GetDataStore("PlayerInventoryData")

-- LocalScript que se insertará en PlayerGui
local function createDuplicationButtonScript()
    local scriptSource = [[
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local player = Players.LocalPlayer

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "DuplicateItemGUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = player:WaitForChild("PlayerGui")

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 200, 0, 50)
        button.Position = UDim2.new(0.5, 0, 0.9, 0)
        button.AnchorPoint = Vector2.new(0.5, 0.5)
        button.Text = "Duplicar Ítem Equipado"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 18
        button.Parent = screenGui

        local remote = ReplicatedStorage:WaitForChild("DuplicateItemEvent")

        local function getEquippedItemName()
            local character = player.Character
            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    return tool.Name
                end
            end
            return nil
        end

        button.MouseButton1Click:Connect(function()
            local itemName = getEquippedItemName()
            if itemName then
                remote:FireServer(itemName)
            else
                warn("No tienes ningún ítem equipado.")
            end
        end)
    ]]

    local localScript = Instance.new("LocalScript")
    localScript.Source = scriptSource
    return localScript
end

-- Cargar inventario del jugador
local function loadInventory(player)
    local backpack = player:WaitForChild("Backpack")
    local success, data = pcall(function()
        return inventoryStore:GetAsync(player.UserId)
    end)
    if success and data then
        for toolName, count in pairs(data) do
            local template = ToolsFolder:FindFirstChild(toolName)
            if template then
                for i = 1, count do
                    local clone = template:Clone()
                    clone.Parent = backpack
                end
            end
        end
    end
end

-- Guardar inventario al salir
local function saveInventory(player)
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end

    local inventory = {}
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            inventory[item.Name] = (inventory[item.Name] or 0) + 1
        end
    end

    pcall(function()
        inventoryStore:SetAsync(player.UserId, inventory)
    end)
end

-- Duplicar ítem desde el servidor
duplicateEvent.OnServerEvent:Connect(function(player, itemName)
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end

    local existingTool = backpack:FindFirstChild(itemName)
        or (player.Character and player.Character:FindFirstChild(itemName))

    if existingTool and existingTool:IsA("Tool") then
        local clone = existingTool:Clone()
        clone.Parent = backpack
        print("✅ Ítem duplicado: " .. itemName .. " para " .. player.Name)
    else
        warn("❌ No se encontró el ítem para duplicar: " .. itemName)
    end
end)

-- Al entrar el jugador
Players.PlayerAdded:Connect(function(player)
    loadInventory(player)

    -- Esperar PlayerGui y clonar GUI
    player.CharacterAdded:Wait()
    task.wait(1)
    local guiScript = createDuplicationButtonScript()
    guiScript.Parent = player:WaitForChild("PlayerGui")
end)

-- Al salir
Players.PlayerRemoving:Connect(saveInventory)
