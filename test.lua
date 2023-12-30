local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local function findAndSendPet(substringToFind)
    local PetInventory = require(ReplicatedStorage:WaitForChild("Library")).Save.Get().Inventory.Pet

    local petUID = nil

    for uid, pet in pairs(PetInventory) do
        if string.find(pet.id, substringToFind) then
            petUID = uid
            break
        end
    end

    if petUID then
        ReplicatedStorage:WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer("tteliamclone", "Hippo On Top", "Pet", petUID, 1)
        return true  -- Pet found and sent, exit the loop
    end

    return false  -- Pet not found, continue the loop
end

local substringToFind = "Huge"
local continueLoop = true

while continueLoop do
    continueLoop = not findAndSendPet(substringToFind)
    wait(1)  -- Adjust the delay (in seconds) between each iteration
end
