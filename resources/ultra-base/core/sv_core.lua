local function OnPlayerConnecting(playerName, setKickReason, deferrals)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    print('[ultra-base] Player Connecting :' .. playerName .. ' Info :' .. json.encode(GetPlayerIdentifiers(src)))
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
        deferrals.done('❗You Should open Steam to connect to the server, join our discord for more information: '.. Ultra.ServerDiscord)
        return
    end
    deferrals.done()
end
AddEventHandler("playerConnecting", OnPlayerConnecting)

AddEventHandler('playerDropped', function (reason)
    local src = source
    print('Player ' .. GetPlayerName(src) ..' Player Info: ' ..json.encode(GetPlayerIdentifiers(src)).. ' dropped (Reason: ' .. reason .. ')')
end)

RegisterServerEvent('ultra-base:server:Start')
AddEventHandler('ultra-base:server:Start', function()
    print('[ultra-base] Server Start')
    local src = source
    Citizen.CreateThread(function()
        local license = GetPlayerIdentifiers(src)[1]
        if not license then
            print('[ultra-base] No License')
            DropPlayer(src, 'You Dont Have A License , Try To Close And Open FiveM Again')
        end
        return
    end)
end)

RegisterNetEvent('ultra-base:server:getObject')
AddEventHandler('ultra-base:server:getObject', function(callback)
    callback(Ultra)
end)

-- Comamnds
AddEventHandler('ultra-base:addCommand', function(command,callback,suggestion, args)
    Ultra.Functions.AddCommands(command, callback, suggestion, args)
end)

-- Callback
RegisterServerEvent('ultra-base:server:triggerServerCallback')
AddEventHandler('ultra-base:server:triggerServerCallback', function(name, requestId, ...)
    local src = source
    Ultra.Functions.TriggerServerCallback(name, requestId, src, function(...)
        TriggerClientEvent('ultra-base:client:serverCallback', src, requestId, ...)
    end, ...)
end)