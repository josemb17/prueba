local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Buscar RemoteEvent (si no existe, crearlo)
local SolicitarRegalo = ReplicatedStorage:FindFirstChild("SolicitarRegalo") 
if not SolicitarRegalo then
    SolicitarRegalo = Instance.new("RemoteEvent")
    SolicitarRegalo.Name = "SolicitarRegalo"
    SolicitarRegalo.Parent = ReplicatedStorage
end

-- Buscar evento del sistema de regalos
local GameEvents = ReplicatedStorage:FindFirstChild("GameEvents")
local PetGiftingService = GameEvents and GameEvents:FindFirstChild("PetGiftingService")

local localPlayer = Players.LocalPlayer

-- Función para encontrar al jugador más cercano
local function EncontrarJugadorCercano()
    local senderCharacter = localPlayer.Character
    if not senderCharacter or not senderCharacter:FindFirstChild("HumanoidRootPart") then return end

    local jugadorMasCercano = nil
    local menorDistancia = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distancia = (senderCharacter.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distancia < 5 and distancia < menorDistancia then -- Rango de proximidad
                menorDistancia = distancia
                jugadorMasCercano = player
            end
        end
    end

    return jugadorMasCercano
end

-- Evento en el servidor que recibe la solicitud y activa GiftPet
SolicitarRegalo.OnServerEvent:Connect(function(sender, targetPlayer)
    if targetPlayer and targetPlayer.Character and PetGiftingService then
        print(sender.Name .. " ha solicitado un regalo de " .. targetPlayer.Name)
        
        -- Activar PetGiftingService para el jugador objetivo
        local args = { [1] = "GivePet", [2] = sender }
        PetGiftingService:FireServer(unpack(args))
    end
end)

-- Cliente envía solicitud al servidor al presionar "G"
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        local jugadorCercano = EncontrarJugadorCercano()
        if jugadorCercano then
            SolicitarRegalo:FireServer(jugadorCercano) -- Solicitar regalo al jugador cercano
            print("Solicitud de regalo enviada a: " .. jugadorCercano.Name)
        else
            print("No hay jugadores cercanos para solicitar regalo.")
        end
    end
end)
