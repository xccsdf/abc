--[[
Credits List
ethereum: creating the base sniper
chocolog: providing type.huge
Edmond: offered tips for optimization
]]--

local osclock = os.clock()
if not game:IsLoaded() then
    game.Loaded:Wait()
end

setfpscap(30)
game.Players.LocalPlayer.PlayerScripts.Scripts.Core["Idle Tracking"].Enabled = false
game:GetService("RunService"):Set3dRenderingEnabled(false)
local Booths_Broadcast = game:GetService("ReplicatedStorage").Network:WaitForChild("Booths_Broadcast")
local Players = game:GetService('Players')
local getPlayers = Players:GetPlayers()
local PlayerInServer = #getPlayers
local http = game:GetService("HttpService")
local ts = game:GetService("TeleportService")
local rs = game:GetService("ReplicatedStorage")
local snipeNormal
local Library = require(rs:WaitForChild("Library"))

if snipeNormalPets == nil then
    snipeNormalPets = false
end

local vu = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   task.wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

local function processListingInfo(uid, gems, item, version, boughtPet, shiny, amount, boughtFrom, boughtStatus, class, failMessage, snipeNormal)
    local gemamount = Players.LocalPlayer.leaderstats["💎 Diamonds"].Value
    local snipeMessage =""
    local weburl, webContent, webcolor
    local versionVal = { [1] = "Golden ", [2] = "Rainbow " }
    local versionStr = versionVal[version] or (version == nil and "")
    local mention = (string.find(item, "Huge") or string.find(item, "Titanic")) and "<@" .. userid .. ">" or ""
	
    if boughtStatus then
	webcolor = tonumber(0x00ff00)
	weburl = webhook
        snipeMessage = snipeMessage .. " just sniped ".. Library.Functions.Commas(amount) .."x "
        webContent = mention
	if snipeNormal == true then
	    weburl = normalwebhook
	    snipeNormal = false
	end
    else
	webContent = failMessage
	webcolor = tonumber(0xff0000)
	weburl = webhookFail
	snipeMessage = snipeMessage .. " failed to snipe ".. Library.Functions.Commas(amount) .."x "
	if snipeNormal == true then
	    weburl = normalwebhook
	    snipeNormal = false
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
                        value = Library.Functions.ParseNumberSmart(gems) .. " ",
                    },
                    {
                        name = "📦 AMOUNT:",
                        value = Library.Functions.Commas(amount) .. "x",
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
                        value = Library.Functions.ParseNumberSmart(gemamount) .. " ",
                    },
                },
                footer = {
                    icon_url = "https://cdn.discordapp.com/attachments/1122535236996182099/1189213923073871953/EmrJ9tNVcAIhVzB.png?ex=659d58c5&is=658ae3c5&hm=c55bc9b5323c6aa542d6a99b4e42c20a0255377566c3bc2d047f63bffce70b7e&", -- optional
                    text = "Touhou Sniper"
                }
            },
        },
    }

    local message2 = {
        content = webContent,
        embeds = {
            {
                author = {
                    name = "😭 Reimu's Sad Fails 😭",
                    icon_url = "https://cdn.discordapp.com/attachments/1167165734674247870/1192871069757997146/image.png?ex=65aaa6c1&is=659831c1&hm=4a534758835feea20460aaf22c1562b19defdeb1ec675fb589bd6ab52ba81cf3&",
                },
                title = snipeMessage,
                color = webcolor,
                timestamp = DateTime.now():ToIsoDate(),
                thumbnail = {
                    url = "https://cdn.discordapp.com/attachments/1167165734674247870/1192869570717941760/56837f7cb2c4629a601acb36875ee24a516ff40c.jpeg?ex=65aaa55c&is=6598305c&hm=669f1b186fcc3ba24e8d56c73d0ae3ed2eb555ffdc49d2dcd57cc98de290afbb&",
                },
                fields = {
                    {
                        name = "🛒 __*PURCHASE INFO:*__ 🛒",
                        value = "\n\n",
                    },
                    {
                        name = "😭 PRICE:",
                        value = Library.Functions.ParseNumberSmart(gems) .. " ",
                    },
                    {
                        name = "📦 AMOUNT:",
                        value = Library.Functions.Commas(amount) .. "x",
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
                        value = Library.Functions.ParseNumberSmart(gemamount) .. " ",
                    },
                },
                footer = {
                    icon_url = "https://cdn.discordapp.com/attachments/1167165734674247870/1192871069757997146/image.png?ex=65aaa6c1&is=659831c1&hm=4a534758835feea20460aaf22c1562b19defdeb1ec675fb589bd6ab52ba81cf3&", -- optional
                    text = "Touhou Sniper Fails"
                }
            },
        },
    }

        local messageToSend = boughtPet and message1 or message2 
        local jsonMessage = http:JSONEncode(messageToSend)
    local success, webMessage = pcall(function()
        http:PostAsync(webhooksnipe, jsonMessage)
    end) 
        if success == false then
        local response = request({
            Url = webhooksnipe,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = jsonMessage
        })
    end
