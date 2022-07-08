local function OnPlayerConnecting(playerName, setKickReason, deferrals)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    print('[nh-base] Player Connecting :' .. playerName .. ' Info :' .. json.encode(GetPlayerIdentifiers(src)))
    deferrals.defer()
    Wait(100)
    deferrals.update(string.format("Hello %s. Your Steam ID is being checked.", playerName))
    Wait(1000)
    deferrals.update(string.format("Hello %s. Your Steam ID is being checked..", playerName))
    Wait(500)
    deferrals.update(string.format("Hello %s. Your Steam ID is being checked...", playerName))
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    Wait(1000)
    if not steamIdentifier then
        deferrals.done('❗You Should open Steam to connect to the server,join our discord for more information'.. nh.ServerDiscord)
    else
        deferrals.done()
    end
end
AddEventHandler("playerConnecting", OnPlayerConnecting)

AddEventHandler('playerDropped', function (reason)
    local src = source
    print('Player ' .. GetPlayerName(source) ..' Player Info: ' ..json.encode(GetPlayerIdentifiers(src)).. ' dropped (Reason: ' .. reason .. ')')
end)

RegisterServerEvent('nh-base:server:Start')
AddEventHandler('nh-base:server:Start', function()
    print('[nh-base] Server Start')
    local src = source
    Citizen.CreateThread(function()
        local license = GetPlayerIdentifiers(src)[1]
        if not license then
            print('[nh-base] No License')
            DropPlayer(src, 'You Dont Have A License , Try To Close And Open FiveM Again')
        end
        return
    end)
end)

RegisterNetEvent('nh-base:server:getObject')
AddEventHandler('nh-base:server:getObject', function(callback)
    callback(nh)
end)