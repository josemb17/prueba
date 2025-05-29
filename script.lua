local StarterPack = game:GetService("StarterPack")
local Players = game:GetService("Players")

local function duplicateItems(player)
    for _, item in pairs(StarterPack:GetChildren()) do
        local clonedItem = item:Clone()
        clonedItem.Parent = player.Backpack -- Asigna el ítem clonado al inventario del jugador
    end
end

game.Players.PlayerAdded:Connect(function(player)
    duplicateItems(player)
end)
