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
local playerID

local vu = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   task.wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

for i = 1, PlayerInServer do
   for ii = 1,#alts do
        if getPlayers[i].Name == alts[ii] and alts[ii] ~= Players.LocalPlayer.Name then
            jumpToServerIfHighPingAndPlayerLimit()
        end
    end
end

local function processListingInfo(uid, gems, item, version, shiny, amount, boughtFrom, boughtStatus, mention)
    local gemamount = Players.LocalPlayer.leaderstats["💎 Diamonds"].Value
    local snipeMessage =""
    local weburl, webContent, webcolor
    if version then
        if version == 2 then
            version = "Rainbow "
        elseif version == 1 then
            version = "Golden "
        end
    else
       version = ""
    end

    if boughtStatus then
	webcolor = tonumber(0x00ff00)
	weburl = webhook
        snipeMessage = snipeMessage .. " Just sniped a "
	if mention then 
            webContent = "<@".. userid ..">"
        else
	    webContent = ""
	end
    else
	webcolor = tonumber(0xff0000)
	weburl = webhookFail
	snipeMessage = snipeMessage .. " Failed to snipe a "
    end
    
    snipeMessage = snipeMessage .. "**" .. version
    
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
                text = "Touhou Sniper",
                icon_url = "https://cdn.discordapp.com/attachments/1122535236996182099/1189213923073871953/EmrJ9tNVcAIhVzB.png?ex=659d58c5&is=658ae3c5&hm=c55bc9b5323c6aa542d6a99b4e42c20a0255377566c3bc2d047f63bffce70b7e&", -- optional
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

local ReadyToBuy = function()
    -- Assuming Booths Frontend is directly under StarterPlayerScripts
    local BoothsFrontendScript = game.StarterPlayer.StarterPlayerScripts:WaitForChild("Booths Frontend") -- Adjust the name accordingly

    -- Call the functions to get the current values
    local currentYouCannotBuyThatYet = BoothsFrontendScript.YouCannotBuyThatYet()
    local currentReadyTimestamp = BoothsFrontendScript.ReadyTimestamp()

    -- Check if YouCannotBuyThatYet has changed to ReadyTimestamp
    if currentYouCannotBuyThatYet ~= currentReadyTimestamp then
        print("YouCannotBuyThatYet has not changed to ReadyTimestamp yet.")
        -- Add any additional actions or logic here if needed
    else
        print("YouCannotBuyThatYet has changed to ReadyTimestamp.")
        -- Add the logic you want to execute when the change occurs
        -- For example:
        -- local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        -- processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    end
end

local function checklisting(uid, gems, item, version, shiny, amount, username, playerid)
    local Library = require(rs:WaitForChild('Library'))
    local purchase = rs.Network.Booths_RequestPurchase
    gems = tonumber(gems)
    local ping = false
    local type = {}
    pcall(function()
        type = Library.Directory.Pets[item]
    end)

    if amount == nil then
        amount = 1
    end

    local price = gems / amount
     
    if type.huge and price <= 1000000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        if boughtPet == true then
            ping = true
        end
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif type.exclusiveLevel and price <= 10000 and item ~= "Banana" and item ~= "Coin" then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif string.find(item, "Exclusive") and price <= 25000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif type.titanic and price <= 10000000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        if boughtPet == true then
            ping = true
        end
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)

    -- Presents and Gifts
    elseif item == "Titanic Christmas Present" and price <= 55000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "2024 New Year's Gift" and price <= 35000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)

    -- Enchantment Books
    elseif item == "Exotic Pet" and price <= 25000 then
    	local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
    	processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Party Time" and price <= 45000 then
    	local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
    	processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Shiny Hunter" and price <= 100000 then
    	local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
    	processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Fortune" and gems <= 100000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Lucky Block" and gems <= 100000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Massive Comet" and gems <= 100000 then
       local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Chest Mimic" and gems <= 1000000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Diamond Chest Mimic" and gems <= 1000000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Huge Hunter" and price <= 1000000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Starfall" and price <= 1000000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Super Lightning" and price <= 1000000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Chest Breaker" and price <= 10000000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)

    -- Misc Items
    elseif item == "Crystal Key" and gems <= 10000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Crystal Key Lower Half" and gems <= 5000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Crystal Key Upper Half" and gems <= 5000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Spinny Wheel Ticket" and gems <= 5000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Booth Slot Voucher" and gems <= 25000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif string.find(item, "Charm") and price <= 100000 and item ~= "Agility Charm" and item ~= "Coin Charm" and item ~= "Bonus Charm" and item ~= "Charm Stone" then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif string.find(item, "HoverBoard") and item == "UFO" and price <= 25000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif string.find(item, "Booth") and price <= 25000 and item ~= "Christmas Booth" and item ~= "Dragon Booth" and item ~= "Rainbow Booth" and item ~= "Gold Booth" and item ~= "Cat Booth" and item ~= "Egg Booth" and item ~= "Monkey Booth" then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)

    -- Potions
    elseif item == "The Cocktail" and gems <= 50000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif string.find(item, "Potion VIII") and price <= 50000 and item == "Diamonds Potion VI" then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)

    -- Tools
    elseif item == "Golden Shovel" and gems <= 150000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Golden Fishing Rod" and gems <= 25000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Golden Watering Can" and gems <= 25000 then
	ReadyToBuy()
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Exotic Treasure Flag" and gems <= 50000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    end
end

Booths_Broadcast.OnClientEvent:Connect(function(username, message)
    local playerIDSuccess, playerError = pcall(function()
	playerID = message['PlayerID']
    end)
    if playerIDSuccess then
        if type(message) == "table" then
            local listing = message["Listings"]
            for key, value in pairs(listing) do
                if type(value) == "table" then
                    local uid = key
                    local gems = value["DiamondCost"]
                    local itemdata = value["ItemData"]

                    if itemdata then
                        local data = itemdata["data"]

                        if data then
                            local item = data["id"]
                            local version = data["pt"]
                            local shiny = data["sh"]
                            local amount = data["_am"]
                            checklisting(uid, gems, item, version, shiny, amount, username, playerID)
                        end
                    end
                end
            end
	end
    end
end)

local function jumpToServer() 
    local sfUrl = "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=%s&excludeFullGames=true" 
    local req = request({ Url = string.format(sfUrl, 15502339080, "Desc", 100) }) 
    local body = http:JSONDecode(req.Body) 
    local deep = math.random(1, 3)
    if deep > 1 then 
        for i = 1, deep, 1 do 
             req = request({ Url = string.format(sfUrl .. "&cursor=" .. body.nextPageCursor, 15502339080, "Desc", 100) }) 
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

Players.PlayerRemoving:Connect(function(player)
    PlayerInServer = #getPlayers
    if PlayerInServer < 25 then
        jumpToServer()
    end
end) 

Players.PlayerAdded:Connect(function(player)
    for i = 1,#alts do
        if player.Name == alts[i] and alts[i] ~= Players.LocalPlayer.Name then
            jumpToServer()
        end
    end
end) 

while task.wait(1) do
    if math.floor(os.clock() - osclock) >= math.random(1800, 3600) then
        jumpToServer()
    end
end
