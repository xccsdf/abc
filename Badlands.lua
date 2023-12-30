getgenv().webhook = "https://discord.com/api/webhooks/1189020953850687488/9ctgyX2lWI-YNfbezdd1sJGktJ8cgWlFUDF6vYRDKjVZM6EnvpehHeWQCufjgyJo_uXE"
getgenv().webhookFail = "https://discord.com/api/webhooks/1190172592720580608/mXoKMDzC2TbSqIz9RxGrrkj8rYdUCA0VXxjZs1YwBRpcc8ew5xW4MpWfkvtxy-T01zqi"
getgenv().userid = "678416724474855425"

repeat wait() until game:IsLoaded()
if game.PlaceId == 15502339080 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LordPippo/PS99/main/HippoSniper.lua"))()
else
  loadstring(game:HttpGet("https://raw.githubusercontent.com/LordPippo/PS99/main/Hopper.lua"))()
end
