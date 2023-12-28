getgenv().webhook = ""
getgenv().alts = {}
if game.PlaceId == 15502339080 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LordPippo/PS99/main/HippoSniper.lua"))()
else
  loadstring(game:HttpGet("https://raw.githubusercontent.com/LordPippo/PS99/main/Hopper.lua"))()
end
