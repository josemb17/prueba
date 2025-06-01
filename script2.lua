local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local DataFolder = ReplicatedStorage:FindFirstChild("Data")
local PetRegistry = DataFolder and DataFolder:FindFirstChild("PetRegistry")
local PetStateRegistry = PetRegistry and PetRegistry:FindFirstChild("PetStateRegistry")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui") -- Asegurar que la GUI esté cargada

-- 📌 **Declarar el ID de la Pet que queremos clonar**
local petIDObjetivo = "{7b7046b6-a1b1-48e7-9733-eb63a34c813b}"

-- 🎨 **Crear la GUI desde el script**
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

local draggableButton = Instance.new("TextButton")
draggableButton.Parent = screenGui
draggableButton.Size = UDim2.new(0, 200, 0, 50) -- Tamaño del botón
draggableButton.Position = UDim2.new(0.5, -100, 0.8, 0) -- Posición inicial
draggableButton.Text = "Clonar Pet"
draggableButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Color azul
draggableButton.TextColor3 = Color3.new(1, 1, 1) -- Texto en blanco
draggableButton.Font = Enum.Font.SourceSansBold
draggableButton.TextSize = 20
draggableButton.BorderSizePixel = 3

-- 🖐 **Habilitar movimiento con Touch**
local isDragging = false
local startPos, startInput

local function onInputBegan(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        startPos = draggableButton.Position
        startInput = input.Position
    end
end

local function onInputChanged(input)
    if isDragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - startInput
        draggableButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

local function onInputEnded(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputChanged:Connect(onInputChanged)
UserInputService.InputEnded:Connect(onInputEnded)

-- 🔍 **Función para buscar la Pet por ID en `PetStateRegistry`**
local function GetPetByID(petID)
    if PetStateRegistry then
        for _, pet in ipairs(PetStateRegistry:GetChildren()) do
            if pet:GetAttribute("PetID") == petID then
                return pet
            end
        end
    end
    return nil
end

-- ✨ **Función para clonar la Pet y cambiar solo el último dígito del ID**
local function ClonePetWithNewID()
    local originalPet = GetPetByID(petIDObjetivo)
    if originalPet then
        local newPet = originalPet:Clone()
        newPet.Parent = PetStateRegistry -- Guardar en el registro

        local petName = originalPet:GetAttribute("Name")
        local petAge = originalPet:GetAttribute("Age")
        local petWeight = originalPet:GetAttribute("Weight")

        -- Cambiar solo el último dígito del ID
        local newLastDigit = tostring(math.random(0, 9))
        local newID = petIDObjetivo:sub(1, #petIDObjetivo - 1) .. newLastDigit

        -- Asignar el nuevo ID sin cambiar el nombre
        newPet:SetAttribute("PetID", newID)
        newPet:SetAttribute("Age", petAge + 1) -- Aumentar edad
        newPet:SetAttribute("Weight", petWeight * 0.9) -- Reducir peso en 10%

        print("Nueva Pet creada con ID: " .. newID .. ", Nombre: " .. petName .. ", Edad: " .. newPet:GetAttribute("Age") .. ", Peso: " .. newPet:GetAttribute("Weight"))
    else
        print("La Pet con ID " .. petIDObjetivo .. " no fue encontrada en `PetStateRegistry`.")
    end
end

-- 🎯 **Conectar el botón GUI para ejecutar la clonación**
draggableButton.MouseButton1Click:Connect(function()
    ClonePetWithNewID()
end)
