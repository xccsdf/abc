--[[
Credits List
ethereum: creating the base sniper
chocolog: providing type.huge
Edmond: offered tips for optimization
LordHippo: Buy List 
]]--

local osclock = os.clock()
repeat task.wait() until game:IsLoaded()

setfpscap(35)
game:GetService("RunService"):Set3dRenderingEnabled(false)
local Booths_Broadcast = game:GetService("ReplicatedStorage").Network:WaitForChild("Booths_Broadcast")
local Players = game:GetService('Players')
local getPlayers = Players:GetPlayers()
local PlayerInServer = #getPlayers
local http = game:GetService("HttpService")
local ts = game:GetService("TeleportService")
local rs = game:GetService("ReplicatedStorage")
local Library = require(rs:WaitForChild('Library'))

local vu = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   task.wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

local function processListingInfo(uid, gems, item, version, shiny, amount, boughtFrom, boughtStatus, class, failMessage,)
    local gemamount = Players.LocalPlayer.leaderstats["💎 Diamonds"].Value
    local snipeMessage =""
    local weburl, webContent, webcolor
    local versionVal = { [1] = "Golden ", [2] = "Rainbow " }
    local versionStr = versionVal[version] or (version == nil and "")
    local mention = (string.find(item, "Huge") or string.find(item, "Titanic")) and "<@" .. userid .. ">" or ""
	
    if boughtStatus then
	webcolor = tonumber(0x00ff00)
	weburl = webhook
        snipeMessage = snipeMessage .. " just sniped a "
        webContent = mention
	end
    else
	webContent = failMessage
	webcolor = tonumber(0xff0000)
	weburl = webhookFail
	snipeMessage = snipeMessage .. " failed to snipe a "
	end
    end
    
    snipeMessage = snipeMessage .. "**" .. versionStr
    
    if shiny then
        snipeMessage = snipeMessage .. " Shiny "
    end
    
    snipeMessage = snipeMessage .. item .. "**"
    
local message1 = {
    content = webContent,
    embeds = {
        {
            author = {
                name = "🌟 Reimu's Epic Purchase 🌟",
                icon_url = "https://cdn.discordapp.com/attachments/1122535236996182099/1189213923073871953/EmrJ9tNVcAIhVzB.png?ex=659d58c5&is=658ae3c5&hm=c55bc9b5323c6aa542d6a99b4e42c20a0255377566c3bc2d047f63bffce70b7e&",
            },
            title = snipeMessage,
            color = webcolor,
            timestamp = DateTime.now():ToIsoDate(),
            thumbnail = {
                url = "https://cdn.discordapp.com/attachments/1167165734674247870/1191840941699514550/ezgif-5-603de3d74d.gif?ex=65a6e75f&is=6594725f&hm=7eb6d7e727339bbfae14a235420de725d2f12061b74953fd2390c6964d73b45c&",
            },
            fields = {
                {
                    name = "🛒 __*PURCHASE INFO:*__ 🛒",
                    value = "\n\n",
                },
                {
                    name = "🤑 PRICE:",
                    value = string.format("%s", tostring(gems):reverse():gsub("%d%d%d", "%1,"):reverse()),
                },
                {
                    name = "📦 AMOUNT:",
                    value = tostring(amount),
                },
                {
                    name = "🤡 BOUGHT FROM:",
                    value = "||" .. tostring(boughtFrom) .. "||",
                },
                {
                    name = "🔖 PETID:",
                    value = "||" .. tostring(uid) .. "|| \n\n",
                },
                {
                    name = "👥 __*USER INFO:*__ 👥",
                    value = "\n\n",
                },
                {
                    name = "👤 USER:",
                    value = "||" .. game.Players.LocalPlayer.Name .. "||",
                },
                {
                    name = "💎 GEM'S LEFT:",
                    value = string.format("%s", tostring(gemamount):reverse():gsub("%d%d%d", "%1,"):reverse()),
                },
            },
            footer = {
                icon_url = "https://cdn.discordapp.com/attachments/1122535236996182099/1189213923073871953/EmrJ9tNVcAIhVzB.png?ex=659d58c5&is=658ae3c5&hm=c55bc9b5323c6aa542d6a99b4e42c20a0255377566c3bc2d047f63bffce70b7e&", -- optional
                text = "Touhou Sniper"
            }
        },
    },
}
    local jsonMessage = http:JSONEncode(message1)
    local success, webMessage = pcall(function()
	http:PostAsync(weburl, jsonMessage)
    end)
    if success == false then
        local response = request({
            Url = weburl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonMessage
        })
    end
end

local function tryPurchase(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
    if buytimestamp > listTimestamp then
      task.wait(3.4 - Players.LocalPlayer:GetNetworkPing())
    end
    local boughtPet, boughtMessage = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, class, boughtMessage,)
end

