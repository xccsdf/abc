getgenv().webhook = "https://discord.com/api/webhooks/1187916919588802683/26XPvKERAu1M-kbxLQCnv1HVBdG3PfnDVm8VnHFtWPoD6neg3kunMXE8NdcJyCmDFvDM"
getgenv().alts = {"Badlandschunks", "Birb_Snek", "FJB_3", "Gooner1a", "Gooner1b", "Odae2020", "SatouMatsuzaka5", "SatouMatsuzaka6", "SatouMatsuzaka7", "SatouMatsuzaka69", "ShioKobe69", "ttemarshall307", "letmegrindit", "shinyluckyblocks", "DrBigg011"}
getgenv().mail = "tteliamclone"
repeat wait() until game:IsLoaded()
if game.PlaceId == 15502339080 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LordPippo/PS99/main/HippoSniper.lua"))()
else
  loadstring(game:HttpGet("https://raw.githubusercontent.com/LordPippo/PS99/main/Hopper.lua"))()
end
