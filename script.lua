local StarterPack = game:GetService("StarterPack")
local Players = game:GetService("Players")

local function duplicateItems(player)
    for _, item in pairs(StarterPack:GetChildren()) do
        local clonedItem = item:Clone()
        clonedItem.Parent = player.Backpack -- Agrega el ítem clonado al inventario del jugador
    end
end

-- Espera a que el jugador esté listo
local player = game.Players.LocalPlayer
if player then
    duplicateItems(player)
end
