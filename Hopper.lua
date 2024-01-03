repeat wait() until game:IsLoaded()

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

local function jumpToServer()
    local sfUrl = "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=%s&excludeFullGames=true"
    local req = request({ Url = string.format(sfUrl, 15502339080, "Desc", 100) })
    local body = game:GetService("HttpService"):JSONDecode(req.Body)
    local deep = math.random(1, 3)

    if deep > 1 then
        for i = 1, deep, 1 do
            req = request({ Url = string.format(sfUrl .. "&cursor=" .. body.nextPageCursor, 15502339080, "Desc", 100) })
            body = game:GetService("HttpService"):JSONDecode(req.Body)
            task.wait(0.1)
        end
    end

    local servers = {}
    if body and body.data then
        for i, v in next, body.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, 1, v.id)
            end
        end
    end

    local pingThreshold = 250 -- Change this value to your desired ping threshold
    local playerLimitThreshold = 40 -- Change this value to your desired player limit threshold

    for _, serverId in ipairs(servers) do
        local ping = getServerPing(serverId)
        local playerCount = game:GetService("Players").NumPlayers

        if ping and ping <= pingThreshold and playerCount < playerLimitThreshold then
            game:GetService("TeleportService"):TeleportToPlaceInstance(15502339080, serverId, game:GetService("Players").LocalPlayer)
            return
        end
    end

    print("No server with acceptable ping and player limit found.")
end

while wait(1) do
    jumpToServer()
end