Booths_Broadcast.OnClientEvent:Connect(function(username, message)
        if type(message) == "table" then
            local highestTimestamp = -math.huge -- Initialize with the smallest possible number
            local key = nil
            local listing = nil
            for v, value in pairs(message["Listings"] or {}) do
                if type(value) == "table" and value["ItemData"] and value["ItemData"]["data"] then
                    local timestamp = value["Timestamp"]
                    if timestamp > highestTimestamp then
                        highestTimestamp = timestamp
                        key = v
                        listing = value
                    end
                end
            end
            if listing then
                local buytimestamp = listing["ReadyTimestamp"]
                local listTimestamp = listing["Timestamp"]
                local data = listing["ItemData"]["data"]
                local gems = tonumber(listing["DiamondCost"])
                local uid = key
                local item = data["id"]
                local version = data["pt"]
                local shiny = data["sh"]
                local amount = tonumber(data["_am"]) or 1
                local playerid = message['PlayerID']
                local class = tostring(listing["ItemData"]["class"])
                local unitGems = gems/amount
                                 
                -- Pets
                if string.find(item, "Huge") and unitGems <= 100000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                    elseif type.huge and unitGems <= 1000000 then
			coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                        return
		    end
                elseif class == "Pet" then
                    local type = Library.Directory.Pets[item]
                    if type.exclusiveLevel and unitGems <= 15000 and item ~= "Banana" and item ~= "Coin" then
                        coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                        return
                    elseif type.titanic and unitGems <= 10000000 then
			coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                        return

                -- Presents and Eggs
                elseif class == "Egg" and unitGems <= 30000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif (item == "Titanic Christmas Present" or string.find(item, "2024 New Year")) and unitGems <= 30000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return

                -- Items
                elseif item == "Crystal Key" and unitGems <= 10000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Crystal Key Lower Half" and unitGems <= 5000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Crystal Key Upper Half" and unitGems <= 5000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Spinny Wheel Ticket" and unitGems <= 5000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Booth Slot Voucher" and unitGems <= 25000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif string.find(item, "Charm") and unitGems <= 100000 and item ~= "Agility Charm" and item ~= "Coin Charm" and item ~= "Bonus Charm" and item ~= "Charm Stone" then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return

                -- Enchants    
                elseif class == "Enchant" and unitGems <= 30000 then
                if item == "Chest Breaker" and unitGems <= 10000000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif string.find(item, "Chest Mimic") and unitGems <= 1000000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Huge Hunter" and unitGems <= 1000000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Starfall" and unitGems <= 1000000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Super Lightning" and unitGems <= 1000000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Lucky Block" and unitGems <= 100000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Fortune" and unitGems <= 100000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Massive Comet" and unitGems <= 100000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Shiny Hunter" and unitGems <= 100000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Party Time" and unitGems <= 45000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Exotic Pet" and unitGems <= 25000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return

                -- Misc Items
                elseif class == "HoverBoard" and unitGems <= 30000 then 
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif class == "Booth" and unitGems <= 10000 and item ~= "Christmas" and item ~= "Dragon" and item ~= "Rainbow" and item ~= "Gold" and item ~= "Cat" and item ~= "Egg" and item ~= "Monkey" then     
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return

                    -- Potion   
                elseif item == "The Cocktail" and gems <= 50000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif string.find(item, "Potion VIII") and price <= 50000 and item == "Diamonds Potion VI" then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return

                    -- Tools 
                elseif item == "Golden Shovel" and unitGems <= 150000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Golden Fishing Rod" and unitGems <= 25000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Golden Watering Can" and unitGems <= 25000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                elseif item == "Exotic Treasure Flag" and unitGems <= 50000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,)
                    return
                end
            end
        end
    end
end)

local function jumpToServer() 
    local sfUrl = "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=%s&excludeFullGames=true" 
    local req = request({ Url = string.format(sfUrl, 15502339080, "Desc", 50) }) 
    local body = http:JSONDecode(req.Body) 
    local deep = math.random(1, 5)
    if deep > 1 then 
        for i = 1, deep, 1 do 
             req = request({ Url = string.format(sfUrl .. "&cursor=" .. body.nextPageCursor, 15502339080, "Desc", 50) }) 
             body = http:JSONDecode(req.Body) 
             task.wait(0.1)
        end 
    end 
    local servers = {} 
    if body and body.data then 
        for i, v in next, body.data do 
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, v.id)
            end
        end
    end
    local randomCount = #servers
    if not randomCount then
       randomCount = 2
    end
    ts:TeleportToPlaceInstance(15502339080, servers[math.random(1, randomCount)], game:GetService("Players").LocalPlayer) 
end

if PlayerInServer < 25 then
    while task.wait(1) do
	jumpToServer()
    end
end

for i = 1, PlayerInServer do
   for ii = 1,#alts do
        if getPlayers[i].Name == alts[ii] and alts[ii] ~= Players.LocalPlayer.Name then
            while task.wait(1) do
		jumpToServer()
	    end
        end
    end
end

Players.PlayerRemoving:Connect(function(player)
    getPlayers = Players:GetPlayers()
    PlayerInServer = #getPlayers
    if PlayerInServer < 25 then
        while task.wait(1) do
	    jumpToServer()
	end
    end
end) 

Players.PlayerAdded:Connect(function(player)
    for i = 1,#alts do
        if player.Name == alts[i] and alts[i] ~= Players.LocalPlayer.Name then
	    task.wait(math.random(0, 60))
            while task.wait(1) do
	        jumpToServer()
	    end
        end
    end
end) 

local hopDelay = math.random(900, 1200)

while task.wait(1) do
    if math.floor(os.clock() - osclock) >= hopDelay then
        while task.wait(1) do
	    jumpToServer()		
	end	
    end
end
