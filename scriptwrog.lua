local StarterPack = game:GetService("StarterPack")
local Players = game:GetService("Players")

local function duplicateItems(player)
	for _, item in pairs(StarterPack:GetChildren()) do
		local clonedItem = item:Clone()
		clonedItem.Parent = player.Backpack 
	end
end

local button = script.Parent
button.MouseButton1Click:Connect(function()
	local player = Players.LocalPlayer
	if player then
		duplicateItems(player)
	end
end)
