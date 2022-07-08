local function OnPlayerConnecting(playerName, setKickReason, deferrals)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    print('[nh-base] Player Connecting' .. playerName .. GetPlayerIdentifiers(src)[1])
    deferrals.defer()
    Wait(0)
    deferrals.update(string.format("Hello %s. Your Steam ID is being checked.", playerName))
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    Wait(0)
    if not steamIdentifier then
        deferrals.done('You Should open steam to connect to the server')
    else
        deferrals.done()
    end
end
AddEventHandler("playerConnecting", OnPlayerConnecting)

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