end

local function tryPurchase(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
    if buytimestamp > listTimestamp then
      task.wait(3.4 - Players.LocalPlayer:GetNetworkPing())
    end
    local boughtPet, boughtMessage = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
    processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, class, boughtMessage, snipeNormal)
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
		snipeNormal = false
                                 
            -- Pets
            if string.find(item, "Huge") and unitGems <= 100000 then
                coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                return
            elseif snipeNormalPets == true and gems == 1 then
                    snipeNormal = true
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp,   snipeNormal)
                    return
            elseif class == "Pet" then
                local type = Library.Directory.Pets[item]
                if type.exclusiveLevel and unitGems <= 15000 and item ~= "Banana" and item ~= "Coin" then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif type.titanic and unitGems <= 10000000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif type.huge and unitGems <= 1000000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, boughtPet, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                end

                -- Presents and Eggs
            elseif (item == "Titanic Christmas Present" or string.find(item, "2024 New Year")) and unitGems <= 30000 then
                coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                return
            elseif class == "Egg" and unitGems <= 30000 then
                coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                return

                -- Items
            elseif item == "Crystal Key" and unitGems <= 10000 then
                coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                return
            elseif item == "Crystal Key Lower Half" and unitGems <= 5000 then
                coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                return
            elseif item == "Crystal Key Upper Half" and unitGems <= 5000 then
                coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                return
            elseif item == "Spinny Wheel Ticket" and unitGems <= 5000 then
                coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                return
            elseif item == "Booth Slot Voucher" and unitGems <= 25000 then
                coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                return
            elseif string.find(item, "Charm") and unitGems <= 100000 and item ~= "Agility Charm" and item ~= "Coin Charm" and item ~= "Bonus Charm" and item ~= "Charm Stone" then
                coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                return

                -- Enchants    
            elseif class == "Enchant" and unitGems <= 30000 then
                if item == "Chest Breaker" and unitGems <= 10000000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif string.find(item, "Chest Mimic") and unitGems <= 1000000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif item == "Huge Hunter" and unitGems <= 1000000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif item == "Starfall" and unitGems <= 1000000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif item == "Super Lightning" and unitGems <= 1000000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif item == "Lucky Block" and unitGems <= 100000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif item == "Fortune" and unitGems <= 100000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif item == "Massive Comet" and unitGems <= 100000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif item == "Shiny Hunter" and unitGems <= 100000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif item == "Party Time" and unitGems <= 45000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif item == "Exotic Pet" and unitGems <= 25000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return

                -- Misc Items
                elseif class == "HoverBoard" and unitGems <= 30000 then 
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif class == "Booth" and unitGems <= 10000 and item ~= "Christmas" and item ~= "Dragon" and item ~= "Rainbow" and item ~= "Gold" and item ~= "Cat" and item ~= "Egg" and item ~= "Monkey" then     
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return

                    -- Potion   
                elseif item == "The Cocktail" and gems <= 50000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif string.find(item, "Potion VIII") and price <= 50000 and item == "Diamonds Potion VI" then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return

                    -- Tools 
                elseif item == "Golden Shovel" and unitGems <= 150000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif item == "Golden Fishing Rod" and unitGems <= 25000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif item == "Golden Watering Can" and unitGems <= 25000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                elseif item == "Exotic Treasure Flag" and unitGems <= 50000 then
                    coroutine.wrap(tryPurchase)(uid, gems, item, version, shiny, amount, username, class, playerid, buytimestamp, listTimestamp, snipeNormal)
                    return
                end
            end
        end
    end
end)

local function getServerPing(serverId)
    local pingUrl = "http://www.roblox.com/Game/PlaceLauncher.ashx?request=RequestPing&placeId=" .. game.PlaceId .. "&gameId=" .. serverId
    local startTime = os.clock()
    local success, response = pcall(function()
        return game:GetService("HttpService"):RequestAsync({
            Url = pingUrl,
            Method = "GET"
        })
    end)

    if success and response and response.Success then
        local endTime = os.clock()
        local ping = (endTime - startTime) * 1000 -- Convert to milliseconds
        return ping
    else
        return nil
    end
end

local function jumpToServerIfHighPingAndPlayerLimit()
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
                table.insert(servers, v)
            end
        end
    end

    local pingThreshold = 250 -- Change this value to your desired ping threshold
    local playerLimitThreshold = 40 -- Change this value to your desired player limit threshold

    for _, server in ipairs(servers) do
        local ping = getServerPing(server.id)
        if ping and ping <= pingThreshold and server.maxPlayers >= playerLimitThreshold then
            ts:TeleportToPlaceInstance(15502339080, server.id, game:GetService("Players").LocalPlayer)
            return
        end
    end

    print("No server with acceptable ping and player limit found.")
end

local hopDelay = math.random(840, 1140)

while task.wait(1) do
    if math.floor(os.clock() - osclock) >= hopDelay then
        while task.wait(10) do
	    jumpToServer()		
	end	
    end
end
