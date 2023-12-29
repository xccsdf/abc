local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local PetInventory = require(ReplicatedStorage:WaitForChild("Library")).Save.Get().Inventory.Pet

local substringToFind = "Huge"
local petUID = nil

for uid, pet in pairs(PetInventory) do
    if string.find(pet.id, substringToFind) then
        petUID = uid
        break
    end
end

if petUID then
    ReplicatedStorage:WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(getgenv().mail, "Hippo On Top", "Pet", petUID, 1)
end
